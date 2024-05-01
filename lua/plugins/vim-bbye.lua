return {
	"moll/vim-bbye",
	config = function()
		vim.keymap.set("n", "<leader>c", "<cmd>:Bdelete!<CR>", { desc = "close the current buffer" })
	end,
}
