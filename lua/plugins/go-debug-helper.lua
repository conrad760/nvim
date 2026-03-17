-- Go Debugging Helper Configuration
-- This file provides intuitive debugging setup specifically for Go

return {
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
					require("dap").run({
						type = "go",
						request = "launch",
						name = "Debug Package",
						program = "${fileDirname}",
					})
				elseif num == 3 then
					local args = vim.fn.input("Arguments: ")
					if args == "" then return end
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
			vim.cmd("write")
			require("dap-go").debug_test()
		end, { desc = "Debug Go test under cursor" })

		-- Helper to debug the current package
		vim.api.nvim_create_user_command("GoDebugPackage", function()
			vim.cmd("wall")
			require("dap").run({
				type = "go",
				request = "launch",
				name = "Debug Package",
				program = "${fileDirname}",
			})
		end, { desc = "Debug Go package" })

		-- Quick test runner with debugging
		vim.api.nvim_create_user_command("GoTestDebug", function(opts)
			local test_name = opts.args ~= "" and opts.args or nil
			if test_name then
				vim.cmd("write")
				require("dap").run({
					type = "go",
					request = "launch",
					mode = "test",
					program = "./${relativeFileDirname}",
					args = { "-test.run", test_name },
				})
			else
				require("dap-go").debug_test()
			end
		end, {
			nargs = "?",
			desc = "Debug specific Go test or test under cursor",
		})

		-- Buffer-local keymaps and which-key registration for Go files
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "go",
			callback = function(ev)
				vim.keymap.set("n", "<leader>dm", function()
					vim.cmd("GoDebugMenu")
				end, { buffer = ev.buf, desc = "Debug: Show Menu" })
			end,
		})

		-- Add WhichKey descriptions if available
		local ok, which_key = pcall(require, "which-key")
		if ok then
			which_key.add({
				{ "<leader>d", group = "Debug", mode = "n" },
			})
		end
	end,
}
