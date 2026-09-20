-- D1 textobjects (mini.ai) · D2 surround · D3 pares · D4 comentarios (nativos + ts-comments)
-- G9 iconos (mini.icons)
-- Los mini.* son módulos pequeños; cargarlos al arranque evita esperas raras
-- en la primera pulsación.

-- Textobject `g` = buffer entero (copiado de MiniExtra.gen_ai_spec.buffer)
---@param ai_type string
local function ai_buffer(ai_type)
  local start_line, end_line = 1, vim.fn.line("$")
  if ai_type == "i" then
    local first_nonblank, last_nonblank = vim.fn.nextnonblank(start_line), vim.fn.prevnonblank(end_line)
    if first_nonblank == 0 or last_nonblank == 0 then
      return { from = { line = start_line, col = 1 } }
    end
    start_line, end_line = first_nonblank, last_nonblank
  end
  local to_col = math.max(vim.fn.getline(end_line):len(), 1)
  return { from = { line = start_line, col = 1 }, to = { line = end_line, col = to_col } }
end

return {
  -- D1
  {
    "nvim-mini/mini.ai",
    lazy = false,
    opts = function()
      local gen = require("mini.ai").gen_spec
      return {
        n_lines = 500,
        custom_textobjects = {
          o = gen.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }),
          f = gen.treesitter({ a = "@function.outer", i = "@function.inner" }),
          c = gen.treesitter({ a = "@class.outer", i = "@class.inner" }),
          t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- etiquetas
          d = { "%f[%d]%d+" }, -- dígitos
          e = {
            -- palabra según uso de mayúsculas
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
          },
          g = ai_buffer, -- buffer
          u = gen.function_call(),
          U = gen.function_call({ name_pattern = "[%w_]" }),
        },
      }
    end,
    config = function(_, opts)
      require("mini.ai").setup(opts)

      local labels = {
        { "o", "bloque" },
        { "f", "función" },
        { "c", "clase" },
        { "t", "etiqueta" },
        { "d", "dígitos" },
        { "e", "palabra (case)" },
        { "g", "buffer" },
        { "u", "llamada" },
        { "U", "llamada sin punto" },
      }
      local keys = {}
      for _, obj in ipairs(labels) do
        keys[#keys + 1] = { "i" .. obj[1], desc = obj[2], mode = { "o", "x" } }
        keys[#keys + 1] = { "a" .. obj[1], desc = obj[2], mode = { "o", "x" } }
      end
      require("which-key").add(keys)
    end,
  },

  -- D2
  {
    "nvim-mini/mini.surround",
    lazy = false,
    opts = {
      -- mismas teclas que tenías en el extra de LazyVim
      mappings = {
        add = "gsa",
        delete = "gsd",
        find = "gsf",
        find_left = "gsF",
        highlight = "gsh",
        replace = "gsr",
        update_n_lines = "gsn",
      },
    },
  },

  -- D3
  {
    "nvim-mini/mini.pairs",
    lazy = false,
    opts = {
      modes = { insert = true, command = true, terminal = false },
      skip_next = [=[[%w%%%'%[%"%.%`%$]]=],
      skip_ts = { "string" },
      skip_unbalanced = true,
      markdown = true,
    },
    config = function(_, opts)
      local pairs = require("mini.pairs")
      pairs.setup(opts)

      -- Portado de LazyVim: no auto-cerrar cuando molesta
      -- (dentro de strings, junto a un cierre, cierres desbalanceados...).
      local open = pairs.open
      pairs.open = function(pair, neigh_pattern)
        if vim.fn.getcmdline() ~= "" then
          return open(pair, neigh_pattern)
        end
        local o, c = pair:sub(1, 1), pair:sub(2, 2)
        local line = vim.api.nvim_get_current_line()
        local cursor = vim.api.nvim_win_get_cursor(0)
        local next_char = line:sub(cursor[2] + 1, cursor[2] + 1)
        local before = line:sub(1, cursor[2])

        if opts.markdown and o == "`" and vim.bo.filetype == "markdown" and before:match("^%s*``") then
          return "`\n```" .. vim.api.nvim_replace_termcodes("<up>", true, true, true)
        end
        if opts.skip_next and next_char ~= "" and next_char:match(opts.skip_next) then
          return o
        end
        if opts.skip_ts and #opts.skip_ts > 0 then
          local ok, captures = pcall(vim.treesitter.get_captures_at_pos, 0, cursor[1] - 1, math.max(cursor[2] - 1, 0))
          for _, capture in ipairs(ok and captures or {}) do
            if vim.tbl_contains(opts.skip_ts, capture.capture) then
              return o
            end
          end
        end
        if opts.skip_unbalanced and next_char == c and c ~= o then
          local _, count_open = line:gsub(vim.pesc(o), "")
          local _, count_close = line:gsub(vim.pesc(c), "")
          if count_close > count_open then
            return o
          end
        end
        return open(pair, neigh_pattern)
      end
    end,
  },

  -- D4: gc/gcc ya son nativos en Neovim 0.10+ y usan `commentstring`;
  -- ts-comments lo parchea para lenguajes embebidos, así que mini.comment sobra.
  { "folke/ts-comments.nvim", lazy = false, opts = {} },

  -- G9
  {
    "nvim-mini/mini.icons",
    lazy = false,
    opts = {},
    config = function(_, opts)
      local icons = require("mini.icons")
      icons.setup(opts)
      -- compatibilidad con plugins que aún esperan nvim-web-devicons
      icons.mock_nvim_web_devicons()
    end,
  },
}
