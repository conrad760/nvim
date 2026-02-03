return {
	"nvim-neorg/neorg",
	ft = "norg", -- Load only for .norg files instead of globally
	version = "*", -- Pin Neorg to the latest stable release
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
	},
	opts = {
		load = {
			["core.defaults"] = {},
			["core.concealer"] = {
				config = {
					icon_preset = "varied",
				},
			},
			["core.summary"] = {},
			["core.completion"] = {
				config = {
					engine = "nvim-cmp",
				},
			},
			["core.dirman"] = {
				config = {
					workspaces = {}, -- Note: it's "workspaces" not "workspace"
				},
			},
		},
	},
}
