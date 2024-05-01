return {
	"stevearc/oil.nvim",
	opts = {},
	-- Optional dependencies
	dependencies = { "nvim-tree/nvim-web-devicons" },
	vim.api.nvim_set_keymap(
		"n",
		"<leader>oi",
		"<cmd>lua require('oil').open_float('.')<CR>",
		{ desc = "Open parent directory", noremap = true, silent = true }
	),
}
