return {
  {
    -- epwalsh/obsidian.nvim is archived; this is the maintained community fork
    "obsidian-nvim/obsidian.nvim",
    version = "*",
    lazy = true,
    ft = "markdown",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      -- v3 dropped the :ObsidianFoo aliases in favour of :Obsidian <sub>
      legacy_commands = false,
      workspaces = {
        {
          name = "main",
          path = "~/Documents/obsidian",
        },
      },
      completion = { min_chars = 2 },
      link = { style = "wiki" },
      ui = { enable = true },
    },
    keys = {
      { "<leader>on", "<Cmd>Obsidian new<CR>",          desc = "New note" },
      { "<leader>oo", "<Cmd>Obsidian quick_switch<CR>", desc = "Open note" },
      { "<leader>os", "<Cmd>Obsidian search<CR>",       desc = "Search notes" },
      { "<leader>ob", "<Cmd>Obsidian backlinks<CR>",    desc = "Backlinks" },
      { "<leader>ot", "<Cmd>Obsidian template<CR>",     desc = "Insert template" },
      { "<leader>oc", "<Cmd>Obsidian toggle_checkbox<CR>", ft = "markdown", desc = "Toggle checkbox" },
    },
  },
}
