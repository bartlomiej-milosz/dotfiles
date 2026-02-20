return {
  "nvim-mini/mini.icons",
  lazy = true,
  opts = {
    style = "glyph", -- "glyph" (nerd font) or "ascii"
  },
  init = function()
    -- Mock nvim-web-devicons so all plugins that depend on it just work
    package.preload["nvim-web-devicons"] = function()
      require("mini.icons").mock_nvim_web_devicons()
      return package.loaded["nvim-web-devicons"]
    end
  end,
}
