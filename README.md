# listdefined.nvim

This plugin provides functions to collect defined positions.

## Example

```lua
local paths = vim.fn.glob("lua/listdefined/test/example.lua", false, true)
local keymaps, err = require("listdefined").keymap(paths)
if err then
  return nil, err
end
print(vim.inspect(keymaps))
```

```lua
{ {
    path = "/path/to/file/lua/listdefined/test/example.lua",
    start_row = 1,
    text = 'vim.keymap.set("n", "j", "gj")'
  }, {
    path = "/path/to/file/lua/listdefined/test/example.lua",
    start_row = 5,
    text = 'vim.keymap.set("n", "k", "gk")'
  } }
```