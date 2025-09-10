-- [[ Setting options ]]
-- These are the options you can change in neovim.
-- use `:help vim.opt` for more information

-- Make line numbers default
vim.opt.number = true
-- You can also add relative line numbers, to help with jumping. Experiment for yourself to see if you like it! vim.opt.relativenumber = true
-- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.mouse = "a"

-- Don't show the mode, since it's already in the status line
vim.opt.showmode = false

-- Sync clipboard between OS and Neovim.
--  Remove this option if you want your OS clipboard to remain independent.
--  See `:help 'clipboard'`
vim.opt.clipboard = "unnamedplus"

-- Enable break indent
vim.opt.breakindent = true

-- Save undo history
vim.opt.undofile = true

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- colorcolumn
---- char = "|",
-- char = "",
-- char = "┇",
-- char = "∶",
-- char = "∷",
-- char = "⋮",
-- char = "",
-- char = "󰮾",
-- vim.opt.colorcolumn = "║"
-- vim.opt.colorcolumn = ""

-- Keep signcolumn on by default
vim.opt.signcolumn = "yes"

-- Decrease update time
vim.opt.updatetime = 250

-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300

-- Configure how new splits should be opened
vim.opt.splitright = true
vim.opt.splitbelow = true

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- Preview substitutions live, as you type!
vim.opt.inccommand = "split"

-- Show which line your cursor is on
vim.opt.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- When text reaches this limit, it automatically wraps to the next line.
-- This WILL NOT auto wrap existing lines, or if you paste a long line into a
-- file it will not wrap it as well
-- https://www.reddit.com/r/neovim/comments/1av26kw/i_tried_to_figure_it_out_but_i_give_up_how_do_i/
vim.opt.textwidth = 150

vim.opt.cmdheight = 1
vim.opt.completeopt = { "menuone", "noselect" }
vim.opt.conceallevel = 1
vim.opt.fileencoding = "utf-8"
vim.opt.hlsearch = true
vim.opt.smartindent = true
vim.opt.swapfile = false
vim.opt.termguicolors = true
vim.opt.undofile = true
vim.opt.writebackup = false
vim.opt.expandtab = true
vim.opt.shiftwidth = 2
vim.opt.tabstop = 2
vim.opt.wrap = false
vim.opt.sidescrolloff = 2
vim.opt.guifont = "Monaco:h10"
vim.opt.foldlevel = 8

vim.opt.shortmess:append("c")

--Show buffer count
vim.cmd(string.format([[highlight WinBar1 guifg=%s]], "#c4b28a"))
vim.cmd(string.format([[highlight WinBar2 guifg=%s]], "#8a9a7b"))
-- Function to get the number of open buffers using the :ls command
local function get_buffer_count()
	local buffers = vim.fn.execute("ls")
	local count = 0
	-- Match only lines that represent buffers, typically starting with a number followed by a space
	for line in string.gmatch(buffers, "[^\r\n]+") do
		if string.match(line, "^%s*%d+") then
			count = count + 1
		end
	end
	return count
end

-- Function to update the winbar
local function update_winbar()
	local buffer_count = get_buffer_count()
	vim.opt.winbar = "%#WinBar1#%m "
		.. "%#WinBar2#("
		.. buffer_count
		.. ") "
		.. "%#WinBar1#"
		.. "%*%=%#WinBar2#"
		.. vim.fn.systemlist("hostname")[1]
end
-- Autocmd to update the winbar on BufEnter and WinEnter events
vim.api.nvim_create_autocmd({ "BufEnter", "WinEnter" }, {
	callback = update_winbar,
})
