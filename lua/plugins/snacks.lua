-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/snacks.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/snacks.lua

-- https://github.com/folke/snacks.nvim/blob/main/docs/lazygit.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
-- https://github.com/folke/snacks.nvim/blob/main/docs/image.md

-- NOTE: If you experience an issue in which you cannot select a file with the
-- snacks picker when you're in insert mode, only in normal mode, and you use
-- the bullets.vim plugin, that's the cause, go to that file to see how to
-- resolve it
-- https://github.com/folke/snacks.nvim/issues/812

return {
	{
		"folke/snacks.nvim",
		keys = {
			-- I use this keymap with mini.files, but snacks explorer was taking over
			-- https://github.com/folke/snacks.nvim/discussions/949
			{ "<leader>e", false },
			-- Open git log in vertical view
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log({
						finder = "git_log",
						format = "git_log",
						preview = "git_show",
						confirm = "git_checkout",
						layout = "vertical",
					})
				end,
				desc = "Git Log",
			},
			-- -- List git branches with Snacks_picker to quickly switch to a new branch
			{
				"<M-l>",
				function()
					Snacks.picker.git_log({
						layout = "telescope",
					})
				end,
				desc = "Logs",
			},
			-- Used in LazyVim to view the different keymaps, this by default is
			-- configured as <leader>sk but I run it too often
			-- Sometimes I need to see if a keymap is already taken or not
			{
				"<M-k>",
				function()
					Snacks.picker.keymaps({
						layout = "vertical",
					})
				end,
				desc = "Keymaps",
			},
			-- File picker
			{
				"<leader>sf",
				function()
					Snacks.picker.files({
						finder = "files",
						format = "file",
						show_empty = true,
						supports_live = true,
					})
				end,
				desc = "Find Files",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep({
						finder = "grep",
						layout = "telescope",
						regex = true,
						format = "file",
						show_empty = true,
						live = true, -- live grep by default
						supports_live = true,
					})
				end,
				desc = "[S]earch by [G]rep",
			},
			-- Navigate my buffers
			{
				"<S-h>",
				function()
					Snacks.picker.buffers({
						-- I always want my buffers picker to start in normal mode
						on_show = function()
							vim.cmd.stopinsert()
						end,
						finder = "buffers",
						format = "buffer",
						hidden = false,
						unloaded = true,
						current = true,
						sort_lastused = true,
						win = {
							input = {
								keys = {
									["c"] = "bufdelete",
								},
							},
							list = { keys = { ["c"] = "bufdelete" } },
						},
						-- In case you want to override the layout for this keymap
						layout = "ivy",
					})
				end,
				desc = "[P]Snacks picker buffers",
			},
		},
		opts = {
			-- Documentation for the picker
			-- https://github.com/folke/snacks.nvim/blob/main/docs/picker.md
			picker = {
				-- My ~/github/dotfiles-latest/neovim/lazyvim/lua/config/keymaps.lua
				-- file was always showing at the top, I needed a way to decrease its
				-- score, in frecency you could use :FrecencyDelete to delete a file
				-- from the database, here you can decrease it's score
				-- transform = function(item)
				-- 	if not item.file then
				-- 		return item
				-- 	end
				-- 	-- Demote the "lazyvim" keymaps file:
				-- 	if item.file:match("lazyvim/lua/config/keymaps%.lua") then
				-- 		item.score_add = (item.score_add or 0) - 30
				-- 	end
				-- 	-- Boost the "neobean" keymaps file:
				-- 	-- if item.file:match("neobean/lua/config/keymaps%.lua") then
				-- 	--   item.score_add = (item.score_add or 0) + 100
				-- 	-- end
				-- 	return item
				-- end,
				-- In case you want to make sure that the score manipulation above works
				-- or if you want to check the score of each file
				debug = {
					scores = false, -- show scores in the list
				},
				-- 	-- I like the "ivy" layout, so I set it as the default globaly, you can
				-- 	-- still override it in different keymaps
				layout = {
					preset = "ivy",
					-- When reaching the bottom of the results in the picker, I don't want
					-- it to cycle and go back to the top
					cycle = false,
				},
				layouts = {
					-- I wanted to modify the ivy layout height and preview pane width,
					-- this is the only way I was able to do it
					-- NOTE: I don't think this is the right way as I'm declaring all the
					-- other values below, if you know a better way, let me know
					--
					-- Then call this layout in the keymaps above
					-- got example from here
					-- https://github.com/folke/snacks.nvim/discussions/468
					ivy = {
						layout = {
							box = "vertical",
							backdrop = false,
							row = -1,
							width = 0,
							height = 0.5,
							border = "top",
							title = " {title} {live} {flags}",
							title_pos = "left",
							{ win = "input", height = 1, border = "bottom" },
							{
								box = "horizontal",
								{ win = "list", border = "none" },
								{ win = "preview", title = "{preview}", width = 0.5, border = "left" },
							},
						},
					},
					-- 		-- I wanted to modify the layout width
					vertical = {
						layout = {
							backdrop = false,
							width = 0.8,
							min_width = 80,
							height = 0.8,
							min_height = 30,
							box = "vertical",
							border = "rounded",
							title = "{title} {live} {flags}",
							title_pos = "center",
							{ win = "input", height = 1, border = "bottom" },
							{ win = "list", border = "none" },
							{ win = "preview", title = "{preview}", height = 0.4, border = "top" },
						},
					},
				},
				-- matcher = {
				-- 	frecency = true,
				-- },
				win = {
					input = {
						keys = {
							-- to close the picker on ESC instead of going to normal mode,
							-- add the following keymap to your config
							["<Esc>"] = { "close", mode = { "n", "i" } },
							-- I'm used to scrolling like this in LazyGit
							["J"] = { "preview_scroll_down", mode = { "i", "n" } },
							["K"] = { "preview_scroll_up", mode = { "i", "n" } },
							["H"] = { "preview_scroll_left", mode = { "i", "n" } },
							["L"] = { "preview_scroll_right", mode = { "i", "n" } },
						},
					},
				},
				formatters = {
					file = {
						filename_first = true, -- display filename before the file path
						truncate = 80,
					},
				},
			},
			notifier = {
				enabled = false,
				top_down = false, -- place notifications from top to bottom
			},
			-- This keeps the image on the top right corner, basically leaving your
			-- text area free, suggestion found in reddit by user `Redox_ahmii`
			-- https://www.reddit.com/r/neovim/comments/1irk9mg/comment/mdfvk8b/?utm_source=share&utm_medium=web3x&utm_name=web3xcss&utm_term=1&utm_content=share_button
			styles = {
				snacks_image = {
					relative = "editor",
					col = -1,
				},
			},
		},
	},
}
