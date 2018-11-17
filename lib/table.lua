-- Make sure this part of the library exists
if not lib then lib = {} end
if not lib.table then lib.table = {} end



function lib.table.hasValue(table, value)
  for _,val in pairs(table) do
    if value == val then
      return true
    end
  end

  return false
end



function lib.table.isEmpty(t)
  return not next(t)
end



function lib.table.areEqual(t1, t2)
  if type(t1) ~= 'table' or type(t2) ~= 'table' then
    return t1 == t2
  end
  for k,v in pairs(t1) do
    if not lib.table.areEqual(v, t2[k]) then
      return false
    end
  end
  for k,v in pairs(t2) do
    if not lib.table.areEqual(v, t1[k]) then
      return false
    end
  end
  return true
end
