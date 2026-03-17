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

                    " Scroll the diff window from insert mode
                    " Map <C-u> and <C-d>
                    imap <buffer><C-u> <Plug>(committia-scroll-diff-down-half)
                    imap <buffer><C-d> <Plug>(committia-scroll-diff-up-half)

                    " Scroll the diff window from normal mode
                    nmap <buffer><C-u> <Plug>(committia-scroll-diff-down-half)
                    nmap <buffer><C-d> <Plug>(committia-scroll-diff-up-half)
                endfunction
            ]])
	end,
}
