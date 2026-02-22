--- @class _Config
--- @field providers string
--- @field path string
--- @field commands table
--- @field mutate fun(opts: table|nil)
local _Config = {
  yq = {
    enabled = true,
    view = "default",
  },
  kustomize = {
    enabled = true,
    path = "./kustomize",
    args = {}
  },
  helm = {
    enabled = true,
    args = {}
  },
  cue = {
    enabled = true,
    args = {}
  },
  style = {
    win = { width = 0.6, height = 0.8 }
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
