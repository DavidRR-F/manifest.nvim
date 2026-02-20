--- @class _Utils
local _Utils = {}

local uv = vim.loop

local ignored_dirs = {
  "charts",
  ".git",
  "node_modules",
  "vendor",
  ".hg",
  ".svn",
  "dist",
  "build"
}

--- @param name string
--- @return boolean
local function is_ignored(name)
  for _, d in ipairs(ignored_dirs) do
    if name == d then
      return true
    end
  end
  return false
end

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

--- @param like string
--- @return string[]
function _Utils.find_files(like)
  local dir = vim.fn.getcwd()
  local results = {}

  local function scan(path)
    local handle = uv.fs_scandir(path)
    if not handle then return end

    while true do
      local name, type = uv.fs_scandir_next(handle)
      if not name then break end

      local full_path = path .. "/" .. name
      if type == "file" then
        if string.match(name, like) then
          table.insert(results, full_path)
        end
      elseif type == "directory" then
        if not is_ignored(name) then
          scan(full_path)
        end
      end
    end
  end

  scan(dir)
  return results
end

return _Utils
