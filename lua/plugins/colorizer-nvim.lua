-- Replaced norcalli/nvim-colorizer.lua (unmaintained) with NvChad fork
-- https://github.com/NvChad/nvim-colorizer.lua

return {
	"NvChad/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("colorizer").setup({
			filetypes = { "*" },
			user_default_options = {
				RGB = true,
				RRGGBB = true,
				names = false, -- "Name" codes like Blue
				RRGGBBAA = true,
				AARRGGBB = true,
				rgb_fn = true, -- CSS rgb() and rgba()
				hsl_fn = true, -- CSS hsl() and hsla()
				css = true,
				css_fn = true,
				mode = "background", -- "foreground", "background", "virtualtext"
				tailwind = true,
				virtualtext = "",
			},
		})
	end,
}
