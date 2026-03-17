return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
		"leoluz/nvim-dap-go",
	},
	-- All keymaps in the keys table so they work immediately and trigger lazy-load
	keys = {
		-- MOST COMMON: These are what you'll use 90% of the time
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
		{ "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue/Start" },
		{ "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Stop/Terminate" },

		-- STEPPING
		{ "<leader>dn", function() require("dap").step_over() end, desc = "Debug: Step Over (Next)" },
		{ "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<leader>do", function() require("dap").step_out() end, desc = "Debug: Step Out" },

		-- UI & INSPECTION
		{ "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
		{ "<leader>de", function() require("dapui").eval() end, desc = "Debug: Evaluate", mode = { "n", "v" } },
		{ "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debug: Hover Variables" },

		-- Go-SPECIFIC
		{ "<leader>dT", function() require("dap-go").debug_test() end, desc = "Debug: Go Test", ft = "go" },
		{ "<leader>dL", function() require("dap-go").debug_last_test() end, desc = "Debug: Last Go Test", ft = "go" },

		-- BREAKPOINT VARIATIONS
		{ "<leader>dB", function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Conditional Breakpoint" },
		{ "<leader>dx", function()
			require("dap").clear_breakpoints()
			vim.notify("All breakpoints cleared", vim.log.levels.WARN)
		end, desc = "Debug: Clear All Breakpoints" },
		{ "<leader>dP", function()
			local msg = vim.fn.input("Log message (use {expr} for interpolation): ")
			if msg ~= "" then
				require("dap").set_breakpoint(nil, nil, msg)
			end
		end, desc = "Debug: Set Log Point" },

		-- ADVANCED CONTROL
		{ "<leader>dC", function() require("dap").run_to_cursor() end, desc = "Debug: Run to Cursor" },
		{ "<leader>da", function()
			local dap = require("dap")
			local ft = vim.bo.filetype
			local configs = dap.configurations[ft]
			if not configs or #configs == 0 then
				vim.notify("No debug configs for filetype: " .. ft, vim.log.levels.WARN)
				return
			end
			local input = vim.fn.input("Arguments: ")
			if input == "" then return end
			local args = vim.fn.split(input, " +")
			local config = vim.deepcopy(configs[1])
			config.args = args
			config.name = config.name .. " (with args)"
			dap.run(config)
		end, desc = "Debug: Run with Args" },
		{ "<leader>dl", function() require("dap").run_last() end, desc = "Debug: Run Last" },
		{ "<leader>dp", function() require("dap").pause() end, desc = "Debug: Pause" },

		-- STACK NAVIGATION
		{ "<leader>dj", function() require("dap").down() end, desc = "Debug: Down Stack" },
		{ "<leader>dk", function() require("dap").up() end, desc = "Debug: Up Stack" },

		-- REPL
		{ "<leader>dr", function() require("dap").repl.toggle() end, desc = "Debug: Toggle REPL" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Better icons for breakpoints with unified colors
		local colors = require("config.colors")
		colors.apply_to_debug_ui()

		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointRejected", { text = "○", texthl = "DapBreakpointRejected", linehl = "", numhl = "" })
		vim.fn.sign_define("DapLogPoint", { text = "◈", texthl = "DapLogPoint", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })

		-- Helper function to prompt for command-line arguments (used by dap-go configs).
		local function get_args()
			local input = vim.fn.input("Arguments: ")
			return vim.fn.split(input, " +")
		end

		-- Mason-nvim-dap: automatically install & setup debuggers.
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			automatic_setup = true,
			ensure_installed = { "delve", "js-debug-adapter" },
		})

		-- Virtual text for better debugging experience
		require("nvim-dap-virtual-text").setup({
			enabled = true,
			enabled_commands = true,
			highlight_changed_variables = true,
			highlight_new_as_changed = false,
			show_stop_reason = true,
			commented = false,
			virt_text_pos = "eol",
		})

		-- Setup dap-ui with better layout
		dapui.setup({
			icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
			mappings = {
				expand = { "<CR>", "<2-LeftMouse>" },
				open = "o",
				remove = "d",
				edit = "e",
				repl = "r",
				toggle = "t",
			},
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.33 },
						{ id = "breakpoints", size = 0.17 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "right",
				},
				{
					elements = { "repl", "console" },
					size = 10,
					position = "bottom",
				},
			},
			floating = {
				max_height = 0.9,
				max_width = 0.9,
				border = "rounded",
				mappings = { close = { "q", "<Esc>" } },
			},
		})

		-- Automatically open/close the dap-ui on session events.
		dap.listeners.after.event_initialized["dapui_config"] = function()
			dapui.open()
		end
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- JavaScript/TypeScript adapter (js-debug-adapter via Mason)
		dap.adapters["pwa-node"] = {
			type = "server",
			host = "localhost",
			port = "${port}",
			executable = {
				command = "node",
				args = {
					vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
					"${port}",
				},
			},
		}

		dap.configurations.javascript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch current file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
		}

		dap.configurations.typescript = {
			{
				type = "pwa-node",
				request = "launch",
				name = "Launch current file",
				program = "${file}",
				cwd = "${workspaceFolder}",
			},
		}

		-- Enhanced Go debugging setup
		require("dap-go").setup({
			dap_configurations = {
				{
					type = "go",
					name = "Debug Package",
					request = "launch",
					program = "${fileDirname}",
				},
				{
					type = "go",
					name = "Debug Current File",
					request = "launch",
					program = "${file}",
				},
				{
					type = "go",
					name = "Debug with Arguments",
					request = "launch",
					program = "${fileDirname}",
					args = get_args,
				},
				{
					type = "go",
					name = "Debug Test (go.mod)",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
				},
				{
					type = "go",
					name = "Attach to Running Process",
					mode = "local",
					request = "attach",
					processId = require("dap.utils").pick_process,
				},
				{
					type = "go",
					name = "Debug Main Package",
					request = "launch",
					program = "${workspaceFolder}",
				},
			},
			delve = {
				path = vim.fn.stdpath("data") .. "/mason/bin/dlv",
				initialize_timeout_sec = 20,
				port = "${port}",
				args = {},
				build_flags = "",
			},
		})

		-- Load Go debug helpers
		local ok, go_helper = pcall(require, "plugins.go-debug-helper")
		if ok and go_helper.setup then
			go_helper.setup()
		end

		-- Persistent breakpoints: save to file on change, restore on session start
		local breakpoints_path = vim.fn.stdpath("data") .. "/dap_breakpoints.json"

		-- Save originals before wrapping so restore can use them without triggering saves
		local orig_toggle = dap.toggle_breakpoint
		local orig_set = dap.set_breakpoint
		local orig_clear = dap.clear_breakpoints

		local function save_breakpoints()
			local bps = require("dap.breakpoints").get()
			local save_data = {}
			for bufnr, buf_bps in pairs(bps) do
				local name = vim.api.nvim_buf_get_name(bufnr)
				if name ~= "" then
					save_data[name] = buf_bps
				end
			end
			local f = io.open(breakpoints_path, "w")
			if f then
				f:write(vim.fn.json_encode(save_data))
				f:close()
			end
		end

		local function set_bp_at_line(bufnr, line, condition, hit_condition, log_message)
			vim.api.nvim_buf_call(bufnr, function()
				local total = vim.api.nvim_buf_line_count(bufnr)
				if line and line <= total then
					vim.api.nvim_win_set_cursor(0, { line, 0 })
					pcall(orig_set, condition, hit_condition, log_message)
				end
			end)
		end

		local function restore_breakpoints()
			local f = io.open(breakpoints_path, "r")
			if not f then return end
			local data = f:read("*a")
			f:close()
			local ok_json, bps = pcall(vim.fn.json_decode, data)
			if not ok_json or type(bps) ~= "table" then return end

			for filepath, buf_bps in pairs(bps) do
				-- Check if file is already loaded in a buffer
				local loaded_bufnr = nil
				for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
					if vim.api.nvim_buf_get_name(bufnr) == filepath and vim.api.nvim_buf_is_loaded(bufnr) then
						loaded_bufnr = bufnr
						break
					end
				end

				if loaded_bufnr then
					for _, bp in ipairs(buf_bps) do
						set_bp_at_line(loaded_bufnr, bp.line, bp.condition, bp.hitCondition, bp.logMessage)
					end
				else
					-- One autocmd per file, restore all its breakpoints when opened
					local file_bps = buf_bps
					vim.api.nvim_create_autocmd("BufReadPost", {
						pattern = filepath,
						once = true,
						callback = function(ev)
							for _, bp in ipairs(file_bps) do
								set_bp_at_line(ev.buf, bp.line, bp.condition, bp.hitCondition, bp.logMessage)
							end
						end,
					})
				end
			end
		end

		restore_breakpoints()

		-- Save breakpoints on debug session events
		dap.listeners.after.event_initialized["persist_breakpoints"] = save_breakpoints
		dap.listeners.after.event_terminated["persist_breakpoints"] = save_breakpoints
		dap.listeners.after.event_exited["persist_breakpoints"] = save_breakpoints

		-- Wrap breakpoint functions to auto-save on changes
		dap.toggle_breakpoint = function(...)
			orig_toggle(...)
			vim.defer_fn(save_breakpoints, 100)
		end
		dap.set_breakpoint = function(...)
			orig_set(...)
			vim.defer_fn(save_breakpoints, 100)
		end
		dap.clear_breakpoints = function(...)
			orig_clear(...)
			vim.defer_fn(save_breakpoints, 100)
		end
	end,
}
