return {
  -- XML LSP
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        lemminx = {
          settings = {
            xml = {
              format = {
                enabled = true,
                splitAttributes = false,
              },
              validation = {
                enabled = true,
              },
            },
          },
        },
      },
    },
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    optional = true,
    opts = {
      formatters_by_ft = {
        xml = { "xmlformat" },
      },
    },
  },

  -- Mason to install tools
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "lemminx", -- XML LSP
        "xmlformatter", -- XML formatter
      },
    },
  },
}
