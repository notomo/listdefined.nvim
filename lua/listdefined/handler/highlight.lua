local M = {}

function M.build_query()
  return vim.treesitter.query.parse(
    "lua",
    [[
(
  (function_call
    name: (_) @highlight.call (#match? @highlight.call "^vim.api.nvim_set_hl$")
    arguments: (arguments
      .
      (_) @highlight.ns
      .
      (_) @highlight.name
      .
      (_) @highlight.val
      .
    )
  ) @highlight
)
]]
  )
end

local tslib = require("listdefined.lib.treesitter")
local response = require("listdefined.response")
function M.collect(path, query)
  local str = require("listdefined.lib.file").read_all(path)
  if type(str) == "table" then
    local err = str
    return err.message
  end

  local root = tslib.get_first_tree_root(str, "lua")
  local items = {}
  for _, match in query:iter_matches(root, str, 0, -1) do
    local captured = tslib.get_captures(match, query, {
      ["highlight"] = function(tbl, tsnode)
        tbl.node = tsnode
      end,
    })
    local item = response.new_item(captured.node, path, str)
    table.insert(items, item)
  end
  return items
end

return M
