local _C = UIManager.SubController(UIManager.ControllerName.BattleHUD, nil)
-- view
_C.view = nil
-- 显示hud
local isShowHud = false
-- 武将信息
local generalInfo = { }
-- 武将血条缓存
local generalHudCache = { }
-- 飘字缓存
local waveNumCache = {
    inUse = { },
    used = { },
}
-- 攻效缓存
local hurtTypeCache = {
    inUse = { },
    used = { },
}

-- 更新武將信息
local function updateGeneralInfo(actor)
    if not _C.IsOpen then
        return
    end

    if nil == actor then
        return
    end
    local property = actor.propertyController
    -- 保存属性
    if generalInfo[property.InsInfo.InsId] == nil then
        generalInfo[property.InsInfo.InsId] = { }
    end
    generalInfo[property.InsInfo.InsId].actor = actor
    generalInfo[property.InsInfo.InsId].property = property

    -- hud头顶刷新
    local hud = generalInfo[property.InsInfo.InsId].hud
    if hud == nil then
        if (#generalHudCache) > 0 then
            hud = generalHudCache[1]
            table.remove(generalHudCache, 1)
        else
            hud = UIPackage.CreateObject("Battle", "LifeBar").asCom
        end

        generalInfo[property.InsInfo.InsId].hud = hud
        if property.InsInfo.Camp == CampType.Attacker then
            hud:GetController("camp_C").selectedIndex = 0
        else
            hud:GetController("camp_C").selectedIndex = 1
        end
        _C.view.UI:AddChild(hud)
    end
    hud:GetChild("com_race"):GetChild("icon").url = UIConfig.Race[property.Config.raceType]
    hud:GetChild("txt_solider").text = property.CurSolider
    hud.visible = false

    print("更新武将hud！！")
end

-- 更新hud位置
local function refreshHudPos()
    for k, v in pairs(generalInfo) do
        local pos = CS.LPCFramework.LogicUtils.WorldToScreenPoint((v.actor:getSlotByType(ActorSlotType.Head)).gameObject)
        v.hud.position = pos
    end
end
-- 回收攻效对象--
local function recycleHurtType(value)
    value.visible = false
    table.insert(hurtTypeCache.used, value)
end
-- 回收飘字对象--
local function recycleWaveNum(value)
    value.visible = false
    table.insert(waveNumCache.used, value)
end
-- 掉血--
local function updatePlayerHp(property, hurtType, damage, soliderDie)
    if not _C.IsOpen then
        return
    end
    local general = generalInfo[property.InsInfo.InsId]
    -- 头顶hud
    general.hud:GetChild("txt_solider").text = property.CurSolider
    if property.CurSolider <= 0 then
        general.hud.visible = false
    end

    -- 攻击类型
    local pos = CS.LPCFramework.LogicUtils.WorldToScreenPoint((general.actor:getSlotByType(ActorSlotType.Head)).gameObject)
    if hurtType ~= HurtType.Normal and hurtType ~= HurtType.None then
        local transition = nil
        if (#hurtTypeCache.used) > 0 then
            transition = hurtTypeCache.used[1]
            table.remove(hurtTypeCache.used, 1)
        else
            transition = UIPackage.CreateObject("Battle", "Hud_Good").asCom
            _C.view.UI:AddChild(transition)
        end
        table.insert(hurtTypeCache.inUse, transition)
        if hurtType == HurtType.Crit then
            transition:GetChild("txt_desc").textFormat.font = UIConfig.Battle.debuffFont
            transition:GetChild("txt_desc").text = "b"
        elseif hurtType == HurtType.Miss then
            transition:GetChild("txt_desc").textFormat.font = UIConfig.Battle.goodbuffFont
            transition:GetChild("txt_desc").text = "s"
        end
        transition.visible = true
        transition.position = pos;
        transition:GetTransition("HUD_T"):Play( function() recycleHurtType(transition) end)
    end

    -- 飘字--	
    if damage <= 0 then
        return
    end
    local damageText = nil
    if (#waveNumCache.used) > 0 then
        damageText = waveNumCache.used[1]
        table.remove(waveNumCache.used, 1)
    else
        damageText = UIPackage.CreateObject("Battle", "Hud_Harm").asCom
        _C.view.UI:AddChild(damageText)
    end
    table.insert(waveNumCache.inUse, damageText)
    if damage > 0 then
        damageText:GetChild("txt_desc").textFormat.font = UIConfig.Battle.debuffFont
    else
        damageText:GetChild("txt_desc").textFormat.font = UIConfig.Battle.goodbuffFont
    end
    damageText.visible = true
    damageText.position = pos;
    damageText:GetChild("txt_desc").text = - damage
    damageText:GetTransition("HUD_T"):Play( function() recycleWaveNum(damageText) end)
end

-- 显示头顶tip--
local function BtnToShowHud(isShow)
    isShowHud = not isShowHud
    if type(isShow) == "boolean" then
        isShowHud = isShow
    end
    for k, v in pairs(generalInfo) do
        -- 先更新位置
        if isShowHud then
            refreshHudPos()
        end
        v.hud.visible = isShowHud
        -- 如果已死亡，则不显示
        if v.property.CurSolider == nil or v.property.CurSolider <= 0 then
            v.hud.visible = false
        end
    end
end

-- 舞台点击
local function StageOnTouchBegin()
    if Stage.isTouchOnUI == false then
        BtnToShowHud(true)
    end
end
-- 舞台点击
local function StageOnTouchEnd()
    BtnToShowHud(false)
end

function _C:onCreat()
    Event.addListener(Event.BATTLE_CAPTAIN_REFRESH, updateGeneralInfo)
    Event.addListener(Event.BATTLE_DROP_OF_BLOOD, updatePlayerHp)
end

function _C:onOpen(data)
    BtnToShowHud(false)
end

function _C:onShow()
    Event.addListener(Event.STAGE_ON_TOUCH_BEGIN, StageOnTouchBegin)
    Event.addListener(Event.STAGE_ON_TOUCH_END, StageOnTouchEnd)
end

function _C:onHide()
    Event.removeListener(Event.STAGE_ON_TOUCH_BEGIN, StageOnTouchBegin)
    Event.removeListener(Event.STAGE_ON_TOUCH_END, StageOnTouchEnd)
end

function _C:onClose()
    -- 缓存
    for k, v in pairs(generalInfo) do
        v.hud.visible = false
        table.insert(generalHudCache, v.hud)
    end
    -- 飘字
    waveNumCache.used = { }
    for k, v in pairs(waveNumCache.inUse) do
        v.visible = false
        table.insert(waveNumCache.used, v)
    end
    waveNumCache.inUse = { }
    -- 动效
    hurtTypeCache.used = { }
    for k, v in pairs(hurtTypeCache.inUse) do
        v.visible = false
        table.insert(hurtTypeCache.used, v)
    end
    hurtTypeCache.inUse = { }

    generalInfo = { }
end

function _C:onUpdate()
    if not isShowHud then
        return
    end
    refreshHudPos()
end

function _C:onDestroy()
    Event.removeListener(Event.BATTLE_CAPTAIN_REFRESH, updateGeneralInfo)
    Event.removeListener(Event.BATTLE_DROP_OF_BLOOD, updatePlayerHp)

    waveNumCache.inUse = { }
    waveNumCache.used = { }
    hurtTypeCache.inUse = { }
    hurtTypeCache.used = { }
    generalHudCache = { }
end

return _C