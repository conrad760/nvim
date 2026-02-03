return {
	"mfussenegger/nvim-dap",
	dependencies = {
		"rcarriga/nvim-dap-ui",
		"nvim-neotest/nvim-nio",
		"williamboman/mason.nvim",
		"jay-babu/mason-nvim-dap.nvim",
		"theHamsta/nvim-dap-virtual-text",
		"leoluz/nvim-dap-go", -- Add Go debugger support
	},
	-- Ergonomic keymaps designed for split keyboard workflow
	-- Using leader+d namespace with intuitive mnemonics
	keys = {
		-- MOST COMMON: These are what you'll use 90% of the time
		{ "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Debug: Toggle Breakpoint" },
		{ "<leader>dc", function() require("dap").continue() end, desc = "Debug: Continue/Start" },
		{ "<leader>dt", function() require("dap").terminate() end, desc = "Debug: Stop/Terminate" },
		
		-- STEPPING: Intuitive single letters (j/k like vim, n for next)
		{ "<leader>dn", function() require("dap").step_over() end, desc = "Debug: Step Over (Next)" },
		{ "<leader>di", function() require("dap").step_into() end, desc = "Debug: Step Into" },
		{ "<leader>do", function() require("dap").step_out() end, desc = "Debug: Step Out" },
		
		-- UI & INSPECTION
		{ "<leader>du", function() require("dapui").toggle() end, desc = "Debug: Toggle UI" },
		{ "<leader>de", function() require("dapui").eval() end, desc = "Debug: Evaluate", mode = {"n", "v"} },
		{ "<leader>dh", function() require("dap.ui.widgets").hover() end, desc = "Debug: Hover Variables" },
		
		-- Go-SPECIFIC (most important for your workflow!)
		{ "<leader>dT", function() require("dap-go").debug_test() end, desc = "Debug: Go Test", ft = "go" },
		{ "<leader>dL", function() require("dap-go").debug_last_test() end, desc = "Debug: Last Go Test", ft = "go" },
	},
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

		-- Better icons for breakpoints with unified colors
		local colors = require("config.colors")
		colors.apply_to_debug_ui()
		
		vim.fn.sign_define("DapBreakpoint", { text = "●", texthl = "DapBreakpoint", linehl = "", numhl = "" })
		vim.fn.sign_define("DapBreakpointCondition", { text = "◆", texthl = "DapBreakpointCondition", linehl = "", numhl = "" })
		vim.fn.sign_define("DapStopped", { text = "▶", texthl = "DapStopped", linehl = "DapStopped", numhl = "" })

		-- Helper function to prompt for command-line arguments.
		local function get_args()
			local input = vim.fn.input("Arguments: ")
			return vim.fn.split(input, " +")
		end

		-- Mason-nvim-dap: automatically install & setup debuggers.
		require("mason-nvim-dap").setup({
			automatic_installation = true,
			automatic_setup = true,
			ensure_installed = { "delve", "node-debug2-adapter" },
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
					position = "right", -- Changed to right for better code visibility
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
			vim.notify("Debugger attached", vim.log.levels.INFO)
		end
		dap.listeners.before.event_terminated["dapui_config"] = dapui.close
		dap.listeners.before.event_exited["dapui_config"] = dapui.close

		-- Define the Node adapter.
		-- Adjust the adapter path if needed.
		dap.adapters.node2 = {
			type = "executable",
			command = "node",
			args = { vim.fn.stdpath("data") .. "/mason/packages/node-debug2-adapter/out/src/nodeDebug.js" },
		}

		-- Minimal JavaScript configuration.
		dap.configurations.javascript = {
			{
				name = "Launch current file",
				type = "node2",
				request = "launch",
				program = "${file}",
				cwd = vim.fn.getcwd(),
				console = "integratedTerminal",
			},
		}

		-- Additional less-common keymaps
		local dap_keymaps = {
			-- Breakpoint variations
			{ "<leader>dB", function() dap.set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, desc = "Debug: Conditional Breakpoint" },
			{ "<leader>dx", function() 
				dap.clear_breakpoints()
				vim.notify("All breakpoints cleared", vim.log.levels.WARN)
			end, desc = "Debug: Clear All Breakpoints" },
			
			-- Advanced control
			{ "<leader>dC", dap.run_to_cursor, desc = "Debug: Run to Cursor" },
			{ "<leader>da", function() dap.continue({ before = get_args }) end, desc = "Debug: Run with Args" },
			{ "<leader>dl", dap.run_last, desc = "Debug: Run Last" },
			{ "<leader>dp", dap.pause, desc = "Debug: Pause" },
			
			-- Stack navigation
			{ "<leader>dj", dap.down, desc = "Debug: Down Stack" },
			{ "<leader>dk", dap.up, desc = "Debug: Up Stack" },
			
			-- REPL
			{ "<leader>dr", dap.repl.toggle, desc = "Debug: Toggle REPL" },
		}
		
		for _, map in ipairs(dap_keymaps) do
			vim.keymap.set(map.mode or "n", map[1], map[2], { desc = map.desc })
		end

		-- Enhanced Go debugging setup
		require("dap-go").setup({
			-- Additional dap configurations for Go
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
			-- delve configurations
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
		
		-- Show a helpful message when DAP is loaded
		vim.notify("Debugger Ready! <leader>db=breakpoint, <leader>dc=start, <leader>dT=test", vim.log.levels.INFO)
	end,
}
