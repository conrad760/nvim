require("lazy").setup({
	require("plugins.nvim-web-devicons"), -- icon pack
	require("plugins.plenary_nvim"), -- Useful lua functions used by lots of plugins
	require("plugins.vim-unimpaired"), -- handy bracket mappings
	require("plugins.vim-fugitive"), -- all the git goodness
	require("plugins.dadbod"), -- database integration
	require("plugins.vim-tmux-navigator"), -- navigate between tmux panes
	require("plugins.nvim-lspconfig"), -- Automatically install LSPs and related tools
	require("plugins.nvim-cmp"),
	require("plugins.comment_nvim"),
	require("plugins.vim-bbye"),
	require("plugins.lualine_nvim"),
	require("plugins.nvim-autopairs"),
	require("plugins.neogit"),
	require("plugins.which-key_nvim"),
	require("plugins.telescope_nvim"),
	require("plugins.colortheme"), -- current colors
	require("plugins.todo-comments_nvim"),
	require("plugins.nvim-treesitter"),
	require("plugins.nvim-treesitter-context"),
	require("plugins.lint"),
	require("plugins.gitsigns"),
	require("plugins.neo-tree"),
	require("plugins.oil-nvim"), -- DEPRICATE w/ nnn
	require("plugins.conform"),
	require("plugins.debug"),
	require("plugins.committia"),
	require("plugins.zen-mode_nvim"),
	require("plugins.markdown-preview"),
	require("plugins.markdowny_nvim"),
	require("plugins.trouble"),
	require("plugins.twilight_nvim"),
	require("plugins.go_nvim"),
	require("plugins.nvim-goc"),
	require("plugins.mini"),
	require("plugins.mini-files"), -- TODO: needs setup
	require("plugins.mini-indentscope"),
	require("plugins.mini-pairs"),
	require("plugins.mini-surround"),
	require("plugins.diffview_nvim"),
	-- require("plugins.zk-nvim"),
	require("plugins.neorg"),
	require("plugins.gen-nvim"),
	require("plugins.obsidian"),
	require("plugins.nvim-window-picker"),
	require("plugins.codeium"),
	require("plugins.notify"),
	require("plugins.colorizer-nvim"), -- not working yet
	require("plugins.flash"), -- TODO: set this up to replace `s`
	require("plugins.ghostty"),
	require("plugins.grug-far"), -- TODO: watch the video
	-- require("plugins.img-clip"), -- TODO: needs setup
	-- require("plugins.lualine"), -- TODO: dependent on MANY
	require("plugins.luasnip"),
	require("plugins.mason-nvim"),
	require("plugins.noice"),
	require("plugins.nvim-lint"),
	require("plugins.nvim-lspconfig"),
	require("plugins.outline"),
	require("plugins.render-markdown"),
	require("plugins.snacks"),
	require("plugins.snipe"),
	require("plugins.stay-centered"),
	require("plugins.virt-column"),
	require("plugins.atac"),
	require("plugins.flash"),
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
