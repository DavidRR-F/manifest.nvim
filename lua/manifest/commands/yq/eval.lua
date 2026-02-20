local Buffer = require("manifest.buffers")
local Utils = require("manifest.buffers.utils")

--- @class Yq.Eval
--- @field cmd fun(file: string, query: string): string[]
--- @field usr_cmd fun(opts: vim.api.keyset.create_user_command.command_args)
--- @field complete fun(arg_lead: string, _, _): string[]
local _Eval = {}

function _Eval.cmd(file, query)
  return Utils.search(file, query)
end

function _Eval.usr_cmd(opts)
  local output = vim.fn.readfile(opts.fargs[1])
  Buffer.window({
    output = output,
    args = opts.args,
    name = "# Yq Eval: " .. opts.args,
    filetype = "yaml"
  })
end

function _Eval.complete(arg_lead, _, _)
  local files = vim.fn.glob("**/*.y*ml", 0, 1)
  return vim.tbl_filter(function(file)
    return vim.startswith(file, arg_lead)
  end, files)
end

return _Eval
