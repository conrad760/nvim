return {
	"rebelot/kanagawa.nvim",
	priority = 1000,
	opts = {
		transparent = true, -- do  set background color
	},
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("kanagawa")
	end,
}
