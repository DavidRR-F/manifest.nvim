local Utils = require("manifest.commands.core")
local Config = require("manifest.config")
local Buffer = require("manifest.buffers")

--- @class Helm.Show
--- @field cmd fun(chart: string): string[]
--- @field usr_cmd fun(opts: vim.api.keyset.create_user_command.command_args)
--- @field complete fun(arg_lead: string, cmd_line: string, cursor_pos: integer): string[]
local _Show = {}

function _Show.cmd(chart)
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

function _Show.usr_cmd(opts)
  local output = _Show.cmd(opts.args)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error: Could not run helm template\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end

  Buffer.window({
    output = output,
    args = opts.args,
    name = "# Helm Chart: " .. opts.args,
    filetype = "yaml",
  })
end

function _Show.complete(arg_lead, _, _)
  local output = vim.fn.systemlist({ "helm", "search", "repo", "-o", "json" })

  if vim.v.shell_error ~= 0 then
    vim.notify("Error: Could not run helm search repo\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return {}
  end

  local json_str = table.concat(output, "\n")

  local ok, decoded = pcall(vim.json.decode, json_str)
  if not ok or type(decoded) ~= "table" then
    vim.notify("Failed to decode JSON from helm search")
    return {}
  end

  local charts = {}
  for _, item in ipairs(decoded) do
    if item.name then
      table.insert(charts, item.name)
    end
  end

  return vim.tbl_filter(function(chart)
    return vim.startswith(chart, arg_lead)
  end, charts)
end

return _Show
