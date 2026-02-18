local _Yq = {}

--- @return string[]
function _Yq.query(query, file)
  return vim.fn.systemlist({ "yq", query, file })
end

return _Yq
