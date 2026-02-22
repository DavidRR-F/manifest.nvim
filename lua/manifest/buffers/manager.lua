local Results = require("manifest.buffers.result")
local Search = require("manifest.buffers.search")
--- @class _Buffer.WindowManager
local _WindowManager = {}

function _WindowManager:new(width, height, yq, view)
  if yq then
    self.results = Results:new(width, height, view)
    self.search = Search:new(" yq> ", width, height)
  else
    self.results = Results:new(width, height, "default")
    self.search = nil
  end
  return self
end

function _WindowManager:create(output)
  self.results:create(output)
  if self.search then
    self.search:create()
  end
end

--- @param last_query string
function _WindowManager:focus_search(last_query)
  vim.api.nvim_set_current_win(self.search.win)
  vim.cmd("startinsert")
  if last_query ~= "" then
    vim.api.nvim_buf_set_lines(self.search.buf, 0, 1, false, { self.search.prompt })
    vim.api.nvim_win_set_cursor(self.search.win, { 1, #self.search.prompt })
    vim.fn.feedkeys(last_query, "n")
  end
end

function _WindowManager:focus_results()
  local current = vim.api.nvim_get_current_win()
  if current == self.results.win[1] then
    vim.api.nvim_set_current_win(self.results.win[#self.results.win])
  else
    vim.api.nvim_set_current_win(self.results.win[1])
  end
end

function _WindowManager:close()
  if vim.api.nvim_win_is_valid(self.results.win[1]) then
    vim.api.nvim_win_close(self.results.win[1], true)
  end
  if vim.api.nvim_win_is_valid(self.results.win[#self.results.win]) then
    vim.api.nvim_win_close(self.results.win[#self.results.win], true)
  end
  if vim.api.nvim_win_is_valid(self.search.win) then
    vim.api.nvim_win_close(self.search.win, true)
  end
end

function _WindowManager:resize()
  if self.search then
    self.search:resize()
  end
  self.results:resize()
end

return _WindowManager
