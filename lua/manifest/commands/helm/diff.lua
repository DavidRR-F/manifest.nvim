local Config = require("manifest.config")
local Utils = require("manifest.commands.core")

--- @class Helm.Diff
--- @field usr_cmd fun(opts: vim.api.keyset.create_user_command.command_args)
local _Diff = {}

function _Diff.cmd(chart)
  local cmd = {
    "helm",
    "show",
    "values",
    chart
  }

  if not vim.tbl_isempty(Config.helm.args) then
    local args = Utils.parce_options_to_flags(Config.helm.args)
    table.insert(cmd, args)
  end

  return vim.fn.systemlist(cmd)
end

function _Diff.usr_cmd(opts)
  local output = _Diff.cmd(opts.args)
  if vim.v.shell_error ~= 0 then
    vim.notify("Error: Could not run helm template\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end
  local temp_file = vim.fn.tempname()
  local file = io.open(temp_file, "w")

  if not file then
    vim.notify("Error: Could file helm default values", vim.log.levels.ERROR)
    return
  end

  file:write(table.concat(output, "\n"))
  file:close()

  -- Open diff view
  vim.cmd("diffthis")
  vim.cmd("vert diffsplit " .. temp_file)
  vim.cmd("setfiletype yaml")
  vim.cmd("w " .. temp_file)
end

return _Diff
