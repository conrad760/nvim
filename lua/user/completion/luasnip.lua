local snip_status_ok, ls = pcall(require, "luasnip")
if not snip_status_ok then
  return
end


local types = require("luasnip.util.types")

ls.config.set_config({
  history = true,
  updateevents = 'TextChanged,TextChangedI',
  enable_autosnippets = true,
  ext_opts = {
    [types.choiceNode] = {
      active = {
        virt_text = { { "<-", "Error" } }
      },
    },
  },
})

require("luasnip.loaders.from_lua").load({ paths = "~/.config/nvim/lua/user/completion/snippets/" })

vim.keymap.set({ "i", "s" }, "<leader>;", function()
  if ls.expand_or_jumpable() then
    ls.expand_or_jump()
  end
end)

vim.keymap.set({ "i", "s" }, "<leader>,", function()
  if ls.jumpable(-1) then
    ls.jump(-1)
  end
end)

-- set keybinds for both INSERT and VISUAL.
-- vim.api.nvim_set_keymap("i", "<C-n>", "<Plug>luasnip-next-choice", {})
-- vim.api.nvim_set_keymap("s", "<C-n>", "<Plug>luasnip-next-choice", {})
-- vim.api.nvim_set_keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", {})
-- vim.api.nvim_set_keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", {})
