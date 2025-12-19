local conditions = require("heirline.conditions")
local utils = require("heirline.utils")

local colors = {
	bright_bg = utils.get_highlight("Folded").bg,
	bright_fg = utils.get_highlight("Folded").fg,
	red = utils.get_highlight("DiagnosticError").fg,
	dark_red = utils.get_highlight("DiffDelete").bg,
	green = utils.get_highlight("String").fg,
	blue = utils.get_highlight("Function").fg,
	gray = utils.get_highlight("NonText").fg,
	orange = utils.get_highlight("Constant").fg,
	purple = utils.get_highlight("Statement").fg,
	cyan = utils.get_highlight("Special").fg,
	diag_warn = utils.get_highlight("DiagnosticWarn").fg,
	diag_error = utils.get_highlight("DiagnosticError").fg,
	diag_hint = utils.get_highlight("DiagnosticHint").fg,
	diag_info = utils.get_highlight("DiagnosticInfo").fg,
	git_del = utils.get_highlight("diffDeleted").fg,
	git_add = utils.get_highlight("diffAdded").fg,
	git_change = utils.get_highlight("diffChanged").fg,
}

local ViMode = {
	-- get vim current mode, this information will be required by the provider
	-- and the highlight functions, so we compute it only once per component
	-- evaluation and store it as a component attribute
	init = function(self)
		self.mode = vim.fn.mode(1) -- :h mode()
	end,
	static = {
		mode_names = {
			n = "N",
			no = "N?",
			nov = "N?",
			noV = "N?",
			["no\22"] = "N?",
			niI = "Ni",
			niR = "Nr",
			niV = "Nv",
			nt = "Nt",
			v = "V",
			vs = "Vs",
			V = "V_",
			Vs = "Vs",
			["\22"] = "^V",
			["\22s"] = "^V",
			s = "S",
			S = "S_",
			["\19"] = "^S",
			i = "I",
			ic = "Ic",
			ix = "Ix",
			R = "R",
			Rc = "Rc",
			Rx = "Rx",
			Rv = "Rv",
			Rvc = "Rv",
			Rvx = "Rv",
			c = "C",
			cv = "Ex",
			r = "...",
			rm = "M",
			["r?"] = "?",
			["!"] = "!",
			t = "T",
		},
		mode_colors = {
			n = "blue",
			i = "green",
			v = "cyan",
			V = "cyan",
			["\22"] = "cyan",
			c = "orange",
			s = "purple",
			S = "purple",
			["\19"] = "purple",
			R = "orange",
			r = "orange",
			["!"] = "blue",
			t = "blue",
		}
	},
	provider = function(self)
		return " " -- The mode indicator is a space charaacter
	end,
	hl = function(self)
		local mode = self.mode:sub(1, 1) -- get only the first mode character
		return { bg = self.mode_colors[mode], bold = true, }
	end,
	-- Re-evaluate the component only on ModeChanged event!
	-- Also allows the statusline to be re-evaluated when entering operator-pending mode
	update = {
		"ModeChanged",
		pattern = "*:*",
		callback = vim.schedule_wrap(function()
			vim.cmd("redrawstatus")
		end),
	},
}

local FileNameBlock = {
	-- let's first set up some attributes needed by this component and its children
	init = function(self)
		self.filename = vim.api.nvim_buf_get_name(0)
	end,
}

local FileIcon = {
	init = function(self)
		local filename = self.filename
		local extension = vim.fn.fnamemodify(filename, ":e")
		self.icon, self.icon_color = require("nvim-web-devicons").get_icon_color(filename, extension,
			{ default = true })
	end,
	provider = function(self)
		return self.icon and (" " .. self.icon .. " ")
	end,
	hl = function(self)
		return { fg = self.icon_color }
	end
}

local FileName = {
	provider = function(self)
		-- first, trim the pattern relative to the current directory. For other
		-- options, see :h filename-modifers
		local filename = vim.fn.fnamemodify(self.filename, ":.")
		if filename == "" then return "[No Name]" end
		-- now, if the filename would occupy more than 1/4th of the available
		-- space, we trim the file path to its initials
		-- See Flexible Components section below for dynamic truncation
		if not conditions.width_percent_below(#filename, 0.25) then
			filename = vim.fn.pathshorten(filename)
		end
		return "" .. filename
	end,
	hl = { fg = utils.get_highlight("Directory").fg },
}

local FileFlags = {
	{
		condition = function()
			return vim.bo.modified
		end,
		provider = "[+]",
		hl = { fg = "green" },
	},
	{
		condition = function()
			return not vim.bo.modifiable or vim.bo.readonly
		end,
		provider = "",
		hl = { fg = "orange" },
	},
}

-- Now, let's say that we want the filename color to change if the buffer is
-- modified. Of course, we could do that directly using the FileName.hl field,
-- but we'll see how easy it is to alter existing components using a "modifier"
-- component

local FileNameModifer = {
	hl = function()
		if vim.bo.modified then
			-- use `force` because we need to override the child's hl foreground
			return { fg = "cyan", bold = true, force = true }
		end
	end,
}

-- let's add the children to our FileNameBlock component
FileNameBlock = utils.insert(FileNameBlock,
	FileIcon,
	utils.insert(FileNameModifer, FileName), -- a new table where FileName is a child of FileNameModifier
	FileFlags,
	{ provider = ' %< ' }                 -- this means that the statusline is cut here when there's not enough space
)

local Ruler = {
	-- %l = current line number
	-- %L = number of lines in the buffer
	-- %c = column number
	provider = "%7(%l/%3L%):%3c ",
}

local LSPActive = {
	condition = conditions.lsp_attached,
	update = { 'LspAttach', 'LspDetach' },

	-- You can keep it simple,
	-- provider = " [LSP]",

	-- Or complicate things a bit and get the servers names
	provider = function()
		local names = {}
		for i, server in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
			table.insert(names, server.name)
		end
		return "  [" .. table.concat(names, " ") .. "] "
	end,
	hl = { fg = "gray", bold = true },
}

local TreesitterActive = {
	provider = function()
		local condition = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
		if condition then return "⦿ TS " else return "○ TS " end
	end,
	-- Green if Treesitter is active, red otherwise
	hl = function()
		local condition = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
		if condition then return { fg = "green" } else return { fg = "red" } end
	end,
}

local Diagnostics = {
	condition = conditions.has_diagnostics,

	-- Fetching custom diagnostic icons

	init = function(self)
		self.errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
		self.warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
		self.hints = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.HINT })
		self.info = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.INFO })
		self.error_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.ERROR]
		self.warn_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.WARN]
		self.info_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.INFO]
		self.hint_icon = vim.diagnostic.config()['signs']['text'][vim.diagnostic.severity.HINT]
	end,

	update = { "DiagnosticChanged", "BufEnter" },

	{
		provider = function(self)
			-- 0 is just another output, we can decide to print it or not!
			return self.errors > 0 and (self.error_icon .. " " .. self.errors .. " ")
		end,
		hl = { fg = "diag_error" },
	},
	{
		provider = function(self)
			return self.warnings > 0 and (self.warn_icon .. " " .. self.warnings .. " ")
		end,
		hl = { fg = "diag_warn" },
	},
	{
		provider = function(self)
			return self.info > 0 and (self.info_icon .. " " .. self.info .. " ")
		end,
		hl = { fg = "diag_info" },
	},
	{
		provider = function(self)
			return self.hints > 0 and (self.hint_icon .. " " .. self.hints .. " ")
		end,
		hl = { fg = "diag_hint" },
	},
}

local Git = {
	condition = conditions.is_git_repo,

	init = function(self)
		self.status_dict = vim.b.gitsigns_status_dict
		self.has_changes = self.status_dict.added ~= 0 or self.status_dict.removed ~= 0 or self.status_dict.changed ~= 0
	end,

	hl = { fg = utils.get_highlight("Directory").fg },


	{ -- git branch name
		provider = function(self)

			return " " .. self.status_dict.head
		end,
		hl = { bold = true }
	},
	-- You could handle delimiters, icons and counts similar to Diagnostics
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = "("
	},
	{
		provider = function(self)
			local count = self.status_dict.added or 0
			return count > 0 and ("+" .. count)
		end,
		hl = { fg = "green" },
	},
	{
		provider = function(self)
			local count = self.status_dict.removed or 0
			return count > 0 and ("-" .. count)
		end,
		hl = { fg = "red" },
	},
	{
		provider = function(self)
			local count = self.status_dict.changed or 0
			return count > 0 and ("~" .. count)
		end,
		hl = { fg = "orange" },
	},
	{
		condition = function(self)
			return self.has_changes
		end,
		provider = ")",
	},
}

local statusLine = {
	ViMode,
	FileNameBlock,
	Git,
	Diagnostics,
	{
		LSPActive,
		TreesitterActive,
		Ruler,
		provider = "%=" -- Right-align this block
	}
}

require("heirline").setup({
	statusline = statusLine,
	opts = {
		colors = colors
	}
})
