--- @class Kustomize
--- @field build Kustomize.Build
local _Kustomize = {
  build = require("manifest.commands.kustomize.build")
}

return _Kustomize
