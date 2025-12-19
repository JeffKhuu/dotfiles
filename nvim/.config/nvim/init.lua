-- #  TODO: Create git repo
-- #  TODO: Create Typst settings
-- #  TODO: Create LaTeX settings ?
-- #  TODO: Create ipynb settings

-- Set Leader Key
vim.g.mapleader = " "

-- Lazy Plugin Manager
require("config.lazy")

-- Options
require("config.options")

-- Mappings
require("config.mappings")

-- LSP
vim.lsp.config("", {})
vim.lsp.enable(
	{
		-- luals
		"luals",

		-- C and C++
		"clangd",

		-- Python
		"pyright",
		"ruff",
	}
)
