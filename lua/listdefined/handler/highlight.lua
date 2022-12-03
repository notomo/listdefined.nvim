local M = {}

function M.build_query()
  return vim.treesitter.parse_query(
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

function M.collect(path, query)
  local str, err = require("listdefined.lib.file").read_all(path)
  if err then
    return nil, err
  end

  local root = require("listdefined.lib.treesitter").get_first_tree_root(str, "lua")
  local items = {}
  for _, match in query:iter_matches(root, str, 0, -1) do
    local captured = require("listdefined.lib.treesitter").get_captures(match, query, {
      ["highlight"] = function(tbl, tsnode)
        tbl.highlight = tsnode
      end,
    })
    local start_row = captured.highlight:start()
    table.insert(items, {
      text = vim.treesitter.get_node_text(captured.highlight, str),
      path = path,
      start_row = start_row + 1,
    })
  end
  return items
end

return M
