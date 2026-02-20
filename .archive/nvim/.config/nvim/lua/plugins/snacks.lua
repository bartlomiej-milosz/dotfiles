return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  ---@type snacks.Config
  opts = {
    bigfile   = { enabled = true },
    dashboard = { enabled = true },
    dim       = { enabled = true },
    explorer  = { enabled = true },
    indent    = { enabled = true },
    input     = { enabled = true },
    notifier  = { enabled = true, timeout = 3000 },
    picker    = { enabled = true },
    scroll    = { enabled = true },
    zen       = {
      toggles = {
        dim = true,
        git_signs = false,
        diagnostics = false,
        inlay_hints = false,
      },
      show = {
        statusline = false,
        tabline = false,
      },
      win = { style = "zen" },
    },
  },
  keys = {
    -- Picker
    { "<leader><space>", function() Snacks.picker.smart() end,         desc = "Smart Find Files" },
    { "<leader>ff",      function() Snacks.picker.files() end,         desc = "Find Files" },
    { "<leader>fg",      function() Snacks.picker.grep() end,          desc = "Grep" },
    { "<leader>fb",      function() Snacks.picker.buffers() end,       desc = "Buffers" },
    { "<leader>fh",      function() Snacks.picker.help() end,          desc = "Help Pages" },
    { "<leader>fr",      function() Snacks.picker.recent() end,        desc = "Recent Files" },
    { "<leader>fd",      function() Snacks.picker.diagnostics() end,   desc = "Diagnostics" },
    { "<leader>fs",      function() Snacks.picker.lsp_symbols() end,   desc = "LSP Symbols" },
    { "<leader>fw",      function() Snacks.picker.grep_word() end,     desc = "Grep Word",            mode = { "n", "x" } },

    -- Explorer
    { "<leader>e",       function() Snacks.explorer() end,             desc = "File Explorer" },

    -- Notifications
    { "<leader>n",       function() Snacks.picker.notifications() end, desc = "Notification History" },
    { "<leader>un",      function() Snacks.notifier.hide() end,        desc = "Dismiss Notifications" },

    -- Terminal
    { "<C-/>",           function() Snacks.terminal() end,             desc = "Toggle Terminal" },

    -- Zen
    { "<leader>z",       function() Snacks.zen() end,                  desc = "Zen Mode" },
    { "<leader>Z",       function() Snacks.zen.zoom() end,             desc = "Zoom (fullscreen)" },
  },
}
