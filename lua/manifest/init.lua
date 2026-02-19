local Config = require("manifest.config")
local Command = require("manifest.commands")

--- @class _Manifest
local _Manifest = {}

function _Manifest.setup(options)
  Config.mutate(options)

  if Config.kustomize.enabled then
    vim.api.nvim_create_user_command(
      "KustomizeBuild",
      Command.kustomize.user_command,
      {
        nargs = 1,
        desc = "kustomize build manifest view",
        complete = Command.kustomize.complete
      }
    )
  end

  if Config.helm.enabled then
    vim.api.nvim_create_user_command(
      "HelmTemplate",
      Command.helm.user_command,
      {
        nargs = "*",
        desc = "helm template manifest view",
        complete = Command.helm.complete
      }
    )
  end

  if Config.cue.enabled then
    vim.api.nvim_create_user_command(
      "CueExport",
      Command.cue.user_command,
      {
        nargs = 1,
        desc = "cue export manifest view",
        complete = Command.cue.complete
      }
    )
  end
end

return _Manifest
