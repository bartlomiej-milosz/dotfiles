return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  opts = {
    -- Enabled modules
    bigfile      = { enabled = true }, -- disable heavy features on big files
    dashboard    = { enabled = true }, -- startup dashboard
    explorer     = { enabled = true }, -- file explorer (sidebar)
    indent       = { enabled = true }, -- indent guides
    input        = { enabled = true }, -- better vim.ui.input
    notifier     = { enabled = true, timeout = 3000 },
    picker       = { enabled = true }, -- fuzzy finder (files, grep, buffers...)
    quickfile    = { enabled = true }, -- fast render when opening a file from CLI
    scope        = { enabled = true }, -- scope detection for indent guides
    scroll       = { enabled = true }, -- smooth scrolling
    statuscolumn = { enabled = true },
    words        = { enabled = true }, -- highlight & jump LSP references
  },
  keys = {
    -- Picker
    { "<leader><space>", function() Snacks.picker.smart() end,            desc = "Smart Find Files" },
    { "<leader>ff",      function() Snacks.picker.files() end,            desc = "Find Files" },
    { "<leader>fg",      function() Snacks.picker.grep() end,             desc = "Grep" },
    { "<leader>fb",      function() Snacks.picker.buffers() end,          desc = "Buffers" },
    { "<leader>fh",      function() Snacks.picker.help() end,             desc = "Help Pages" },
    { "<leader>fr",      function() Snacks.picker.recent() end,           desc = "Recent Files" },
    { "<leader>fc",      function() Snacks.picker.command_history() end,  desc = "Command History" },
    { "<leader>fd",      function() Snacks.picker.diagnostics() end,      desc = "Diagnostics" },
    { "<leader>fs",      function() Snacks.picker.lsp_symbols() end,      desc = "LSP Symbols" },
    { "<leader>fw",      function() Snacks.picker.grep_word() end,        desc = "Grep Word",            mode = { "n", "x" } },

    -- Explorer
    { "<leader>e",       function() Snacks.explorer() end,                desc = "File Explorer" },

    -- Buffers
    { "<leader>bd",      function() Snacks.bufdelete() end,               desc = "Delete Buffer" },

    -- Git
    { "<leader>gg",      function() Snacks.lazygit() end,                 desc = "Lazygit" },
    { "<leader>gB",      function() Snacks.gitbrowse() end,               desc = "Git Browse",           mode = { "n", "v" } },
    { "<leader>gl",      function() Snacks.git.blame_line() end,          desc = "Git Blame Line" },

    --  Notifications
    { "<leader>n",       function() Snacks.picker.notifications() end,    desc = "Notification History" },
    { "<leader>un",      function() Snacks.notifier.hide() end,           desc = "Dismiss Notifications" },

    -- Terminal
    { "<C-/>",           function() Snacks.terminal() end,                desc = "Toggle Terminal" },

    -- LSP References
    { "]]",              function() Snacks.words.jump(vim.v.count1) end,  desc = "Next Reference",       mode = { "n", "t" } },
    { "[[",              function() Snacks.words.jump(-vim.v.count1) end, desc = "Prev Reference",       mode = { "n", "t" } },

    -- Misc
    { "<leader>cR",      function() Snacks.rename.rename_file() end,      desc = "Rename File" },
    { "<leader>.",       function() Snacks.scratch() end,                 desc = "Toggle Scratch Buffer" },
    { "<leader>z",       function() Snacks.zen() end,                     desc = "Zen Mode" },
  },
}
