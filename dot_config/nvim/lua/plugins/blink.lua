-- B4 completado + B6 snippets.
-- blink.cmp añade sus capabilities a vim.lsp.config("*") desde su propio
-- plugin/blink-cmp.lua, así que no hay que cablearlo aquí.

return {
  {
    "saghen/blink.cmp",
    version = "*",
    event = { "InsertEnter", "CmdlineEnter" },
    dependencies = { "rafamadriz/friendly-snippets" },
    ---@module 'blink.cmp'
    ---@type blink.cmp.Config
    opts = {
      -- igual que antes: <Tab> acepta, salta snippets y navega el menú
      keymap = { preset = "super-tab" },

      appearance = { nerd_font_variant = "mono" },

      completion = {
        accept = { auto_brackets = { enabled = true } },
        menu = { draw = { treesitter = { "lsp" } } },
        documentation = { auto_show = true, auto_show_delay_ms = 200 },
        ghost_text = { enabled = true },
      },

      sources = { default = { "lsp", "path", "snippets", "buffer" } },

      cmdline = {
        enabled = true,
        keymap = { preset = "cmdline", ["<Right>"] = false, ["<Left>"] = false },
        completion = { menu = { auto_show = function() return vim.fn.getcmdtype() == ":" end } },
      },
    },
  },
}
