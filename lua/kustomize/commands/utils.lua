--- @class _Utils
local _Utils = {}

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
function _Utils.parce_options_to_flags(options)
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

return _Utils
