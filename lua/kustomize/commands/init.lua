local Config = require("kustomize.config")

local flag_handlers = {
  --- @param key string
  --- @return string
  boolean = function(key, _)
    return "--" .. key:gsub("_", "-")
  end,
  --- @param key string
  --- @param value string
  --- @return string
  string = function(key, value)
    local flag = "--" .. key:gsub("_", "-")
    return flag .. " " .. value
  end,
  --- @param key string
  --- @param value string[]
  --- @return string
  table = function(key, value)
    local flag = "--" .. key:gsub("_", "-")
    local concat_list = table.concat(value, ",")
    return flag .. " " .. concat_list
  end
}

--- @param options table
--- @return string
local function parce_options_to_flags(options)
  if next(options) == nil then
    return ""
  end

  local flags = {}
  for key, value in pairs(options) do
    local fn = flag_handlers[type(value)]
    if fn then
      table.insert(flags, fn(key, value))
    end
  end
  return table.concat(flags, " ")
end

--- @class _Command
local _Command = {}

--- @return string[]
function _Command.build(overlay)
  return vim.fn.systemlist("kustomize build " ..
    Config.path .. "/kustomize/overlays/" .. overlay .. " " .. parce_options_to_flags(Config.commands.build))
end

function _Command.complete(_, _, _)
  local overlay_dirs = vim.fn.glob(Config.path .. "/kustomize/overlays/*", 1, 1)
  local results = {}
  for _, path in ipairs(overlay_dirs) do
    if vim.fn.isdirectory(path) == 1 then
      table.insert(results, vim.fn.fnamemodify(path, ":t"))
    end
  end
  return results
end

return _Command
