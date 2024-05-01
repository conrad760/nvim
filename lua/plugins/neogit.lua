return {
	"TimUntersberger/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		"nvim-telescope/telescope.nvim", -- optional
	},
	keys = { { "<leader>gg", "<cmd>:Neogit<CR>" } },
	opts = {},
}
