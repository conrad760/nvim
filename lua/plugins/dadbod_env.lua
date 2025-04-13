-- dadbod_env.lua
local M = {}

-- Load direnv env vars manually (optional if using GUI launch)
function M.load_direnv()
	vim.fn.jobstart("direnv export bash", {
		stdout_buffered = true,
		on_stdout = function(_, data)
			for _, line in ipairs(data or {}) do
				local key, val = line:match('^export (%S+)="(.*)"$')
				if key and val then
					vim.fn.setenv(key, val)
				end
			end
		end,
	})
end

-- Command to connect to DB via dadbod using $DB_CONN
function M.setup()
	vim.api.nvim_create_user_command("DBConnect", function()
		local db_conn = os.getenv("DB_CONN")
		if db_conn then
			vim.cmd("DB " .. db_conn)
		else
			vim.api.nvim_echo({ { "DB_CONN not set in environment", "WarningMsg" } }, false, {})
		end
	end, {})

	-- Optional: show current DB on startup
	-- Uncomment if you want a reminder
	local db_conn = os.getenv("DB_CONN")
	if db_conn then
		vim.schedule(function()
			vim.api.nvim_echo({ { "DB Ready: " .. db_conn, "Normal" } }, false, {})
		end)
	end
end

return M
