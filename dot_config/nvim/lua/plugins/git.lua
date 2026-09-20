-- F1 gitsigns · F2 lazygit (el keymap <leader>gg está en lua/config/keymaps.lua)
-- F7 resaltado de git va por parsers, en lua/plugins/treesitter.lua

return {
  {
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPre", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▔" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
        untracked = { text = "▎" },
      },
      signs_staged = {
        add = { text = "▎" },
        change = { text = "▎" },
        delete = { text = "▔" },
        topdelete = { text = "▔" },
        changedelete = { text = "▎" },
      },
      on_attach = function(bufnr)
        local gs = package.loaded.gitsigns

        local function map(mode, lhs, rhs, desc)
          vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc, silent = true })
        end

        map("n", "]h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "]c", bang = true })
          else
            gs.nav_hunk("next")
          end
        end, "Hunk siguiente")
        map("n", "[h", function()
          if vim.wo.diff then
            vim.cmd.normal({ "[c", bang = true })
          else
            gs.nav_hunk("prev")
          end
        end, "Hunk anterior")

        map({ "n", "x" }, "<leader>ghs", ":Gitsigns stage_hunk<cr>", "Preparar hunk")
        map({ "n", "x" }, "<leader>ghr", ":Gitsigns reset_hunk<cr>", "Descartar hunk")
        map("n", "<leader>ghS", gs.stage_buffer, "Preparar buffer")
        map("n", "<leader>ghu", gs.undo_stage_hunk, "Deshacer stage")
        map("n", "<leader>ghR", gs.reset_buffer, "Descartar buffer")
        map("n", "<leader>ghp", gs.preview_hunk_inline, "Ver hunk")
        map("n", "<leader>ghb", function() gs.blame_line({ full = true }) end, "Blame de la línea")
        map("n", "<leader>ghd", gs.diffthis, "Diff con el índice")
        map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff con HEAD~")
        map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<cr>", "Seleccionar hunk")
      end,
    },
  },
}
