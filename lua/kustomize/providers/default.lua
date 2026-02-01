--- @class _Default
local _Default = {}

function _Default.window(opts)
  if not opts.output then
    vim.notify("No output to display", vim.log.levels.ERROR)
    return
  end

  for i, line in ipairs(opts.output) do
    opts.output[i] = line:gsub("\r", "")
  end

  table.insert(opts.output, 1, opts.name)

  local buf = vim.api.nvim_create_buf(false, true)

  local b = vim.bo[buf]
  b.filetype = "yaml"
  b.bufhidden = "wipe"

  vim.api.nvim_buf_set_lines(buf, 0, -1, false, opts.output)

  local ui = vim.api.nvim_list_uis()[1]
  local width = math.floor(ui.width * 0.6)
  local height = math.floor(ui.height * 0.8)
  local row = math.floor((ui.height - height) / 2)
  local col = math.floor((ui.width - width) / 2)

  local win = vim.api.nvim_open_win(buf, true, {
    relative = "editor",
    width = width,
    height = height,
    row = row,
    col = col,
    style = "minimal",
    border = "rounded",
  })

  local w = vim.wo[win]
  w.wrap = false
  w.spell = false
  w.signcolumn = "yes"
  w.statuscolumn = " "
  w.conceallevel = 3

  vim.keymap.set("n", "q", function()
    if vim.api.nvim_win_is_valid(win) then
      vim.api.nvim_win_close(win, true)
    end
  end, { buffer = buf, noremap = true, silent = true })
end

return _Default
