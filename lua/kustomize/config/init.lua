--- @class _Config
--- @field providers string
--- @field path string
--- @field commands table
--- @field mutate fun(opts: table|nil)
local _Config = {
  provider = "default",
  path = "./deploy",
  commands = {
    build = {
      enable_helm = true,
    },
  }
}

function _Config.mutate(opts)
  if not opts then return end
  local new_config = vim.tbl_deep_extend("force", _Config, opts)
  for k, v in pairs(new_config) do
    _Config[k] = v
  end
end

return _Config
