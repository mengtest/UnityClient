local GameObjectBase = require "Actor.GameObjectBase"
local BezierObjectBase = GameObjectBase:extend("BezierObjectBase")
               
-- 攻击目标
BezierObjectBase.attackTarget = nil
-- 攻击点
BezierObjectBase.attackPoint = nil
-- 贝塞尔曲线
BezierObjectBase.bezier = nil
-- 抛物线高度系数
BezierObjectBase.heightFactor = 0.7
-- 当销毁时
BezierObjectBase.onDestroyCallBack = nil
-- 当销毁时参数
BezierObjectBase.onDestroyCallBackArgs = nil

-- 基本方法请查看GameObjectBase

function BezierObjectBase:init()
end

-- 设置目标对象
-- <param name="caster" type="actorbase"></param>
-- <param name="targetActor" type="actorbase"></param>
-- <param name="time" type="number"></param>
-- <param name="speedRate" type="number"></param>
function BezierObjectBase:setTarget(caster, targetActor, aliveTime, onDestroyCallBack, onDestroyCallBackArgs)
    self.attackPoint = targetActor:getSlotByType(ActorSlotType.Base)

    self.attackTarget = targetActor
    self.onDestroyCallBack = onDestroyCallBack
    self.onDestroyCallBackArgs = onDestroyCallBackArgs

    if nil == self.bezier then
        self.bezier = require "bezier"()
    end
    local distance = CS.UnityEngine.Vector3.Distance(self.gameObject.transform.position, self.attackPoint.position)
    self.bezier:SetBezierPoints(self.gameObject.transform.position, self.attackPoint.position, distance * self.heightFactor);
    self.super.setTarget(self, caster, aliveTime)
end
-- 计时进行
function BezierObjectBase:update()
    if self.attackTarget == nil or self.config == nil then
        return
    end

    local scale = self.aliveTimer.CurCd / self.aliveTimer.MaxCd
    self.gameObject.transform:LookAt(self.bezier:GetPointAtTime((1 - scale) * 1.1));
    self.gameObject.transform.position = self.bezier:GetPointAtTime(1 - scale);
end
-- 销毁
function BezierObjectBase:onDestroy()
    -- 销毁回调
    if nil ~= self.onDestroyCallBack then
        self.onDestroyCallBack(self.attackTarget, self.onDestroyCallBackArgs)
    end
    -- 父类销毁
    self.super.onDestroy(self)
    -- 清除
    self.onDestroyCallBack = nil
    self.attackTarget = nil
    self.attackPoint = nil
    self.bezier = nil
end

return BezierObjectBase

