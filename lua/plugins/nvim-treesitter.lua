return {
	"nvim-treesitter/nvim-treesitter",
	build = ":TSUpdate",
	lazy = false,
	priority = 1000,
	config = function(plugin)
		-- Add plugin path to Lua search path (needed for Nix)
		local plugin_dir = vim.fn.expand("~/.local/share/nvim/lazy/nvim-treesitter")
		local lua_path = plugin_dir .. "/lua/?.lua;" .. plugin_dir .. "/lua/?/init.lua;"
		package.path = lua_path .. package.path

		-- New nvim-treesitter API (2024+)
		-- Highlighting is now built into Neovim via vim.treesitter
		-- The plugin now only handles parser installation

		-- Configure install directory and add to runtimepath
		local install_dir = vim.fn.stdpath("data") .. "/site"
		vim.opt.runtimepath:append(install_dir)

		require("nvim-treesitter.config").setup({
			install_dir = install_dir,
		})

		-- Install parsers
		local parsers_to_install = {
			"go", "gomod", "gosum", "gowork", "gotmpl", -- Go ecosystem
			"bash", "c", "html", "lua", "luadoc", "markdown", "markdown_inline",
			"vim", "vimdoc", "javascript", "typescript", "tsx", "json", "yaml", "toml",
			"css", "scss", "python", "rust", "java", "cpp", "cmake", "make",
			"dockerfile", "git_config", "gitignore", "diff", "regex", "sql",
			"graphql", "proto", "xml", "norg", "comment", "nix",
		}

		-- Install missing parsers asynchronously
		vim.api.nvim_create_autocmd("VimEnter", {
			callback = function()
				local installed = require("nvim-treesitter.config").get_installed()
				local installed_set = {}
				for _, p in ipairs(installed) do
					installed_set[p] = true
				end

				local to_install = {}
				for _, parser in ipairs(parsers_to_install) do
					if not installed_set[parser] then
						table.insert(to_install, parser)
					end
				end

				if #to_install > 0 then
					vim.cmd("TSInstall " .. table.concat(to_install, " "))
				end
			end,
			once = true,
		})

		-- Treesitter-based folding
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldlevel = 99

		-- Enable treesitter highlighting for all supported filetypes
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local ok = pcall(vim.treesitter.start, args.buf)
				if ok then
					-- Enable indentation via treesitter
					vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
				end
			end,
		})
	end,
}
