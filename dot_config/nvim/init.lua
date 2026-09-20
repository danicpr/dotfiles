-- Config propia para Neovim 0.12, sin LazyVim.
--   lua/config/*  -> opciones, filetypes, keymaps, autocmds
--   lua/plugins/* -> specs de lazy.nvim
-- Debe ir antes de lazy.nvim: registra el autocmd de treesitter y los keymaps.
require("config.options")
require("config.filetypes")
require("config.keymaps")
require("config.autocmds")

-- A1: bootstrap de lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
  local repo = "https://github.com/folke/lazy.nvim.git"
  local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", repo, lazypath })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "No se pudo clonar lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
      { "\nPulsa una tecla para salir...", "MoreMsg" },
    }, true, {})
    vim.fn.getchar()
    os.exit(1)
  end
end
vim.opt.rtp:prepend(lazypath)

-- Primera pasada del colorscheme: deja la paleta lista antes de que los plugins
-- se configuren (lualine la lee para construirse, ver lua/plugins/ui.lua).
pcall(vim.cmd.colorscheme, "caelestia")

require("lazy").setup({
  spec = { { import = "plugins" } },
  install = { colorscheme = { "caelestia", "habamax" } },
  -- A4: revisar actualizaciones, sin avisar
  checker = { enabled = true, notify = false },
  performance = {
    rtp = {
      disabled_plugins = { "gzip", "tarPlugin", "tohtml", "tutor", "zipPlugin" },
    },
  },
})

-- G1: cuando lazy.setup() termina, todos los plugins eager ya cargaron, así que
-- aplicar aquí el theme evita que sus highlight groups pisen los del colorscheme.
pcall(vim.cmd.colorscheme, "caelestia")
