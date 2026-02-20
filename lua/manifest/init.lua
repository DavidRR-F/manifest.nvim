local Config = require("manifest.config")
local Command = require("manifest.commands")

--- @class _Manifest
local _Manifest = {}

function _Manifest.setup(options)
  Config.mutate(options)

  if Config.yq.enabled then
    vim.api.nvim_create_user_command(
      "YqEval",
      Command.yq.eval.usr_cmd,
      {
        nargs = 1,
        desc = "yaml file manifest view",
        complete = Command.yq.eval.complete
      }
    )
  end

  if Config.kustomize.enabled then
    vim.api.nvim_create_user_command(
      "KustomizeBuild",
      Command.kustomize.build.usr_cmd,
      {
        nargs = 1,
        desc = "kustomize build manifest view",
        complete = Command.kustomize.build.complete
      }
    )
  end

  if Config.helm.enabled then
    vim.api.nvim_create_user_command(
      "HelmTemplate",
      Command.helm.template.usr_cmd,
      {
        nargs = "*",
        desc = "helm template manifest view",
        complete = Command.helm.template.complete
      }
    )
    vim.api.nvim_create_user_command(
      "HelmShowValues",
      Command.helm.show.usr_cmd,
      {
        nargs = 1,
        desc = "helm template manifest view",
        complete = Command.helm.show.complete
      }
    )
    vim.api.nvim_create_user_command(
      "HelmDiffValues",
      Command.helm.diff.usr_cmd,
      {
        nargs = 1,
        desc = "helm values diff view",
        complete = Command.helm.show.complete
      }
    )
  end

  if Config.cue.enabled then
    vim.api.nvim_create_user_command(
      "CueExport",
      Command.cue.export.usr_cmd,
      {
        nargs = 1,
        desc = "cue export manifest view",
        complete = Command.cue.export.complete
      }
    )
  end
end

return _Manifest
