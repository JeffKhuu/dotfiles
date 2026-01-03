return {
	-- LSP & Formatting
	{ 'neovim/nvim-lspconfig' },
	{
		'stevearc/conform.nvim',
		opts = {
			formatters_by_ft = {
				python = { "black" },
			},
		}
	},

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
