local helper = require("listdefined.test.helper")
local listdefined = helper.require("listdefined")

describe("listdefined.keymap()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns keymap defined positions", function()
    helper.test_data:create_file(
      "test1.lua",
      [=[
vim.keymap.set("n", "j", "gj")

vim.keymap.set(
  [[n]],
  [[k]],
  [[gk]]
)
]=]
    )
    helper.test_data:create_file(
      "test2.lua",
      [=[

vim.keymap.set("n", "j", "gj")
]=]
    )

    local paths = {
      helper.test_data.full_path .. "test1.lua",
      helper.test_data.full_path .. "test2.lua",
    }
    local got = listdefined.keymap(paths)
    local want = {
      {
        row = 1,
        path = helper.test_data.full_path .. "test1.lua",
        text = [=[vim.keymap.set("n", "j", "gj")]=],
      },
      {
        row = 3,
        path = helper.test_data.full_path .. "test1.lua",
        text = [=[
vim.keymap.set(
  [[n]],
  [[k]],
  [[gk]]
)]=],
      },
      {
        row = 2,
        path = helper.test_data.full_path .. "test2.lua",
        text = [=[vim.keymap.set("n", "j", "gj")]=],
      },
    }
    assert.is_same(want, got)
  end)

  it("returns error if paths include invalid path", function()
    local _, got_err = listdefined.keymap({ helper.test_data.full_path .. "not_found_path" })
    local want_err = ("cannot read: %s"):format(helper.test_data.full_path .. "not_found_path")
    assert.equal(want_err, got_err)
  end)
end)
