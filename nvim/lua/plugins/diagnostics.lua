return {
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("trouble").setup({})
      vim.keymap.set("n", "<leader>xx", "<Cmd>Trouble diagnostics toggle filter.buf=0<CR>", { desc = "Document diagnostics" })
      vim.keymap.set("n", "<leader>xw", "<Cmd>Trouble diagnostics toggle<CR>",               { desc = "Workspace diagnostics" })
      vim.keymap.set("n", "<leader>xq", "<Cmd>Trouble qflist toggle<CR>",                    { desc = "Quickfix list" })
      vim.keymap.set("n", "<leader>xt", "<Cmd>Trouble todo toggle<CR>",                      { desc = "TODOs list" })
    end,
  },
}
