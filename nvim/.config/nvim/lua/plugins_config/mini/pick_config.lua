return {
    mappings = {
        move_down = "<C-j>",
        move_up = "<C-k>",
    },
    vim.keymap.set("n", "<leader>ff", "<cmd>Pick files<cr>", { desc = "[F]ind [F]iles" }),
    vim.keymap.set("n", "<leader>fb", "<cmd>Pick buffers<cr>", { desc = "[F]ind [B]uffers" }),
    vim.keymap.set("n", "<leader>fh", "<cmd>Pick help<cr>", { desc = "[F]ind [H]elp" }),
}
