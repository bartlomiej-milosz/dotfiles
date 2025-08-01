return {
	"folke/which-key.nvim",
	event = "VimEnter",
	config = function()
		-- Gain access to the which-key plugin
		local wk = require("which-key")
		-- Call the setup function with default properties
		wk.setup()
		-- Register prefixes for the different key mappings we have setup previously
		wk.add({
			{ "<leader>c", group = "[C]ode" },
			{ "<leader>d", group = "[D]ebug" },
			{ "<leader>f", group = "[F]ind" },
			{ "<leader>i", group = "[I]nsert" },
			{ "<leader>s", group = "[S]how" },
			{ "<leader>w", group = "[W]indow" },
		})
	end,
}
