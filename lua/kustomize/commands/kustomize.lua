local Config = require("kustomize.config")
local Utils = require("kustomize.commands.utils")

--- @class _Kustomize
local _Kustomize = {}

--- @param overlay string
--- @return string[]
function _Kustomize.build(overlay)
  return vim.fn.systemlist("kustomize build " ..
    Config.kustomize.path .. "/overlays/" .. overlay .. " " .. Utils.parce_options_to_flags(Config.kustomize.args))
end

function _Kustomize.complete(_, _, _)
  local overlay_dirs = vim.fn.glob(Config.kustomize.path .. "/overlays/*", 1, 1)
  local results = {}
  for _, path in ipairs(overlay_dirs) do
    if vim.fn.isdirectory(path) == 1 then
      table.insert(results, vim.fn.fnamemodify(path, ":t"))
    end
  end
  return results
end

return _Kustomize
