local M = {}

M.config = {
	max_diff_chars = 4000, -- budget for single-pass mode
	max_file_chars = 1500, -- per-file budget before truncation
	two_pass_threshold = 6000, -- raw diff size that triggers two-pass mode
	host = nil, -- falls back to gen.nvim config, then "localhost"
	port = nil, -- falls back to gen.nvim config, then "11434"
	model_fast = "llama3.2", -- fast model for file-level summaries (pass 1)
	model_large = "llama3.2", -- quality model for final synthesis (pass 2)
}

-- Files to completely exclude from diffs (noise, generated, binaries)
local ignore_patterns = {
	-- Lock files
	"package%-lock%.json",
	"yarn%.lock",
	"pnpm%-lock%.yaml",
	"Gemfile%.lock",
	"Cargo%.lock",
	"composer%.lock",
	"poetry%.lock",
	"go%.sum",
	"flake%.lock",
	-- Generated / build artifacts
	"%.min%.js$",
	"%.min%.css$",
	"%.map$",
	"dist/",
	"build/",
	"node_modules/",
	"vendor/",
	"%.pb%.go$",
	-- Binary indicators
	"Binary files",
}

local prompt_template = [[You are a git commit message generator. Based on the following staged diff, generate a commit message following the Conventional Commits format.

Format: <type>(<scope>): <summary>

Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore

Rules:
- Use imperative mood ("Fix issue" not "Fixed issue")
- Capitalize the first letter of the summary
- Do not end the summary with a period
- Keep the summary under 60 characters
- If the change is complex, add a blank line followed by a concise description (1-3 bullet points)
- Omit the scope if it is not obvious
- Respond with ONLY the commit message, no explanations or markdown formatting

Diff:
%s]]

local file_summary_prompt = [[Summarize the following git diff for a single file in ONE sentence. Focus on WHAT changed and WHY (if apparent). Be specific and concise.

File: %s
Diff:
%s

One-sentence summary:]]

local synthesis_prompt = [[You are a git commit message generator. Based on the following per-file change summaries, generate a single commit message following the Conventional Commits format.

Format: <type>(<scope>): <summary>

Types: feat, fix, docs, style, refactor, perf, test, build, ci, chore

Rules:
- Use imperative mood ("Fix issue" not "Fixed issue")
- Capitalize the first letter of the summary
- Do not end the summary with a period
- Keep the summary under 60 characters
- If the change is complex, add a blank line followed by a concise description (1-3 bullet points)
- Omit the scope if it is not obvious
- Respond with ONLY the commit message, no explanations or markdown formatting

Changed files and summaries:
%s]]

-- ──────────────────────────────────────────────────────────────
-- Helpers
-- ──────────────────────────────────────────────────────────────

--- Resolve a config value by checking our config, then gen.nvim, then a fallback.
---@param key string
---@param fallback string
---@return string
local function resolve(key, fallback)
	if M.config[key] then
		return M.config[key]
	end
	local ok, gen = pcall(require, "gen")
	if ok and gen[key] then
		return tostring(gen[key])
	end
	return fallback
end

--- Check if a file path matches any ignore pattern.
---@param path string
---@return boolean
local function should_ignore(path)
	for _, pattern in ipairs(ignore_patterns) do
		if path:find(pattern) then
			return true
		end
	end
	return false
end

--- Parse a unified diff into per-file chunks.
---@param raw_diff string
---@return table[] list of { file: string, diff: string }
local function parse_diff_files(raw_diff)
	local files = {}
	local current_file = nil
	local current_lines = {}

	for line in raw_diff:gmatch("([^\n]*)\n?") do
		local file = line:match("^diff %-%-git a/.+ b/(.+)$")
		if file then
			-- Flush previous file
			if current_file then
				table.insert(files, {
					file = current_file,
					diff = table.concat(current_lines, "\n"),
				})
			end
			current_file = file
			current_lines = { line }
		elseif current_file then
			table.insert(current_lines, line)
		end
	end
	-- Flush last file
	if current_file then
		table.insert(files, {
			file = current_file,
			diff = table.concat(current_lines, "\n"),
		})
	end
	return files
end

--- Filter and budget-truncate diff files.
---@param files table[] from parse_diff_files
---@return table[] filtered list, boolean any_truncated
local function filter_and_truncate(files)
	local filtered = {}
	local any_truncated = false

	for _, f in ipairs(files) do
		if not should_ignore(f.file) then
			if #f.diff > M.config.max_file_chars then
				-- Keep the header and as many hunks as fit in the budget
				f.diff = f.diff:sub(1, M.config.max_file_chars) .. "\n... (truncated)"
				any_truncated = true
			end
			table.insert(filtered, f)
		end
	end
	return filtered, any_truncated
end

--- Reassemble filtered file diffs into a single string, respecting total budget.
---@param files table[]
---@return string combined_diff, boolean truncated
local function assemble_diff(files)
	local parts = {}
	local total = 0
	local truncated = false

	for _, f in ipairs(files) do
		if total + #f.diff > M.config.max_diff_chars then
			truncated = true
			-- Try to fit a partial
			local remaining = M.config.max_diff_chars - total
			if remaining > 200 then
				table.insert(parts, f.diff:sub(1, remaining) .. "\n... (truncated)")
			end
			break
		end
		table.insert(parts, f.diff)
		total = total + #f.diff
	end
	return table.concat(parts, "\n"), truncated
end

-- ──────────────────────────────────────────────────────────────
-- Diff retrieval
-- ──────────────────────────────────────────────────────────────

--- Get the staged diff, pre-filtered and structured.
---@param callback fun(files: table[]|nil, raw_size: number)
local function get_staged_diff(callback)
	vim.system({ "git", "diff", "--cached" }, { text = true }, function(result)
		if result.code ~= 0 or not result.stdout or result.stdout == "" then
			callback(nil, 0)
			return
		end
		local raw_size = #result.stdout
		local files = parse_diff_files(result.stdout)
		local filtered = filter_and_truncate(files)
		callback(filtered, raw_size)
	end)
end

-- ──────────────────────────────────────────────────────────────
-- Ollama communication
-- ──────────────────────────────────────────────────────────────

--- Call Ollama with a prompt and return the response text.
---@param prompt string
---@param model string
---@param callback fun(response: string|nil, err: string|nil)
local function call_ollama(prompt, model, callback)
	local host = resolve("host", "localhost")
	local port = resolve("port", "11434")
	local url = string.format("http://%s:%s/api/generate", host, port)

	local body = vim.json.encode({
		model = model,
		prompt = prompt,
		stream = false,
	})

	vim.system({
		"curl",
		"--silent",
		"--max-time",
		"30",
		"-X",
		"POST",
		url,
		"-H",
		"Content-Type: application/json",
		"-d",
		body,
	}, { text = true }, function(result)
		if result.code ~= 0 then
			callback(nil, "Ollama request failed (exit " .. result.code .. ")")
			return
		end
		local ok, decoded = pcall(vim.json.decode, result.stdout)
		if not ok or not decoded then
			callback(nil, "Failed to parse Ollama response: " .. (result.stdout or ""):sub(1, 200))
			return
		end
		if decoded.error then
			callback(nil, "Ollama error: " .. decoded.error)
			return
		end
		if not decoded.response then
			callback(nil, "Ollama returned no response field: " .. (result.stdout or ""):sub(1, 200))
			return
		end
		-- Clean up: trim whitespace, strip markdown fences
		local msg = decoded.response:gsub("^%s+", ""):gsub("%s+$", "")
		msg = msg:gsub("^```%w*\n?", ""):gsub("\n?```$", "")
		msg = msg:gsub("^%s+", ""):gsub("%s+$", "")
		callback(msg, nil)
	end)
end

-- ──────────────────────────────────────────────────────────────
-- Single-pass: small diffs
-- ──────────────────────────────────────────────────────────────

---@param files table[]
---@param callback fun(message: string|nil, err: string|nil)
local function single_pass(files, callback)
	local combined, truncated = assemble_diff(files)
	if truncated then
		vim.schedule(function()
			vim.notify("Diff truncated to fit context window", vim.log.levels.WARN)
		end)
	end

	local model = M.config.model_large or resolve("model", "llama3.2")
	local prompt = string.format(prompt_template, combined)
	call_ollama(prompt, model, callback)
end

-- ──────────────────────────────────────────────────────────────
-- Two-pass: large diffs (map file summaries → synthesize)
-- ──────────────────────────────────────────────────────────────

---@param files table[]
---@param callback fun(message: string|nil, err: string|nil)
local function two_pass(files, callback)
	local model_fast = M.config.model_fast or resolve("model", "llama3.2")
	local model_large = M.config.model_large or resolve("model", "llama3.2")

	vim.schedule(function()
		vim.notify(
			string.format("Large diff (%d files) — using two-pass summarization", #files),
			vim.log.levels.INFO
		)
	end)

	-- Pass 1: summarize each file in parallel
	local summaries = {}
	local pending = #files
	local has_error = false

	for i, f in ipairs(files) do
		-- Truncate individual file diffs aggressively for pass 1
		local file_diff = f.diff
		if #file_diff > M.config.max_file_chars then
			file_diff = file_diff:sub(1, M.config.max_file_chars) .. "\n... (truncated)"
		end

		local prompt = string.format(file_summary_prompt, f.file, file_diff)
		call_ollama(prompt, model_fast, function(response, err)
			if has_error then
				return
			end
			if err then
				has_error = true
				callback(nil, "Pass 1 failed on " .. f.file .. ": " .. err)
				return
			end
			summaries[i] = string.format("- %s: %s", f.file, response)
			pending = pending - 1

			if pending == 0 then
				-- Pass 2: synthesize all summaries into a commit message
				local summary_block = table.concat(summaries, "\n")
				local synth_prompt = string.format(synthesis_prompt, summary_block)
				call_ollama(synth_prompt, model_large, callback)
			end
		end)
	end
end

-- ──────────────────────────────────────────────────────────────
-- Buffer insertion
-- ──────────────────────────────────────────────────────────────

--- Insert a draft commit message into the given buffer.
---@param bufnr integer
---@param message string
---@param changedtick integer snapshot to guard against user edits
local function insert_draft(bufnr, message, changedtick)
	vim.schedule(function()
		if not vim.api.nvim_buf_is_valid(bufnr) then
			return
		end
		if vim.api.nvim_buf_get_changedtick(bufnr) ~= changedtick then
			return
		end

		local lines = vim.split(message, "\n", { plain = true })
		vim.api.nvim_buf_set_lines(bufnr, 0, 1, false, lines)
		local win = vim.fn.bufwinid(bufnr)
		if win ~= -1 then
			vim.api.nvim_win_set_cursor(win, { 1, #lines[1] })
		end
		vim.notify("Commit draft generated — edit or regenerate with <leader>ai", vim.log.levels.INFO)
	end)
end

-- ──────────────────────────────────────────────────────────────
-- Public API
-- ──────────────────────────────────────────────────────────────

--- Generate a commit message and insert it into the current gitcommit buffer.
---@param opts? { force: boolean } force=true skips the empty-line check (for keymap re-trigger)
function M.generate(opts)
	opts = opts or {}
	local bufnr = vim.api.nvim_get_current_buf()
	local first_line = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)[1] or ""

	if not opts.force and first_line ~= "" then
		return
	end

	local changedtick = vim.api.nvim_buf_get_changedtick(bufnr)

	vim.notify("Generating commit message...", vim.log.levels.INFO)

	get_staged_diff(function(files, raw_size)
		if not files or #files == 0 then
			vim.schedule(function()
				vim.notify("No staged changes found (or all files filtered)", vim.log.levels.WARN)
			end)
			return
		end

		vim.schedule(function()
			local filtered_count = #files
			vim.notify(
				string.format("%d file(s) after filtering (raw diff: %s)", filtered_count, _format_bytes(raw_size)),
				vim.log.levels.INFO
			)
		end)

		local on_done = function(message, err)
			if err then
				vim.schedule(function()
					vim.notify("AI commit: " .. err, vim.log.levels.ERROR)
				end)
				return
			end
			if message then
				insert_draft(bufnr, message, changedtick)
			end
		end

		-- Route: single-pass for small diffs, two-pass for large ones
		if raw_size > M.config.two_pass_threshold then
			two_pass(files, on_done)
		else
			single_pass(files, on_done)
		end
	end)
end

--- Format byte count for display.
---@param bytes number
---@return string
function _format_bytes(bytes)
	if bytes < 1024 then
		return bytes .. "B"
	elseif bytes < 1024 * 1024 then
		return string.format("%.1fKB", bytes / 1024)
	else
		return string.format("%.1fMB", bytes / 1024 / 1024)
	end
end

--- Register the autocommand and buffer-local keymap.
function M.setup()
	local group = vim.api.nvim_create_augroup("ai_commit", { clear = true })

	vim.api.nvim_create_autocmd("FileType", {
		group = group,
		pattern = "gitcommit",
		callback = function(ev)
			-- Auto-generate draft for empty commit messages
			vim.defer_fn(function()
				if vim.api.nvim_buf_is_valid(ev.buf) then
					local first_line = vim.api.nvim_buf_get_lines(ev.buf, 0, 1, false)[1] or ""
					if first_line == "" then
						M.generate()
					end
				end
			end, 100)

			-- Buffer-local keymap to regenerate on demand
			vim.keymap.set("n", "<leader>ai", function()
				local lines = vim.api.nvim_buf_get_lines(ev.buf, 0, -1, false)
				local first_comment = 1
				for i, line in ipairs(lines) do
					if line:match("^#") then
						first_comment = i
						break
					end
				end
				if first_comment > 1 then
					vim.api.nvim_buf_set_lines(ev.buf, 0, first_comment - 1, false, { "" })
				end
				M.generate({ force = true })
			end, { buffer = ev.buf, desc = "[ai] Regenerate commit message" })
		end,
	})
end

return M
