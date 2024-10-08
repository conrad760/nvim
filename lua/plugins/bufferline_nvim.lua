return {
	"akinsho/bufferline.nvim",
	dependencies = "nvim-tree/nvim-web-devicons",
	opts = {
		options = {
			mode = "buffers", -- set to "tabs" to only show tabpages instead
			numbers = "none", -- | "ordinal" | "buffer_id" | "both" | function({ ordinal, id, lower, raise }): string,
			close_command = "Bdelete! %d", -- can be a string | function, see "Mouse actions"
			right_mouse_command = nil, -- can be a string | function, see "Mouse actions"
			left_mouse_command = nil, -- can be a string | function, see "Mouse actions"
			middle_mouse_command = nil, -- can be a string | function, see "Mouse actions"
			indicator = {
				icon = "▎", -- this should be omitted if indicator style is not 'icon'
				style = "icon", --'icon' | 'underline' | 'none',
			},
			buffer_close_icon = "",
			modified_icon = "●",
			close_icon = " ",
			left_trunc_marker = " ",
			right_trunc_marker = " ",
			max_name_length = 25,
			max_prefix_length = 23, -- prefix used when a buffer is de-duplicated
			truncate_names = true, -- whether or not tab names should be truncated
			tab_size = 25,
			diagnostics = "nvim_lsp", -- | "nvim_lsp" | "coc",
			diagnostics_update_in_insert = false,
			-- The diagnostics indicator can be set to nil to keep the buffer name highlight but delete the highlighting
			diagnostics_indicator = function(count)
				return "(" .. count .. ")"
			end,
			-- NOTE: this will be called a lot so don't do any heavy processing here
			-- custom_filter = function(buf_number, buf_numbers)
			-- 	-- filter out filetypes you don't want to see
			-- 	if vim.bo[buf_number].filetype ~= "<i-dont-want-to-see-this>" then
			-- 		return true
			-- 	end
			-- 	-- filter out by buffer name
			-- 	if vim.fn.bufname(buf_number) ~= "<buffer-name-I-dont-want>" then
			-- 		return true
			-- 	end
			-- 	-- filter out based on arbitrary rules
			-- 	-- e.g. filter out vim wiki buffer from tabline in your work repo
			-- 	if vim.fn.getcwd() == "<work-repo>" and vim.bo[buf_number].filetype ~= "wiki" then
			-- 		return true
			-- 	end
			-- 	-- filter out by it's index number in list (don't show first buffer)
			-- 	if buf_numbers[1] ~= buf_number then
			-- 		return true
			-- 	end
			-- end,
			offsets = {
				{
					filetype = "NvimTree",
					text = "File Explorer", --| function ,
					text_align = "left", --| "center" | "right"
					separator = true,
				},
			},
			color_icons = true, -- | false, -- whether or not to add the filetype icon highlights
			show_buffer_icons = true, -- | false, -- disable filetype icons for buffers
			show_buffer_close_icons = true, -- | false,
			-- show_buffer_default_icon = true, -- | false, -- whether or not an unrecognised filetype should show a default icon
			show_close_icon = true, -- | false,
			show_tab_indicators = true, -- | false,
			show_duplicate_prefix = true, -- | false, -- whether to show duplicate buffer prefix
			persist_buffer_sort = true, -- whether or not custom sorted buffers should persist
			-- can also be a table containing 2 custom separators
			-- [focused and unfocused]. eg: { '|', '|' }
			separator_style = "slant", -- | "thick" | "thin" | { 'any', 'any' },
			enforce_regular_tabs = false, -- | true,
			always_show_bufferline = true, -- | false,
			hover = {
				enabled = true,
				delay = 200,
				reveal = { "close" },
			},
			sort_by = "insert_at_end", -- | 'insert_after_current' |'insert_at_end' | 'id' | 'extension' | 'relative_directory' | 'directory' | 'tabs' | function(buffer_a, buffer_b)
		},
	},
}
