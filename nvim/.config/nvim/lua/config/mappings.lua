local set = vim.keymap.set
local k = vim.keycode

-- LSP
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup('lsp-attach', { clear = true }),
	callback = function()
		set('n', 'K', vim.lsp.buf.hover, { desc = "Hover" })
		set('n', '<leader>lk', vim.diagnostic.open_float, { desc = "View Diagnostic" })
		set('n', '<leader>ln', vim.lsp.buf.rename, { desc = "Re[n]ame" })
		set('n', '<leader>ld', vim.lsp.buf.definition, { desc = "[D]efinition" })
		set('n', '<leader>lr', vim.lsp.buf.references, { desc = "[R]eferences" })
		set('n', '<leader>lv', "<cmd>vsplit | lua vim.lsp.buf.definition.()<CR>",
			{ desc = "[V]ertical Split and goto Definition" })
	end
},

set({"n", "v"}, "<leader>lf", function()
    require("conform").format({ async = true, lsp_fallback = true })
end, { desc = "Format file or selection" }))

-- File Movement
set('n', '<leader>f', '<cmd>:Pick files<CR>')
set('n', '<leader>e', '<cmd>:Oil --float<CR>', { desc = "[E]xplorer" })

-- Clear Search Highlight
set("n", "<CR>", function()
	if vim.v.hlsearch == 1 then
		vim.cmd.nohl()
		return ""
	else
		return k "<CR>"
	end
end, { expr = true })

-- Split and Split Controls
set('n', '<leader>|', vim.cmd.vsplit, { desc = "Split Vertical (|)" })
set('n', '<leader>-', vim.cmd.split, { desc = "Split Horizontal (-)" })
set("n", "<c-j>", "<c-w><c-j>", { desc = "Navigate to split below" })
set("n", "<c-k>", "<c-w><c-k>", { desc = "Navigate to split above" })
set("n", "<c-l>", "<c-w><c-l>", { desc = "Navigate to split left" })
set("n", "<c-h>", "<c-w><c-h>", { desc = "Navigate to split right" })

-- Join Lines w/o Moving Cursor
set('n', '<M-j>', "mzJ`z", { desc = "Join Lines" })

-- Move Half Pages & Center
set('n', '<C-d>', "<C-d>zz", { desc = "Half page down (and center)" })
set('n', '<C-u>', "<C-u>zz", { desc = "Half page up (and center)" })

-- Move Selection
set('v', 'J', ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
set('v', 'K', ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Toggle Floating Term
set('n', '<leader>t', '<CMD>:ToggleTerm direction=float<CR>', { desc = "Toggle Floating Terminal"})
