-- [[ Basic Autocommands ]]
--  See `:help lua-guide-autocommands`
-- The next two examples are both ways of writing commands in vim

--- Remove all trailing whitespace on save
local TrimWhiteSpaceGrp = vim.api.nvim_create_augroup("TrimWhiteSpaceGrp", { clear = true })
vim.api.nvim_create_autocmd("BufWritePre", {
	command = [[:%s/\s\+$//e]],
	group = TrimWhiteSpaceGrp,
})

-- Toggle diagnostics visibility
function ToggleDiagnostics()
	-- Check the current state of diagnostics visibility
	local status, diagnostics_visible = pcall(vim.api.nvim_buf_get_var, 0, "diagnostics_visible")

	if not status or diagnostics_visible then
		vim.diagnostic.enabel(false)
		vim.api.nvim_buf_set_var(0, "diagnostics_visible", false)
	else
		vim.diagnostic.enable()
		vim.api.nvim_buf_set_var(0, "diagnostics_visible", true)
	end
end

-- Safely initialize the buffer variable
pcall(vim.api.nvim_buf_set_var, 0, "diagnostics_visible", true)

vim.api.nvim_create_user_command("ToggleDiagnostics", ToggleDiagnostics, {})

-- Highlight the yanked text
vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlights the yanked (copied) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap_spell", { clear = true }),
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.textwidth = 80
		vim.opt_local.wrap = true
		vim.opt_local.spell = true
		vim.opt_local.tabstop = 2
		vim.opt_local.softtabstop = 2
		vim.opt_local.shiftwidth = 2
		vim.opt_local.expandtab = true
	end,
})
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("wrap_markdowny", { clear = true }),
	desc = "markdowny.nvim keymaps",
	pattern = { "gitcommit", "markdown" },
	callback = function()
		vim.keymap.set(
			"v",
			"<leader>mb",
			":lua require('markdowny').bold()<cr>",
			{ buffer = 0, desc = "[m]ake [b]old" }
		)
		vim.keymap.set(
			"v",
			"<leader>mi",
			":lua require('markdowny').italic()<cr>",
			{ buffer = 0, desc = "[m]ake [i]talic" }
		)
		vim.keymap.set(
			"v",
			"<leader>mlk",
			":lua require('markdowny').link()<cr>",
			{ buffer = 0, desc = "[m]ake [l]in[k]" }
		)
		vim.keymap.set(
			"v",
			"<leader>mc",
			":lua require('markdowny').code()<cr>",
			{ buffer = 0, desc = "[m]ake [c]ode" }
		)
	end,
})

vim.cmd([[
  augroup _general_settings
    autocmd!
    autocmd FileType qf,help,man,lspinfo nnoremap <silent> <buffer> q :close<CR>
    autocmd TextYankPost * silent!lua require('vim.highlight').on_yank({higroup = 'Visual', timeout = 200})
    autocmd FileType qf set nobuflisted
  augroup end

  augroup _git
    autocmd!
    autocmd FileType gitcommit setlocal wrap
    autocmd FileType gitcommit setlocal spell
  augroup end

  augroup _markdown
    autocmd!
    " Set .md files to use markdown syntax
    autocmd BufNewFile,BufRead *.md set syntax=markdown
    autocmd FileType markdown setlocal wrap
    autocmd FileType markdown setlocal spell
  augroup end

  augroup _auto_resize
    autocmd!
    autocmd VimResized * tabdo wincmd =
  augroup end

]])
-- Autoformat
-- augroup _lsp
--   autocmd!
--   autocmd BufWritePre * lua vim.lsp.buf.formatting()
-- augroup end
