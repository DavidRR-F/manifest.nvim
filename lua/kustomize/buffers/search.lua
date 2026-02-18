local Utils = require("kustomize.buffers.utils")
local Command = require("kustomize.commands")
--- @class _Search
local _Search = {}

function _Search:new(prompt, width, height)
  self.prompt = prompt
  self.width = width
  self.height = height
  self.win = nil
  self.buf = nil
  return self
end

function _Search:create()
  local buf = vim.api.nvim_create_buf(false, true)
  vim.bo[buf].buftype = "prompt"
  vim.bo[buf].bufhidden = "wipe"

  local w, _, r, c = Utils.size(self.width, self.height)

  local win = vim.api.nvim_open_win(buf, false, {
    relative = "editor",
    width = w,
    height = 1,
    row = r - 1,
    col = c,
    style = "minimal",
    border = "rounded",
  })

  self.win = win
  self.buf = buf

  vim.fn.prompt_setprompt(buf, self.prompt)
  vim.api.nvim_set_current_win(win)
  vim.api.nvim_win_set_cursor(win, { 1, #self.prompt })
  vim.cmd("startinsert")
end

function _Search:update(buf, query, output)
  if not query or query == "" then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, output)
    return
  end

  -- Write YAML to temp file
  local tmpfile = vim.fn.tempname() .. ".yaml"
  vim.fn.writefile(output, tmpfile)
  local result = Command.yq.query(query, tmpfile)
  local exit_code = vim.v.shell_error

  vim.fn.delete(tmpfile)

  if exit_code ~= 0 then
    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
      "yq error:",
      unpack(result),
    })
    return
  end

  if vim.tbl_isempty(result) then
    result = { "No matches" }
  end

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, result)
end

function _Search:resize()
  local w, _, r, c = Utils.size(self.width, self.height)

  if vim.api.nvim_win_is_valid(self.win) then
    vim.api.nvim_win_set_config(self.win, {
      relative = "editor",
      width = w,
      row = r - 1,
      col = c,
      style = "minimal",
      border = "rounded",
    })
  end
end

return _Search
