return {
  {
    "stevearc/conform.nvim",
    config = function()
      require("conform").setup({
        formatters_by_ft = {
          javascript      = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescript      = { "prettierd" },
          typescriptreact = { "prettierd" },
          css             = { "prettierd" },
          scss            = { "prettierd" },
          html            = { "prettierd" },
          json            = { "prettierd" },
          jsonc           = { "prettierd" },
          markdown        = { "prettierd" },
          lua             = { "stylua" },
        },
        format_on_save = {
          timeout_ms = 2000,
          lsp_fallback = false,
        },
      })
    end,
  },
}
