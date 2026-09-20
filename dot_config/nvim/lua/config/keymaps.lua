-- Keymaps con el mismo esquema de <leader> que LazyVim, para no perder memoria
-- muscular. Los grupos están declarados en lua/plugins/ui.lua (which-key).

---@param mode string|string[]
local function map(mode, lhs, rhs, desc)
  vim.keymap.set(mode, lhs, rhs, { desc = desc, silent = true })
end

--- Picker (E1) abierto en la raíz del proyecto
---@param name string
local function root_pick(name)
  return function()
    require("snacks").picker[name]({ cwd = require("util.root").get() })
  end
end

--- Picker (E1) que no se filtra por raíz (buffers, recientes, undo, help...)
---@param name string
local function pick(name)
  return function()
    require("snacks").picker[name]()
  end
end

-- buffers
map("n", "<S-h>", "<cmd>bprevious<cr>", "Buffer anterior")
map("n", "<S-l>", "<cmd>bnext<cr>", "Buffer siguiente")
map("n", "[b", "<cmd>bprevious<cr>", "Buffer anterior")
map("n", "]b", "<cmd>bnext<cr>", "Buffer siguiente")
map("n", "<leader>bb", "<cmd>e #<cr>", "Buffer alterno")
map("n", "<leader>`", "<cmd>e #<cr>", "Buffer alterno")
map("n", "<leader>bd", function() require("snacks").bufdelete() end, "Cerrar buffer")
map("n", "<leader>bo", function() require("snacks").bufdelete.other() end, "Cerrar otros buffers")

-- archivos
map("n", "<leader><space>", root_pick("files"), "Buscar archivo")
map("n", "<leader>,", pick("buffers"), "Buffers abiertos")
map("n", "<leader>/", root_pick("grep"), "Buscar texto (raíz)")
map("n", "<leader>ff", root_pick("files"), "Buscar archivo (raíz)")
map("n", "<leader>fF", pick("files"), "Buscar archivo (cwd)")
map("n", "<leader>fg", pick("git_files"), "Archivos de git")
map("n", "<leader>fr", pick("recent"), "Recientes")
map("n", "<leader>fp", pick("projects"), "Proyectos")
map("n", "<leader>fc", function()
  require("snacks").picker.files({ cwd = vim.fn.stdpath("config") })
end, "Config de nvim")
map("n", "<leader>fn", "<cmd>enew<cr>", "Archivo nuevo")

-- explorador (E3)
map("n", "<leader>e", function()
  require("snacks").explorer({ cwd = require("util.root").get() })
end, "Explorador de archivos (raíz)")
map("n", "<leader>E", function()
  require("snacks").explorer()
end, "Explorador de archivos (cwd)")

-- buscar
map("n", "<leader>sg", root_pick("grep"), "Grep (raíz)")
map("n", "<leader>sG", pick("grep"), "Grep (cwd)")
map({ "n", "x" }, "<leader>sw", root_pick("grep_word"), "Palabra o selección (raíz)")
map("n", "<leader>sb", pick("lines"), "Líneas del buffer")
map("n", "<leader>sd", pick("diagnostics"), "Diagnósticos")
map("n", "<leader>sD", pick("diagnostics_buffer"), "Diagnósticos del buffer")
map("n", "<leader>ss", pick("lsp_symbols"), "Símbolos del buffer")
map("n", "<leader>sS", pick("lsp_workspace_symbols"), "Símbolos del proyecto")
map("n", "<leader>sk", pick("keymaps"), "Keymaps")
map("n", "<leader>sh", pick("help"), "Ayuda")
map("n", "<leader>su", pick("undo"), "Undo tree")
map("n", "<leader>sc", pick("command_history"), "Historial de comandos")
map("n", "<leader>sr", function() require("grug-far").open({ transient = true }) end, "Buscar y reemplazar (D12)")

-- git
map("n", "<leader>gg", function() require("snacks").lazygit({ cwd = require("util.root").get() }) end, "Lazygit")
map("n", "<leader>gl", function() require("snacks").picker.git_log({ cwd = require("util.root").get() }) end, "Git log")
map("n", "<leader>gb", pick("git_log_line"), "Blame de la línea")
map("n", "<leader>gf", pick("git_log_file"), "Historial del archivo")

-- código (los keymaps de LSP van por buffer en lua/plugins/lsp.lua)
map("n", "<leader>cf", function()
  require("conform").format({ async = true, lsp_format = "fallback" })
end, "Formatear buffer")
map("n", "<leader>cd", vim.diagnostic.open_float, "Diagnóstico de la línea")
map("n", "[d", function() vim.diagnostic.jump({ count = -1 }) end, "Diagnóstico anterior")
map("n", "]d", function() vim.diagnostic.jump({ count = 1 }) end, "Diagnóstico siguiente")

-- ventanas
map("n", "<leader>-", "<C-w>s", "Split abajo")
map("n", "<leader>|", "<C-w>v", "Split a la derecha")
map("n", "<leader>wd", "<C-w>c", "Cerrar ventana")

-- ui (toggles de snacks)
map("n", "<leader>uh", function() require("snacks").toggle.inlay_hints():toggle() end, "Inlay hints")
map("n", "<leader>ug", function() require("snacks").toggle.indent():toggle() end, "Guías de indentación")
map("n", "<leader>uS", function() require("snacks").toggle.scroll():toggle() end, "Scrollbar")
map("n", "<leader>ul", function() require("snacks").toggle.line_number():toggle() end, "Números de línea")
map("n", "<leader>uw", function()
  require("snacks").toggle.option("wrap", { name = "Wrap" }):toggle()
end, "Ajuste de línea")
map("n", "<leader>uL", function()
  require("snacks").toggle.option("relativenumber", { name = "Relative Number" }):toggle()
end, "Números relativos")
map("n", "<leader>us", function()
  require("snacks").toggle.option("spell", { name = "Spelling" }):toggle()
end, "Corrector ortográfico")
map("n", "<leader>uf", function()
  vim.g.autoformat = not vim.g.autoformat
  vim.notify("Autoformato al guardar: " .. (vim.g.autoformat and "sí" or "no"))
end, "Autoformato al guardar")

-- varios
map("n", "<leader>qq", "<cmd>qa<cr>", "Salir de todo")
map("n", "<leader>l", "<cmd>Lazy<cr>", "Lazy")
map("n", "<leader>ui", vim.show_pos, "Inspeccionar posición")
