local SkillLogicBase = Class("SkillLogicBase")

-- 时间线
local timeLine = require("Skill.TimeLine").TimeLine
local lineEvent = require("Skill.TimeLine").LineEvent

-- 技能配置
SkillLogicBase.config = nil
-- 释放速率
SkillLogicBase.speedRate = 1
-- 摄像机动画
SkillLogicBase.camAnim = nil

-- 时间线
SkillLogicBase.timeLine = { }

-- 施法对象
SkillLogicBase.caster = nil
-- 受击对象
SkillLogicBase.receiver = nil
-- 伤害值
SkillLogicBase.damageV = 0
-- 伤害类型
SkillLogicBase.damageType = HurtType.None

-- 构造函数
function SkillLogicBase:init()
end
-- 初始化
function SkillLogicBase:initialize(caster, config, speedRate)
    self.camAnim = CS.UnityEngine.Camera.main.gameObject:GetComponent(typeof((CS.UnityEngine.Animator)))
    self.caster = caster
    self.config = config
    self.speedRate = speedRate
    self:addLineEvent()
end
-- 释放技能
function SkillLogicBase:doSkill(receiver, damageV, hurtType)
    self.receiver = receiver
    self.damageV = damageV
    self.damageType = hurtType
    self:doTimeLine(1)
end
-- 打断技能
function SkillLogicBase:doInterrupt()
    for k, v in pairs(self.timeLine) do
        v:reset()
    end
end
-- 播放动作
function SkillLogicBase:doAnimation(id)
    if nil ~= self.caster then
        self.caster:stopMove()
        self.caster:onAnimation(id)
    end
end
-- 摄像机震动
function SkillLogicBase:doCamEffect(id)
    if nil ~= self.camAnim and nil ~= id then
        self.camAnim:SetInteger("MotionType", id)
    end
end
-- 播放音效
function SkillLogicBase:doSound(id)
    -- ToDo
end
-- 执行伤害
function SkillLogicBase:doDamage()
    if nil ~= self.receiver then
        self.receiver:onDamage(self.damageV, self.damageType)
    end
end
-- 生成特效
function SkillLogicBase:doSpawnParticle(args)
    local targetId, particleId = args[1], args[2]
    if nil ~= self.caster and targetId == 0 then
        self.caster:spawnParticle(particleId)
    end
    if nil ~= self.receiver and targetId == 1 then
        self.receiver:spawnParticle(particleId)
    end
end
-- 生成近战物体
function SkillLogicBase:doSpawnMeleeObject(id)
    -- 获取脚本
    local config, script = self.caster:spawnObject(id)

    if nil == config or nil == script then
        return
    end
    local aliveTime = config.lifeTime or 0
    script:setTarget(self.caster, self.receiver, aliveTime)
end
-- 生成飞行道具
function SkillLogicBase:doSpawnFlyObject(args)
    local flyId = args[1]
    -- 获取脚本
    local config, script = self.caster:spawnObject(flyId)

    if nil == config or nil == script then
        return
    end

    -- 远程攻击
    local selfHorizontalPos = CS.UnityEngine.Vector3(self.receiver.gameObject.transform.position.x, 0, self.receiver.gameObject.transform.position.z)
    local casterHorizontalPos = CS.UnityEngine.Vector3(self.caster.gameObject.transform.position.x, 0, self.caster.gameObject.transform.position.z)
    local distance = CS.UnityEngine.Vector3.Distance(casterHorizontalPos, selfHorizontalPos)
    local aliveTime = distance / config.velocity

    -- 当飞行物销毁时
    local onFlyObjectDestroy = function(target, destroyArgs)
        if nil ~= target then
            target:onDamage(destroyArgs.damageV, destroyArgs.damageType)
            target:spawnParticle(destroyArgs.hitId)
        end
        self:doCamEffect(destroyArgs.camEffId)
    end

    script:setTarget(self.caster, self.receiver, aliveTime, onFlyObjectDestroy, { hitId = args[2], camEffId = args[3], damageV = self.damageV, damageType = self.damageType })
end
-- 速率
function SkillLogicBase:setSpeedRate(speed)
    self.speedRate = speed
    -- 更改时间线上速率
    for k, v in pairs(self.timeLine) do
        v:setSpeedRate(speed)
    end
    -- 更改摄像机震动速率
    if nil ~= self.camAnim then
        self.camAnim.speed = speed
    end
end
-- 更新
function SkillLogicBase:update()
    for k, v in pairs(self.timeLine) do
        v:update()
    end
end
-- 执行时间线
function SkillLogicBase:doTimeLine(id)
    if nil ~= self.timeLine[id] then
        self.timeLine[id]:start()
    end
end
-- 添加时间线事件
function SkillLogicBase:addLineEvent()
    self.timeLine = { }
    if self.config == nil then
        return
    end

    local delayTime = 0
    -- 添加时间线
    for k, v in pairs(self.config.timeLine) do
        delayTime = 0
        local line = timeLine(self.speedRate)
        for m, n in pairs(v) do
            -- 保存最大延迟
            if n.delayTime > delayTime then
                delayTime = n.delayTime
            end
            if n.eventType == SkillDelayEventType.Animation then
                line:addEvent(n.delayTime, n.args, self.doAnimation, self)
            elseif n.eventType == SkillDelayEventType.MeleeObject then
                line:addEvent(n.delayTime, n.args, self.doSpawnMeleeObject, self)
            elseif n.eventType == SkillDelayEventType.FlyObject then
                line:addEvent(n.delayTime, n.args, self.doSpawnFlyObject, self)
            elseif n.eventType == SkillDelayEventType.Sound then
                line:addEvent(n.delayTime, n.args, self.doSound, self)
            elseif n.eventType == SkillDelayEventType.Particle then
                line:addEvent(n.delayTime, n.args, self.doSpawnParticle, self)
            elseif n.eventType == SkillDelayEventType.Damage then
                line:addEvent(n.delayTime, n.args, self.doDamage, self)
            elseif n.eventType == SkillDelayEventType.CameraEff then
                line:addEvent(n.delayTime, n.args, self.doCamEffect, self)
            end
        end
        -- 技能结束回调
        line:addEvent(delayTime + 0.5, nil, self.doInterrupt, self)

        table.insert(self.timeLine, line)
    end
end

return SkillLogicBase

