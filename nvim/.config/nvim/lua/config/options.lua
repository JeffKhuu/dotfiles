local opt = vim.opt

-- Preview incremental (find and replace) commands
opt.inccommand = "split"
opt.incsearch = true

-- Enable line numbers
opt.number = true
opt.relativenumber = true

-- Better search settings
opt.smartcase = true
opt.ignorecase = true

-- Control how splits show up
opt.splitbelow = true
opt.splitright = true

-- Sign column
opt.signcolumn = "yes"

-- Disable the swapfile
opt.swapfile = false

-- Disable Auto Comment on New Line
vim.cmd([[autocmd FileType * set formatoptions-=ro]])
opt.formatoptions:remove "o"

-- Spacing
opt.tabstop = 4
opt.softtabstop = 4
opt.shiftwidth = 4
opt.smartindent = true

-- Save undo history
opt.undofile = true

-- Minimum number of lines to keep above/below cursor when scrolling
opt.scrolloff = 10

-- Highlight cursor number
opt.cursorline = true
opt.cursorlineopt = "number"

-- Sync neovim and desktop clipboard
opt.clipboard = 'unnamedplus'

opt.confirm = true

-- Highlight Yanks
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

-- Diagnostic Config
vim.diagnostic.config({
	-- virtual_lines = true,
	virtual_text = true,
	underline = true,
	update_in_insert = false,
	severity_sort = true,
	float = {
		border = "rounded",
		source = true
	},

	signs = {
		text = {
			[vim.diagnostic.severity.ERROR] = '',
			[vim.diagnostic.severity.WARN] = '',
			[vim.diagnostic.severity.INFO] = '󰋇',
			[vim.diagnostic.severity.HINT] = '󰌵',
		},
	},
})
