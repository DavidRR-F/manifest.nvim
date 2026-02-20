local Config = require("manifest.config")
local Search = require("manifest.buffers.search")
local Result = require("manifest.buffers.result")

--- @class _Buffer
local _Buffer = {}

function _Buffer.window(opts)
  if not opts.output then
    vim.notify("No output to display", vim.log.levels.ERROR)
    return
  end

  -- sanitize
  for i, line in ipairs(opts.output) do
    opts.output[i] = line:gsub("\r", "")
  end

  table.insert(opts.output, 1, opts.name)

  local result = Result:new(Config.style.win.width, Config.style.win.height)
  result:create(opts.output)

  if Config.yq.enabled then
    local search = Search:new(" yq> ", Config.style.win.width, Config.style.win.height)
    search:create()
    local last_query = ""

    vim.fn.prompt_setcallback(search.buf, function(input)
      last_query = input
      search:update(result.buf, result.win, input, opts.output)
      vim.api.nvim_set_current_win(result.win)
    end)

    vim.keymap.set("n", "/", function()
      vim.api.nvim_set_current_win(search.win)
      vim.cmd("startinsert")
      if last_query ~= "" then
        vim.api.nvim_buf_set_lines(search.buf, 0, 1, false, { search.prompt })
        vim.api.nvim_win_set_cursor(search.win, { 1, #search.prompt })
        vim.fn.feedkeys(last_query, "n")
      end
    end, { buffer = result.buf })

    vim.keymap.set("n", "q", function()
      if vim.api.nvim_win_is_valid(result.win) then
        vim.api.nvim_win_close(result.win, true)
      end
      if vim.api.nvim_win_is_valid(search.win) then
        vim.api.nvim_win_close(search.win, true)
      end
    end, { buffer = result.buf, silent = true })

    vim.keymap.set("n", "q", function()
      if vim.api.nvim_win_is_valid(result.win) then
        vim.api.nvim_win_close(result.win, true)
      end
      if vim.api.nvim_win_is_valid(search.win) then
        vim.api.nvim_win_close(search.win, true)
      end
    end, { buffer = search.buf, silent = true })
    vim.api.nvim_create_autocmd("WinResized", {
      callback = function()
        result:resize()
        search:resize()
      end,
    })
  else
    vim.keymap.set("n", "q", function()
      if vim.api.nvim_win_is_valid(result.win) then
        vim.api.nvim_win_close(result.win, true)
      end
    end, { buffer = result.buf, silent = true })
    vim.api.nvim_create_autocmd("WinResized", {
      callback = function()
        result:resize()
      end,
    })
  end
end

return _Buffer
