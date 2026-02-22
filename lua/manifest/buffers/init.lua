local Config = require("manifest.config")
local Manager = require("manifest.buffers.manager")

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

  local windows = Manager:new(Config.style.win.width, Config.style.win.height, Config.yq.enabled, Config.yq.view)

  windows:create(opts.output)

  if windows.search then
    local last_query = ""
    vim.fn.prompt_setcallback(windows.search.buf, function(input)
      last_query = input
      windows.search:update(windows.results.buf[#windows.results.buf], windows.results.win[#windows.results.buf], input,
        opts.output)
      vim.api.nvim_set_current_win(windows.results.win[#windows.results.buf])
    end)
    vim.keymap.set("n", "q", function() windows:close() end,
      { buffer = windows.search.buf, silent = true, noremap = true })
    --vim.keymap.set("n", "<Tab>", function() windows:focus_results() end,
    --  { buffer = windows.search.buf, silent = true, noremap = true })
    --vim.keymap.set("i", "<Tab>", function() windows:focus_results() end,
    --  { buffer = windows.search.buf, silent = true, noremap = true })
    vim.keymap.set("n", "/", function() windows:focus_search(last_query) end,
      { buffer = windows.results.buf[1], silent = true, noremap = true })
    vim.keymap.set("n", "/", function() windows:focus_search(last_query) end,
      { buffer = windows.results.buf[#windows.results.buf], silent = true, noremap = true })
  end

  vim.keymap.set("n", "q", function() windows:close() end,
    { buffer = windows.results.buf[1], silent = true, noremap = true })
  vim.keymap.set("n", "q", function() windows:close() end,
    { buffer = windows.results.buf[#windows.results.buf], silent = true, noremap = true })
  vim.keymap.set("n", "<Tab>", function() windows:focus_results() end,
    { buffer = windows.results.buf[1], silent = true, noremap = true })
  vim.keymap.set("n", "<Tab>", function() windows:focus_results() end,
    { buffer = windows.results.buf[#windows.results.buf], silent = true, noremap = true })
  vim.api.nvim_create_autocmd("WinResized", { callback = function() windows:resize() end })
end

return _Buffer
