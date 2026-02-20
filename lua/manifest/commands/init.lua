--- @class Command
--- @field kustomize Kustomize
--- @field helm Helm
--- @field cue Cue
--- @field yq Yq
local _Command = {
  kustomize = require("manifest.commands.kustomize"),
  helm = require("manifest.commands.helm"),
  cue = require("manifest.commands.cue"),
  yq = require("manifest.commands.yq"),
}

return _Command
