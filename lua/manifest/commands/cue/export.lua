local Utils = require("manifest.commands.core")
local Config = require("manifest.config")
local Buffer = require("manifest.buffers")

--- @class Cue.Export
--- @field cmd fun(path: string): string[]
--- @field usr_cmd fun(opts: vim.api.keyset.create_user_command.command_args)
--- @field complete fun(arg_lead: string, _, _): string[]
local _Export = {}

function _Export.cmd(path)
  local cmd = {
    "cue",
    "export",
    path,
    "--out",
    "yaml"
  }

  if not vim.tbl_isempty(Config.cue.args) then
    local args = Utils.parce_options_to_flags(Config.cue.args)
    table.insert(cmd, args)
  end

  return vim.fn.systemlist(cmd)
end

--- @param opts vim.api.keyset.create_user_command.command_args
function _Export.usr_cmd(opts)
  local output = _Export.cmd(opts.args)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error: Could not run cue export\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end

  Buffer.window({
    output = output,
    args = opts.args,
    name = "# Cue Export: " .. opts.args,
    filetype = "yaml",
  })
end

--- @param arg_lead string
--- @return string[]
function _Export.complete(arg_lead, _, _)
  return vim.fn.glob(arg_lead .. '*', 0, 1)
end

return _Export
