local Config = require("manifest.config")
local Command = require("manifest.commands")
local Buffer = require("manifest.buffers")


--- @class _Manifest.Options.Commands.Build
--- @field flags string[]

--- @class _Manifest.Options.Commands
--- @field build _Manifest.Options.Commands.Build


--- @class _Manifest.Options
--- @field provider "default" | "snacks"
--- @field commands _Manifest.Options.Commands

--- @class _Manifest
local _Manifest = {}

--- @param options _Manifest.Options?
function _Manifest.setup(options)
  Config.mutate(options)
  vim.api.nvim_create_user_command(
    "KustomizeBuild",
    function(opts)
      local output = Command.kustomize.build(opts.args)

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
    end, {
      nargs = 1,
      desc = "kustomize build manifest view",
      complete = Command.kustomize.complete
    }
  )
  vim.api.nvim_create_user_command(
    "HelmTemplate",
    function(opts)
      local release = opts.fargs[1]
      local chart = opts.fargs[2]
      local values = opts.fargs[3]
      local output = {}

      if not chart then
        vim.notify("Error: chart name is required")
        return
      end

      if values then
        output = Command.helm.template(release, chart, values)
      else
        output = Command.helm.template(release, chart)
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
    end, {
      nargs = "*",
      desc = "helm template manifest view",
      complete = Command.helm.complete
    }
  )
end

return _Manifest
