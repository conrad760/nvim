-- Go Debugging Helper Configuration
-- This file provides intuitive debugging setup specifically for Go

return {
	-- Quick Debug Menu for Go
	setup = function()
		-- Create a command palette for Go debugging
		vim.api.nvim_create_user_command("GoDebugMenu", function()
			local items = {
				"1. Debug current test (cursor on test function)",
				"2. Debug entire package",
				"3. Debug with arguments",
				"4. Set breakpoint here",
				"5. Clear all breakpoints",
				"6. Show debug UI",
				"7. Debug last test",
				"8. List all breakpoints",
			}
			
			vim.ui.select(items, {
				prompt = "Go Debug Actions:",
			}, function(choice)
				if not choice then return end
				local num = tonumber(choice:match("^(%d+)"))
				
				if num == 1 then
					require("dap-go").debug_test()
				elseif num == 2 then
					require("dap").continue()
				elseif num == 3 then
					local args = vim.fn.input("Arguments: ")
					require("dap").run({
						type = "go",
						request = "launch",
						name = "Debug with args",
						program = "${fileDirname}",
						args = vim.split(args, " "),
					})
				elseif num == 4 then
					require("dap").toggle_breakpoint()
				elseif num == 5 then
					require("dap").clear_breakpoints()
					vim.notify("All breakpoints cleared", vim.log.levels.INFO)
				elseif num == 6 then
					require("dapui").toggle()
				elseif num == 7 then
					require("dap-go").debug_last_test()
				elseif num == 8 then
					require("dap").list_breakpoints()
				end
			end)
		end, { desc = "Show Go debug menu" })
		
		-- Helper to debug the current test function
		vim.api.nvim_create_user_command("GoDebugTest", function()
			-- Save the file first
			vim.cmd("write")
			require("dap-go").debug_test()
		end, { desc = "Debug Go test under cursor" })
		
		-- Helper to debug with common configurations
		vim.api.nvim_create_user_command("GoDebugPackage", function()
			-- Save all files
			vim.cmd("wall")
			require("dap").continue()
		end, { desc = "Debug Go package" })
		
		-- Create autocmd to show hints when opening Go files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "go",
			callback = function()
				-- Only show once per session
				if not vim.g.go_debug_hints_shown then
					vim.g.go_debug_hints_shown = true
					vim.notify(
						"Go Debug: <leader>dT=test, <leader>db=breakpoint, <leader>dc=start, :GoDebugMenu",
						vim.log.levels.INFO,
						{ title = "Debugger Ready", timeout = 6000 }
					)
				end
			end,
		})
		
		-- Quick test runner with debugging
		vim.api.nvim_create_user_command("GoTestDebug", function(opts)
			local test_name = opts.args ~= "" and opts.args or nil
			if test_name then
				-- Run specific test
				vim.cmd("write")
				require("dap").run({
					type = "go",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
					args = { "-test.run", test_name },
				})
			else
				-- Run test under cursor
				require("dap-go").debug_test()
			end
		end, {
			nargs = "?",
			desc = "Debug specific Go test or test under cursor",
		})
		
		-- Create buffer-local keymaps for Go files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "go",
			callback = function(ev)
				local opts = { buffer = ev.buf }
				
				-- Additional quick access to debug menu in Go files
				vim.keymap.set("n", "<leader>dm", function()
					vim.cmd("GoDebugMenu")
				end, vim.tbl_extend("force", opts, { desc = "Debug: Show Menu" }))
				

			end,
		})
		
		-- Helper function to set up debug environment
		_G.setup_go_debug_env = function()
			-- Check if delve is installed
			local delve_path = vim.fn.stdpath("data") .. "/mason/bin/dlv"
			if vim.fn.filereadable(delve_path) == 0 then
				vim.notify("Delve not found. Installing via Mason...", vim.log.levels.WARN)
				vim.cmd("MasonInstall delve")
				return false
			end
			
			-- Check if dap-go is set up
			local ok, dap_go = pcall(require, "dap-go")
			if not ok then
				vim.notify("dap-go not loaded", vim.log.levels.ERROR)
				return false
			end
			
			return true
		end
		
		-- Add WhichKey descriptions if available
		local ok, which_key = pcall(require, "which-key")
		if ok then
			which_key.add({
				{ "<leader>d", group = "Debug", mode = "n" },
			})
		end
	end,
}