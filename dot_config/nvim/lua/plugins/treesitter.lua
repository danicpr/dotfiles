-- C1 parsers + C2 resaltado + C3 indentado + C4 textobjects.
-- El resaltado y el indentado se activan en lua/config/autocmds.lua.
-- rama main: el plugin solo instala/actualiza parsers y aporta las queries;
-- los .so viven en ~/.local/share/nvim/site/parser (se reutilizan los ya
-- compilados, no se recompila nada).

local parsers = {
  -- lenguajes
  "lua",
  "luadoc",
  "bash",
  "fish",
  "python",
  "c",
  "rust",
  "typescript",
  "tsx",
  "javascript",
  "jsdoc",
  -- datos y docs
  "json",
  "yaml",
  "toml",
  "markdown",
  "markdown_inline",
  "query",
  "regex",
  "vim",
  "vimdoc",
  -- git (F7) y configs
  "diff",
  "gitcommit",
  "git_rebase",
  "git_config",
  "gitignore",
  "gitattributes",
  "hyprlang",
}

return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "main",
    version = false,
    lazy = false, -- los queries tienen que estar antes del primer archivo
    build = function()
      require("nvim-treesitter").update(nil, { summary = true })
    end,
    config = function()
      local TS = require("nvim-treesitter")
      TS.setup()

      local installed = TS.get_installed("parsers")
      local missing = vim.tbl_filter(function(lang)
        return not vim.tbl_contains(installed, lang)
      end, parsers)

      if #missing > 0 then
        -- fuera del arranque: compilar no debe bloquear la primera pantalla
        vim.schedule(function()
          TS.install(missing, { summary = true }):await(function() end)
        end)
      end
    end,
  },

  -- C4: solo aporta las queries `textobjects` que consume mini.ai (af, if, ac,
  -- ic, ao, io...). nvim-treesitter main ya no las incluye, así que este plugin
  -- tiene que estar en el runtimepath: lazy=false, si no mini.ai no encuentra
  -- las queries.
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    branch = "main",
    version = false,
    lazy = false,
  },
}
