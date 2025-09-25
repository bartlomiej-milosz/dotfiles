-- lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- Configure the explorer
        explorer = {
          hidden = true,
          exclude = {
            "*.iml",
            "*.class",  -- add more patterns as needed
            ".DS_Store",
          },
        },
        -- Configure the file picker
        files = {
          hidden = true,
          exclude = {
            "*.iml",
            "*.class",
            ".DS_Store",
          },
        },
      },
    },
  },
}
