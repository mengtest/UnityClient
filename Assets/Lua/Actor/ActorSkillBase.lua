local ActorSkillBase = Class("ActorSkillBase")

-- 角色
ActorSkillBase.actor = nil
-- 技能
ActorSkillBase.skills = { }
-- 构造函数
function ActorSkillBase:init()
end
-- 初始化
function ActorSkillBase:initialize(actor)
    self.actor = actor
end
-- 释放技能
function ActorSkillBase:doSkill(skillId, receiver, damageV, hurtType)
--    if self.actor.propertyController.Config.raceType == RaceType.Archer then
--        skillId = 4
--    elseif self.actor.propertyController.Config.raceType == RaceType.Catapult then
--        skillId = 5
--    elseif self.actor.propertyController.Config.raceType == RaceType.Cavalry then
--        skillId = 2
--    elseif self.actor.propertyController.Config.raceType == RaceType.Chariots then
--        skillId = 3
--    elseif self.actor.propertyController.Config.raceType == RaceType.Infantry then
--        skillId = 1
--    end
    local skillLogic = self:getSkillLogic(skillId)
    if skillLogic ~= nil then
        skillLogic:doSkill(receiver, damageV, hurtType)
    end
end
-- 播放速率
function ActorSkillBase:setPlaybackSpeed(speed)
    for k, v in pairs(self.skills) do
        v:setSpeedRate(speed)
    end
end
-- 播放速率
function ActorSkillBase:update()
    for k, v in pairs(self.skills) do
        v:update()
    end
end
-- 获取技能逻辑
function ActorSkillBase:getSkillLogic(skillId)
    if self.skills[skillId] == nil then
        local skillConfig = SkillConfig:getConfigByKey(skillId)
        if nil ~= skillConfig then
            local skillLogic = require(skillConfig.script)()
            skillLogic:initialize(self.actor, skillConfig, self.actor.speedRate)

            self.skills[skillId] = skillLogic
        end
    else
        self.skills[skillId]:doInterrupt()
    end

    return self.skills[skillId]
end
return ActorSkillBase

