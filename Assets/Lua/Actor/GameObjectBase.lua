-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local GameObjectBase = Class("GameObjectBase")

GameObjectBase.caster = nil                         -- 寄体
GameObjectBase.config = nil                         -- 配置

GameObjectBase.gameObject = nil                     -- 游戏对象
GameObjectBase.insInfo = nil                        -- 对象实例化

GameObjectBase.effects = nil                        -- 效果

GameObjectBase.speedRate = 1                        -- 计时速率
GameObjectBase.aliveTimer = nil                     -- 存活计时器

function GameObjectBase:init()
end
-- 初始化
-- <param name="gameObject" type="GameObject"></param>
-- <param name="insInfo" type="table"></param>
-- <param name="config" type="GameObjectConfig"></param>
function GameObjectBase:initialize(gameObject, insInfo, config, speedRate)
    -- 可复用
    if nil ~= gameObject then
        self.gameObject = gameObject
    end
    if nil ~= insInfo then
        self.insInfo = insInfo
    end

    self.config = config
    self.speedRate = speedRate
    -- 身上效果
    if self.gameObject ~= nil and self.effects == nil then
        self.effects = self.gameObject:AddComponent(typeof(CS.LPCFramework.EffectController))
    end

    -- 默认为持续计时
    if nil == self.aliveTimer then
        self.aliveTimer = TimerManager.newTimer(Const.INFINITE, false, false, nil, nil, self.onDestroy, self)
    end
    self.aliveTimer:start()
    -- 初始速度
    self:setPlaybackSpeed(speedRate)
end
-- 设置目标对象
-- <param name="caster" type="actorbase"></param>
-- <param name="aliveTime" type="存活时间"></param>
-- <param name="speedRate" type="速率"></param>
function GameObjectBase:setTarget(caster, aliveTime)
    self.caster = caster
    if aliveTime <= 0 then
        -- 直接销毁
        self:onDestroy()
        return
    end
    -- 判断为持续计时
    if aliveTime == -1 then
        self.MaxCd = -1
    else
        self:setAliveTime(aliveTime)
    end
end
-- 设置存活时间
-- <param name="aliveTime" type="number"></param>
function GameObjectBase:setAliveTime(aliveTime)
    if nil ~= self.aliveTimer then
        self.aliveTimer:addCd(aliveTime - self.aliveTimer.MaxCd)
    end
end
-- 设置播放速度
-- 加减速将影响到角色的动画播放、粒子播放和移动速度等
-- <param name="speed" type="number"></param>
function GameObjectBase:setPlaybackSpeed(speed)
    if speed < 0 then
        speed = 0
    end
    self.speedRate = speed
    if self.effects ~= nil then
        self.effects:SetPlaySpeed(speed)
    end
    if self.aliveTimer ~= nil then
        self.aliveTimer:setSpeed(speed)
    end
end
-- 设置可见
function GameObjectBase:setActive(active)
    if nil ~= self.gameObject then
        self.gameObject:SetActive(active)
    end
end
-- 设置旋转
-- <param name="direction" type="Vector3"></param>
function GameObjectBase:setRotateByDir(direction)
    -- 角度
    local angle = CS.UnityEngine.Vector3.Angle(direction, self.gameObject.transform.forward)
    -- 判断正负
    local signValue = CS.UnityEngine.Vector3.Dot(self.gameObject.transform.up, CS.UnityEngine.Vector3.Cross(self.gameObject.transform.forward, direction))

    if signValue < 0 then
        signValue = -1
    else
        signValue = 1
    end

    angle = angle * signValue;

    if angle ~= 0 then
        self.gameObject.transform:Rotate(self.gameObject.transform.up, angle)
    end
end
-- 设置位置和旋转
function GameObjectBase:setPosAndRot(position, rotation)
    self.gameObject.transform.position = position
    self.gameObject.transform.rotation = rotation
end
-- 进行中
function GameObjectBase:update()
end
-- 销毁
function GameObjectBase:onDestroy()
    -- 移除计时器
    TimerManager.disposeTimer(self.aliveTimer)
    -- 如果对象已经被销毁直接return，避免计时器回调时找不到对象
    if self.gameObject == nil or self.config == nil then
        return
    end
    -- 把对象实例还给对象池
    GameObjectManager.returnObjectToPool(self.gameObject, self.insInfo.InsId, self.config.id, false)

    -- 清除
    self.caster = nil
    self.insInfo = nil
    self.config = nil
    self.gameObject = nil
    self.effects = nil
    self.speedRate = nil
end

return GameObjectBase

