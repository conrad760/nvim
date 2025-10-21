return {
	"NachoNievaG/atac.nvim",
	enabled = false,
	dependencies = { "akinsho/toggleterm.nvim" },
	keys = {
		{
			"<leader>la",
			function()
				vim.notify("Launching Atac...", vim.log.levels.INFO)
				vim.cmd("Atac")
			end,
			desc = "HTTP Client (Atac)",
		},
	},
	config = function()
		require("atac").setup({
			-- dir will use default plugin path
		})
		vim.notify("Atac has been configured", vim.log.levels.INFO)
	end,
}
