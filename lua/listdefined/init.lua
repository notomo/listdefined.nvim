local M = {}

--- @class ListdefinedItem
--- @field path string defined file path
--- @field start_row integer defined position start row
--- @field text string

--- Returns keymap positions defined in the files.
--- This function targets |vim.keymap.set()|.
--- @param paths string[]: file paths
--- @return ListdefinedItem[]: keymap positions |ListdefinedItem|
--- @return nil|string: error message
function M.keymap(paths)
  return require("listdefined.command").collect(paths, "keymap")
end

--- Returns autocmd positions defined in the files.
--- This function targets |vim.api.nvim_create_autocmd()|.
--- @param paths string[]: file paths
--- @return ListdefinedItem[]: autocmd positions |ListdefinedItem|
--- @return nil|string: error message
function M.autocmd(paths)
  return require("listdefined.command").collect(paths, "autocmd")
end

--- Returns autocmd group positions defined in the files.
--- This function targets |vim.api.nvim_create_augroup()|.
--- @param paths string[]: file paths
--- @return ListdefinedItem[]: autocmd group positions |ListdefinedItem|
--- @return nil|string: error message
function M.autocmd_group(paths)
  return require("listdefined.command").collect(paths, "autocmd_group")
end

--- Returns highlight positions defined in the files.
--- This function targets |vim.api.nvim_set_hl()|.
--- @param paths string[]: file paths
--- @return ListdefinedItem[]: highlight positions |ListdefinedItem|
--- @return nil|string: error message
function M.highlight(paths)
  return require("listdefined.command").collect(paths, "highlight")
end

return M
