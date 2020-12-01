local HexMetrics = require 'Hexagon.HexMetrics'

local HexCoordinates = Class("HexCoordinates")
HexCoordinates.X = 0
HexCoordinates.Z = 0
HexCoordinates.Y = 0

-- Constructor，创建实例时自动调用，可带参数
function HexCoordinates:init(x, z)
    self.X = x
    self.Z = z
    self.Y = -x-z
end

-- int x, int z
function HexCoordinates:FromOffsetCoordinates(baseX, baseZ, xOffSet, zOffSet)
    return HexCoordinates(baseX + xOffSet, baseZ + zOffSet)
end

-- Vector3 position
function HexCoordinates:FromPosition(position)
    local z = position.z / (HexMetrics.innerRadius * 2)
    local y = -z
    local offset = position.x / (HexMetrics.outerRadius * 3)
    z = z - offset
    y = y - offset

    local iZ = math.floor(z + 0.5)                  -- 相当于Mathf.RoundToInt(z)
    local iY = math.floor(y + 0.5)
    local iX = math.floor(-z - y + 0.5)

    if iX + iY + iZ ~= 0 then
        local dZ = math.abs(z - iZ)
        local dY = math.abs(y - iY)
        local dX = math.abs(-z - y - iX)

        if dZ > dY and dZ > dX then
            iZ = -iY - iX
        elseif dX > dY then
            iX = -iZ - iY
        end
    end

    return HexCoordinates(iX, iZ)
end

function HexCoordinates.ToString()
    return X .. ", " .. Z
end

return HexCoordinates