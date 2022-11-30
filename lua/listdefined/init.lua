local M = {}

--- Returns keymap positions defined in the files.
--- @param paths string[]: file paths
--- @return table: keymap positions {path: string, row: number, text: string}[]
--- @return nil|string: error message
function M.keymap(paths)
  return require("listdefined.command").keymap(paths)
end

return M
