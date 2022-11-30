local paths = vim.fn.glob("lua/listdefined/test/example.lua", false, true)
local keymaps, err = require("listdefined").keymap(paths)
if err then
  return nil, err
end
print(vim.inspect(keymaps))
