-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local ActorBase = Class("ActorBase")

ActorBase.gameObject = nil
ActorBase.speedRate = nil
ActorBase.BodySlot = nil

function ActorBase:init()
end

-- 初始化
-- <param name="gameObject" type="GameObject"></param>
function ActorBase:initialize(gameObject, speedRate)
    self.gameObject = gameObject
    self.speedRate = speedRate
    if self.gameObject == nil then
        return
    end
    -- 获取槽位脚本
    self.BodySlot = self.gameObject:GetComponent(typeof(CS.LPCFramework.ActorBodySlots))
    if self.BodySlot == nil then
        self.BodySlot = self.gameObject:AddComponent(typeof(CS.LPCFramework.ActorBodySlots))
    end
end
-- 攻击指定对象
-- <param name="target" type="ActorBase"></param>
-- <param name="skillType" type="number"></param>
function ActorBase:onAttack(target, skillType, damage, hurtType)
end
-- 向指定位置移动(指定位置)
-- <param name="point" type="Vector3"></param>
-- <param name="moveTime" type="number"></param>
function ActorBase:movePoint(point, moveTime, moveType)
end
-- 向指定位置移动(路点移动)
-- <param name="points" type="Vector3"></param>
-- <param name="moveTime" type="number"></param>
function ActorBase:movePoints(points, moveTime, moveType)
end
-- 停止移动
function ActorBase:stopMove()
end
-- 受到伤害
-- <param name="damage" type="number"></param>
function ActorBase:onDamage(damage, hurtType)
end
-- 播放动作
function ActorBase:onAnimation(id)
end
-- 生成特效，如命中特效，死亡特效等
function ActorBase:spawnParticle(id, aliveTime)
    local config, script = self:spawnObject(id)
    -- 改变存活时间
    if nil ~= aliveTime then
        script:setAliveTime(aliveTime)
    end
    return config, script
end
-- 生成物体
function ActorBase:spawnObject(id)
    -- 获取配置
    local spawnConfig = GameObjectConfig:getConfigByKey(id)
    if nil == spawnConfig then
        return nil, nil
    end

    -- 槽位信息
    local slotTrans = nil
    if nil ~= self.BodySlot then
        slotTrans = self.BodySlot:GetTransformBySlotType(spawnConfig.SlotType)
    end

    return spawnConfig, GameObjectManager.spawnObject(id, self.speedRate, nil, nil, slotTrans)
end
-- 设置可见
function ActorBase:setActive(active)
    if nil ~= self.gameObject then
        self.gameObject:SetActive(active)
    end
end
-- 设置旋转
-- <param name="direction" type="Vector3"></param>
function ActorBase:setRotateByDir(direction)
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
-- <param name="position" type="Vector3"></param>
-- <param name="rotation" type="Quaternion"></param>
function ActorBase:setPosAndRot(position, rotation)
    if self.gameObject == nil then
        return
    end
    self.gameObject.transform.position = position
    self.gameObject.transform.rotation = rotation
end
-- 设置播放速度
-- 加减速将影响到角色的动画播放、粒子播放和移动速度等
-- <param name="speed" type="number"></param>
function ActorBase:setPlaybackSpeed(speed)
    self.speedRate = speed
end
-- 获取Transform组件
function ActorBase:getTransform()
    if self.gameObject == nil then
        return nil
    end

    return self.gameObject.transform
end
-- 获取位置
function ActorBase:getPosition()
    if self.gameObject.transform == nil then
        return nil
    end

    return self.gameObject.transform.position
end
-- 根据槽位类型获取槽位
-- <param name="slotType" type="ActorSlotType">槽位类型</param>
function ActorBase:getSlotByType(slotType)
    if nil == self.BodySlot then
        return nil
    end
    return self.BodySlot:GetTransformBySlotType(slotType)
end

-- 更新
function ActorBase:update()
end
-- 死亡
function ActorBase:onDie()
end
-- 销毁
function ActorBase:onDestroy()
    self.gameObject = nil
end


return ActorBase

