return {
	"zk-org/zk-nvim",
	opts = {},
	config = function()
		require("zk").setup({
			-- See Setup section below
			-- can be "telescope", "fzf", "fzf_lua", "minipick", or "select" (`vim.ui.select`)
			-- it's recommended to use "telescope", "fzf", "fzf_lua", or "minipick"
			picker = "telescope",

			lsp = {
				-- `config` is passed to `vim.lsp.start_client(config)`
				config = {
					cmd = { "zk", "lsp" },
					name = "zk",
					-- on_attach = ...
					-- etc, see `:h vim.lsp.start_client()`
				},

				-- automatically attach buffers in a zk notebook that match the given filetypes
				auto_attach = {
					enabled = true,
					filetypes = { "markdown" },
				},
			},
		})

		-- Require necessary modules
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local finders = require("telescope.finders")
		local pickers = require("telescope.pickers")
		local previewers = require("telescope.previewers")
		local conf = require("telescope.config").values
		local Path = require("plenary.path")
		local scan = require("plenary.scandir")

		-- Define the zk_template_picker function
		local function zk_template_picker()
			local template_dir = Path:new(vim.fn.getenv("ZK_NOTEBOOK_DIR"), ".zk/templates")

			-- Scan the template directory for markdown files
			local templates =
				scan.scan_dir(template_dir:absolute(), { hidden = false, depth = 1, search_pattern = "%.md$" })

			-- Create a custom finder that filters templates by name
			local finder = finders.new_table({
				results = templates,
				entry_maker = function(entry)
					local display = Path:new(entry):make_relative(template_dir:absolute())
					return {
						value = entry,
						display = display,
						ordinal = display,
					}
				end,
			})

			pickers
				.new({}, {
					prompt_title = "ZK Templates",
					finder = finder,
					sorter = conf.generic_sorter({}),
					attach_mappings = function(prompt_bufnr, map)
						local function create_note_from_template()
							local selected_entry = action_state.get_selected_entry()
							local selected_template = selected_entry.value
							local note_title = vim.fn.input("Title: ")
							vim.cmd(
								'ZkNew { template = "' .. selected_template .. '", title = "' .. note_title .. '" }'
							)
							actions.close(prompt_bufnr)
						end

						-- Bind the <CR> key to create a note from the selected template
						map("i", "<CR>", create_note_from_template)
						map("n", "<CR>", create_note_from_template)
						return true
					end,
					previewer = previewers.cat.new({
						get_command = function(entry)
							return { "cat", entry.value }
						end,
					}),
				})
				:find()
		end
		-- Create a Neovim command to trigger the picker
		vim.api.nvim_create_user_command("ZkTemplate", zk_template_picker, {})

		-- zk
		-- Add the key mappings only for Markdown files in a zk notebook.
		local function map(...)
			vim.api.nvim_buf_set_keymap(0, ...)
		end
		local opts = { noremap = true, silent = false }
		-- Open the link under the caret.
		map("n", "<CR>", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
		-- Create a new note after asking for its title.
		-- This overrides the global `<leader>zn` mapping to create the note in the same directory as the current buffer.
		map("n", "<leader>zt", "<Cmd>ZkTemplate<CR>", opts)
		map("n", "<leader>zT", "<Cmd>ZkTags<CR>", opts)
		map("n", "<leader>zN", "<Cmd>ZkNotes<CR>", opts)
		map("n", "<leader>zn", "<Cmd>ZkNew { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>", opts)
		-- Create a new note in the same directory as the current buffer, using the current selection for title.
		map("v", "<leader>znt", ":'<,'>ZkNewFromTitleSelection { dir = vim.fn.expand('%:p:h') }<CR>", opts)
		-- Create a new note in the same directory as the current buffer, using the current selection for note content and asking for its title.
		map(
			"v",
			"<leader>znc",
			":'<,'>ZkNewFromContentSelection { dir = vim.fn.expand('%:p:h'), title = vim.fn.input('Title: ') }<CR>",
			opts
		)

		-- Open notes linking to the current buffer.
		map("n", "<leader>zb", "<Cmd>ZkBacklinks<CR>", opts)
		-- Alternative for backlinks using pure LSP and showing the source context.
		--map('n', '<leader>zb', '<Cmd>lua vim.lsp.buf.references()<CR>', opts)
		-- Open notes linked by the current buffer.
		map("n", "<leader>zl", "<Cmd>ZkLinks<CR>", opts)

		-- Preview a linked note.
		map("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
		-- Open the code actions for a visual selection.
		map("v", "<leader>za", ":'<,'>lua vim.lsp.buf.range_code_action()<CR>", opts)
	end,
}
