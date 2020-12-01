-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local ActorBehaviourBase = Class("ActorBehaviourBase")

ActorBehaviourBase.actor = nil                          -- 自身
ActorBehaviourBase.animator = nil                       -- 动画控制器
-- ActorBehaviourBase.pathAgent = nil                   -- 自动寻路代理(NavMeshAgent),用到时再打开

-- 初始化
-- <param name="actor" type="actorbase"></param>
function ActorBehaviourBase:initialize(actor)
    self.actor = actor

    -- 获取组件
    -- self.pathAgent = self.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.AI.NavMeshAgent))
    self.animator = self.actor.gameObject:GetComponentInChildren(typeof(CS.UnityEngine.Animator))
    if self.animator ~= nil then
        self.animator.applyRootMotion = false
    end
end
-- 向指定位置移动(指定位置)
-- <param name="point" type="Vector3"></param>
-- <param name="moveTime" type="number"></param>
function ActorBehaviourBase:movePoint(point, moveTime, moveType)
end
-- 向指定位置移动(路点移动)
-- <param name="points" type="Vector3"></param>
-- <param name="moveTime" type="number"></param>
function ActorBehaviourBase:movePoint(points, moveTime, moveType)
end
-- 停止移动
function ActorBehaviourBase:stopMove()
end
-- 设置播放速度，加减速将影响到角色的动画播放、粒子播放和移动速度等
-- <param name="speed" type="number"></param>
function ActorBehaviourBase:setPlaybackSpeed(speed)
    if self.animator ~= nil then
        self.animator:SetFloat("AniSpeedFactor", speed)
    end
end
-- 设置位置和旋转
function ActorBehaviourBase:setPosAndRot(position, rotation)
    self.actor.gameObject.transform.position = position
    self.actor.gameObject.transform.rotation = rotation
end
-- 播放动作
function ActorBehaviourBase:onAnimation(id)
    if self.animator ~= nil then
        self.animator:SetInteger("MotionType", id)
    end
end
-- 播放动作Idle
function ActorBehaviourBase:onIdle()
    if self.animator ~= nil then
        self.animator:SetInteger("MotionType", 0)
    end
end
-- 播放动作FightIdle
function ActorBehaviourBase:onFightIdle()
    if self.animator ~= nil then
        self.animator:SetInteger("MotionType", 1)
    end
end
-- 播放动作Walk
function ActorBehaviourBase:onWalk()
    if self.animator ~= nil then
        self.animator:SetInteger("MotionType", 2)
    end
end
-- 播放动作Run
function ActorBehaviourBase:onRun()
    if self.animator ~= nil then
        self.animator:SetInteger("MotionType", 6)
    end
end
-- 死亡
function ActorBehaviourBase:onDie()
    if self.animator ~= nil then
        self.animator:SetInteger("MotionType", 3)
    end
end
---- 播放动作Attack1
-- function ActorBehaviourBase:onAttack1()
--    if self.animator ~= nil then
--        self.animator:SetInteger("MotionType", 4)
--    end
-- end
---- 播放动作Attack2
-- function ActorBehaviourBase:onAttack2()
--    if self.animator ~= nil then
--        self.animator:SetInteger("MotionType", 5)
--    end
-- end

-- 进行中
function ActorBehaviourBase:update()
end
-- 销毁
function ActorBehaviourBase:onDestroy()
    -- 清除
    self.actor = nil
    self.animator = nil
    -- self.pathAgent = nil
end

return ActorBehaviourBase

