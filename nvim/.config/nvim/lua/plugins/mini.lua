return {
	"echasnovski/mini.nvim",
	version = false, -- Always use the latest version
	config = function()
        local mini = require("plugins_config.mini")
        -- Empty setup means default settings
		require("mini.icons").setup()
		require("mini.statusline").setup()
		require("mini.starter").setup()
		require("mini.git").setup()
		require("mini.diff").setup()
		require("mini.pairs").setup()
		require("mini.pick").setup(mini.pick_config)
		require("mini.files").setup(mini.files_config)
		require("mini.comment").setup(mini.comment_config)
	end,
}
