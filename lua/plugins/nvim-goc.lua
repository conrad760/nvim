return {
	"rafaelsq/nvim-goc.lua",
	event = "VeryLazy",
	ft = "go",
	config = function()
		-- if set, when we switch between buffers, it will not split more than once. It will switch to the existing buffer instead
		-- vim.opt.switchbuf = "useopen"
		vim.opt.switchbuf:remove("useopen")

		local goc = require("nvim-goc")
		goc.setup({ verticalSplit = false }) -- default to horizontal

		vim.keymap.set("n", "<leader>ocf", goc.Coverage, {
			silent = true,
			desc = "Coverage:  run for the whole File",
		})
		vim.keymap.set(
			"n",
			"<leader>oct",
			goc.CoverageFunc,
			{ silent = true, desc = "Coverage: run only for a specific Test unit" }
		)
		vim.keymap.set(
			"n",
			"<leader>occ",
			goc.ClearCoverage,
			{ silent = true, desc = "Coverage: clear coverage highlights" }
		)

		-- If you need custom arguments, you can supply an array as in the example below.
		-- vim.keymap.set('n', '<leader>ocf', function() goc.Coverage({ "-race", "-count=1" }) end, {silent=true})
		-- vim.keymap.set('n', '<leader>oct', function() goc.CoverageFunc({ "-race", "-count=1" }) end, {silent=true})

		vim.keymap.set(
			"n",
			"]a",
			goc.Alternate,
			{ silent = true, desc = "Coverage: set verticalSplit=true for horizontal" }
		)
		vim.keymap.set(
			"n",
			"[a",
			goc.AlternateSplit,
			{ silent = true, desc = "Coverage: set verticalSplit=true for vertical" }
		)

		local cf = function(testCurrentFunction)
			local cb = function(path)
				if path then
					-- `xdg-open|open` command performs the same function as double-clicking on the file.
					-- change from `xdg-open` to `open` on MacOSx
					vim.cmd(':silent exec "!open ' .. path .. '"')
				end
			end

			if testCurrentFunction then
				goc.CoverageFunc(nil, cb, 0)
			else
				goc.Coverage(nil, cb)
			end
		end

		-- If you want to open it in your browser, you can use the commands below.
		-- You need to create a callback function to configure which command to use to open the HTML.
		-- On Linux, `xdg-open` is generally used, on MacOSx it's just `open`.
		vim.keymap.set("n", "<leader>oca", cf, { silent = true, desc = "Coverage: Open coverage in browser" })
		vim.keymap.set("n", "<leader>ocb", function()
			cf(true)
		end, { silent = true, desc = "Coverage: Open coverage in browser current Function" })

		-- default colors
		-- vim.api.nvim_set_hl(0, 'GocNormal', {link='Comment'})
		-- vim.api.nvim_set_hl(0, 'GocCovered', {link='String'})
		-- vim.api.nvim_set_hl(0, 'GocUncovered', {link='Error'})
	end,
}
