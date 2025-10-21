-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/render-markdown.lua

-- https://github.com/MeanderingProgrammer/markdown.nvim
--
-- When I hover over markdown headings, this plugins goes away, so I need to
-- edit the default highlights
-- I tried adding this as an autocommand, in the options.lua
-- file, also in the markdownl.lua file, but the highlights kept being overriden
-- so the only way I was able to make it work was loading it
-- after the config.lazy in the init.lua file lamw25wmal

-- Require the colors.lua module and access the colors directly without
-- additional file reads
local colors = require("config.colors")

return {
	"MeanderingProgrammer/render-markdown.nvim",
	enabled = true,
	-- Moved highlight creation out of opts as suggested by plugin maintainer
	-- There was no issue, but it was creating unnecessary noise when ran
	-- :checkhealth render-markdown
	-- https://github.com/MeanderingProgrammer/render-markdown.nvim/issues/138#issuecomment-2295422741
	init = function()
		local colorInline_bg = "#ebfafa" -- colors["linkarzu_color02"]
		-- local color_fg = colors["linkarzu_color26"]
		-- local color_sign = "#ebfafa"
		-- Define color variables
		local color1_bg = colors["linkarzu_color04"]
		local color2_bg = colors["linkarzu_color02"]
		local color3_bg = colors["linkarzu_color03"]
		local color4_bg = colors["linkarzu_color01"]
		local color5_bg = colors["linkarzu_color05"]
		local color6_bg = colors["linkarzu_color08"]
		local color_fg1 = colors["linkarzu_color18"]
		local color_fg2 = colors["linkarzu_color19"]
		local color_fg3 = colors["linkarzu_color20"]
		local color_fg4 = colors["linkarzu_color21"]
		local color_fg5 = colors["linkarzu_color22"]
		local color_fg6 = colors["linkarzu_color23"]

		-- Heading colors (when not hovered over), extends through the entire line
		vim.cmd(string.format([[highlight Headline1Bg guibg=%s guifg=%s ]], color_fg1, color1_bg))
		vim.cmd(string.format([[highlight Headline2Bg guibg=%s guifg=%s ]], color_fg2, color2_bg))
		vim.cmd(string.format([[highlight Headline3Bg guibg=%s guifg=%s ]], color_fg3, color3_bg))
		vim.cmd(string.format([[highlight Headline4Bg guibg=%s guifg=%s ]], color_fg4, color4_bg))
		vim.cmd(string.format([[highlight Headline5Bg guibg=%s guifg=%s ]], color_fg5, color5_bg))
		vim.cmd(string.format([[highlight Headline6Bg guibg=%s guifg=%s ]], color_fg6, color6_bg))
		-- Define inline code highlight for markdown
		-- vim.cmd(string.format([[highlight RenderMarkdownCodeInline guifg=%s guibg=%s]], colorInline_bg, color_fg))
		vim.cmd(string.format([[highlight RenderMarkdownCodeInline guifg=%s]], colorInline_bg))
		
		-- Additional highlights for HTML tags
		vim.cmd([[highlight Bold gui=bold]])
		vim.cmd([[highlight Italic gui=italic]])
		vim.cmd([[highlight RenderMarkdownBullet guifg=]] .. colors["linkarzu_color02"])

		-- Highlight for the heading and sign icons (symbol on the left)
		-- I have the sign disabled for now, so this makes no effect
		vim.cmd(string.format([[highlight Headline1Fg cterm=bold gui=bold guifg=%s]], color1_bg))
		vim.cmd(string.format([[highlight Headline2Fg cterm=bold gui=bold guifg=%s]], color2_bg))
		vim.cmd(string.format([[highlight Headline3Fg cterm=bold gui=bold guifg=%s]], color3_bg))
		vim.cmd(string.format([[highlight Headline4Fg cterm=bold gui=bold guifg=%s]], color4_bg))
		vim.cmd(string.format([[highlight Headline5Fg cterm=bold gui=bold guifg=%s]], color5_bg))
		vim.cmd(string.format([[highlight Headline6Fg cterm=bold gui=bold guifg=%s]], color6_bg))
	end,
	opts = {
		code = {
			-- Turn on / off code block & inline code rendering.
			enabled = true,
			-- Additional modes to render code blocks.
			render_modes = false,
			-- Turn on / off any sign column related rendering.
			sign = true,
			-- Determines how code blocks & inline code are rendered.
			-- | none     | disables all rendering                                                    |
			-- | normal   | highlight group to code blocks & inline code, adds padding to code blocks |
			-- | language | language icon to sign column if enabled and icon + name above code blocks |
			-- | full     | normal + language                                                         |
			style = "full",
			-- Determines where language icon is rendered.
			-- | right | right side of code block |
			-- | left  | left side of code block  |
			position = "left",
			-- Amount of padding to add around the language.
			-- If a float < 1 is provided it is treated as a percentage of available window space.
			language_pad = 0,
			-- Whether to include the language icon above code blocks.
			language_icon = false,
			-- Whether to include the language name above code blocks.
			language_name = false,
			-- A list of language names for which background highlighting will be disabled.
			-- Likely because that language has background highlights itself.
			-- Use a boolean to make behavior apply to all languages.
			-- Borders above & below blocks will continue to be rendered.
			disable_background = { "diff" },
			-- Width of the code block background.
			-- | block | width of the code block  |
			-- | full  | full width of the window |
			width = "block",
			-- Amount of margin to add to the left of code blocks.
			-- If a float < 1 is provided it is treated as a percentage of available window space.
			-- Margin available space is computed after accounting for padding.
			left_margin = 1,
			-- Amount of padding to add to the left of code blocks.
			-- If a float < 1 is provided it is treated as a percentage of available window space.
			left_pad = 0,
			-- Amount of padding to add to the right of code blocks when width is 'block'.
			-- If a float < 1 is provided it is treated as a percentage of available window space.
			right_pad = 2,
			-- Minimum width to use for code blocks when width is 'block'.
			min_width = 80,
			-- Determines how the top / bottom of code block are rendered.
			-- | none  | do not render a border                               |
			-- | thick | use the same highlight as the code body              |
			-- | thin  | when lines are empty overlay the above & below icons |
			-- | hide  | conceal lines unless language name or icon is added  |
			border = "hide",
			-- Used above code blocks for thin border.
			above = "▁",
			-- Used below code blocks for thin border.
			below = "▔",
			-- Icon to add to the left of inline code.
			inline_left = "",
			-- Icon to add to the right of inline code.
			inline_right = "",
			-- Padding to add to the left & right of inline code.
			inline_pad = 0,
			-- Highlight for code blocks.
			highlight = "RenderMarkdownCode",
			-- Highlight for language, overrides icon provider value.
			highlight_language = nil,
			-- Highlight for border, use false to add no highlight.
			highlight_border = "RenderMarkdownCodeBorder",
			-- Highlight for language, used if icon provider does not have a value.
			highlight_fallback = "RenderMarkdownCodeFallback",
			-- Highlight for inline code.
			highlight_inline = "RenderMarkdownCodeInline",
		},
		bullet = {
			-- Turn on / off list bullet rendering
			enabled = true,
		},
		checkbox = {
			-- Turn on / off checkbox state rendering
			enabled = true,
			-- Determines how icons fill the available space:
			--  inline:  underlying text is concealed resulting in a left aligned icon
			--  overlay: result is left padded with spaces to hide any additional text
			position = "inline",
			unchecked = {
				-- Replaces '[ ]' of 'task_list_marker_unchecked'
				-- icon = "   󰄱 ",
				-- Highlight for the unchecked icon
				highlight = "RenderMarkdownUnchecked",
				-- Highlight for item associated with unchecked checkbox
				scope_highlight = nil,
			},
			checked = {
				-- Replaces '[x]' of 'task_list_marker_checked'
				-- icon = "   󰱒 ",
				-- Highlight for the checked icon
				highlight = "RenderMarkdownChecked",
				-- Highlight for item associated with checked checkbox
				scope_highlight = nil,
			},
		},
		html = {
			-- Turn on / off all HTML rendering
			enabled = true,
			comment = {
				-- Turn on / off HTML comment concealing
				conceal = false,
			},
			-- HTML tags whose start and end will be hidden and icon shown
			tag = {
				-- Paragraph
				p = {
					icon = "",
					highlight = "Normal",
				},
				-- Preformatted text/code blocks
				pre = {
					icon = "",
					highlight = "RenderMarkdownCode",
				},
				-- Unordered list
				ul = {
					icon = "",
					highlight = "RenderMarkdownBullet",
				},
				-- Ordered list
				ol = {
					icon = "",
					highlight = "RenderMarkdownBullet",
				},
				-- List item rendering
				li = {
					icon = "• ",
					highlight = "RenderMarkdownBullet",
				},
				-- Code tag rendering  
				code = {
					icon = "",
					highlight = "RenderMarkdownCodeInline",
				},
				-- Strong/Bold tag rendering
				strong = {
					icon = "",
					highlight = "Bold",
				},
				-- Additional common HTML tags
				em = {
					icon = "",
					highlight = "Italic",
				},
				b = {
					icon = "",
					highlight = "Bold",
				},
				i = {
					icon = "",
					highlight = "Italic",
				},
				-- Span (common in LeetCode)
				span = {
					icon = "",
					highlight = "Normal",
				},
				-- Div
				div = {
					icon = "",
					highlight = "Normal",
				},
			},
		},
		-- Add custom icons lamw26wmal
		link = {
			custom = {
				youtu = { pattern = "youtu%.be", icon = "󰗃 " },
			},
		},
		heading = {
			sign = true,
			icons = { "󰎤 ", "󰎧 ", "󰎪 ", "󰎭 ", "󰎱 ", "󰎳 " },
			backgrounds = {
				"Headline1Bg",
				"Headline2Bg",
				"Headline3Bg",
				"Headline4Bg",
				"Headline5Bg",
				"Headline6Bg",
			},
			foregrounds = {
				"Headline1Fg",
				"Headline2Fg",
				"Headline3Fg",
				"Headline4Fg",
				"Headline5Fg",
				"Headline6Fg",
			},
		},
	},
}
