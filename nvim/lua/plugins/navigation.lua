return {
  {
    "ibhagwan/fzf-lua",
    config = function()
      require("fzf-lua").setup({ defaults = { color_icons = false } })
      local fzf = require("fzf-lua")
      vim.keymap.set("n", "<leader>ff", fzf.files, { desc = "Find files" })
      vim.keymap.set("n", "<leader>fg", fzf.live_grep, { desc = "Live grep" })
      vim.keymap.set("n", "<leader>fb", fzf.buffers, { desc = "Buffers" })
      vim.keymap.set("n", "<leader>fh", fzf.help_tags, { desc = "Help tags" })
      vim.keymap.set("n", "<leader>fx", fzf.diagnostics_document, { desc = "Document diagnostics" })
      vim.keymap.set("n", "<leader>fX", fzf.diagnostics_workspace, { desc = "Workspace diagnostics" })
      vim.keymap.set("n", "<leader>ft", "<Cmd>TodoFzfLua<CR>", { desc = "TODOs" })
    end,
  },
  {
    "nvim-tree/nvim-web-devicons",
    opts = { color_icons = false },
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
      -- transparent tree; separator follows the active theme's WinSeparator.
      -- mono/nightsea set their own NeoTreeNormal* on top, so use "default"
      -- to not clobber them.
      local function tree_hl()
        vim.api.nvim_set_hl(0, "NeoTreeNormalNC", { bg = "none", default = true })
        vim.api.nvim_set_hl(0, "NeoTreeNormal", { bg = "none", default = true })
        vim.api.nvim_set_hl(0, "NeoTreeEndOfBuffer", { bg = "none", default = true })
        vim.api.nvim_set_hl(0, "NeoTreeWinSeparator", { link = "WinSeparator" })
      end
      tree_hl()
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = vim.api.nvim_create_augroup("NeoTreeHl", { clear = true }),
        callback = tree_hl,
      })
    end,
  },
  {
    "ThePrimeagen/harpoon",
    branch = "harpoon2",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      local harpoon = require("harpoon")
      harpoon:setup({})
      vim.keymap.set("n", "<leader>ha", function()
        harpoon:list():add()
      end, { desc = "Harpoon add" })
      vim.keymap.set("n", "<leader>hh", function()
        harpoon.ui:toggle_quick_menu(harpoon:list())
      end, { desc = "Harpoon list" })
      -- <leader>N, not <C-N>: tmux drops Ctrl+digit unless extended-keys is on
      for i = 1, 4 do
        vim.keymap.set("n", "<leader>" .. i, function()
          harpoon:list():select(i)
        end, { desc = "Harpoon file " .. i })
      end
    end,
  },
}
