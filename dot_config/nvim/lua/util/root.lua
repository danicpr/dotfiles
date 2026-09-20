local M = {}

--- Raíz del proyecto, para pickers y lazygit.
--- Orden: workspace del LSP > directorio con .git hacia arriba > cwd.
---@param buf? integer
---@return string
function M.get(buf)
  buf = buf or 0

  for _, client in ipairs(vim.lsp.get_clients({ bufnr = buf })) do
    local dir = client.root_dir
    if not dir and client.workspace_folders then
      local first = client.workspace_folders[1]
      dir = first and first.name or nil
    end
    if dir and dir ~= "" then
      return vim.fs.normalize(dir)
    end
  end

  return vim.fs.normalize(vim.fs.root(buf, { ".git", ".hg" }) or vim.uv.cwd())
end

return M
