local aug = vim.api.nvim_create_augroup("user", { clear = true })

--- ¿Hay parser instalado y query disponible para este lenguaje?
---@param lang string
---@param query string
---@return boolean
local function ts_ready(lang, query)
  if not pcall(vim.treesitter.language.add, lang) then
    return false
  end
  return #vim.treesitter.query.get_files(lang, query) > 0
end

-- C2 resaltado + C3 indentado con treesitter.
-- Neovim 0.12 no los activa solo: hay que arrancarlos por buffer.
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  callback = function(ev)
    -- en archivos enormes treesitter cuesta más de lo que aporta
    local path = vim.api.nvim_buf_get_name(ev.buf)
    if path ~= "" and vim.fn.getfsize(path) > 1024 * 1024 then
      return
    end

    local lang = vim.treesitter.language.get_lang(ev.match) or ev.match

    if ts_ready(lang, "highlights") then
      pcall(vim.treesitter.start, ev.buf)
    end

    -- indentado: no pisar el que trae el runtime (python, c, ...)
    if vim.bo[ev.buf].indentexpr == "" and ts_ready(lang, "indents") then
      vim.bo[ev.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})

-- I6b: Python (PEP 8) y Rust (rustfmt) usan 4 espacios, no 2.
vim.api.nvim_create_autocmd("FileType", {
  group = aug,
  pattern = { "python", "rust" },
  callback = function()
    vim.bo.shiftwidth = 4
    vim.bo.tabstop = 4
  end,
})

-- feedback al copiar (nativo)
vim.api.nvim_create_autocmd("TextYankPost", {
  group = aug,
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})
