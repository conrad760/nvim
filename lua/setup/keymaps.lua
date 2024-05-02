-- [[ Keymaps ]]
--
-- This is a list of keymaps.
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
vim.keymap.set("", "<leader>o", ":setlocal spell! spelllang=en_us<CR>", { desc = "Toggle spell check" })
vim.keymap.set(
	"n",
	"<leader>tc",
	":setlocal <C-R>=&conceallevel ? 'conceallevel=0' : 'conceallevel=2'<CR><CR>",
	{ desc = "[T]oggle [C]onceallevel" }
)

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

---- Navigate buffers
vim.keymap.set("n", "<S-l>", ":bnext<CR>", { desc = "open next buffer", noremap = true, silent = true })
vim.keymap.set("n", "<S-h>", ":bprevious<CR>", { desc = "open previous buffer", noremap = true, silent = true })

vim.keymap.set("n", "[d", vim.diagnostic.goto_prev, { desc = "Go to previous [D]iagnostic message" })
vim.keymap.set("n", "]d", vim.diagnostic.goto_next, { desc = "Go to next [D]iagnostic message" })
vim.keymap.set("n", "<leader>l", vim.diagnostic.open_float, { desc = "Show diagnostic error messages" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

---- Insert --
---- Press jk fast to exit insert mode
vim.keymap.set("i", "jk", "<ESC>", { desc = "Press jk fast to exit insert mode", noremap = true, silent = true })
vim.keymap.set("i", "kj", "<ESC>", { desc = "Press kj fast to exit insert mode", noremap = true, silent = true })
--
---- Visual --
---- Stay in indent mode
vim.keymap.set("v", "<<", "<gv", { desc = "Press kj fast to exit insert mode", noremap = true, silent = true })
vim.keymap.set("v", ">>", ">gv", { desc = "Stay selected when indenting blocks", noremap = true, silent = true })
--
---- Move text up and down
--keymap("v", "<A-j>", ":m .+1<CR>==", opts)
--keymap("v", "<A-k>", ":m .-2<CR>==", opts)
--keymap("v", "p", '"_dP', opts)
--
---- Visual Block --
--
---- Move text up and down
--keymap("x", "J", ":move '>+1<CR>gv-gv", opts)
--keymap("x", "K", ":move '<-2<CR>gv-gv", opts)
--keymap("x", "<A-j>", ":move '>+1<CR>gv-gv", opts)
--keymap("x", "<A-k>", ":move '<-2<CR>gv-gv", opts)

---- Terminal --
---- Better terminal navigation
vim.keymap.set("t", "<C-h>", "<C-\\><C-N><C-w>h", { silent = true })
vim.keymap.set("t", "<C-j>", "<C-\\><C-N><C-w>j", { silent = true })
vim.keymap.set("t", "<C-k>", "<C-\\><C-N><C-w>k", { silent = true })
vim.keymap.set("t", "<C-l>", "<C-\\><C-N><C-w>l", { silent = true })

-- NOTE: Moving the plugins key mapping to the lazy setup unless I figure out a better way
---- -- Plugins --

---- Telescope
--keymap("n", "<leader>ff", ":Telescope find_files<CR>", opts)
--keymap("n", "<leader>ft", ":Telescope live_grep<CR>", opts)
--keymap("n", "<leader>fo", ":Telescope oldfiles<CR>", opts)
--keymap("n", "<leader>fp", ":Telescope projects<CR>", opts)
--keymap("n", "<leader>fb", ":Telescope buffers<CR>", opts)
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

---- DB / Dadbod
--keymap("n", "<leader>dad", ":DBUIToggle<CR>", opts)
--
---- ChatGPT
--keymap("n", "<leader>tk", "<cmd>:ChatGPT<cr>", opts)
--keymap("n", "<leader>tj", "<cmd>:ChatGPTActAs<cr>", opts)
--keymap("n", "<leader>tt", "<cmd>:ChatGPTEditWithInstructions<cr>", opts)
--
---- DAP
----
--keymap("n", "<leader>db", "<cmd>lua require'dap'.toggle_breakpoint()<cr>", opts)
--keymap("n", "<leader>dc", "<cmd>lua require'dap'.continue()<cr>", opts)
--keymap("n", "<leader>di", "<cmd>lua require'dap'.step_into()<cr>", opts)
--keymap("n", "<leader>do", "<cmd>lua require'dap'.step_over()<cr>", opts)
--keymap("n", "<leader>dO", "<cmd>lua require'dap'.step_out()<cr>", opts)
--keymap("n", "<leader>dr", "<cmd>lua require'dap'.repl.toggle()<cr>", opts)
--keymap("n", "<leader>dl", "<cmd>lua require'dap'.run_last()<cr>", opts)
--keymap("n", "<leader>du", "<cmd>lua require'dapui'.toggle()<cr>", opts)
--keymap("n", "<leader>ds", "<cmd>lua require'dap'.terminate()<cr>", opts)
--keymap("n", "<leader>dt", "<cmd>lua require'dap-go'.debug_test()<cr>", opts)
--
---- Luasnip
--keymap("i", "<C-n>", "<Plug>luasnip-next-choice", opts)
--keymap("s", "<C-n>", "<Plug>luasnip-next-choice", opts)
--keymap("i", "<C-p>", "<Plug>luasnip-prev-choice", opts)
--keymap("s", "<C-p>", "<Plug>luasnip-prev-choice", opts)
--keymap("n", "<leader><leader>s", "<cmd>source ~/.config/nvim/lua/user/completion/luasnip.lua<CR>", opts)
