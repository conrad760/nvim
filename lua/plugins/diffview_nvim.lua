return {
	"sindrets/diffview.nvim",
	cmd = { "DiffviewOpen", "DiffviewFileHistory" },
	keys = {
		{ "<leader>gd", "<cmd>DiffviewOpen<cr>", desc = "Open DiffView" },
		{ "<leader>gD", "<cmd>DiffviewOpen origin/main...HEAD<cr>", desc = "Open DiffView (against main)" },
		{ "<leader>gh", "<cmd>DiffviewFileHistory<cr>", desc = "File history (repo)" },
		{ "<leader>gH", "<cmd>DiffviewFileHistory %<cr>", desc = "File history (file)" },
		{ "<leader>gq", "<cmd>DiffviewClose<cr>", desc = "Close DiffView" },
	},
	opts = {
		use_icons = true,
	},
}
