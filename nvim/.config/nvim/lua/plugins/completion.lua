return {
	{
		"hrsh7th/nvim-cmp",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"L3MON4D3/LuaSnip",
			"hrsh7th/cmp-path"
		},
		config = function()
			local cmp = require("cmp")
			local luasnip = require("luasnip")

			cmp.setup({
				snippet = {
					expand = function(args)
						luasnip.lsp_expand(args.body)
					end,
				},

				mapping = cmp.mapping.preset.insert({
					["<C-Space>"] = cmp.mapping.complete(),
					["<C-Y>"] = cmp.mapping.confirm({ select = true }),
				}),

				performance = {
				},

				sources = {
					{
						name = "nvim_lsp",
						entry_filter = function(entry, ctx)
							-- This prevents "Text" kind items from appearing in the menu
							return cmp.lsp.CompletionItemKind.Text ~= entry:get_kind()
						end
					},
					{ name = "path" }
				},
			})
		end,
	},
}
