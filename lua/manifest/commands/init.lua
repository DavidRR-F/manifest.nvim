local Config = require("manifest.config")
local Kustomize = require("manifest.commands.kustomize")
local Helm = require("manifest.commands.helm")
local Yq = require("manifest.commands.yq")

--- @class _Command
local _Command = {
  kustomize = Kustomize,
  helm = Helm,
  yq = Yq
}

return _Command
