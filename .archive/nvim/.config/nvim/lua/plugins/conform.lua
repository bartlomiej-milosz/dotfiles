return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  dependencies = { "mason-org/mason.nvim" },
  opts = {
    formatters_by_ft = {
      java = { "google-java-format" },
      lua  = { "stylua" },
      -- Add more as needed:
      -- json = { "prettier" },
      -- yaml = { "prettier" },
    },

    -- Format on save
    format_on_save = {
      timeout_ms = 3000,
      lsp_format = "fallback",       -- use LSP formatting if no conform formatter available
    },

    -- google-java-format uses 2-space indent by default (Google style)
    -- uncomment below to use 4-space indent (AOSP style) instead
    -- formatters = {
    --     ["google-java-format"] = {
    --         prepend_args = { "--aosp" },
    --     },
    -- },
  },
  keys = {
    {
      "<leader>cf",
      function() require("conform").format({ async = true }) end,
      mode = { "n", "v" },
      desc = "Format",
    },
  },
  -- Ensure google-java-format is installed via Mason
  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "MasonToolsStartingInstall",
      once = true,
      callback = function() end,
    })
  end,
}
