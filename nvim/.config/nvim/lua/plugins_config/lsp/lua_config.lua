return function(lspconfig, capabilities)
  lspconfig.lua_ls.setup({
    capabilities = capabilities,
  })
end
