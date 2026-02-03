-- Consolidated mini.nvim configuration
-- Combines all mini.nvim modules into a single file for better organization

return {
	{
		"echasnovski/mini.nvim",
		version = "*",
		config = function()
			-- Mini.files - File explorer
			local mini_files_km = require("config.modules.mini-files-km")
			local mini_files_git = require("config.modules.mini-files-git")
			
			require("mini.files").setup({
				mappings = {
					close = "q",
					go_in = "l",
					go_in_plus = "<CR>",
					go_out = "H",
					go_out_plus = "h",
					reset = "<BS>",
					reveal_cwd = ".",
					show_help = "g?",
					synchronize = "s",
					trim_left = "<",
					trim_right = ">",
				},
				options = {
					permanent_delete = false,
					use_as_default_explorer = true,
				},
				windows = {
					preview = true,
					width_focus = 30,
					width_nofocus = 15,
					width_preview = 80,
				},
			})
			
			-- Set up keymaps and git integration
			mini_files_km.setup()
			mini_files_git.setup()
			
			-- Mini.indentscope - Show indent scope
			require("mini.indentscope").setup({
				symbol = "│",
				options = { try_as_border = true },
				draw = {
					animation = require("mini.indentscope").gen_animation.none(),
				},
			})
			
			-- Disable for certain filetypes
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"help", "alpha", "dashboard", "neo-tree", "Trouble", "trouble",
					"lazy", "mason", "notify", "toggleterm", "lazyterm",
				},
				callback = function()
					vim.b.miniindentscope_disable = true
				end,
			})
			
			-- Mini.pairs - Auto pairs
			require("mini.pairs").setup({
				modes = { insert = true, command = false, terminal = false },
			})
			
			-- Mini.surround - Surround operations
			require("mini.surround").setup({
				mappings = {
					add = "gsa",
					delete = "gsd",
					find = "gsf",
					find_left = "gsF",
					highlight = "gsh",
					replace = "gsr",
					update_n_lines = "gsn",
				},
			})
		end,
		keys = {
			-- Mini.files keymaps
			{
				"<leader>e",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (Directory of Current File)",
			},
			{
				"<leader>E",
				function()
					require("mini.files").open(vim.uv.cwd(), true)
				end,
				desc = "Open mini.files (cwd)",
			},
			{
				"<leader>gm",
				function()
					require("mini.files").open(vim.api.nvim_buf_get_name(0), true)
				end,
				desc = "Open mini.files (Directory of Current File)",
			},
			{
				"<leader>gM",
				function()
					require("mini.files").open(vim.uv.cwd(), true)
				end,
				desc = "Open mini.files (cwd)",
			},
		},
	},
}