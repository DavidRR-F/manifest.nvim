local Utils = require("manifest.commands.core")
local Config = require("manifest.config")
local Buffer = require("manifest.buffers")

--- @class Helm.Show
--- @field cmd fun(chart: string): string[]
--- @field usr_cmd fun(opts: vim.api.keyset.create_user_command.command_args)
--- @field complete fun(arg_lead: string, cmd_line: string, cursor_pos: integer): string[]
local _Template = {}

function _Template.cmd(chart)
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

function _Template.usr_cmd(opts)
  local release = opts.fargs[1]
  local chart = opts.fargs[2]
  local values = opts.fargs[3]
  local output = {}

  if not chart or not release then
    vim.notify("Error: release and chart name is required")
    return
  end

  if values then
    output = _Template.cmd(release, chart, values)
  else
    output = _Template.cmd(release, chart)
  end

  if vim.v.shell_error ~= 0 then
    vim.notify("Error: Could not run helm template\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end

  Buffer.window({
    output = output,
    args = opts.args,
    name = "# Helm Chart: " .. opts.fargs[2],
    filetype = "yaml",
  })
end

function _Template.complete(arg_lead, cmd_line, cursor_pos)
  local before_cursor = cmd_line:sub(1, cursor_pos)
  local args = vim.split(before_cursor, " ")
  local arg_index = #args - 1
  if arg_index == 2 then
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
  elseif arg_index == 3 then
    local files = vim.fn.glob("**/*values.y*ml", 0, 1)
    return vim.tbl_filter(function(file)
      return vim.startswith(file, arg_lead)
    end, files)
  else
    return {}
  end
end

return _Template
