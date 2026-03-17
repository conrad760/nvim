return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	priority = 1000,
	config = function()
		-- Add plugin path to Lua search path (needed for Nix)
		local plugin_dir = vim.fn.expand("~/.local/share/nvim/lazy/nvim-treesitter")
		local lua_path = plugin_dir .. "/lua/?.lua;" .. plugin_dir .. "/lua/?/init.lua;"
		package.path = lua_path .. package.path

		-- Use writable install dir (Nix store is read-only)
		local install_dir = vim.fn.stdpath("data") .. "/site"
		vim.opt.runtimepath:append(install_dir)

		require("nvim-treesitter.configs").setup({
			parser_install_dir = install_dir,
			ensure_installed = {
				"go", "gomod", "gosum", "gowork", "gotmpl", -- Go ecosystem
				"bash", "c", "html", "lua", "luadoc", "markdown", "markdown_inline",
				"vim", "vimdoc", "javascript", "typescript", "tsx", "json", "yaml", "toml",
				"css", "scss", "python", "rust", "java", "cpp", "cmake", "make",
				"dockerfile", "git_config", "gitignore", "diff", "regex", "sql",
				"graphql", "proto", "xml", "norg", "comment", "nix",
			},
			auto_install = false,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
		})

		-- Treesitter-based folding
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldlevel = 99
	end,
}
