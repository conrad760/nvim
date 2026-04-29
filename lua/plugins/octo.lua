-- Octo.nvim — GitHub PRs, issues, and reviews inside Neovim.
-- Triggered by gh-dash's `C` keybinding: `nvim -c ":silent Octo pr edit {{.PrNumber}}"`
return {
	"pwntester/octo.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"folke/snacks.nvim",
		"nvim-tree/nvim-web-devicons",
	},
	cmd = "Octo",
	keys = {
		{ "<leader>op", "<cmd>Octo pr list<cr>", desc = "Octo: list PRs" },
		{ "<leader>oi", "<cmd>Octo issue list<cr>", desc = "Octo: list issues" },
		{ "<leader>or", "<cmd>Octo review start<cr>", desc = "Octo: start review" },
		{ "<leader>oc", "<cmd>Octo review submit<cr>", desc = "Octo: submit review" },
	},
	opts = {
		picker = "snacks",
		enable_builtin = true,
		suppress_missing_scope = {
			projects_v2 = true, -- silence warning if PAT lacks project scope
		},
		default_merge_method = "squash",
		mappings_disable_default = false,
	},
}
