-- I use 3 plugins for this to work properly, but I only add a single file,
-- which is the current one, and the other 2 plugins are listed under dependencies
-- These dependencies will be automatically installed

--[=====[

https://github.com/tpope/vim-dadbod
Vim plugin for interacting with databases
Connections are specified with a single URL
:DB mysql://user:pass@hostname:port SHOW DATABASES;

https://github.com/kristijanhusak/vim-dadbod-ui
To add a new dtabase, toggle DBUI, then hit capital `A` to add a new connection
Example formats:
mysql://user:pass@hostname:port
postgres://user:pass@hostname:port/
Then you will be asked for the name of the database that will show in the toogle

https://github.com/kristijanhusak/vim-dadbod-completion

-------------------------------------------------------------------------------

postgres
- Lets say I'm on macOS and I want to connect to a postgres DB
- I need to have psql installed, otherwise I won't be able to connect to the databases
- So install it with
  - `brew install postgresql@15`
  - Installation command found in `https://www.postgresql.org/download/macosx/`
- Then you can check the version with
  - `psql --version`

-------------------------------------------------------------------------------

- I found the below file in this thread that helped me solve the autocompletion
  issue I has having.
- I had to add the cmp configg to `config/autocmds.lua`
  `https://github.com/kristijanhusak/vim-dadbod-completion/issues/53#issuecomment-1705335855`
- This thread also pointed me to the plugin's creator dotfiles
- The file below is the one that the dadbod-ui creator uses, so that's the config I'm using
  `https://github.com/kristijanhusak/neovim-config/blob/master/nvim/lua/partials/plugins/db.lua`

-------------------------------------------------------------------------------

How to's
- When dadbod is open press `?` to look at the help
- <Leader>W - (sql) Save currently opened query
  - That is an uppercase `W`
  - This will save the query in the `vim.g.db_ui_save_location` location configured below

--]=====]
--
--
return {
	"kristijanhusak/vim-dadbod-ui",
	enabled = true,
	dependencies = {
		{
			"tpope/vim-dadbod",
			lazy = false,
		},
		{
			"kristijanhusak/vim-dadbod-completion",
			ft = { "sql", "mysql", "plsql" },
			config = function()
				-- Just for extra safety if db#resolve gets called without context
				vim.g.db_completion_use_suggestions = 0
			end,
		},
	},
	keys = {
		{ "<leader>D", "<cmd>toggle_dbui_tab<CR>", desc = "Toggle DBUI in tab" },
	},
	cmd = {
		"DBUI",
		"DBUIToggle",
		"DBUIAddConnection",
		"DBUIFindBuffer",
	},
	init = function()
		vim.g.db_ui_show_help = 1
		vim.g.db_ui_win_position = "right"
		vim.g.db_ui_use_nerd_fonts = 1
		vim.g.db_ui_use_nvim_notify = 1
		-- Removed hardcoded paths - will use plugin defaults
		vim.g.db_ui_hide_schemas = { "pg_toast_temp.*" }

		local function toggle_dbui_tab()
			local dbui_bufname = "dbui"
			for _, tabnr in ipairs(vim.api.nvim_list_tabpages()) do
				for _, win in ipairs(vim.api.nvim_tabpage_list_wins(tabnr)) do
					local buf = vim.api.nvim_win_get_buf(win)
					local name = vim.api.nvim_buf_get_name(buf)

					if name:match(dbui_bufname) then
						vim.api.nvim_set_current_tabpage(tabnr) -- switch to tab
						vim.notify("Switched to DBUI tab")
						return
					end
				end
			end

			vim.api.nvim_command("tabnew | DBUI")
		end

		vim.keymap.set("n", "<leader>D", toggle_dbui_tab, { desc = "Toggle DBUI in tab" })
	end,
}
