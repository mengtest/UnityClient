local ActorPropertyBase = Class("ActorPropertyBase")

ActorPropertyBase.gameObject = nil
ActorPropertyBase.InsInfo = nil
ActorPropertyBase.Config = nil

ActorPropertyBase.CurSolider = nil

-- Constructor，创建实例时自动调用，可带参数
function ActorPropertyBase:init()
end

-- <param name="insInfo" type="table"></param>
-- <param name="config" type="table"></param>
function ActorPropertyBase:initialize(gameObject, insInfo, config)
    self.gameObject = gameObject
    self.InsInfo = insInfo
    self.Config = config
    self.CurSolider = insInfo.Captain.Soldier
end

-- 受到伤害
-- <param name="damage" type="number"></param>
function ActorPropertyBase:onDamage(damage)
    self.CurSolider = self.CurSolider - damage
end
return ActorPropertyBase

