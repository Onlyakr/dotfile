return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter").setup({})

      local ensure_installed = {
        "vim", "vimdoc", "lua",
        "javascript", "typescript", "tsx",
        "html", "css", "json", "markdown", "markdown_inline",
        "bash", "python", "go", "rust", "c", "cpp",
        "vue", "svelte",
      }

      local already = require("nvim-treesitter").get_installed()
      local to_install = {}
      for _, p in ipairs(ensure_installed) do
        if not vim.tbl_contains(already, p) then
          table.insert(to_install, p)
        end
      end
      if #to_install > 0 then
        require("nvim-treesitter").install(to_install)
      end

      local group = vim.api.nvim_create_augroup("TreeSitterConfig", { clear = true })
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        callback = function(args)
          local lang = vim.treesitter.language.get_lang(args.match)
          if lang and vim.list_contains(require("nvim-treesitter").get_installed(), lang) then
            vim.treesitter.start(args.buf)
          end
        end,
      })
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    config = function()
      require("nvim-ts-autotag").setup({})
    end,
  },
}
