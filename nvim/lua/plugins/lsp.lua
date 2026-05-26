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
          local ok, fzf = pcall(require, "fzf-lua")
          if not ok then return end

          vim.keymap.set("n", "<leader>gd", function() fzf.lsp_definitions({ jump_to_single_result = true }) end, vim.tbl_extend("force", opts, { desc = "Go to definition" }))
          vim.keymap.set("n", "<leader>gD", vim.lsp.buf.definition, vim.tbl_extend("force", opts, { desc = "Definition (native)" }))
          vim.keymap.set("n", "<leader>gS", function() vim.cmd("vsplit") vim.lsp.buf.definition() end, vim.tbl_extend("force", opts, { desc = "Definition in split" }))
          vim.keymap.set("n", "<leader>gr", fzf.lsp_references, vim.tbl_extend("force", opts, { desc = "References" }))
          vim.keymap.set("n", "<leader>gi", fzf.lsp_implementations, vim.tbl_extend("force", opts, { desc = "Implementations" }))
          vim.keymap.set("n", "<leader>gt", fzf.lsp_typedefs, vim.tbl_extend("force", opts, { desc = "Type definitions" }))
          vim.keymap.set("n", "<leader>gs", fzf.lsp_document_symbols, vim.tbl_extend("force", opts, { desc = "Document symbols" }))
          vim.keymap.set("n", "<leader>gw", fzf.lsp_workspace_symbols, vim.tbl_extend("force", opts, { desc = "Workspace symbols" }))
          vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, vim.tbl_extend("force", opts, { desc = "Code action" }))
          vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, vim.tbl_extend("force", opts, { desc = "Rename" }))
          vim.keymap.set("n", "K", vim.lsp.buf.hover, vim.tbl_extend("force", opts, { desc = "Hover docs" }))
          vim.keymap.set("n", "<leader>d", function() vim.diagnostic.open_float({ scope = "cursor" }) end, vim.tbl_extend("force", opts, { desc = "Cursor diagnostics" }))
          vim.keymap.set("n", "<leader>D", function() vim.diagnostic.open_float({ scope = "line" }) end, vim.tbl_extend("force", opts, { desc = "Line diagnostics" }))
          vim.keymap.set("n", "<leader>nd", function() vim.diagnostic.jump({ count = 1 }) end, vim.tbl_extend("force", opts, { desc = "Next diagnostic" }))
          vim.keymap.set("n", "<leader>pd", function() vim.diagnostic.jump({ count = -1 }) end, vim.tbl_extend("force", opts, { desc = "Prev diagnostic" }))

          if client:supports_method("textDocument/codeAction", bufnr) then
            vim.keymap.set("n", "<leader>oi", function()
              vim.lsp.buf.code_action({
                context = { only = { "source.organizeImports" }, diagnostics = {} },
                apply = true,
                bufnr = bufnr,
              })
            end, vim.tbl_extend("force", opts, { desc = "Organize imports" }))
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
          source = "always",
          header = "",
          prefix = "",
          focusable = false,
          style = "minimal",
        },
      })

      do
        local orig = vim.lsp.util.open_floating_preview
        function vim.lsp.util.open_floating_preview(contents, syntax, opts, ...)
          opts = opts or {}
          opts.border = opts.border or "rounded"
          return orig(contents, syntax, opts, ...)
        end
      end

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
