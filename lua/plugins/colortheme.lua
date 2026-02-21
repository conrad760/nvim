local sharing = vim.env.SCREEN_SHARING ~= nil

if sharing then
	return {
		"maxmx03/solarized.nvim",
		lazy = false,
		priority = 1000,
		opts = {},
		init = function()
			vim.o.background = "light"
			vim.cmd.colorscheme("solarized")
		end,
	}
else
	return {
		"rebelot/kanagawa.nvim",
		priority = 1000,
		opts = {
			transparent = true,
		},
		init = function()
			vim.cmd.colorscheme("kanagawa")
		end,
	}
end
