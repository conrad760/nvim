# Neovim Configuration Codebase Guidelines

## Build/Test Commands
- **Reload config**: `:source %` or `<leader>so` (saves and sources current file)
- **Check health**: `:checkhealth` to verify plugin installations
- **Update plugins**: `:Lazy sync` to update all plugins via lazy.nvim
- **Format buffer**: `<leader>f` or auto-format on save (via conform.nvim)
- **Lint check**: Auto-lints on BufEnter/BufWritePost/InsertLeave events

## Code Style Guidelines
- **Language**: Lua 5.1+ for Neovim configuration
- **Formatting**: Use `stylua` for Lua files (auto-formats on save)
- **File structure**: Modular approach with `lua/plugins/` for plugin configs, `lua/config/` for core settings
- **Plugin format**: Return table with plugin spec: `return { "author/plugin", opts = {}, config = function() end }`
- **Imports**: Use `require()` for modules, avoid global namespace pollution
- **Naming**: Snake_case for files, camelCase for local vars, UPPER_CASE for constants
- **Comments**: Minimal inline comments, use `-- ` prefix, document complex logic only
- **Error handling**: Use `pcall()` for safe requires, `vim.notify()` for user messages
- **Keymaps**: Define with `vim.keymap.set()`, include `desc` field for which-key
- **Lazy loading**: Set `lazy = false` for essential plugins, use event triggers for others
- **Dependencies**: Explicitly declare in plugin spec, check with `:Lazy` before assuming availability
- **Git**: Never commit spell/, autoload/, or compiled plugin files (see .gitignore)