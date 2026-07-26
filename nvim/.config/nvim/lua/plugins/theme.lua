return {
  {
    "projekt0n/github-nvim-theme",
    name = "github-theme",
    lazy = false,
    priority = 1000,
    opts = {},
  },

  -- Tell LazyVim to use the GitHub theme as the active colorscheme.
  {
    "LazyVim/LazyVim",
    opts = {
      colorscheme = "github_dark_default",
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
        vim.cmd.colorscheme("github_dark_default")
      end,
      set_light_mode = function()
        vim.o.background = "light"
        vim.cmd.colorscheme("github_light")
      end,
    },
  },
}
