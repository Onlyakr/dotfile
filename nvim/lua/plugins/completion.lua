return {
  {
    "saghen/blink.cmp",
    version = "1.*",
    dependencies = {
      "L3MON4D3/LuaSnip",
      "rafamadriz/friendly-snippets",
    },
    config = function()
      require("luasnip.loaders.from_vscode").lazy_load()

      require("blink.cmp").setup({
        sources = {
          default = { "lsp", "path", "snippets", "buffer" },
        },
        keymap = {
          preset = "none",
          ["<C-Space>"] = { "show", "hide" },
          ["<Tab>"]     = { "accept", "fallback" },
          ["<CR>"]      = { "fallback" },
          ["<C-j>"]     = { "select_next", "fallback" },
          ["<C-k>"]     = { "select_prev", "fallback" },
        },
        appearance = { nerd_font_variant = "mono" },
        completion = { menu = { auto_show = true } },
        snippets = { preset = "luasnip" },
        fuzzy = { implementation = "lua" },
      })
    end,
  },
}
