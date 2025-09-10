-- Enhanced Snacks.nvim configuration with full picker parity
-- Replaces Telescope with Snacks picker for all operations

return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		bigfile = { enabled = true },
		dashboard = { enabled = false }, -- Using your own dashboard
		indent = { enabled = false }, -- Using mini.indentscope
		input = { enabled = true },
		notifier = { enabled = true },
		quickfile = { enabled = true },
		scroll = { enabled = false },
		statuscolumn = { enabled = false },
		words = { enabled = true },
		picker = {
			enabled = true,
			-- Default layout configuration
			layout = {
				preset = "telescope",
			},
			-- Default find options
			defaults = {
				file_ignore_patterns = { "node_modules", ".git", "dist", "build" },
				-- Show filename before path for all file pickers
				formatters = {
					file = {
						filename_first = true, -- display filename before the file path
						truncate = 80,
					},
				},
			},
		},
	},
	keys = {
		-- Disable default explorer binding (using mini.files)
		{ "<leader>e", false },

		-- Buffer Operations
		{
			"<S-h>",
			function()
				Snacks.picker.buffers({
					-- I always want my buffers picker to start in normal mode
					on_show = function()
						vim.cmd.stopinsert()
					end,
					finder = "buffers",
					layout = "ivy",
					show_empty = true,
					sort_mru = true,
					sort_lastused = true,
				})
			end,
			desc = "Shift Huffers",
		},
		{ "<leader><space>", "<cmd>e #<cr>", desc = "Alternate Buffer" },

		-- File Operations
		{
			"<leader>sf",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>sF",
			function()
				Snacks.picker.files({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Find Files (current dir)",
		},
		{
			"<leader>sR",
			function()
				Snacks.picker.recent()
			end,
			desc = "Recent Files",
		},
		{
			"<leader>sb",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers",
		},
		{
			"<leader>sr",
			function()
				Snacks.picker.resume()
			end,
			desc = "Resume Last Search",
		},

		-- Text Search
		{
			"<leader>sg",
			function()
				Snacks.picker.grep()
			end,
			desc = "Live Grep",
		},
		{
			"<leader>sw",
			function()
				Snacks.picker.grep_word()
			end,
			desc = "Grep Word Under Cursor",
			mode = { "n", "x" },
		},
		{
			"<leader>sG",
			function()
				Snacks.picker.grep({ cwd = vim.fn.expand("%:p:h") })
			end,
			desc = "Grep (current dir)",
		},

		-- Git Operations
		{
			"<leader>gc",
			function()
				Snacks.picker.git_commits()
			end,
			desc = "Git Commits",
		},
		{
			"<leader>gs",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status",
		},
		{
			"<leader>gb",
			function()
				Snacks.picker.git_branches()
			end,
			desc = "Git Branches",
		},
		{
			"<leader>gl",
			function()
				Snacks.picker.git_log({ layout = "vertical" })
			end,
			desc = "Git Log",
		},
		{
			"<leader>gf",
			function()
				Snacks.picker.git_files()
			end,
			desc = "Git Files",
		},

		-- LSP Operations
		{
			"gd",
			function()
				Snacks.picker.lsp_definitions()
			end,
			desc = "Goto Definition",
		},
		{
			"gr",
			function()
				Snacks.picker.lsp_references()
			end,
			desc = "References",
		},
		{
			"gI",
			function()
				Snacks.picker.lsp_implementations()
			end,
			desc = "Goto Implementation",
		},
		{
			"gy",
			function()
				Snacks.picker.lsp_type_definitions()
			end,
			desc = "Goto Type Definition",
		},
		{
			"<leader>ss",
			function()
				Snacks.picker.lsp_symbols()
			end,
			desc = "Document Symbols",
		},
		{
			"<leader>sS",
			function()
				Snacks.picker.lsp_workspace_symbols()
			end,
			desc = "Workspace Symbols",
		},
		{
			"<leader>sd",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},
		{
			"<leader>sD",
			function()
				Snacks.picker.diagnostics({ current_buf = true })
			end,
			desc = "Buffer Diagnostics",
		},

		-- Vim/Help Operations
		{
			"<leader>sh",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Pages",
		},
		{
			"<leader>sk",
			function()
				Snacks.picker.keymaps()
			end,
			desc = "Keymaps",
		},
		{
			"<leader>sc",
			function()
				Snacks.picker.commands()
			end,
			desc = "Commands",
		},
		{
			"<leader>sm",
			function()
				Snacks.picker.marks()
			end,
			desc = "Marks",
		},
		{
			"<leader>sj",
			function()
				Snacks.picker.jumps()
			end,
			desc = "Jumps",
		},
		{
			"<leader>s:",
			function()
				Snacks.picker.command_history()
			end,
			desc = "Command History",
		},
		{
			"<leader>s/",
			function()
				Snacks.picker.search_history()
			end,
			desc = "Search History",
		},
		{
			"<leader>sM",
			function()
				Snacks.picker.man()
			end,
			desc = "Man Pages",
		},
		{
			"<leader>so",
			function()
				Snacks.picker.options()
			end,
			desc = "Vim Options",
		},
		{
			"<leader>sa",
			function()
				Snacks.picker.autocmds()
			end,
			desc = "Autocmds",
		},
		{
			"<leader>sH",
			function()
				Snacks.picker.highlights()
			end,
			desc = "Highlights",
		},
		{
			"<leader>st",
			function()
				Snacks.picker.treesitter()
			end,
			desc = "Treesitter Symbols",
		},
		{
			"<leader>sq",
			function()
				Snacks.picker.qflist()
			end,
			desc = "Quickfix List",
		},
		{
			"<leader>sl",
			function()
				Snacks.picker.loclist()
			end,
			desc = "Location List",
		},

		-- Special/Custom
		{
			"<leader>sn",
			function()
				Snacks.picker.notifications()
			end,
			desc = "Notifications",
		},
		{
			"<leader>.",
			function()
				Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
			end,
			desc = "Neovim Config Files",
		},
		{
			"<leader>sp",
			function()
				Snacks.picker.lazy()
			end,
			desc = "Lazy Plugins",
		},

		-- Quick access shortcuts
		{
			"<C-p>",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files",
		},
		{
			"<M-l>",
			function()
				Snacks.picker.git_log({ layout = "telescope" })
			end,
			desc = "Git Logs",
		},
		{
			"<S-l>",
			function()
				Snacks.picker.diagnostics()
			end,
			desc = "Diagnostics",
		},

		-- Other Snacks features
		{
			"<leader>n",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		{
			"<leader>bd",
			function()
				Snacks.bufdelete()
			end,
			desc = "Delete Buffer",
		},
		{
			"<leader>bo",
			function()
				Snacks.bufdelete.other()
			end,
			desc = "Delete Other Buffers",
		},

		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Git Browse",
			mode = { "n", "v" },
		},
		{
			"<leader>un",
			function()
				Snacks.notifier.hide()
			end,
			desc = "Dismiss All Notifications",
		},
		{
			"]]",
			function()
				Snacks.words.jump(vim.v.count1)
			end,
			desc = "Next Reference",
			mode = { "n", "t" },
		},
		{
			"[[",
			function()
				Snacks.words.jump(-vim.v.count1)
			end,
			desc = "Prev Reference",
			mode = { "n", "t" },
		},

		-- Rename with Snacks
		{
			"<leader>cr",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
	},
	init = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "VeryLazy",
			callback = function()
				-- Setup toggle keymaps
				Snacks.toggle.option("spell", { name = "Spelling" }):map("<leader>us")
				Snacks.toggle.option("wrap", { name = "Wrap" }):map("<leader>uw")
				Snacks.toggle.option("relativenumber", { name = "Relative Number" }):map("<leader>uL")
				Snacks.toggle.diagnostics():map("<leader>ud")
				Snacks.toggle.line_number():map("<leader>ul")
				Snacks.toggle
					.option("conceallevel", { off = 0, on = vim.o.conceallevel > 0 and vim.o.conceallevel or 2 })
					:map("<leader>uc")
				Snacks.toggle.treesitter():map("<leader>uT")
				Snacks.toggle
					.option("background", { off = "light", on = "dark", name = "Dark Background" })
					:map("<leader>ub")
				Snacks.toggle.inlay_hints():map("<leader>uh")
				Snacks.toggle.indent():map("<leader>ug")
				Snacks.toggle.dim():map("<leader>uD")
			end,
		})
	end,
}
