-- Replaced vim-bbye (unmaintained) with mini.bufremove
return {
	"echasnovski/mini.bufremove",
	version = false,
	config = function()
		require("mini.bufremove").setup()
		vim.keymap.set("n", "<leader>cc", function()
			require("mini.bufremove").delete(0, true)
		end, { desc = "close the current buffer" })
	end,
}
