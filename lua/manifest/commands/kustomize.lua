local Config = require("manifest.config")
local Utils = require("manifest.commands.utils")

--- @class _Kustomize
local _Kustomize = {}

--- @param overlay string
--- @return string[]
function _Kustomize.build(overlay)
  local cmd = {
    "kustomize",
    "build",
    Config.kustomize.path .. "/overlays/" .. overlay,
  }

  if not vim.tbl_isempty(Config.kustomize.args) then
    local args = Utils.parce_options_to_flags(Config.kustomize.args)
    table.insert(cmd, args)
  end

  return vim.fn.systemlist(cmd)
end

--- @param arg_lead string
--- @return string[]
function _Kustomize.complete(arg_lead, _, _)
  local overlay_dirs = vim.fn.glob(Config.kustomize.path .. "/overlays/*", 1, 1)
  local overlays = {}
  for _, path in ipairs(overlay_dirs) do
    if vim.fn.isdirectory(path) == 1 then
      table.insert(overlays, vim.fn.fnamemodify(path, ":t"))
    end
  end
  return vim.tbl_filter(function(overlay)
    return vim.startswith(overlay, arg_lead)
  end, overlays)
end

return _Kustomize
