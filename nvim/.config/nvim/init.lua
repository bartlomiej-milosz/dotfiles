-- Load core config before plugins (leader must be set first)
require("config.options")
require("config.keymaps")
require("config.autocmds")

-- Bootstrap and load plugins
require("config.lazy")
