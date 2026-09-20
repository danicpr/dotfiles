-- E1 picker · E3 explorador · G8 guías de indentación · G10 scrollbar
-- G3 statusline (lualine) · G6 which-key

return {
  {
    "folke/snacks.nvim",
    priority = 1000,
    lazy = false,
    opts = {
      picker = { enabled = true },
      explorer = { enabled = true },
      indent = { enabled = true },
      scroll = { enabled = true },
    },
  },

  -- G3: el tema de la statusline se construye desde la paleta de caelestia
  -- (vim.g.caelestia_palette), así que sigue los cambios de wallpaper, el modo
  -- claro/oscuro y el flag de transparencia sin tocar nada más.
  {
    "nvim-lualine/lualine.nvim",
    lazy = false,
    opts = function()
      ---@return table
      local function theme()
        local p = vim.g.caelestia_palette
        if not p then
          -- todavía sin scheme.json: fallback neutro. Nunca devolver nil, que
          -- lualine lo avisaría y caería a gruvbox (colores que no pegan nada).
          return {
            normal = {
              a = { fg = "#131313", bg = "#8ab4f8" },
              b = { fg = "#c6c6c6", bg = "#2b2b2b" },
              c = { fg = "#c6c6c6", bg = "#1e1e1e" },
            },
          }
        end

        -- fg = surface sobre el color del modo: contrasta en claro y en oscuro
        local function mode(color)
          return {
            a = { fg = p.surface, bg = color },
            b = { fg = p.onSurfaceVariant, bg = p.surfaceContainerHigh },
            c = { fg = p.onSurface, bg = p.surfaceContainer },
          }
        end

        return {
          normal = mode(p.primary),
          insert = mode(p.term2),
          visual = mode(p.term5),
          replace = mode(p.error),
          command = mode(p.term3),
          terminal = mode(p.term6),
          inactive = {
            a = { fg = p.outline, bg = p.surfaceContainerLow },
            b = { fg = p.outline, bg = p.surfaceContainerLow },
            c = { fg = p.outlineVariant, bg = p.surfaceContainerLow },
          },
        }
      end

      --- Ruta del archivo relativa a la raíz del proyecto
      ---@return string
      local function pretty_path()
        local name = vim.api.nvim_buf_get_name(0)
        if name == "" then
          return "[Sin nombre]"
        end
        return vim.fs.relpath(require("util.root").get(0), name) or vim.fn.fnamemodify(name, ":~")
      end

      return {
        options = {
          theme = theme, -- función: lualine la reevalúa en cada ColorScheme
          globalstatus = true,
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff" },
          lualine_c = { { "diagnostics" }, { pretty_path } },
          lualine_x = { "filetype" },
          lualine_y = { "progress" },
          lualine_z = { "location" },
        },
        inactive_sections = {
          lualine_c = { { pretty_path } },
          lualine_x = { "location" },
        },
      }
    end,
  },

  {
    "folke/which-key.nvim",
    lazy = false,
    opts = {
      preset = "helix",
      spec = {
        { "<leader>b", group = "buffer" },
        { "<leader>c", group = "código" },
        { "<leader>f", group = "archivo" },
        { "<leader>g", group = "git" },
        { "<leader>gh", group = "hunks" },
        { "<leader>q", group = "salir" },
        { "<leader>s", group = "buscar" },
        { "<leader>u", group = "interfaz" },
        { "<leader>w", group = "ventanas" },
        { "gs", group = "surround" },
        { "[", group = "anterior" },
        { "]", group = "siguiente" },
        { "g", group = "ir a" },
      },
    },
  },
}
