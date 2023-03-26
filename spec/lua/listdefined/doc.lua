local util = require("genvdoc.util")
local plugin_name = vim.env.PLUGIN_NAME
local full_plugin_name = plugin_name .. ".nvim"

local example_path = ("./spec/lua/%s/example.lua"):format(plugin_name)
local example_output = vim.api.nvim_exec2("luafile " .. example_path, { output = true }).output
example_output = example_output:gsub(vim.fn.fnamemodify(".", ":p"), "/path/to/file/")

require("genvdoc").generate(full_plugin_name, {
  source = { patterns = { ("lua/%s/init.lua"):format(plugin_name) } },
  chapters = {
    {
      name = function(group)
        return "Lua module: " .. group
      end,
      group = function(node)
        if node.declaration == nil or node.declaration.type ~= "function" then
          return nil
        end
        return node.declaration.module
      end,
    },
    {
      name = "STRUCTURE",
      group = function(node)
        if node.declaration == nil or node.declaration.type ~= "class" then
          return nil
        end
        return "STRUCTURE"
      end,
    },
    {
      name = "EXAMPLES",
      body = function()
        return util.help_code_block_from_file(example_path) .. "\n\n" .. util.help_code_block(example_output)
      end,
    },
  },
})

local gen_readme = function()
  local f = io.open(example_path, "r")
  local exmaple = f:read("*a")
  f:close()

  local content = ([[
# %s

This plugin provides functions to collect defined positions.

## Example

```lua
%s```

```lua
%s
```]]):format(full_plugin_name, exmaple, example_output)

  local readme = io.open("README.md", "w")
  readme:write(content)
  readme:close()
end
gen_readme()
