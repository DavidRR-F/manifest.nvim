local Utils = require("manifest.buffers.utils")
--- @class _Result
local _Result = {}

--- @param width integer
--- @param height integer
--- @param view string?
function _Result:new(width, height, view)
  self.width = width
  self.height = height
  self.view = view or "default"
  self.win = nil
  self.buf = nil
  return self
end

function _Result:create(output)
  local buf = nil
  local win = nil
  local w, h, r, c = Utils.size(self.width, self.height)
  if self.view == "default" then
    buf = { vim.api.nvim_create_buf(false, true) }

    vim.bo[buf[1]].filetype = "yaml"
    vim.bo[buf[1]].bufhidden = "wipe"

    vim.api.nvim_buf_set_lines(buf[1], 0, -1, false, output)

    win = {
      vim.api.nvim_open_win(buf[1], true, {
        relative = "editor",
        width = w,
        height = h - 2,
        row = r + 2,
        col = c,
        style = "minimal",
        border = "rounded",
      })
    }

    local window = vim.wo[win[1]]
    window.wrap = false
    window.spell = false
    window.signcolumn = "yes"
    window.statuscolumn = " "
    window.conceallevel = 3
  else
    buf = { vim.api.nvim_create_buf(false, true), vim.api.nvim_create_buf(false, true) }
    win = {
      vim.api.nvim_open_win(buf[1], true, {
        relative = "editor",
        width = math.floor(w / 2),
        height = h - 2,
        row = r + 2,
        col = c,
        style = "minimal",
        border = "rounded",
      }),
      vim.api.nvim_open_win(buf[2], true, {
        relative = "editor",
        width = math.floor(w / 2),
        height = h - 2,
        row = r + 2,
        col = math.floor(c * 2.5),
        style = "minimal",
        border = "rounded",
      }),
    }
    vim.bo[buf[1]].filetype = "yaml"
    vim.bo[buf[1]].bufhidden = "wipe"
    vim.bo[buf[2]].filetype = "yaml"
    vim.bo[buf[2]].bufhidden = "wipe"
    vim.api.nvim_buf_set_lines(buf[1], 0, -1, false, output)

    vim.wo[win[1]].wrap = false
    vim.wo[win[1]].spell = false
    vim.wo[win[1]].signcolumn = "yes"
    vim.wo[win[1]].statuscolumn = " "
    vim.wo[win[1]].conceallevel = 3
    vim.wo[win[2]].wrap = false
    vim.wo[win[2]].spell = false
    vim.wo[win[2]].signcolumn = "yes"
    vim.wo[win[2]].statuscolumn = " "
    vim.wo[win[2]].conceallevel = 3
  end

  self.win = win
  self.buf = buf
end

function _Result:resize()
  local w, h, r, c = Utils.size(self.width, self.height)

  if self.view == "default" then
    if vim.api.nvim_win_is_valid(self.win[1]) then
      vim.api.nvim_win_set_config(self.win[1], {
        relative = "editor",
        width = w,
        height = h - 2,
        row = r + 2,
        col = c,
        style = "minimal",
        border = "rounded",
      })
    end
  else
    if vim.api.nvim_win_is_valid(self.win[1]) then
      vim.api.nvim_win_set_config(self.win[1], {
        relative = "editor",
        width = math.floor(w / 2),
        height = h - 2,
        row = r + 2,
        col = c / 2,
        style = "minimal",
        border = "rounded",
      })
    end
    if vim.api.nvim_win_is_valid(self.win[2]) then
      vim.api.nvim_win_set_config(self.win[2], {
        relative = "editor",
        width = math.floor(w / 2),
        height = h - 2,
        row = r + 2,
        col = math.floor(c * 2.5),
        style = "minimal",
        border = "rounded",
      })
    end
  end
end

return _Result
