-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- Custom map function - safer for lazy.nvim conflicts
local function map(mode, lhs, rhs, opts)
    local keys = require("lazy.core.handler").handlers.keys
    ---@cast keys LazyKeysHandler

    -- Check if lazy.nvim already reserved this keybind
    if not keys.active[keys.parse({ lhs, mode = mode }).id] then
        opts = opts or {}
        opts.silent = opts.silent ~= false -- default silent = true
        if opts.remap then
            opts.remap = nil
        end
        vim.keymap.set(mode, lhs, rhs, opts)
    end
end

vim.keymap.set("n", "<F5>", function()
  vim.cmd("wall")
  Snacks.terminal("mvn clean compile exec:java", {
    interactive = false,  -- keeps terminal open after command finishes
  })
end, { desc = "Maven run" })
