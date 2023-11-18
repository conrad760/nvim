local status_ok, _ = pcall(require, "lspconfig")
if not status_ok then
  return
end

require "user.plugins.lsp.configs"
require("user.plugins.lsp.handlers").setup()
require "user.plugins.lsp.null-ls"
