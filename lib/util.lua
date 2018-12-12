if not lib then lib = {} end
if not lib.util then lib.util = {} end

function lib.util.stringSplit(inputstring, sep)
  --Make sure sep is one character long.
  if sep == nil then
    sep = "%s"
  end
  local t = {}
  local i = 1
  for str in inputstring:gmatch("([^" .. sep .. "]+)") do
    t[i] = str
    i = i + 1
  end
  return t
end

function lib.util.convertRGB(color)
  for key,_ in pairs(color) do
    color[key] = color[key] / 255
  end
  return color
end
