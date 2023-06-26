local helper = require("listdefined.test.helper")
local listdefined = helper.require("listdefined")

describe("listdefined.keymap()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns keymap defined positions", function()
    local file_path1 = helper.test_data:create_file(
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
    local file_path2 = helper.test_data:create_file(
      "test2.lua",
      [=[

vim.keymap.set("n", "j", "gj")
]=]
    )

    local paths = {
      file_path1,
      file_path2,
    }
    local got = listdefined.keymap(paths)
    local want = {
      {
        start_row = 1,
        path = file_path1,
        text = [=[vim.keymap.set("n", "j", "gj")]=],
      },
      {
        start_row = 3,
        path = file_path1,
        text = [=[
vim.keymap.set(
  [[n]],
  [[k]],
  [[gk]]
)]=],
      },
      {
        start_row = 2,
        path = file_path2,
        text = [=[vim.keymap.set("n", "j", "gj")]=],
      },
    }
    assert.is_same(want, got)
  end)

  it("returns error if paths include invalid path", function()
    local _, got_err = listdefined.keymap({ helper.test_data:path("not_found_path") })
    local want_err = ("cannot read: %s"):format(helper.test_data:path("not_found_path"))
    assert.equal(want_err, got_err)
  end)
end)

describe("listdefined.autocmd()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns autocmd defined positions", function()
    local file_path = helper.test_data:create_file(
      "test1.lua",
      [=[
vim.api.nvim_create_autocmd({ "SwapExists" }, {
  pattern = {"*"},
  callback = function()
    print("swap")
  end
})
]=]
    )

    local paths = { file_path }
    local got = listdefined.autocmd(paths)
    local want = {
      {
        start_row = 1,
        path = file_path,
        text = [=[
vim.api.nvim_create_autocmd({ "SwapExists" }, {
  pattern = {"*"},
  callback = function()
    print("swap")
  end
})]=],
      },
    }
    assert.is_same(want, got)
  end)
end)

describe("listdefined.autocmd_group()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns autocmd group defined positions", function()
    local file_path = helper.test_data:create_file(
      "test1.lua",
      [=[
vim.api.nvim_create_augroup("test", {})
]=]
    )

    local paths = { file_path }
    local got = listdefined.autocmd_group(paths)
    local want = {
      {
        start_row = 1,
        path = file_path,
        text = [=[
vim.api.nvim_create_augroup("test", {})]=],
      },
    }
    assert.is_same(want, got)
  end)
end)

describe("listdefined.highlight()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns highlight defined positions", function()
    local file_path = helper.test_data:create_file(
      "test1.lua",
      [=[
vim.api.nvim_set_hl(0, "helpExample", { bold = true })
]=]
    )

    local paths = { file_path }
    local got = listdefined.highlight(paths)
    local want = {
      {
        start_row = 1,
        path = file_path,
        text = [=[vim.api.nvim_set_hl(0, "helpExample", { bold = true })]=],
      },
    }
    assert.is_same(want, got)
  end)
end)
