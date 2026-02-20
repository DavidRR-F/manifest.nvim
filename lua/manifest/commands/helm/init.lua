--- @class Helm
--- @field template Helm.Template
--- @field show Helm.Show
--- @field diff Helm.Diff
local _Helm = {
  template = require("manifest.commands.helm.template"),
  show = require("manifest.commands.helm.show"),
  diff = require("manifest.commands.helm.diff")
}

return _Helm
