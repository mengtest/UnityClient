-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local ActorBehaviourBase = require("Actor.ActorBehaviourBase")
local ActorBehaviourFighter = ActorBehaviourBase:extend("ActorBehaviourFighter")

-- 移动方向
ActorBehaviourFighter.moveDirection = nil           
-- 移动速度
ActorBehaviourFighter.moveSpeed = nil
-- 总移动时间
ActorBehaviourFighter.totalMoveTime = 0
-- 当前移动时间
ActorBehaviourFighter.curMoveTime = 0
-- 移动路径点
ActorBehaviourFighter.wayPoints = nil

-- 初始化
-- <param name="actor" type="tabele"></param>
function ActorBehaviourFighter:initialize(actor)
    -- 父类初始化
    self.super.initialize(self, actor)

    -- 初始idle状态
    self:onFightIdle()
end
-- 向指定位置移动(制定位置)
-- <param name="point" type="Vector3"></param>
-- <param name="moveTime" type="number"></param>
function ActorBehaviourFighter:movePoint(point, moveTime, moveType)
    -- 进行移动
    self:movePoints( { [1] = point }, moveTime, moveType)
end
-- 向指定位置移动(路点移动)
-- <param name="points" type="Vector3"></param>
-- <param name="moveTime" type="number"></param>
function ActorBehaviourFighter:movePoints(points, moveTime, moveType)
    -- 路点首位
    table.insert(points, 1, self.actor.gameObject.transform.position)
    -- 遍历路点
    local distance = 0
    for i = 2, #points do
        -- 高度一致
        points[i].y = points[1].y
        -- 总距计算
        distance = distance + CS.UnityEngine.Vector3.Distance(points[i], points[i - 1])
    end
    -- 移动位置
    self.wayPoints = points
    -- 移动时间
    self.totalMoveTime = moveTime
    self.curMoveTime = 0
    -- 移动速度
    self.moveSpeed = distance / moveTime
    -- 检测方向
    self:checkMoveDirection()

    -- 播放动作
    if moveType == ActorMoveType.Walk then
        self:onWalk()
    else
        self:onRun()
    end
end
-- 停止移动
function ActorBehaviourFighter:stopMove()
    self.moveDirection = nil
    self.totalMoveTime = 0
    self.curMoveTime = 0

    -- 初始idle状态
    self:onFightIdle()
end
-- 死亡
function ActorBehaviourFighter:onDie()
    self:stopMove()
    self.super.onDie(self)
end
-- 更新
function ActorBehaviourFighter:update()
    self:updateMoveTowards()
end
-- 销毁
function ActorBehaviourFighter:onDestroy()
    self.super.onDestroy(self)
end
-- 检测移动方向
function ActorBehaviourFighter:checkMoveDirection()
    -- 检测目标
    if nil == self.wayPoints or nil == self.wayPoints[1] then
        return
    end
    -- 距离判断,当已经接近目标时
    if (CS.UnityEngine.Vector3.Distance(self.actor.gameObject.transform.position, self.wayPoints[1])) < 0.5 then
        -- 检测下一目标
        if nil ~= self.wayPoints[2] then
            -- 改变移动方向
            self.moveDirection =(self.wayPoints[2] - self.actor.gameObject.transform.position).normalized
            -- 设置旋转
            self.actor:setRotateByDir(self.moveDirection)
        end

        -- 移除走过的点
        table.remove(self.wayPoints, 1)
    end
end
-- 更新位移
function ActorBehaviourFighter:updateMoveTowards()
    -- 无移动方向
    if self.moveDirection == nil or nil == self.actor.gameObject then
        return
    end
    -- 超过移动时间
    if self.curMoveTime > self.totalMoveTime then
        -- 停止移动
        self:stopMove()
        return
    end
    -- 方向判断
    self:checkMoveDirection()
    if self.moveDirection == nil then
        -- 停止移动
        self:stopMove()
        return
    end
    -- 移动时间
    self.curMoveTime = self.curMoveTime + self.actor.speedRate * TimerManager.deltaTime
    -- 匀速直线
    self.actor.gameObject.transform:Translate(self.moveDirection * self.actor.speedRate * self.moveSpeed * TimerManager.deltaTime, CS.UnityEngine.Space.World);
end

return ActorBehaviourFighter

