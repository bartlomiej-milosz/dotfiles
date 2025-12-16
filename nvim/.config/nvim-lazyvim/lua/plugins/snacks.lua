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
            "*.class",
            ".DS_Store",
            ".idea",
            ".mvn",
            ".settings",
            ".classpath",
            ".project",
          },
        },
        -- Configure the file picker
        files = {
          hidden = true,
          exclude = {
            "*.iml",
            "*.class",
            ".DS_Store",
            ".idea",
            ".mvn",
            ".settings",
            ".classpath",
            ".project",
          },
        },
      },
    },
  },
}
