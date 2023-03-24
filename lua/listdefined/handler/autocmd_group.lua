local M = {}

function M.build_query()
  return vim.treesitter.query.parse(
    "lua",
    [[
(
  (function_call
    name: (_) @autocmd_group._name (#match? @autocmd_group._name "^vim.api.nvim_create_augroup$")
    arguments: (arguments
      .
      (_) @autocmd_group.name
      .
      (_) @autocmd_group.opts
      .
    )
  ) @autocmd_group
)
]]
  )
end

local tslib = require("listdefined.lib.treesitter")
local response = require("listdefined.response")
function M.collect(path, query)
  local str, err = require("listdefined.lib.file").read_all(path)
  if err then
    return nil, err
  end

  local root = tslib.get_first_tree_root(str, "lua")
  local items = {}
  for _, match in query:iter_matches(root, str, 0, -1) do
    local captured = tslib.get_captures(match, query, {
      ["autocmd_group"] = function(tbl, tsnode)
        tbl.node = tsnode
      end,
    })
    local item = response.new_item(captured.node, path, str)
    table.insert(items, item)
  end
  return items
end

return M
