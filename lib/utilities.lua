
function orientationTo4WayDirection(orientation)
  -- Orientation will be a number in range [0, 1[
  -- 0 is north, 0.25 is east, 0.5 is south, 0.75 is west
  if orientation < .125 then
    return defines.direction.north
  elseif orientation < .375 then
    return defines.direction.east
  elseif orientation < .625 then
    return defines.direction.south
  elseif orientation < .875 then
    return defines.direction.west
  else -- >= .875
    return defines.direction.north
  end
end
