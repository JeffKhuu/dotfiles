local set = vim.keymap.set
local k = vim.keycode

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("lsp-attach", { clear = true }),
	callback = function(args)
		local function opts(desc)
			return { noremap = true, silent = true, desc = desc, buffer = args.buf }
		end

		set("n", "K", vim.lsp.buf.hover, opts("Hover"))
		set("n", "<leader>k", vim.diagnostic.open_float, opts("View Diagnostic"))

		-- Diagnostic Navigation
		set("n", "[d", function()
			vim.diagnostic.jump({ count = -1 })
		end, opts("Prev. Diagnostic"))
		set("n", "]d", function()
			vim.diagnostic.jump({ count = 1 })
		end, opts("Next Diagnostic"))

		-- Code
		set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts("Code [A]ction"))
		set("n", "<leader>cn", vim.lsp.buf.rename, opts("Re[n]ame"))
		set("n", "<leader>cd", vim.lsp.buf.definition, opts("[D]efinition"))
		set("n", "<leader>cr", vim.lsp.buf.references, opts("[R]eferences"))
		set("n",
			"<leader>cv",
			"<cmd>vsplit | lua vim.lsp.buf.definition.()<CR>",
			opts("[V]ertical Split and goto Definition")
		)
		set("n", "<leader>lh", function()
			vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = args.buf }), { bufnr = args.buf })
		end, opts("Toggle Inlay Code [H]ints"))

		-- LSP
		set("n", "<leader>li", "<cmd>LspInfo<cr>", { desc = "LSP Info" })
		set("n", "<leader>lr", "<cmd>LspRestart<cr>", { desc = "LSP Restart" })

		set({ "n", "v" }, "<leader>lf", vim.lsp.buf.format, opts("[F]ormat"))
	end,
})

-- File Movement
set("n", "<leader>f", "<cmd>:Pick files<CR>")
set("n", "<leader>e", "<cmd>:Oil --float<CR>", { desc = "[E]xplorer" })

-- Clear Search Highlight
set("n", "<CR>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd.nohl()
		return ""
	else
		return k("<CR>")
	end
end, { expr = true })

-- Split and Split Controls
set("n", "<leader>|", vim.cmd.vsplit, { desc = "Split Vertical (|)" })
set("n", "<leader>-", vim.cmd.split, { desc = "Split Horizontal (-)" })
set("n", "<c-j>", "<c-w><c-j>", { desc = "Navigate to split below" })
set("n", "<c-k>", "<c-w><c-k>", { desc = "Navigate to split above" })
set("n", "<c-l>", "<c-w><c-l>", { desc = "Navigate to split left" })
set("n", "<c-h>", "<c-w><c-h>", { desc = "Navigate to split right" })

-- Join Lines w/o Moving Cursor
set("n", "<M-j>", "mzJ`z", { desc = "Join Lines" })

-- Move Half Pages & Center
set("n", "<C-d>", "<C-d>zz", { desc = "Half page down (and center)" })
set("n", "<C-u>", "<C-u>zz", { desc = "Half page up (and center)" })

-- Move Selection
set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Toggle Floating Term
set("n", "<leader>t", "<CMD>:ToggleTerm direction=float<CR>", { desc = "Toggle Floating Terminal" })
