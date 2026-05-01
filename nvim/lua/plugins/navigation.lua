return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({})
      local fzf = require("fzf-lua")
      vim.keymap.set("n", "<leader>ff", fzf.files,                { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep,            { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers,              { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags,            { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fx", fzf.diagnostics_document, { desc = "Document diagnostics" })
      vim.keymap.set("n", "<leader>fX", fzf.diagnostics_workspace,{ desc = "Workspace diagnostics" })
      vim.keymap.set("n", "<leader>ft", "<Cmd>TodoFzfLua<CR>",    { desc = "TODOs" })
    end,
  },
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    config = function()
      require("neo-tree").setup({
        window = { width = 35 },
        filesystem = {
          filtered_items = {
            hide_dotfiles = false,
            hide_gitignored = false,
          },
        },
      })
      vim.keymap.set("n", "<leader>e", "<Cmd>Neotree toggle<CR>", { silent = true, desc = "Toggle file explorer" })
      vim.api.nvim_set_hl(0, "NeoTreeNormalNC",     { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeNormal",       { bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { fg = "#2a2a2a", bg = "none" })
      vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer",  { bg = "none" })
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})
      vim.keymap.set("n", "<leader>ha", function() harpoon:list():add() end,
        { desc = "Harpoon add" })
      vim.keymap.set("n", "<leader>hh", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end,
        { desc = "Harpoon list" })
      vim.keymap.set("n", "<C-1>", function() harpoon:list():select(1) end, { desc = "Harpoon file 1" })
      vim.keymap.set("n", "<C-2>", function() harpoon:list():select(2) end, { desc = "Harpoon file 2" })
      vim.keymap.set("n", "<C-3>", function() harpoon:list():select(3) end, { desc = "Harpoon file 3" })
      vim.keymap.set("n", "<C-4>", function() harpoon:list():select(4) end, { desc = "Harpoon file 4" })
    end,
  },
}
