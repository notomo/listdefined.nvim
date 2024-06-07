local M = {}

function M.collect(paths, name)
  vim.validate({
    paths = { paths, "table" },
  })
  local handler = require("listdefined.vendor.misclib.module").find("listdefined.handler." .. name)
  local query = handler.build_query()
  local all_items = {}
  for _, path in ipairs(paths) do
    local absolute_path = vim.fn.fnamemodify(path, ":p")
    local items = handler.collect(absolute_path, query)
    if type(items) == "string" then
      local err = items
      error("[listdefined] " .. err)
    end
    vim.list_extend(all_items, items)
  end
  return all_items
end

return M
