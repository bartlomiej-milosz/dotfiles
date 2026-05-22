local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Clone lazy if not present
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"--branch=stable",
		lazyrepo,
		lazypath,
	})
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({

	-- Scan lua/plugins/ directory
	spec = {
		{ import = "plugins" },
	},

	defaults = {
		lazy = false, -- load plugins at startup (override per-plugin)
		version = false, -- always use latest git commit, not tag
	},

	-- Check for plugin updates in the background
	checker = {
		enabled = true,
		notify = false, -- no notifications, check manually via :Lazy
	},

	-- Silent config file change detection
	change_detection = {
		enabled = true,
		notify = false,
	},

	-- UI
	ui = {
		border = "rounded",
		icons = {
			cmd = "⌘",
			config = "",
			event = "",
			ft = "",
			init = "",
			keys = "",
			plugin = "",
			runtime = "",
			require = "",
			source = "",
			start = "",
			task = "✔",
			lazy = "󰒲 ",
			loaded = "●",
			not_loaded = "○",
		},
	},

	performance = {
		rtp = {
			reset = true,
			disabled_plugins = {
				-- Archives and compression
				"gzip",
				"tarPlugin",
				"zipPlugin",
				"vimball",
				"vimballPlugin",

				-- Old file explorer (replaced by mini.files)
				"netrw",
				"netrwPlugin",
				"netrwSettings",
				"netrwFileHandlers",

				-- Rarely used built-ins
				"2html_plugin",
				"getscript",
				"getscriptPlugin",
				"logipat",
				"rrhelper",
				"optwin",
				"compiler",
				"spellfile_plugin",
				"matchit", -- replaced by treesitter
			},
		},
	},

	rocks = {
		enabled = false,
	},
})
