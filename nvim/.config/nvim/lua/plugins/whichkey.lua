return { 
	"folke/which-key.nvim", 
	config = function()
		local wk = require("which-key")
		wk.add({
			{ "<leader>l", group = "Language" },
		})
	end
}
