local Kustomize = require("manifest.commands.kustomize")
local Helm = require("manifest.commands.helm")
local Cue = require("manifest.commands.cue")
local Yq = require("manifest.commands.yq")

--- @class _Command
local _Command = {
  kustomize = Kustomize,
  helm = Helm,
  cue = Cue,
  yq = Yq
}

return _Command
