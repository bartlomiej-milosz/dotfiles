-- lua/plugins/sonarlint.lua
return {
  {
    "https://gitlab.com/schrieveslaach/sonarlint.nvim",
    dependencies = {
      "neovim/nvim-lspconfig",
    },
    event = "BufReadPre",
    ft = { "java", "python" },
    config = function()
      require("sonarlint").setup({
        server = {
          cmd = {
            "sonarlint-language-server",
            "-stdio",
            "-analyzers",
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarjava.jar"),
            vim.fn.expand("$MASON/share/sonarlint-analyzers/sonarpython.jar"),
          },
        },
        filetypes = { "java", "python" },
      })
    end,
    keys = {
      {
        "<leader>ls",
        function()
          for _, client in ipairs(vim.lsp.get_clients({ bufnr = 0 })) do
            if client.name:match("sonarlint") then
              vim.lsp.stop_client(client.id)
              vim.notify("SonarLint stopped", vim.log.levels.INFO)
              return
            end
          end
          vim.notify("SonarLint client not found", vim.log.levels.WARN)
        end,
        desc = "Stop SonarLint",
      },
    },
  },

  -- Mason to install tools
  {
    "mason-org/mason.nvim",
    opts = {
      ensure_installed = {
        "sonarlint-language-server",
      },
    },
  },
}
