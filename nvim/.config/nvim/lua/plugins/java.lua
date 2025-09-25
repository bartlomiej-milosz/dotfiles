-- lua/plugins/jdtls.lua
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
          configuration = {
            runtimes = {
              { name = "JavaSE-21", path = "/opt/homebrew/opt/openjdk@21" },
              { name = "JavaSE-25", path = "/opt/homebrew/opt/openjdk" },
            },
          },
        },
      })
      return opts
    end,
  },
}
