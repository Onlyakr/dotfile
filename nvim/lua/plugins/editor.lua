return {
  {
    "echasnovski/mini.nvim",
    config = function()
      require("mini.ai").setup({})
      require("mini.comment").setup({})
      require("mini.surround").setup({})
      require("mini.pairs").setup({})
      require("mini.cursorword").setup({})
      require("mini.indentscope").setup({})
      require("mini.trailspace").setup({})
      require("mini.bufremove").setup({})
      require("mini.icons").setup({})
    end,
  },
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    config = function()
      local wk = require("which-key")
      wk.setup({})
      wk.add({
        { "<leader>b",  group = "Buffer" },
        { "<leader>f",  group = "Find" },
        { "<leader>g",  group = "Go to (LSP)" },
        { "<leader>h",  group = "Hunk / Harpoon" },
        { "<leader>o",  group = "Obsidian" },
        { "<leader>s",  group = "Split" },
        { "<leader>x",  group = "Diagnostics" },
        { "<leader>c",  desc  = "Clear search" },
        { "<leader>e",  desc  = "File explorer" },
        { "<leader>t",  desc  = "Terminal" },
        { "<leader>w",  desc  = "Save" },
        { "<leader>q",  desc  = "Quit" },
        { "<leader>td", desc  = "Toggle diagnostics" },
        { "<leader>pa", desc  = "Copy file path" },
        { "<leader>ca", desc  = "Code action" },
        { "<leader>rn", desc  = "Rename symbol" },
        { "<leader>oi", desc  = "Organize imports" },
        { "<leader>gg", desc  = "Lazygit" },
      })
    end,
  },
  {
    "lewis6991/gitsigns.nvim",
    config = function()
      require("gitsigns").setup({
        signs = {
          add          = { text = "▐" },
          change       = { text = "▐" },
          delete       = { text = "▐" },
          topdelete    = { text = "◦" },
          changedelete = { text = "●" },
          untracked    = { text = "○" },
        },
        signcolumn = true,
        current_line_blame = false,
      })
      local gs = require("gitsigns")
      vim.keymap.set("n", "]h", gs.next_hunk, { desc = "Next hunk" })
      vim.keymap.set("n", "[h", gs.prev_hunk, { desc = "Prev hunk" })
      vim.keymap.set("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      vim.keymap.set("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      vim.keymap.set("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      vim.keymap.set("n", "<leader>hb", function() gs.blame_line({ full = true }) end, { desc = "Blame line" })
      vim.keymap.set("n", "<leader>hB", gs.toggle_current_line_blame, { desc = "Toggle blame" })
      vim.keymap.set("n", "<leader>hd", gs.diffthis, { desc = "Diff this" })
    end,
  },
  {
    "folke/todo-comments.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("todo-comments").setup({})
    end,
  },
}
