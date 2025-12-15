return {
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    build = ":MasonUpdate",
    opts = {
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    },
    config = function(_, opts)
      require("mason").setup(opts)
    end,
  },

  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      ensure_installed = {
        -- "lua_ls",
        -- "clangd",
        -- "jdtls",
        -- "quick_lint_js",
        -- "basedpyright",
        -- "gopls",
        -- "rust_analyzer",
        -- "tinymist",
        -- "jsonls",
        -- "yaml_ls",
        -- "html",
        -- "cssls",
        -- "emmet_ls",
        -- "eslint",
        -- "tailwindcss",
        -- "bashls",
      },
      automatic_installation = true,
    },
    config = function(_, opts)
      require("mason-lspconfig").setup(opts)
    end,
  },

  {
    "neovim/nvim-lspconfig",
    dependencies = {
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
    },
    config = function()
      -- Global mappings for diagnostics
      vim.keymap.set('n', '<leader>E', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
      vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
      vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Next diagnostic" })
      vim.keymap.set('n', '<leader>q', vim.diagnostic.setloclist, { desc = "Set diagnostic loclist" })

      -- Use LspAttach autocommand to only map the following keys
      -- after the language server attaches to the current buffer
      vim.api.nvim_create_autocmd('LspAttach', {
        group = vim.api.nvim_create_augroup('UserLspConfig', {}),
        callback = function(ev)
          local opts = { buffer = ev.buf }
          local map = vim.keymap.set

          -- Navigation
          map('n', 'gD', vim.lsp.buf.declaration, { desc = "Go to declaration", buffer = ev.buf })
          map('n', 'gd', vim.lsp.buf.definition, { desc = "Go to definition", buffer = ev.buf })
          map('n', 'K', vim.lsp.buf.hover, { desc = "Hover documentation", buffer = ev.buf })
          map('n', 'gi', vim.lsp.buf.implementation, { desc = "Go to implementation", buffer = ev.buf })
          map('n', '<C-k>', vim.lsp.buf.signature_help, { desc = "Signature help", buffer = ev.buf })
          map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder", buffer = ev.buf })
          map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder", buffer = ev.buf })
          map('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
          end, { desc = "List workspace folders", buffer = ev.buf })
          map('n', '<leader>D', vim.lsp.buf.type_definition, { desc = "Type definition", buffer = ev.buf })
          map('n', '<leader>rn', vim.lsp.buf.rename, { desc = "Rename", buffer = ev.buf })
          map({ 'n', 'v' }, '<leader>ca', vim.lsp.buf.code_action, { desc = "Code action", buffer = ev.buf })
          map('n', 'gr', vim.lsp.buf.references, { desc = "Show references", buffer = ev.buf })
          map('n', '<leader>f', function()
            vim.lsp.buf.format({ async = true })
          end, { desc = "Format buffer", buffer = ev.buf })
        end,
      })

      -- LSP server capabilities
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)

      -- Setup LSP servers with common options
      require("mason-lspconfig").setup({
        handlers = {
          function(server_name)
            require("lspconfig")[server_name].setup({
              capabilities = capabilities,
              flags = {
                debounce_text_changes = 150,
              },
            })
          end,
        }
      })
    end,
  },
}
