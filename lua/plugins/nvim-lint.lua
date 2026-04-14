-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-lint.lua
-- ~/github/dotfiles-latest/neovim/neobean/lua/plugins/nvim-lint.lua

--[=====[
https://github.com/mfussenegger/nvim-lint

This plugin allows you to globally set the .markdownlint.yaml file instead of 
doing it on a per :pwd directory

If you add the file to the :pwd directory, that file will take precedence
instead of the --config file specified below lamw25wmal

This suggestion came from one of my youtube videos from user @killua_148
"My complete Neovim markdown setup and workflow in 2024"
https://youtu.be/c0cuvzK1SDo

--]=====]

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    linters_by_ft = {
      terraform = { "tflint" },
      tf = { "tflint" },
      ["terraform-vars"] = { "tflint" },
    },
    linters = {
      -- markdownlint-cli2 will use its default config or local .markdownlint.yaml if present
      ["markdownlint-cli2"] = {},
    },
  },
  config = function(_, opts)
    local lint = require("lint")
    lint.linters_by_ft = opts.linters_by_ft or {}
    for name, linter in pairs(opts.linters or {}) do
      if type(linter) == "table" and type(lint.linters[name]) == "table" then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], linter)
      else
        lint.linters[name] = linter
      end
    end

    -- Auto-lint on save and insert leave
    vim.api.nvim_create_autocmd({ "BufWritePost", "InsertLeave", "BufReadPost" }, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        if vim.opt_local.modifiable:get() then
          lint.try_lint()
        end
      end,
    })
  end,
}
