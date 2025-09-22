-- Declare the path where lazy will clone plugin code
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out,                            "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end
-- Add the path to the lazy plugin repositories to the vim runtime path
vim.opt.rtp:prepend(lazypath)
require("lazy").setup({
	spec = {
		-- import/override with your plugins
		{ import = "plugins" },
	},
	defaults = {
		-- By default, only LazyVim plugins will be lazy-loaded. Your custom plugins will load during startup.
		-- If you know what you're doing, you can set this to `true` to have all your custom plugins lazy-loaded by default.
		lazy = false,
		-- It's recommended to leave version=false for now, since a lot the plugin that support versioning,
		-- have outdated releases, which may break your Neovim install.
		version = false, -- always use the latest git commit
	},
	checker = {
		enabled = true, -- check for plugin updates periodically
		notify = false, -- notify on update
	},
	performance = {
		rtp = {
			reset = true, -- Reset the runtime path to $VIMRUNTIME and your config directory
			-- for slightly better performance disable unused build-in plugins
			disabled_plugins = {
				"gzip",          -- Handles compressed files (.gz)
				"tarPlugin",     -- Handles tar archives
				"zipPlugin",     -- Handles zip archives
				"netrw",         -- Old file explorer (disable if using another file manager like nvim-tree)
				"netrwPlugin",   -- Related to netrw
				"netrwSettings", -- Settings for netrw
				"netrwFileHandlers", -- File handlers for netrw
				"2html_plugin",  -- Converts buffers to HTML
				"logipat",       -- Legacy Vim pattern matching
				"rrhelper",      -- Rarely used helper for remote plugins
				"vimball",       -- Vimball archive support
				"vimballPlugin", -- Vimball plugin
				"getscript",     -- Legacy script downloading
				"getscriptPlugin", -- Plugin for getscript
				-- "tutor", -- Built-in Vim tutorial
				"optwin",        -- Optional plugin window
				"compiler",      -- Compiler plugin (for older Vim setups)
			},
		},
	},
})
