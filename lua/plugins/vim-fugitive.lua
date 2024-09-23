return {
	"tpope/vim-fugitive",
	cmd = { "Git", "Gdiffsplit", "Gread", "Gwrite", "Ggrep", "GMove", "GDelete", "GBrowse" },
	dependencies = { "tpope/vim-rhubarb" },
	keys = {
		{ "<leader>gB", ":GBrowse<cr>", mode = { "n", "v" }, desc = "[G]it [B]rowse" },
	},
}
