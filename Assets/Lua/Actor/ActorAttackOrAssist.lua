

local ActorBehaviourBase = require "Actor.ActorBehaviourBase"
local ActorAttackOrAssist = ActorBehaviourBase:extend("ActorAttackOrAssist")
ActorAttackOrAssist.Action = nil

function ActorAttackOrAssist:initialize(objInstance, insInfo, config, position, rotation)
    if objInstance == nil then
        return
    end
    self.super.initialize(self, objInstance)
end

function ActorAttackOrAssist:setPosAndDir(posX, posY, posZ, towardsX, towardsY, towardsZ, actionType)
    self.actor.gameObject.transform.localPosition = CS.UnityEngine.Vector3(posX, posY, posZ)
    self.Action = actionType
    if actionType == MilitaryActionType.Invasion then
        self.actor.gameObject.transform.forward = CS.UnityEngine.Vector3(towardsX - posX, towardsY - posY, towardsZ - posZ)
        self:attack()
    else
        self.actor.gameObject.transform.forward = CS.UnityEngine.Vector3(posX - towardsX, posY - towardsY, posZ - towardsZ)
        self:idle()
    end
end

function ActorAttackOrAssist:attack()
    if self.animator ~= nil then
        self.animator:SetInteger("MotionType", 5)
    end
end

function ActorAttackOrAssist:idle()
    self:onIdle()
end

return ActorAttackOrAssist