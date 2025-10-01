-- lua/plugins/colorscheme.lua
return {
  -- Auto dark mode based on system
  {
    "f-person/auto-dark-mode.nvim",
    priority = 1000,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.opt.background = "dark"
        vim.cmd.colorscheme("kanso-mist")
      end,
      set_light_mode = function()
        vim.opt.background = "light"
        vim.cmd.colorscheme("kanso-pearl")
      end,
    },
  },

  -- Kanso theme
  {
    "webhooked/kanso.nvim",
    lazy = false,
    priority = 999, -- Load after auto-dark-mode
  },
}
