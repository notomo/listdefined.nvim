local M = {}

local collect = function(handler, paths)
  vim.validate({
    paths = { paths, "table" },
  })

  local query = handler.build_query()
  local all_items = {}
  for _, path in ipairs(paths) do
    local absolute_path = vim.fn.fnamemodify(path, ":p")
    local items, err = handler.collect(absolute_path, query)
    if err then
      return nil, err
    end
    vim.list_extend(all_items, items)
  end
  return all_items, nil
end

function M.keymap(paths)
  local handler = require("listdefined.handler.keymap")
  return collect(handler, paths)
end

function M.autocmd(paths)
  local handler = require("listdefined.handler.autocmd")
  return collect(handler, paths)
end

return M
