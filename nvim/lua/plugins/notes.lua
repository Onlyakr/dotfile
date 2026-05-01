return {
  {
    "epwalsh/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("obsidian").setup({
        workspaces = {
          {
            name = "main",
            path = "~/Documents/obsidian",
          },
        },
        completion = {
          nvim_cmp = false,
          min_chars = 2,
        },
        mappings = {
          ["<leader>oc"] = {
            action = function()
              return require("obsidian").util.toggle_checkbox()
            end,
            opts = { buffer = true, desc = "Toggle checkbox" },
          },
        },
        preferred_link_style = "wiki",
        ui = { enable = true },
      })

      vim.keymap.set("n", "<leader>on", "<Cmd>ObsidianNew<CR>",         { desc = "New note" })
      vim.keymap.set("n", "<leader>oo", "<Cmd>ObsidianQuickSwitch<CR>", { desc = "Open note" })
      vim.keymap.set("n", "<leader>os", "<Cmd>ObsidianSearch<CR>",      { desc = "Search notes" })
      vim.keymap.set("n", "<leader>ob", "<Cmd>ObsidianBacklinks<CR>",   { desc = "Backlinks" })
      vim.keymap.set("n", "<leader>ot", "<Cmd>ObsidianTemplate<CR>",    { desc = "Insert template" })
    end,
  },
}
