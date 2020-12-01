-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local GameObjectBase = require "Actor.GameObjectBase"
local MeleeAttackBase = GameObjectBase:extend("MeleeAttackBase")

-- 攻击目标
MeleeAttackBase.attackTarget = nil

function MeleeAttackBase:init()
end

-- 设置目标对象
-- <param name="targetActor" type="ActorBase"></param>
function MeleeAttackBase:setTarget(caster, targetActor, aliveTime)
    self.attackTarget = targetActor
    self.super.setTarget(self, caster, aliveTime)
end
-- 销毁
function MeleeAttackBase:onDestroy()
    -- 父类销毁
    self.super.onDestroy(self)
    -- 清除
    self.attackTarget = nil
end
return MeleeAttackBase

