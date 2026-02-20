local Config = require("manifest.config")
local Utils = require("manifest.commands.core")
local Buffer = require("manifest.buffers")

--- @class Kustomize.Build
--- @field cmd fun(overlay: string): string[]
--- @field usr_cmd fun(opts: vim.api.keyset.create_user_command.command_args)
--- @field complete fun(arg_lead: string, _, _): string[]
local _Build = {}

function _Build.cmd(overlay)
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

function _Build.usr_cmd(opts)
  local output = _Build.cmd(opts.args)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error: Could not run kustomize build\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end

  Buffer.window({
    output = output,
    args = opts.args,
    name = "# Kustomize Build: " .. opts.args,
    filetype = "yaml",
  })
end

function _Build.complete(arg_lead, _, _)
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

return _Build
