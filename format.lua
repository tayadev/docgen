local RESET = "\027[0m"
local BOLD = "\027[1m"
local UNDERLINE = "\027[4m"

-- fg colors
local BLACK   = "\027[30m"
local RED     = "\027[31m"
local GREEN   = "\027[32m"
local YELLOW  = "\027[33m"
local BLUE    = "\027[34m"
local MAGENTA = "\027[35m"
local CYAN    = "\027[36m"
local WHITE   = "\027[37m"

---comment
---@param v any
---@param nocolor? boolean
---@return string
function format(v, nocolor)
  nocolor = nocolor or false

  if type(v) == 'string' then
    return (nocolor and '' or GREEN) .. '"' .. v .. '"' .. (nocolor and '' or RESET)
  elseif type(v) == 'number' then
    return (nocolor and '' or YELLOW) .. v .. (nocolor and '' or RESET)
  elseif type(v) == 'boolean' then
    return (nocolor and '' or RED) .. tostring(v) .. (nocolor and '' or RESET)
  elseif type(v) == 'nil' then
    return (nocolor and '' or RED) .. 'nil' .. (nocolor and '' or RESET)
  elseif type(v) == 'function' then
    return (nocolor and '' or MAGENTA) .. tostring(v) .. (nocolor and '' or RESET)
  elseif type(v) == 'userdata' then
    return (nocolor and '' or CYAN) .. tostring(v) .. (nocolor and '' or RESET)
  elseif type(v) == 'table' then
    if v[1] ~= nil then -- list
      local out = ''
      for i = 1, #v do
        out = out .. format(v[i], nocolor)
        if i < #v then
          out = out .. ', '
        end
      end
      return '['..out..']'
    else -- map
      local ordered_keys = {}
      for k in pairs(v) do
        table.insert(ordered_keys, k)
      end
      table.sort(ordered_keys)
      local out = "{"
      for i = 1, #ordered_keys do
        local k, v = ordered_keys[i], v[ordered_keys[i]]
        out = out ..  k .. " = " .. format(v, nocolor)
        if i < #ordered_keys then
          out = out .. ", "
        end
      end
      out = out .. "}"
      return out
    end
  end

  return tostring(v)
end

return format