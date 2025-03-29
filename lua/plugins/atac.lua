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
			dir = "~/.config/atac", -- Ensure this directory exists and is writable.
			-- Optionally add a debug flag if the plugin supports it:
			-- debug = true,
		})
		vim.notify("Atac has been configured", vim.log.levels.INFO)
	end,
}
