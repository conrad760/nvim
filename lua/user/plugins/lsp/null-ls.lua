local null_ls_status_ok, null_ls = pcall(require, "none-ls")
if not null_ls_status_ok then
	return
end

-- https://github.com/jose-elias-alvarez/none-ls.nvim/tree/main/lua/null-ls/builtins/formatting
local formatting = null_ls.builtins.formatting
-- https://github.com/jose-elias-alvarez/none-ls.nvim/tree/main/lua/null-ls/builtins/diagnostics
local diagnostics = null_ls.builtins.diagnostics

null_ls.setup({
	debug = false,
	sources = {
    require("none-ls").builtins.formatting.stylua,
    require("none-ls").builtins.formatting.golines,
    require("none-ls").builtins.formatting.gofumpt,
    require("none-ls").builtins.formatting.goimports_reviser,

    require("none-ls").builtins.diagnostics.eslint,
    require("none-ls").builtins.completion.spell,
--    require("none-ls").builtins.diagnostics.revive, -- this is great but I need a better config
		formatting.prettier.with({ extra_args = { "--no-semi", "--single-quote", "--jsx-single-quote" } }),
		formatting.stylua,
    diagnostics.flake8
	},
})
