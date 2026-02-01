local Snacks = require("snacks")

--- @class _Snacks
local _Snacks = {}

function _Snacks.window(opts)
  if not opts.output then
    vim.notify("No output to display", vim.log.levels.ERROR)
    return
  end

  for i, line in ipairs(opts.output) do
    opts.output[i] = line:gsub("\r", "")
  end

  table.insert(opts.output, 1, opts.name)

  Snacks.win({
    text = opts.output,
    width = 0.6,
    height = 0.8,
    border = "rounded",
    backdrop = 50,
    resize = true,
    fixbuf = true,
    ft = "yaml",
    wo = {
      spell = false,
      wrap = false,
      signcolumn = "yes",
      statuscolumn = " ",
      conceallevel = 3,
    },
    keys = {
      q = "close"
    },
  })
end

return _Snacks
