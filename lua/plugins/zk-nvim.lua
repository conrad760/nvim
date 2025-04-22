return {
	"zk-org/zk-nvim",
	dependencies = { "nvim-telescope/telescope.nvim" }, -- optional, but recommended
	ft = "markdown",
	opts = {
		picker = "telescope",
		lsp = {
			config = {
				cmd = { "zk", "lsp" },
				name = "zk",
			},
			auto_attach = {
				enabled = true,
				filetypes = { "markdown" },
			},
		},
	},
	config = function()
		require("zk").setup()
	end,
}
