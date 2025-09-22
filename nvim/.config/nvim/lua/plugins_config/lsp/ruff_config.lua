return function(lspconfig, capabilities)
  lspconfig.ruff.setup({
    capabilities = capabilities,
    init_options = {
      settings = {
        -- Any extra CLI arguments for `ruff` go here.
        args = {},
      },
    },
  })
end
