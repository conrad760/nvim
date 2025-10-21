-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- The next two examples are both ways of writing commands in vim
--
---- testing ----
-- local border = {
--   { "🭽", "FloatBorder" },
--   { "▔", "FloatBorder" },
--   { "🭾", "FloatBorder" },
--   { "▕", "FloatBorder" },
--   { "🭿", "FloatBorder" },
--   { "▁", "FloatBorder" },
--   { "🭼", "FloatBorder" },
--   { "▏", "FloatBorder" },
-- }
-- Always show the diagnostics window
-- vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
-- 	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
-- 	callback = function()
-- 		vim.diagnostic.open_float(nil, {
-- 			focus = false,
-- 			border = "rounded",
-- 		})
-- 	end,
-- })

--- Remove all trailing whitespace on save
local TrimWhiteSpaceGrp = vim.api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	command = [[:%s/\s\+$//e]],
	group = TrimWhiteSpaceGrp,
})

-- Toggle diagnostics visibility
function ToggleDiagnostics()
	-- Check the current state of diagnostics visibility
	local status, diagnostics_visible = pcall(vim.api.nvim_buf_get_var, 0, "diagnostics_visible")

	if not status or diagnostics_visible then
		vim.diagnostic.enable(false)
		vim.api.nvim_buf_set_var(0, "diagnostics_visible", false)
	else
		vim.diagnostic.enable()
		vim.api.nvim_buf_set_var(0, "diagnostics_visible", true)
	end
end

-- Safely initialize the buffer variable
pcall(vim.api.nvim_buf_set_var, 0, "diagnostics_visible", true)

vim.api.nvim_create_user_command("ToggleDiagnostics", ToggleDiagnostics, {})

-- commit spell good
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.textwidth = 80
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap_markdowny", { clear = true }),
	desc = "markdowny.nvim keymaps",
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.keymap.set(
			"v",
			"<leader>mb",
			":lua require('markdowny').bold()<cr>",
			{ buffer = 0, desc = "[m]ake [b]old" }
		)
		vim.keymap.set(
			"v",
			"<leader>mi",
			":lua require('markdowny').italic()<cr>",
			{ buffer = 0, desc = "[m]ake [i]talic" }
		)
		vim.keymap.set(
			"v",
			"<leader>ml",
			":lua require('markdowny').link()<cr>",
			{ buffer = 0, desc = "[m]ake [l]in[k]" }
		)
		vim.keymap.set(
			"v",
			"<leader>mc",
			":lua require('markdowny').code()<cr>",
			{ buffer = 0, desc = "[m]ake [c]ode" }
		)
	end,
})

-- General settings
local general_settings = vim.api.nvim_create_augroup("_general_settings", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = general_settings,
	pattern = { "qf", "help", "man", "lspinfo", "git" },
	command = "nnoremap <silent> <buffer> q :close<CR>",
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = general_settings,
	pattern = "*",
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 200 })
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = general_settings,
	pattern = "qf",
	command = "set nobuflisted",
})

-- Git settings
local git_group = vim.api.nvim_create_augroup("_git", { clear = true })

vim.api.nvim_create_autocmd("FileType", {
	group = git_group,
	pattern = "gitcommit",
	command = "setlocal wrap",
})

vim.api.nvim_create_autocmd("FileType", {
	group = git_group,
	pattern = "gitcommit",
	command = "setlocal spell",
})

-- Markdown settings
local markdown_group = vim.api.nvim_create_augroup("_markdown", { clear = true })

vim.api.nvim_create_autocmd({ "BufNewFile", "BufRead" }, {
	group = markdown_group,
	pattern = "*.md",
	command = "set syntax=markdown",
})

vim.api.nvim_create_autocmd("FileType", {
	group = markdown_group,
	pattern = "markdown",
	command = "setlocal wrap",
})

vim.api.nvim_create_autocmd("FileType", {
	group = markdown_group,
	pattern = "markdown",
	command = "setlocal spell",
})

-- Auto resize splits on Vim resize
local resize_group = vim.api.nvim_create_augroup("_auto_resize", { clear = true })

vim.api.nvim_create_autocmd("VimResized", {
	group = resize_group,
	pattern = "*",
	command = "tabdo wincmd =",
})

vim.opt.exrc = true
vim.opt.secure = true
