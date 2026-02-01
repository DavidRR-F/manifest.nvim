local Config = require("kustomize.config")

local providers = {
  default = "kustomize.providers.default",
  snacks = "kustomize.providers.snacks",
}

local active

--- @class _Provider
local _Provider = {}

function _Provider.set()
  if active then
    return active
  end

  local module = providers[Config.provider]

  if not module then
    vim.notify("Unable to import required provider " .. Config.provider, vim.log.levels.ERROR)
    return
  end

  active = require(module)
end

function _Provider.window(opts)
  active.window(opts)
end

return _Provider
