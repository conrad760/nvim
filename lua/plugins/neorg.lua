return {
	"nvim-neorg/neorg", -- TODO: https://www.youtube.com/watch?v=NnmRVY22Lq8&list=PLx2ksyallYzVI8CN1JMXhEf62j2AijeDa&index=2
	lazy = false, -- Disable lazy loading as some `lazy.nvim` distributions set `lazy = true` by default
	version = "*", -- Pin Neorg to the latest stable release
	config = true,
	opts = {
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
				workspace = {},
			},
		},
	},
}
