local helper = require("listdefined.test.helper")
local listdefined = helper.require("listdefined")
local assert = require("assertlib").typed(assert)

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
    assert.same(want, got)
  end)

  it("raises error if paths include invalid path", function()
    local ok, got_err = pcall(listdefined.keymap, { helper.test_data:path("not_found_path") })
    local want_err = ("%%[listdefined%%] cannot read: %s"):format(helper.test_data:path("not_found_path"))
    assert.is_false(ok)
    assert.match(want_err, got_err)
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
    assert.same(want, got)
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
    assert.same(want, got)
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
    assert.same(want, got)
  end)
end)

describe("listdefined.command()", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("returns command defined positions", function()
    local file_path = helper.test_data:create_file(
      "test1.lua",
      [=[
vim.api.nvim_create_user_command("Test", function()
  return nil
end, {})

vim.api.nvim_buf_create_user_command(0, "TestBuffer", function()
  return nil
end, {})
]=]
    )

    local paths = { file_path }
    local got = listdefined.command(paths)
    local want = {
      {
        start_row = 1,
        path = file_path,
        text = [=[vim.api.nvim_create_user_command("Test", function()
  return nil
end, {})]=],
      },
      {
        start_row = 5,
        path = file_path,
        text = [=[vim.api.nvim_buf_create_user_command(0, "TestBuffer", function()
  return nil
end, {})]=],
      },
    }
    assert.same(want, got)
  end)
end)
