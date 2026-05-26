return {
  {
    "catppuccin/nvim",
    name = "catppuccin",
    priority = 1000,
    config = function()
      require("catppuccin").setup({
        flavour = "mocha",
        transparent_background = true,
      })
      vim.cmd.colorscheme("catppuccin")
      local groups = {
        "Normal", "NormalNC", "EndOfBuffer", "NormalFloat", "FloatBorder",
        "SignColumn", "StatusLine", "StatusLineNC", "TabLine", "TabLineFill",
        "TabLineSel", "ColorColumn",
      }
      for _, g in ipairs(groups) do
        vim.api.nvim_set_hl(0, g, { bg = "none" })
      end
    end,
  },
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons", "catppuccin/nvim" },
    config = function()
      require("lualine").setup({
        options = {
          theme = "catppuccin",
          globalstatus = true,
          component_separators = { left = "│", right = "│" },
          section_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", "diagnostics" },
          lualine_c = { { "filename", path = 1 } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
      })
    end,
  },
  {
    "andweeb/presence.nvim",
    config = function()
      require("presence").setup({
        auto_update = true,
        neovim_image_text = "Neovim",
        main_image = "neovim",
        client_id = "793271441293967371",
        log_level = nil,
        debounce_timeout = 10,
        enable_line_number = false,
        blacklist = {},
        buttons = true,
        show_time = true,
      })
    end,
  },
}
