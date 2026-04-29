return {
	"nvim-treesitter/nvim-treesitter",
	branch = "main",
	build = ":TSUpdate",
	lazy = false,
	priority = 1000,
	config = function()
		-- Use writable install dir (Nix store is read-only)
		local install_dir = vim.fn.stdpath("data") .. "/site"
		require("nvim-treesitter").setup({
			install_dir = install_dir,
		})

		-- Auto-install missing parsers (runs async)
		local ensure_installed = {
			"go", "gomod", "gosum", "gowork", "gotmpl", -- Go ecosystem
			"bash", "c", "html", "lua", "luadoc", "markdown", "markdown_inline",
			"vim", "vimdoc", "javascript", "typescript", "tsx", "json", "yaml", "toml",
			"css", "scss", "python", "rust", "java", "cpp", "cmake", "make",
			"dockerfile", "git_config", "gitignore", "diff", "regex", "sql",
			"graphql", "proto", "xml", "comment", "nix",
			"hcl", "terraform", -- Terraform / tfvars
		}
		local installed = require("nvim-treesitter.config").get_installed()
		local query_dir = vim.fs.joinpath(install_dir, "queries")
		local to_install = vim.tbl_filter(function(lang)
			-- Reinstall if parser or query symlinks are missing
			if not vim.list_contains(installed, lang) then
				return true
			end
			return not vim.uv.fs_stat(vim.fs.joinpath(query_dir, lang))
		end, ensure_installed)
		if #to_install > 0 then
			require("nvim-treesitter.install").install(to_install, { force = true })
		end

		-- Treesitter-based folding
		vim.opt.foldmethod = "expr"
		vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
		vim.opt.foldlevel = 99

		-- Auto-start treesitter highlighting on FileType
		-- (main branch does not do this automatically like master did)
		vim.api.nvim_create_autocmd("FileType", {
			callback = function(args)
				local buf = args.buf
				local ft = args.match
				local lang = vim.treesitter.language.get_lang(ft) or ft
				if not vim.treesitter.language.add(lang) then
					return
				end
				pcall(vim.treesitter.start, buf, lang)
				-- Use treesitter for indent too
				vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
			end,
		})
	end,
}
