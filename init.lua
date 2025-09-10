vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- [[ Setting options ]]
require("setup.options")

-- [[ Keymaps ]]
require("setup.keymaps")

-- [[ Basic Autocommands ]]
require("setup.autocmd")

-- [[ Install `lazy.nvim` plugin manager ]]
require("setup.lazy-bootstrap")

-- [[ Configure and install plugins ]]
require("setup.lazy-plugins")

vim.keymap.set("n", "<leader>so", ":update<CR> :source<CR>")
