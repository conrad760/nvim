-- ~/github/dotfiles-latest/neovim/neobean/lua/config/colors.lua

-- load the colors once when the module is required and then expose the colors
-- directly. This avoids the need to call load_colors() in every file

-- Function to load colors from the external file
local function load_colors()
	local colors = {}
	-- Use vim.fn.stdpath to get the config directory portably
	local config_dir = vim.fn.stdpath("config")
	local active_file = config_dir .. "/lua/config/active-colorscheme.sh"

	local file = io.open(active_file, "r")
	if not file then
		error("Could not open the active colorscheme file: " .. active_file)
	end

	for line in file:lines() do
		if not line:match("^%s*#") and not line:match("^%s*$") and not line:match("^wallpaper=") then
			local name, value = line:match("^(%S+)=%s*(.+)")
			if name and value then
				colors[name] = value:gsub('"', "")
			end
		end
	end

	file:close()
	return colors
end

-- Load colors when the module is required
local colors = load_colors()

-- Check if the 'vim' global exists (i.e., if running in Neovim)
if _G.vim then
	for name, hex in pairs(colors) do
		vim.api.nvim_set_hl(0, name, { fg = hex })
	end
end

-- Helper functions to apply colors to specific UI components
local M = {}

-- Copy all color values to M
for k, v in pairs(colors) do
	M[k] = v
end

-- Apply colors to debug UI
M.apply_to_debug_ui = function()
	vim.api.nvim_set_hl(0, "DapBreakpoint", { fg = M.linkarzu_color03 or "#e06c75" })
	vim.api.nvim_set_hl(0, "DapBreakpointCondition", { fg = M.linkarzu_color24 or "#f7bb3b" })
	vim.api.nvim_set_hl(0, "DapStopped", { fg = M.linkarzu_color02 or "#98c379", bg = M.linkarzu_color13 or "#31353f" })
	vim.api.nvim_set_hl(0, "DapBreakpointRejected", { fg = M.linkarzu_color04 or "#c678dd" })
	vim.api.nvim_set_hl(0, "DapLogPoint", { fg = M.linkarzu_color01 or "#61afef" })
end

-- Apply colors to winbar (already done in options.lua, but keeping for reference)
M.apply_to_winbar = function()
	vim.cmd(string.format([[highlight WinBar1 guifg=%s]], M.linkarzu_color03 or "#61afef"))
	vim.cmd(string.format([[highlight WinBar2 guifg=%s]], M.linkarzu_color02 or "#98c379"))
	vim.cmd(string.format([[highlight WinBar3 guifg=%s gui=bold]], M.linkarzu_color24 or "#e5c07b"))
end

-- Return the module for external usage
return M
