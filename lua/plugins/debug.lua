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
	config = function()
		local dap = require("dap")
		local dapui = require("dapui")

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

		-- Setup dap-ui with some emoji icons.
		dapui.setup({
			floating = {
				max_height = nil,
				max_width = nil,
				border = "single",
				mappings = { close = { "q", "<Esc>" } },
			},

			mappings = {}, -- Minimal empty mapping
			element_mappings = {}, -- Minimal empty element mappings
			expand_lines = true, -- Use true to auto-expand long lines
			force_buffers = true, -- Force using dedicated buffers for UI elements
			layouts = {
				{
					elements = {
						{ id = "scopes", size = 0.25 },
						{ id = "breakpoints", size = 0.25 },
						{ id = "stacks", size = 0.25 },
						{ id = "watches", size = 0.25 },
					},
					size = 40,
					position = "left",
				},
				{
					elements = { "repl", "console" },
					size = 10,
					position = "bottom",
				},
			},
		})

		-- Automatically open/close the dap-ui on session events.
		dap.listeners.after.event_initialized["dapui_config"] = dapui.open
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

		-- Restore your earlier key mappings.
		local dap_keymaps = {
			{
				"<leader>dB",
				function()
					dap.set_breakpoint(vim.fn.input("Breakpoint condition: "))
				end,
				desc = "Breakpoint Condition",
			},
			{ "<leader>db", dap.toggle_breakpoint, desc = "Toggle Breakpoint" },
			{ "<leader>dc", dap.continue, desc = "Run/Continue" },
			{
				"<leader>da",
				function()
					dap.continue({ before = get_args })
				end,
				desc = "Run with Args",
			},
			{ "<leader>dC", dap.run_to_cursor, desc = "Run to Cursor" },
			{ "<leader>dg", dap.goto_, desc = "Go to Line (No Execute)" },
			{ "<leader>di", dap.step_into, desc = "Step Into" },
			{ "<leader>dj", dap.down, desc = "Down" },
			{ "<leader>dk", dap.up, desc = "Up" },
			{ "<leader>dl", dap.run_last, desc = "Run Last" },
			{ "<leader>do", dap.step_out, desc = "Step Out" },
			{ "<leader>dO", dap.step_over, desc = "Step Over" },
			{ "<leader>dP", dap.pause, desc = "Pause" },
			{ "<leader>dr", dap.repl.toggle, desc = "Toggle REPL" },
			{ "<leader>ds", dap.session, desc = "Session" },
			{ "<leader>dt", dap.terminate, desc = "Terminate" },
			{
				"<leader>dw",
				function()
					require("dap.ui.widgets").hover()
				end,
				desc = "Widgets",
			},
			{
				"<localleader>dd",
				function()
					dap.clear_breakpoints()
					require("notify")("Breakpoints cleared", "warn")
				end,
				desc = "Clear Breakpoints",
			},
		}
		for _, map in ipairs(dap_keymaps) do
			vim.keymap.set("n", map[1], map[2], { desc = map.desc })
		end

		-- Initialize Go debugging.
		require("dap-go").setup()
	end,
}
