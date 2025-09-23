-- lua/plugins/snacks.lua
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      sources = {
        -- Configure the explorer
        explorer = {
          exclude = {
            "*.iml",
            "*.class",  -- add more patterns as needed
            ".DS_Store",
          },
        },
        -- Configure the file picker
        files = {
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
