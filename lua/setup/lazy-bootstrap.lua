-- [[ Install `lazy.nvim` plugin manager ]]
--    See `:help lazy.nvim.txt` or https://github.com/folke/lazy.nvim for more info
-- Use explicit path to avoid Nix stdpath override issues
local lazyroot = vim.fn.expand("~/.local/share/nvim/lazy")
local lazypath = lazyroot .. "/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

-- Store lazyroot globally so lazy.nvim uses the correct path
vim.g.lazy_root = lazyroot
