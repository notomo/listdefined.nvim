local M = {}

function M.build_query()
  return vim.treesitter.parse_query(
    "lua",
    [[
(
  (function_call
    name: (_) @autocmd.name (#match? @autocmd.name "^vim.api.nvim_create_autocmd$")
    arguments: (arguments
      .
      (_) @autocmd.events
      .
      (_) @autocmd.opts
      .
    )
  ) @autocmd
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
      ["autocmd"] = function(tbl, tsnode)
        tbl.autocmd = tsnode
      end,
    })
    local start_row = captured.autocmd:start()
    table.insert(items, {
      text = vim.treesitter.get_node_text(captured.autocmd, str),
      path = path,
      row = start_row + 1,
    })
  end
  return items
end

return M