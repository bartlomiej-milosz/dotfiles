-- lua/plugins/java.lua
return {
  {
    "mfussenegger/nvim-jdtls",
    -- Disable jdtls formatting (conform instead) + add runtimes
    opts = function(_, opts)
      opts.settings = vim.tbl_deep_extend("force", opts.settings or {}, {
        java = {
          format = {
            enabled = false,
          },
        },
      })
      return opts
    end,
  },

  -- Formatter
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        java = { "google-java-format" },
      },
    },
  },
}
