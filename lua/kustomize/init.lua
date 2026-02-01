local Config = require("kustomize.config")
local Command = require("kustomize.commands")
local Provider = require("kustomize.providers")


--- @class _Kustomize.Options.Commands.Build
--- @field flags string[]

--- @class _Kustomize.Options.Commands
--- @field build _Kustomize.Options.Commands.Build


--- @class _Kustomize.Options
--- @field provider "default" | "snacks"
--- @field commands _Kustomize.Options.Commands

--- @class _Kustomize
local _Kustomize = {}

--- @param overlay string
function _Kustomize.build(overlay)
  local output = Command.build(overlay)

  if vim.v.shell_error ~= 0 then
    vim.notify("Error: Could not run kustomize build\n" .. table.concat(output, "\n"), vim.log.levels.ERROR)
    return
  end

  Provider.window({
    output = output,
    args = overlay,
    name = "# Kustomize Build: " .. overlay,
    filetype = "yaml",
  })
end

--- @param options _Kustomize.Options?
function _Kustomize.setup(options)
  Config.mutate(options)
  Provider.set()
  vim.api.nvim_create_user_command(
    "KustomizeBuild",
    function(opts)
      _Kustomize.build(opts.args)
    end, {
      nargs = 1,
      desc = "kustomize build manifest view",
      complete = Command.complete
    }
  )
end

return _Kustomize
