return {
	"stevearc/conform.nvim",
	lazy = false,
	keys = {
		{
			"<leader>f",
			function()
				require("conform").format({ async = true, lsp_fallback = true })
			end,
			mode = "n",
			desc = "[F]ormat buffer",
		},
	},
	opts = function()
		local util = require("conform.util")
		return {
			notify_on_error = true,

			format_on_save = function(bufnr)
				local disable_filetypes = { c = true, cpp = true }
				return {
					timeout_ms = 1000,
					lsp_fallback = not disable_filetypes[vim.bo[bufnr].filetype],
				}
			end,

			formatters_by_ft = {
				lua = { "stylua" },
				go = { "goimports", "golines", "gofumpt" },
				bash = { "shfmt" },
				sql = { "sqlfluff" },
				nix = { "treefmt", "nixfmt", "alejandra", "nixpkgs_fmt", "nil_ls" },
			},

			formatters = {
				sqlfluff = {
					command = "sqlfluff",
					args = { "format", "--dialect", "postgres", "-" },
					stdin = true,
				},

				treefmt = {
					condition = function(ctx)
						return util.find_root({ "treefmt.toml", ".treefmt.toml" }, ctx.filename) ~= nil
					end,
					command = "treefmt",
					args = { "--stdin", "--stdin-filename", "$FILENAME" },
					stdin = true,
				},
				nixfmt = {
					command = "nixfmt",
					args = { "--width", "100" },
					stdin = true,
				},
				alejandra = {
					command = "alejandra",
					args = { "-" },
					stdin = true,
				},
				nixpkgs_fmt = {
					command = "nixpkgs-fmt",
					stdin = true,
				},
			},
		}
	end,
}
