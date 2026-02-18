local Utils = require("kustomize.buffers.utils")
--- @class _Result
local _Result = {}

function _Result:new(width, height)
  self.width = width
  self.height = height
  self.win = nil
  self.buf = nil
  return self
end

function _Result:create(output)
  local buf = vim.api.nvim_create_buf(false, true)

  vim.bo[buf].filetype = "yaml"
  vim.bo[buf].bufhidden = "wipe"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)

  local w, h, r, c = Utils.size(self.width, self.height)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = w,
    height = h - 2,
    row = r + 2,
    col = c,
    style = "minimal",
    border = "rounded",
  })

  local window = vim.wo[win]
  window.wrap = false
  window.spell = false
  window.signcolumn = "yes"
  window.statuscolumn = " "
  window.conceallevel = 3

  self.win = win
  self.buf = buf
end

function _Result:resize()
  local w, h, r, c = Utils.size(self.width, self.height)

  if vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_set_config(self.win, {
      relative = "editor",
      width = w,
      height = h - 2,
      row = r + 2,
      col = c,
      style = "minimal",
      border = "rounded",
    })
  end
end

return _Result
