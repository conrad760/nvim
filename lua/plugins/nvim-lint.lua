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
  optional = true,
  opts = {
    linters = {
      -- markdownlint-cli2 will use its default config or local .markdownlint.yaml if present
      ["markdownlint-cli2"] = {},
    },
  },
}
