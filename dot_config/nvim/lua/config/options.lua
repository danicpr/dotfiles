-- Opciones del editor. Espejo de los defaults de LazyVim (misma sensación que
-- antes) menos lo que ya no aplica. Cada bloque lleva su feature: I1..I6.

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- lo consulta lua/plugins/format.lua (D10)
vim.g.autoformat = true

local opt = vim.opt

-- I1: clipboard del sistema
opt.clipboard = "unnamedplus"

-- I2: indentación (I6b: python y rust a 4 espacios, ver lua/config/autocmds.lua)
opt.expandtab = true
opt.shiftwidth = 2
opt.tabstop = 2
opt.shiftround = true
opt.smartindent = true
opt.formatoptions = "jcroqlnt"

-- I3: undo persistente del mismo archivo entre cierres del editor
opt.undofile = true
opt.undolevels = 10000

-- I4: números, cursor y contexto
opt.number = true
opt.relativenumber = true
opt.signcolumn = "yes"
opt.cursorline = true
opt.scrolloff = 4
opt.sidescrolloff = 8
opt.virtualedit = "block"
opt.smoothscroll = true

-- I4: ventanas y ratón
opt.mouse = "a"
opt.confirm = true
opt.autowrite = true
opt.splitright = true
opt.splitbelow = true
opt.splitkeep = "screen"
opt.jumpoptions = "view"
opt.winminwidth = 5

-- I4: texto y búsqueda
opt.wrap = false
opt.linebreak = true
opt.list = true
opt.conceallevel = 2
opt.ignorecase = true
opt.smartcase = true
opt.inccommand = "nosplit"
opt.grepprg = "rg --vimgrep"
opt.grepformat = "%f:%l:%c:%m"

-- I4: pliegues (indent; no usamos folds de treesitter ni de LSP)
opt.foldmethod = "indent"
opt.foldlevel = 99
opt.foldtext = ""
opt.fillchars = { fold = " ", foldsep = " ", eob = " ", diff = "╱" }

-- I4: interfaz
opt.termguicolors = true
opt.completeopt = "menu,menuone,noselect"
opt.pumblend = 10
opt.pumheight = 10
opt.wildmode = "longest:full,full"
opt.timeoutlen = 300
opt.updatetime = 200
opt.spelllang = "en"
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false
opt.ruler = false
-- G3: una sola statusline global, como con LazyVim + lualine
opt.laststatus = 3
