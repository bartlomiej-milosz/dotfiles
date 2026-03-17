-- Neovim 0.11 native LSP config for lua_ls
return {
  settings = {
    Lua = {
      workspace = {
        checkThirdParty = false,
      },
      telemetry = { enable = false },
    },
  },
}
