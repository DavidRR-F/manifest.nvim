--- @class Helm
--- @field template Helm.Template
---
local _Helm = {
  template = require("manifest.commands.helm.template")
}

return _Helm
