local M = {}

function M.new_item(node, path, str)
  local start_row = node:start()
  return {
    text = vim.treesitter.get_node_text(node, str),
    path = path,
    start_row = start_row + 1,
  }
end

return M
