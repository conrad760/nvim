return {
	"NickvanDyke/opencode.nvim",
	dependencies = {
		-- Recommended for better prompt input, and required to use `opencode.nvim`'s embedded terminal — otherwise optional
		{ "folke/snacks.nvim", opts = { input = { enabled = true } } },
	},
	opts = {
		auto_fallback_to_embedded = false,
	},
	keys = {
		-- Ask (no context)
		{
			"<leader>oA",
			function()
				require("opencode").ask()
			end,
			desc = "Ask opencode",
			mode = "n",
		},

		-- Ask about cursor/selection
		{
			"<leader>oa",
			function()
				require("opencode").ask("@cursor: ")
			end,
			desc = "Ask opencode about this",
			mode = "n",
		},
		{
			"<leader>oa",
			function()
				require("opencode").ask("@selection: ")
			end,
			desc = "Ask opencode about selection",
			mode = "v",
		},

		-- Sessions / utilities
		-- {
		-- 	"<leader>on",
		-- 	function()
		-- 		require("opencode").command("session_new")
		-- 	end,
		-- 	desc = "New opencode session",
		-- 	mode = "n",
		-- },
		-- {
		-- 	"<leader>oy",
		-- 	function()
		-- 		require("opencode").command("messages_copy")
		-- 	end,
		-- 	desc = "Copy last opencode response",
		-- 	mode = "n",
		-- },
		-- {
		-- 	"<leader>os",
		-- 	function()
		-- 		require("opencode").select()
		-- 	end,
		-- 	desc = "Select opencode prompt",
		-- 	mode = { "n", "v" },
		-- },

		-- Example: custom prompt
		{
			"<leader>oe",
			function()
				require("opencode").prompt("Explain @cursor and its context")
			end,
			desc = "Explain this code",
			mode = "n",
		},

		-- If you want the toggle too, uncomment:
		-- { '<leader>ot', function() require('opencode').toggle() end, desc = 'Toggle opencode', mode = 'n' },
	},
}
