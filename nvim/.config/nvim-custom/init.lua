-- Load basic settings before loading plugins
require("config.keymaps") -- Keybindings
require("config.options") -- Global settings, options
require("config.autocmds") -- Scripts
-- bootstrap lazy.nvim, LazyVim and your plugins
require("config.lazy")
