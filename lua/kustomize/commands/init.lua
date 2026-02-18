local Config = require("kustomize.config")
local Kustomize = require("kustomize.commands.kustomize")
local Helm = require("kustomize.commands.helm")
local Yq = require("kustomize.commands.yq")

--- @class _Command
local _Command = {
  kustomize = Kustomize,
  helm = Helm,
  yq = Yq
}

return _Command
