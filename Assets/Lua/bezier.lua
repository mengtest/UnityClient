local Bezier = Class()

Bezier.startPos = nil
Bezier.endPos = nil
Bezier.middlePos = nil

function Bezier:SetBezierPoints(startPos, endPos, height)
    self.startPos = startPos
    self.middlePos = startPos + CS.UnityEngine.Vector3(0, height, 0)
    self.endPos = endPos
end

Bezier.resultPos = CS.UnityEngine.Vector3.zero
function Bezier:GetPointAtTime(value)
    if value > 1 then value = 1 end
    if value < 0 then value = 0 end

    self.resultPos.x = value * value *(self.endPos.x - 2 * self.middlePos.x + self.startPos.x) + self.startPos.x + 2 * value *(self.middlePos.x - self.startPos.x)
    self.resultPos.y = value * value *(self.endPos.y - 2 * self.middlePos.y + self.startPos.y) + self.startPos.y + 2 * value *(self.middlePos.y - self.startPos.y)
    self.resultPos.z = value * value *(self.endPos.z - 2 * self.middlePos.z + self.startPos.z) + self.startPos.z + 2 * value *(self.middlePos.z - self.startPos.z)

    return self.resultPos
end

return Bezier
