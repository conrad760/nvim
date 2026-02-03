-- Filename: ~/github/dotfiles-latest/neovim/neobean/lua/config/autocmds.lua

-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- config/autocmds.lua

-- Require the colors.lua module and access the colors directly without
-- additional file reads
-- local colors = require("config.colors")

local function augroup(name)
	return vim.api.nvim_create_augroup("lazyvim_" .. name, { clear = true })
end



-- close some filetypes with <esc>
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("close_with_q"),
	pattern = {
		"PlenaryTestPopup",
		"grug-far",
		"help",
		"lspinfo",
		"notify",
		"qf",
		"spectre_panel",
		"startuptime",
		"tsplayground",
		"neotest-output",
		"checkhealth",
		"neotest-summary",
		"neotest-output-panel",
		"dbout",
		"gitsigns-blame",
		"Lazy",
	},
	callback = function(event)
		vim.bo[event.buf].buflisted = false
		vim.schedule(function()
			vim.keymap.set("n", "<esc>", function()
				vim.cmd("close")
				pcall(vim.api.nvim_buf_delete, event.buf, { force = true })
			end, {
				buffer = event.buf,
				silent = true,
				desc = "Quit buffer",
			})
		end)
	end,
})



-- wrap and check for spell in text filetypes
vim.api.nvim_create_autocmd("FileType", {
	group = augroup("wrap_spell"),
	pattern = { "text", "plaintex", "typst", "gitcommit", "markdown" },
	callback = function()
		vim.opt_local.spell = true
	end,
})

-- Show LSP diagnostics (inlay hints) in a hover window / popup
-- https://github.com/neovim/nvim-lspconfig/wiki/UI-Customization#show-line-diagnostics-automatically-in-hover-window
-- If you want to increase the hover time, modify vim.o.updatetime = 200 in your options.lua file
vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
	group = vim.api.nvim_create_augroup("float_diagnostic", { clear = true }),
	callback = function()
		vim.diagnostic.open_float(nil, {
			focus = false,
			border = "rounded",
		})
	end,
})

-- When I open markdown files I want to fold the markdown headings
vim.api.nvim_create_autocmd("BufRead", {
	pattern = "*.md",
	callback = function()
		-- Avoid running zk multiple times for the same buffer
		if vim.b.zk_executed then
			return
		end
		vim.b.zk_executed = true
		vim.defer_fn(function()
			vim.cmd("normal zk")
			vim.notify("Folded keymaps", vim.log.levels.INFO)
		end, 100)
	end,
})
