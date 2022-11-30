local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)

function helper.before_each()
  helper.test_data = require("listdefined.vendor.misclib.test.data_dir").setup(helper.root)
end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
  helper.test_data:teardown()
end

local asserts = require("vusted.assert").asserts
local asserters = require(plugin_name .. ".vendor.assertlib").list()
require(plugin_name .. ".vendor.misclib.test.assert").register(asserts.create, asserters)

return helper
