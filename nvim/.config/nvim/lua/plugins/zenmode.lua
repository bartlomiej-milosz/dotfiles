-- lua/plugins/zenmode.lua
-- lua/plugins/zen-mode.lua
return {
  "folke/zen-mode.nvim",
  cmd = "ZenMode",
  opts = {
    window = {
      backdrop = 1,
      width = 0.85,
      height = 1,
      options = {
        -- signcolumn = "no",
        -- number = false,
        -- relativenumber = false,
        -- cursorline = false,
        -- cursorcolumn = false,
        -- foldcolumn = "0",
        -- list = false,
      },
    },
    plugins = {
      options = {
        enabled = true,
        -- ruler = false,
        showcmd = false,
        laststatus = 0,  -- hide statusline
      },
    },
  },
  keys = {
    { "<leader>z", "<cmd>ZenMode<cr>", desc = "Toggle Zen Mode" },
  },
}
