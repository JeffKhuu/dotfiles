-- Set Leader Key
vim.g.mapleader = " "

-- Lazy Plugin Manager
require("config.lazy")

-- Options
require("config.options")

-- Mappings
require("config.mappings")

-- LSP
local servers = {
		-- luals
		"lua_ls",

		-- C and C++
		"clangd",

		-- Rust
		"rust-analyzer",

		-- Python
		"pyright",

		-- Typst
		"tinymist",
}
local capabilities = require("cmp_nvim_lsp").default_capabilities()
vim.lsp.config("*", {
	capabilities = capabilities;
})
vim.lsp.enable(servers)
