local colorscheme = "darkplus"
local default = "darkblue"

local status_ok, _ = pcall(vim.cmd,"colorscheme " .. colorscheme)

if not status_ok then
  vim.notify("colorscheme " .. colorscheme .. " not found!")
  local status_ok, _ = pcall(vim.cmd,"colorscheme " .. default)
  return
end
