return {
  {
    "folke/tokyonight.nvim",
    opts = {
      style = "moon",
      light_style = "day",
    },
  },

  {
    "f-person/auto-dark-mode.nvim",
    lazy = false,
    priority = 1000,
    opts = {
      update_interval = 1000,
      set_dark_mode = function()
        vim.o.background = "dark"
        vim.cmd.colorscheme("tokyonight-moon")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("tokyonight-day")
      end,
    },
  },
}
