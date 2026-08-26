return {
  {
    "neovim/nvim-lspconfig",
    dependencies = {
      { "mason-org/mason.nvim", opts = {} },
      "mason-org/mason-lspconfig.nvim",
      "saghen/blink.cmp",
    },
    config = function()
      require("mason-lspconfig").setup({
        ensure_installed = {
          "ts_ls",
          "eslint",
          "cssls",
          "html",
          "jsonls",
          "lua_ls",
          "gopls",
        },
        automatic_installation = true,
      })

      vim.lsp.config("*", {
        capabilities = require("blink.cmp").get_lsp_capabilities(),
      })

      local augroup = vim.api.nvim_create_augroup("LspConfig", { clear = true })

      vim.api.nvim_create_autocmd("LspAttach", {
        group = augroup,
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then return end
          local bufnr = ev.buf
          local opts = { noremap = true, silent = true, buffer = bufnr }
          local function map(lhs, rhs, desc)
            vim.keymap.set("n", lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
          end

          map("<leader>gD", vim.lsp.buf.definition, "Definition (native)")
          map("<leader>gS", function() vim.cmd("vsplit") vim.lsp.buf.definition() end, "Definition in split")
          map("<leader>ca", vim.lsp.buf.code_action, "Code action")
          map("<leader>rn", vim.lsp.buf.rename, "Rename")
          map("K", function() vim.lsp.buf.hover({ border = "rounded" }) end, "Hover docs")

          -- picker-backed maps only: keep the rest working if fzf-lua is missing
          local ok, fzf = pcall(require, "fzf-lua")
          if ok then
            map("<leader>gd", function() fzf.lsp_definitions({ jump_to_single_result = true }) end, "Go to definition")
            map("<leader>gr", fzf.lsp_references, "References")
            map("<leader>gi", fzf.lsp_implementations, "Implementations")
            map("<leader>gt", fzf.lsp_typedefs, "Type definitions")
            map("<leader>gs", fzf.lsp_document_symbols, "Document symbols")
            map("<leader>gw", fzf.lsp_workspace_symbols, "Workspace symbols")
          else
            map("<leader>gd", vim.lsp.buf.definition, "Go to definition")
            map("<leader>gr", vim.lsp.buf.references, "References")
            map("<leader>gi", vim.lsp.buf.implementation, "Implementations")
            map("<leader>gt", vim.lsp.buf.type_definition, "Type definitions")
            map("<leader>gs", vim.lsp.buf.document_symbol, "Document symbols")
            map("<leader>gw", vim.lsp.buf.workspace_symbol, "Workspace symbols")
          end
          map("<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, "Cursor diagnostics")
          map("<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, "Line diagnostics")
          map("<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, "Next diagnostic")
          map("<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, "Prev diagnostic")

          if client:supports_method("textDocument/codeAction", bufnr) then
            map("<leader>oi", function()
              vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" }, diagnostics = {} },
                apply = true,
                bufnr = bufnr,
              })
            end, "Organize imports")
          end
        end,
      })

      vim.diagnostic.config({
        virtual_text = { prefix = "●", spacing = 4 },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = " ",
            [vim.diagnostic.severity.WARN]  = " ",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
          },
        },
        underline = true,
        update_in_insert = false,
        severity_sort = true,
        float = {
          border = "rounded",
          source = true,
          header = "",
          prefix = "",
          focusable = false,
          style = "minimal",
        },
      })

      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            diagnostics = { globals = { "vim" } },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.enable({ "ts_ls", "eslint", "cssls", "html", "jsonls", "lua_ls", "gopls" })
    end,
  },
}
