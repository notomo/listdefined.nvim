local M = {}

--- Returns keymap positions defined in the files.
--- This function targets |vim.keymap.set()|.
--- @param paths string[]: file paths
--- @return table: keymap positions {path: string, start_row: number, text: string}[]
--- @return nil|string: error message
function M.keymap(paths)
  return require("listdefined.command").keymap(paths)
end

--- Returns autocmd positions defined in the files.
--- This function targets |vim.api.nvim_create_autocmd()|.
--- @param paths string[]: file paths
--- @return table: autocmd positions {path: string, start_row: number, text: string}[]
--- @return nil|string: error message
function M.autocmd(paths)
  return require("listdefined.command").autocmd(paths)
end

--- Returns highlight positions defined in the files.
--- This function targets |vim.api.nvim_set_hl()|.
--- @param paths string[]: file paths
--- @return table: highlight positions {path: string, start_row: number, text: string}[]
--- @return nil|string: error message
function M.highlight(paths)
  return require("listdefined.command").highlight(paths)
end

return M
