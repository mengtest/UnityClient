local ActorPropertyBase = require "Actor.ActorPropertyBase"
local ActorPropertyFighter = ActorPropertyBase:extend("ActorPropertyFighter")

ActorPropertyFighter.DieSolider = nil

-- 初始化--
function ActorPropertyFighter:initialize(gameObject, insInfo, config)
    self.super.initialize(self, gameObject, insInfo, config)
    self.DieSolider = insInfo.Captain.TotalSoldier - self.CurSolider
end
-- 受到伤害
-- <param name="damage" type="number"></param>
function ActorPropertyFighter:onDamage(damage)
    self.super.onDamage(self, damage)
    self.DieSolider = self.InsInfo.Captain.TotalSoldier - self.CurSolider
end

return ActorPropertyFighter

