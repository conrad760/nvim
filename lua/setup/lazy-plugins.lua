require("lazy").setup({
	require("plugins.nvim-web-devicons"),
	require("plugins.plenary_nvim"), -- Useful lua functions used by lots of plugins
	-- require("plugins.vim-sleuth"), -- Detect tabstop and shiftwidth automatically
	require("plugins.vim-rhubarb"),
	require("plugins.vim-unimpaired"),
	require("plugins.vim-fugitive"),
	require("plugins.dadbod"),
	require("plugins.vim-tmux-navigator"),
	require("plugins.nvim-lspconfig"),
	require("plugins.nvim-cmp"),
	require("plugins.comment_nvim"),
	require("plugins.vim-bbye"),
	require("plugins.bufferline_nvim"),
	require("plugins.lualine_nvim"),
	require("plugins.nvim-autopairs"),
	require("plugins.neogit"),
	require("plugins.which-key_nvim"),
	require("plugins.telescope_nvim"),
	require("plugins.colortheme"),
	require("plugins.todo-comments_nvim"),
	require("plugins.nvim-treesitter"),
	require("plugins.lint"),
	require("plugins.gitsigns"),
	require("plugins.neo-tree"), -- DEPRICATE w/ nnn
	-- require("plugins.nnn_nvim"), -- NOT THERE Yet
	require("plugins.oil"), -- DEPRICATE w/ nnn
	require("plugins.conform"),
	--require("plugins.debug"),
	--require("plugins.nvim-dap-virtual-text"),
	require("plugins.committia"),
	require("plugins.zen-mode_nvim"),
	require("plugins.markdown-preview"),
	require("plugins.markdowny_nvim"),
	require("plugins.trouble"),
	require("plugins.twilight_nvim"),
	require("plugins.go_nvim"),
	require("plugins.nvim-goc"),
	require("plugins.mini"),
	require("plugins.diffview_nvim"),
	-- require("plugins.zk-nvim"),
	require("plugins.neorg"),
	require("plugins.gen-nvim"),
	require("plugins.obsidian"),
	require("plugins.nvim-window-picker"),
	--	require("plugins.json2struct"), -- untested
}, {
	ui = {
		-- If you are using a Nerd Font: set icons to an empty table which will use the
		-- default lazy.nvim defined Nerd Font icons, otherwise define a unicode icons table
		icons = true and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})
