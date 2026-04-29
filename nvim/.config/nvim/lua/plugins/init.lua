return {
	-- LSP & Formatting
	{ "mason-org/mason.nvim" },
	{ 'neovim/nvim-lspconfig' },
	{
		'mason-org/mason-lspconfig.nvim',
		opts = {},
		dependencies = {
			{ "mason-org/mason.nvim", opts = {} },
			"neovim/nvim-lspconfig",
		},
	},
	{ 'WhoIsSethDaniel/mason-tool-installer.nvim' },

	-- Colorscheme
	{
		'catppuccin/nvim',
		lazy = false,
		priority = 1000,
		config = function()
			vim.cmd([[colorscheme catppuccin-frappe]])
		end,
	},

	-- Mini
	{ 'nvim-mini/mini.basics', version = '*' },
	{ 'nvim-mini/mini.pick',   opts = {} },
	{ 'nvim-mini/mini.visits', opts = {} },

	-- Statusline
	{
		'rebelot/heirline.nvim',
		config = function()
			require("config.status")
		end
	},

	-- Other Utilities
	{
		'folke/todo-comments.nvim',
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {}
	},
	{
		'abecodes/tabout.nvim',
		opts = {
			ignore_beginning = false,
		}
	},
	{
		'windwp/nvim-autopairs',
		event = "InsertEnter",
		config = true,
	},
	{ 'nvim-tree/nvim-web-devicons', opts = {} },
	{ 'lewis6991/gitsigns.nvim',     opts = {} },
	{ 'j-hui/fidget.nvim',           opts = {} },
	{ 'kylechui/nvim-surround',      opts = {} },
	{ 'akinsho/toggleterm.nvim',     version = "*", config = true },
}
