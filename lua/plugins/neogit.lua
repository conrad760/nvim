return {
	"NeogitOrg/neogit",
	dependencies = {
		"nvim-lua/plenary.nvim", -- required
		"sindrets/diffview.nvim", -- optional - Diff integration

		-- Only one of these is needed.
		"nvim-telescope/telescope.nvim", -- optional
		"ibhagwan/fzf-lua", -- optional
		"echasnovski/mini.pick", -- optional
	},
	keys = {
		{ "<leader>gg", "<cmd>:Neogit kind=auto<CR>", desc = "Open Neogit" },
		{ "<M-g>", "<cmd>:Neogit kind=floating<CR>", desc = "Open Neogit" },
	},
	config = true,
}
