-- D5 saltos con etiquetas (flash) · D12 buscar y reemplazar (grug-far)

return {
  {
    "folke/flash.nvim",
    keys = {
      { "s", mode = { "n", "x", "o" }, function() require("flash").jump() end, desc = "Flash" },
      { "S", mode = { "n", "o", "x" }, function() require("flash").treesitter() end, desc = "Flash treesitter" },
      { "r", mode = "o", function() require("flash").remote() end, desc = "Flash remoto" },
      { "R", mode = { "o", "x" }, function() require("flash").treesitter_search() end, desc = "Búsqueda treesitter" },
      { "<c-s>", mode = "c", function() require("flash").toggle() end, desc = "Alternar flash en búsqueda" },
      {
        "<c-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = { ["<c-space>"] = "next", ["<BS>"] = "prev" },
          })
        end,
        desc = "Selección incremental",
      },
    },
    opts = {},
  },

  -- `<leader>sr` está en lua/config/keymaps.lua
  {
    "MagicDuck/grug-far.nvim",
    cmd = { "GrugFar", "GrugFarWithin" },
    opts = { headerMaxWidth = 80 },
  },
}
