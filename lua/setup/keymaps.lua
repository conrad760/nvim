-- [[ Keymaps ]]
--
-- [Modes]
--   map_mode = "",
--   normal_mode = "n",
--   insert_mode = "i",
--   visual_mode = "v",
--   visual_block_mode = "x",
--   term_mode = "t",
--   command_mode = "c",

-- Set highlight on search, but clear on pressing <Esc> in normal mode
vim.keymap.set("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "clear on pressing <Esc> in normal mode" })

-- Toggle spell check
vim.keymap.set("", "<leader>zo", ":setlocal spell! spelllang=en_us<CR>", { desc = "Toggle spell check" })

---- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the left" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to down " })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to up" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the right" })
vim.keymap.set("n", "j", "gj", { desc = "Go to the line below even on wrapped text" })
vim.keymap.set("n", "k", "gk", { desc = "Go to the line above even on wrapped text" })
vim.keymap.set("n", "<Down>", "gj", { desc = "Go to the line below even on wrapped text" })
vim.keymap.set("n", "<Up>", "gk", { desc = "Go to the line above even on wrapped text" })
vim.keymap.set("i", "<Down>", "<C-o>gj", { desc = "Go to the line below even on wrapped text" })
vim.keymap.set("i", "<Up>", "<C-o>gk", { desc = "Go to the line above even on wrapped text" })
vim.keymap.set("n", "<S-Tab>", "<C-w>w", { desc = "Cycle throch windows" })
vim.keymap.set("n", "<leader>tn", ":tabnew<CR>", { desc = "new tab" })
vim.keymap.set("n", "<leader>tc", ":tabclose<CR>", { desc = "close tab" })
vim.keymap.set("n", "<leader>tl", ":tabs<CR>", { desc = "list tabs" })

---- Navigate buffers
---
vim.keymap.set("n", "[d", vim.diagnostic.get_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.get_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>l", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

---- Insert --
---- Press jk fast to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Press jk fast to exit insert mode", noremap = true, silent = true })
vim.keymap.set("i", "kj", "<ESC>", { desc = "Press kj fast to exit insert mode", noremap = true, silent = true })
--
---- Visual --
---- Visual Block --
---- Terminal ----
-- I never want to open a terminal in nvim.
---- Better terminal navigation
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { silent = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { silent = true })

-- NOTE: Moving the plugins key mapping to the lazy setup unless I figure out a better way
-- Plugins --

---- Telescope
vim.keymap.set(
	"n",
	"<leader>go",
	"<cmd>Telescope git_status<cr>",
	{ desc = "Open changed file", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>gb",
	"<cmd>Telescope git_branches<cr>",
	{ desc = "Checkout branch", noremap = true, silent = true }
)
vim.keymap.set(
	"n",
	"<leader>gc",
	"<cmd>Telescope git_commits<cr>",
	{ desc = "Checkout commits", noremap = true, silent = true }
)
---- Twiliight
vim.keymap.set("n", "<leader>tt", "<cmd>Twilight<cr>", { desc = "[t]oggle [T]wiliight", noremap = true, silent = true })
---- Custom
vim.keymap.set(
	"n",
	"<leader>tdd",
	"<cmd>ToggleDiagnostics<cr>",
	{ desc = "[t]oggle [d]iagnostics", noremap = true, silent = true }
)

vim.keymap.set(
	"n",
	"<leader>gfs",
	":GoFillStruct<cr>",
	{ desc = "[G]o [F]ill [S]truct", noremap = true, silent = true }
)

vim.keymap.set(
	"n",
	"<leader>gfat",
	":GoAddAllTest<cr>",
	{ desc = "[G]o [F]ill [A]ll [T]est", noremap = true, silent = true }
)

vim.keymap.set("n", "<leader>gft", ":GoAddTest<cr>", { desc = "[G]o [F]ill [T]est", noremap = true, silent = true })

----- DAP
---
-- Luasnip
vim.api.nvim_set_keymap(
	"i",
	"<C-p>",
	"<cmd>lua require('luasnip').change_choice(-1)<CR>",
	{ silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
	"s",
	"<C-p>",
	"<cmd>lua require('luasnip').change_choice(-1)<CR>",
	{ silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
	"i",
	"<C-n>",
	"<cmd>lua require('luasnip').change_choice(1)<CR>",
	{ silent = true, noremap = true }
)
vim.api.nvim_set_keymap(
	"s",
	"<C-n>",
	"<cmd>lua require('luasnip').change_choice(1)<CR>",
	{ silent = true, noremap = true }
)

---- zk ----

vim.keymap.set(
	"v",
	"<leader>znt",
	"<cmd>'<,'>ZkNewFromTitleSelection<CR>",
	{ desc = "Zk: New from title sel", silent = true }
)

vim.keymap.set(
	"v",
	"<leader>znc",
	"<cmd>'<,'>ZkNewFromContentSelection<CR>",
	{ desc = "Zk: New from content sel", silent = true }
)

vim.keymap.set("n", "<leader>zt", "<cmd>ZkTags<CR>", { desc = "Zk: Tags", silent = true })
vim.keymap.set("n", "<leader>zN", "<cmd>ZkNotes<CR>", { desc = "Zk: Notes", silent = true })
vim.keymap.set("n", "<leader>zb", "<cmd>ZkBacklinks<CR>", { desc = "Zk: Backlinks", silent = true })
vim.keymap.set("n", "<leader>zl", "<cmd>ZkLinks<CR>", { desc = "Zk: Outgoing links", silent = true })
vim.keymap.set("n", "<leader>zgx", vim.lsp.buf.definition, { desc = "Zk: Go to link", silent = true })
