return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration
		"echasnovski/mini.pick", -- optional
	},
	keys = {
		{ "<leader>gg", "<cmd>:Neogit kind=auto<CR>", desc = "Open Neogit" },
		{ "<M-g>", "<cmd>:Neogit kind=floating<CR>", desc = "Open Neogit" },
	},
	config = true,
}
