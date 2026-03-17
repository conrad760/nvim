return {
	"rhysd/committia.vim",
	ft = { "gitcommit", "gitsendemail", "*commit*", "*COMMIT*" },
	dependencies = { "tpope/vim-fugitive" },
	config = function()
		vim.cmd([[
                let g:committia_open_only_vim_starting = 1
                let g:committia_diff_window_opencmd = 'botright vsplit'
                let g:committia#git#use_verbose = 1

                let g:committia_hooks = {}
                function! g:committia_hooks.edit_open(info)
                " Additional settings
                setlocal spell

                " NOTE: startinsert removed to avoid conflicting with ai-commit.lua's
                " changedtick guard. The AI draft will be inserted first, then you can
                " edit normally.

                    " Scroll the diff window from insert mode
                    " Map <C-n> and <C-p>
                    imap <buffer><C-u> <Plug>(committia-scroll-diff-down-half)
                    imap <buffer><C-d> <Plug>(committia-scroll-diff-up-half)
                endfunction
            ]])
	end,
}
