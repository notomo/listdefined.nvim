local M = {}

--- @param paths string[]
--- @param name string
function M.collect(paths, name)
  local handler = require("listdefined.vendor.misclib.module").find("listdefined.handler." .. name)
  local query = handler.build_query()

  return vim
    .iter(paths)
    :map(function(path)
      local absolute_path = vim.fn.fnamemodify(path, ":p")

      local items = handler.collect(absolute_path, query)
      if type(items) == "string" then
        local err = items
        error("[listdefined] " .. err)
      end

      return items
    end)
    :flatten()
    :totable()
end

return M
