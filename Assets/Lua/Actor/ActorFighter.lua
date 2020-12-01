-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local ActorBase = require "Actor.ActorBase"
local ActorBehaviour = require "Actor.ActorBehaviourFighter"
local ActorProperty = require "Actor.ActorPropertyFighter"
local ActorSkill = require "Actor.ActorSkillFighter"

local ActorFighter = ActorBase:extend("ActorFighter")

ActorFighter.behaviourController = nil
ActorFighter.propertyController = nil
ActorFighter.skillController = nil
ActorFighter.HitEff = nil;
ActorFighter.Shadow = nil;

ActorFighter.isInitialized = false
ActorFighter.isDead = true

-- 初始化
-- <param name="gameobject" type="GameObject"></param>
-- <param name="insInfo" type="CombatTroopsClass"></param>
-- <param name="config" type="ActorConfig"></param>
-- <param name="position" type="vector3"></param>
-- <param name="rotation" type="Quaternion"></param>
function ActorFighter:initialize(gameobject, insInfo, config, speedRate)
    if nil == gameobject then
        gameobject = self.gameObject
    end
    -- 初始化
    self.super.initialize(self, gameobject, speedRate)

    -- 行为
    if nil == self.behaviourController then
        self.behaviourController = ActorBehaviour()
    end
    self.behaviourController:initialize(self)
    -- 属性
    if nil == self.propertyController then
        self.propertyController = ActorProperty()
    end
    self.propertyController:initialize(self.gameObject, insInfo, config)
    -- 技能
    if nil == self.skillController then
        self.skillController = ActorSkill()
    end
    self.skillController:initialize(self)

    -- 根据阵营修改材质球颜色
    CS.LPCFramework.ActorMaterialsController.SetActorMaterials(self.gameObject, insInfo.Camp)

    -- 受击特效
    self.HitEff = self.gameObject:GetComponent(typeof(CS.LPCFramework.SoldierHit))
    if self.HitEff == nil then
        self.HitEff = self.gameObject:AddComponent(typeof(CS.LPCFramework.SoldierHit))
    end

    -- 阴影
    self.Shadow = self.gameObject:GetComponent(typeof(CS.DynamicProjector))
    if self.Shadow == nil then
        self.Shadow = self.gameObject:AddComponent(typeof(CS.DynamicProjector))
    end
    self.Shadow.enabled = true

    -- 可见性
    self:setActive(true)

    self.isInitialized = true
    self.isDead = false
end
-- 向指定位置移动(指定位置)
function ActorFighter:movePoint(point, moveTime, moveType)
    self.behaviourController:movePoint(point, moveTime, moveType)
end
-- 向指定位置移动(路点移动)
function ActorFighter:movePoints(points, moveTime, moveType)
    self.behaviourController:movePoints(points, moveTime, moveType)
end
-- 停止移动
function ActorFighter:stopMove()
    self.behaviourController:stopMove()
end
-- 播放动作
function ActorFighter:onAnimation(id)
    self.behaviourController:onAnimation(id)
end
-- 攻击，指定对象
-- <param name="target" type="ActorBase"></param>
-- <param name="skillId" type="number"></param>
-- <param name="damage" type="number"></param>
function ActorFighter:onAttack(target, skillId, damage, hurtType)
    local direction =(target.gameObject.transform.position - self.gameObject.transform.position).normalized
    self:setRotateByDir(direction)
    self.skillController:doSkill(skillId, target, damage, hurtType)
end
-- 受到伤害
-- <param name="damage" type="number"></param>
function ActorFighter:onDamage(damage, hurtType)
    -- HitEff
    if self.HitEff ~= nil then
        self.HitEff:Play()
    end

    -- 伤害值限制
    if damage > self.propertyController.CurSolider then
        damage = self.propertyController.CurSolider
    end
    -- 掉血
    self.propertyController:onDamage(damage)

    -- 死亡判断
    if self.propertyController.CurSolider <= 0 then
        print("die", self.propertyController.InsInfo.InsId, self.propertyController.InsInfo.Captain.Name)
        self:onDie()
    end
    -- 通知UI显示
    Event.dispatch(Event.BATTLE_DROP_OF_BLOOD, self.propertyController, hurtType, damage, damage)
end

-- 设置播放速度
-- 加减速将影响到角色的动画播放、粒子播放和移动速度等
-- <param name="speed" type="number"></param>
function ActorFighter:setPlaybackSpeed(speed)
    self.super.setPlaybackSpeed(self, speed)

    self.behaviourController:setPlaybackSpeed(speed)
    self.skillController:setPlaybackSpeed(speed)
end

-- 更新
function ActorFighter:update()
    if not self.isInitialized or self.isDead then
        return
    end
    if nil == self.behaviourController then
        return
    end
    self.behaviourController:update()
    if nil == self.skillController then
        return
    end
    self.skillController:update()
end

-- 角色死亡
function ActorFighter:onDie()
    self.isDead = true
    self.behaviourController:onDie()
    
    if self.Shadow ~= nil then
        self.Shadow.enabled = false
    end
end

-- 销毁角色
function ActorFighter:onDestroy()
    self.super.onDestroy(self)

    self.behaviourController:onDestroy()
end


return ActorFighter

