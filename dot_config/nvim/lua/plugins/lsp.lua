-- B1 cliente LSP nativo + B2 mason + B3 auto-setup + B7 inlay hints
-- B10 diagnósticos + B11 lazydev + B12 servidores: lua, bash, rust, ts, python

-- B12: rust-analyzer NO va por mason: lo sirve rustup, así que su versión
-- siempre coincide con la del toolchain que compilas.
local servers = { "lua_ls", "bashls", "rust_analyzer", "vtsls", "basedpyright" }

return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = { "mason-org/mason.nvim", "mason-org/mason-lspconfig.nvim" },
    config = function()
      -- B10: presentación de diagnósticos
      vim.diagnostic.config({
        virtual_text = { spacing = 4, source = "if_many", prefix = "●" },
        severity_sort = true,
        float = { border = "rounded", source = true },
      })

      -- Ajustes por servidor (el resto lo aporta nvim-lspconfig)
      vim.lsp.config("lua_ls", {
        settings = {
          Lua = {
            workspace = { checkThirdParty = false },
            completion = { callSnippet = "Replace" },
            telemetry = { enable = false },
          },
        },
      })

      vim.lsp.config("rust_analyzer", {
        settings = {
          ["rust-analyzer"] = {
            check = { command = "clippy" },
            cargo = { allFeatures = true },
          },
        },
      })

      vim.lsp.config("basedpyright", {
        settings = {
          basedpyright = {
            analysis = {
              autoSearchPaths = true,
              useLibraryCodeForTypes = true,
            },
          },
        },
      })

      vim.lsp.config("vtsls", {
        settings = {
          typescript = {
            updateImportsOnFileMove = { enabled = "always" },
            inlayHints = { parameterNames = { enabled = "literals" } },
          },
          javascript = { updateImportsOnFileMove = { enabled = "always" } },
        },
      })

      -- B1: arrancar los servidores. mason-lspconfig tiene automatic_enable
      -- desactivado a propósito (ver lua/plugins/... más abajo) para que la
      -- lista de servidores sea esta y no "lo que mason tenga instalado".
      vim.lsp.enable(servers)

      vim.api.nvim_create_autocmd("LspAttach", {
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          if not client then
            return
          end

          local function map(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = ev.buf, desc = desc, silent = true })
          end

          map("n", "gd", vim.lsp.buf.definition, "Ir a definición")
          map("n", "gD", vim.lsp.buf.declaration, "Ir a declaración")
          map("n", "gr", function() require("snacks").picker.lsp_references() end, "Referencias")
          map("n", "gi", vim.lsp.buf.implementation, "Implementaciones")
          map("n", "gy", vim.lsp.buf.type_definition, "Definición de tipo")
          map("n", "K", vim.lsp.buf.hover, "Documentación")
          map("n", "<C-k>", vim.lsp.buf.signature_help, "Ayuda de firma")
          map("n", "<leader>ca", vim.lsp.buf.code_action, "Acción de código")
          map("n", "<leader>cr", vim.lsp.buf.rename, "Renombrar")

          -- B7: inlay hints donde el servidor los soporte
          if client:supports_method("textDocument/inlayHint") then
            vim.lsp.inlay_hint.enable(true, { bufnr = ev.buf })
          end
        end,
      })
    end,
  },

  { "mason-org/mason.nvim", cmd = "Mason", opts = {} },

  {
    "mason-org/mason-lspconfig.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      -- B3: nombres de servidor LSP (mason-lspconfig los traduce al paquete de
      -- mason: lua_ls -> lua-language-server, bashls -> bash-language-server).
      -- Solo lo que no viene del sistema: rust va por rustup, no por mason.
      ensure_installed = { "lua_ls", "bashls", "basedpyright", "vtsls" },
      automatic_enable = false,
    },
  },

  -- B11: tipos de vim.* y de las APIs de los plugins al editar Lua
  {
    "folke/lazydev.nvim",
    ft = "lua",
    opts = {
      library = {
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },

  -- progreso de indexado de rust-analyzer / vtsls (en vez de noice)
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {},
  },
}
