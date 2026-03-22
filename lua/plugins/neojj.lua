return {
	"NicholasZolton/neojj",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		"echasnovski/mini.pick", -- optional
	},
	keys = {
		{ "<leader>jj", "<cmd>:Neojj kind=auto<CR>", desc = "Open Neojj" },
	},
	config = true,
}
