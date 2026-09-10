return {
  {
    "stevearc/conform.nvim",
    config = function()
      local obsidian_vault = vim.fn.expand("~/Documents/obsidian")
      require("conform").setup({
        formatters_by_ft = {
          javascript = { "prettierd" },
          javascriptreact = { "prettierd" },
          typescript = { "prettierd" },
          typescriptreact = { "prettierd" },
          css = { "prettierd" },
          scss = { "prettierd" },
          html = { "prettierd" },
          json = { "prettierd" },
          jsonc = { "prettierd" },
          markdown = { "prettierd" },
          lua = { "stylua" },
          go = { "goimports", "gofmt" },
        },
        format_on_save = function(bufnr)
          -- prettier rewrites list markers and escapes in markdown; keep it
          -- away from the Obsidian vault so notes only change when edited.
          local name = vim.api.nvim_buf_get_name(bufnr)
          if vim.startswith(name, obsidian_vault) then
            return nil
          end
          return { timeout_ms = 2000, lsp_format = "never" }
        end,
      })
    end,
  },
}
