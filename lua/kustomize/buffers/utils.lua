local _Utils = {}

function _Utils.size(w, h)
  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * w)
  local height = math.floor(ui.height * h)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)
  return width, height, row, col
end

return _Utils
