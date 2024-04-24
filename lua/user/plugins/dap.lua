local dap_ok, dap = pcall(require, "dap")
if not (dap_ok) then
  print("nvim-dap not installed!")
  return
end
local dap_ui_ok, ui = pcall(require, "dapui")

require('dap').set_log_level('INFO') -- Helps when configuring DAP, see logs with :DapShowLog
 
dap.configurations = {
    go = {
      {
        type = "go", -- Which adapter to use
        name = "Debug", -- Human readable name
        request = "launch", -- Whether to "launch" or "attach" to program
        program = "${file}", -- The buffer you are focused on when running nvim-dap
      },
    }
}
dap.adapters.go = {
  type = "server",
  port = "${port}",
  executable = {
    command = vim.fn.stdpath("data") .. '/mason/bin/dlv',
    args = { "dap", "-l", "127.0.0.1:${port}" },
  },
}
 
if not (dap_ok and dap_ui_ok) then
  require("notify")("nvim-dap or dap-ui not installed!", "warning") -- nvim-notify is a separate plugin, I recommend it too!
  return
end
 
-- vim.fn.sign_define('DapBreakpoint', { text = '🐞' })
 
-- Start debugging session
vim.keymap.set("n", "<localleader>ds", function()
  dap.continue()
  ui.toggle({})
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false) -- Spaces buffers evenly
end)
 
-- Set breakpoints, get variable values, step into/out of functions, etc.
vim.keymap.set("n", "<localleader>dl", require("dap.ui.widgets").hover)
vim.keymap.set("n", "<localleader>dc", dap.continue)
vim.keymap.set("n", "<localleader>db", dap.toggle_breakpoint)
vim.keymap.set("n", "<localleader>dn", dap.step_over)
vim.keymap.set("n", "<localleader>di", dap.step_into)
vim.keymap.set("n", "<localleader>do", dap.step_out)
vim.keymap.set("n", "<localleader>dC", function()
  dap.clear_breakpoints()
  require("notify")("Breakpoints cleared", "warn")
end)
 
-- Close debugger and clear breakpoints
vim.keymap.set("n", "<localleader>de", function()
  dap.clear_breakpoints()
  ui.toggle({})
  dap.terminate()
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-w>=", false, true, true), "n", false)
  require("notify")("Debugger session ended", "warn")
end)

-- local status_ok, dap_go = pcall(require, "dap-go")
-- if not status_ok then
-- 	return
-- end
local status_ok, dapui = pcall(require, "dapui")
if not status_ok then
	return
end
-- local status_ok, dapvt = pcall(require, "nvim-dap-virtual-text")
-- if not status_ok then
-- 	return
-- end




-- dap_go.setup()
-- Debugging with dlv in headless mode
  -- Register a new option to attach to a remote debugger:
-- lua require('dap-go').setup {
--   dap_configurations = {
--     {
--       type = "go",
--       name = "Attach remote",
--       mode = "remote",
--       request = "attach",
--     },
--   },
-- }

-- In a new terminal run:
-- dlv debug -l 127.0.0.1:38697 --headless ./main.go -- subcommand --myflag=xyz

-- Call :lua require('dap').continue() to start debugging.
-- Select the new registered option Attach remote.


dapui.setup()
--dapvt.setup()


