return {
	"rebelot/kanagawa.nvim",
	--	enabled = false,
	priority = 1000,
	opts = {
		transparent = false, -- do not set background color
	},
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("kanagawa-dragon")
	end,
}
