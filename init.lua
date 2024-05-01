-- You don't even need it
-- Set <space> as the leader key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

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
