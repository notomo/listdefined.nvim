local tslib = require("listdefined.lib.treesitter")
local response = require("listdefined.response")

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

local function search_one(path, query_text)
  local str = require("listdefined.lib.file").read_all(path)
  if type(str) == "table" then
    local err = str
    return err.message
  end

  local filetype = vim.filetype.match({
    filename = path,
  }) or ""
  local language = vim.treesitter.language.get_lang(filetype)
  if not language then
    return ("no language: filetype=%s"):format(filetype)
  end

  local query = vim.treesitter.query.parse(language, query_text)

  local root = tslib.get_first_tree_root(str, language)

  return vim
    .iter(query:iter_matches(root, str, 0, -1))
    :map(function(_, match)
      local captured = tslib.get_captures(match, query, {
        target = function(tbl, tsnode)
          tbl.node = tsnode
        end,
      })
      return response.new_item(captured.node, path, str)
    end)
    :totable()
end

function M.search(paths, query_text)
  return vim
    .iter(paths)
    :map(function(path)
      local items = search_one(path, query_text)
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
