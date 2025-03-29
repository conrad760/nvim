-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/mini-surround.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/mini-surround.lua
--
-- I'm just using lazyvim.org defaults here
-- This plugin comes installed by default, but it was removed one time, so just
-- leaving it here because I want to always have it installed
--
-- https://github.com/echasnovski/mini.surround

return {
	"echasnovski/mini.surround",
	recommended = true,
	opts = {
		mappings = {
			add = "gsa", -- Add surrounding in Normal and Visual modes
			delete = "gsd", -- Delete surrounding
			find = "gsf", -- Find surrounding (to the right)
			find_left = "gsF", -- Find surrounding (to the left)
			highlight = "gsv", -- Highlight surrounding
			replace = "gsc", -- Replace surrounding
			update_n_lines = "gsn", -- Update `n_lines`
		},
	},
}
