-- I5: filetypes de dotfiles.
-- Comprobado con vim.filetype.match(): Neovim ya detecta por su cuenta
--   ~/.config/hypr/**/*.conf -> hyprlang
--   ~/.config/fuzzel/fuzzel.ini -> dosini
--   **/config.fish -> fish
--   ~/.gitconfig -> gitconfig
-- así que aquí solo va lo que falta de verdad.
vim.filetype.add({
  pattern = {
    [".*/%.env$"] = "sh",
    [".*/%.env%.[%w_.-]+"] = "sh",
  },
})
