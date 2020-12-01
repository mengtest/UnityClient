-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local GameObjectBase = require "Actor.GameObjectBase"
local FlyObjectBase = GameObjectBase:extend("FlyObjectBase")
               
-- 攻击目标
FlyObjectBase.attackTarget = nil
-- 攻击点
FlyObjectBase.attackPoint = nil
-- 移动速度
FlyObjectBase.moveSpeed = nil
-- 当销毁时
FlyObjectBase.onDestroyCallBack = nil
-- 当销毁时参数
FlyObjectBase.onDestroyCallBackArgs = nil

-- 基本方法请查看GameObjectBase

function FlyObjectBase:init()
end

-- 设置目标对象
-- <param name="caster" type="actorbase"></param>
-- <param name="targetActor" type="actorbase"></param>
-- <param name="time" type="number"></param>
-- <param name="speedRate" type="number"></param>
function FlyObjectBase:setTarget(caster, targetActor, aliveTime, onDestroyCallBack, onDestroyCallBackArgs)
    self.attackPoint = targetActor:getSlotByType(ActorSlotType.Center)
    local distance = CS.UnityEngine.Vector3.Distance(self.attackPoint.position, self.gameObject.transform.position)
    self.moveSpeed = distance / aliveTime
    self.attackTarget = targetActor
    self.onDestroyCallBack = onDestroyCallBack
    self.onDestroyCallBackArgs = onDestroyCallBackArgs

    self.super.setTarget(self, caster, aliveTime)
end
-- 计时进行
function FlyObjectBase:update()
    if self.attackTarget == nil or self.config == nil then
        return
    end
    -- 看向目标
    self.gameObject.transform:LookAt(self.attackPoint)
    -- 匀速直线
    self.gameObject.transform:Translate(self.gameObject.transform.forward * self.speedRate * self.moveSpeed * TimerManager.deltaTime, CS.UnityEngine.Space.World);
end
-- 销毁
function FlyObjectBase:onDestroy()
    -- 销毁回调
    if nil ~= self.onDestroyCallBack then
        self.onDestroyCallBack(self.attackTarget, self.onDestroyCallBackArgs)
    end
    -- 父类销毁
    self.super.onDestroy(self)
    -- 清除
    self.attackTarget = nil
    self.moveDirection = nil
    self.moveSpeed = nil
    self.onDestroyCallBack = nil
end

return FlyObjectBase

