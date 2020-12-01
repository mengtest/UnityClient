local _C = UIManager.Controller(UIManager.ControllerName.WallDefense, UIManager.ViewName.WallDefense)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 当前处理驻守部队Id
local handleGarrisonTroopId = 0
-- 君主实例化信息
local monarchsData = DataTrunk.PlayerInfo.MonarchsData
-- 军政实例化数据
local militaryAffairsInsData = DataTrunk.PlayerInfo.MilitaryAffairsData
-- 内政实例化数据
local internalAffairsData = DataTrunk.PlayerInfo.InternalAffairsData
-- 队伍个数
local theNumTroops = 3

-- 返回 
local function btnBack()
    _C:close()
end
-- 去布阵
local function btnEmbattle()
    UIManager.openController(UIManager.ControllerName.TroopsEmbattle)
end
-- 驻防主城
local function btnGarrisonHome()
    NetworkManager.C2SSetDefenseTroopProto(false, handleGarrisonTroopId)
end

-- 驻防行营
local function btnGarrisonTent()
    NetworkManager.C2SSetDefenseTroopProto(true, handleGarrisonTroopId)
end

-- 驻防
local function btnGarrison(troopId)
    handleGarrisonTroopId = troopId
    view.HandleTroopStat.selectedIndex = troopId
end

-- 撤防
local function btnRevocation(troopId)
    if monarchsData.HomeDefenseTroopId == troopId then
        NetworkManager.C2SSetDefenseTroopProto(false, 0)
    else
        NetworkManager.C2SSetDefenseTroopProto(true, 0)
    end
end

-- 补兵
local function btnAddSolider(troopId)
    local captainId = { }
    for k, v in pairs(militaryAffairsInsData.Troops[troopId].Captains) do
        if v ~= 0 then
            table.insert(captainId, v)
        end
    end
    if #captainId <= 0 then
        UIManager.showTip( { content = Localization.TroopCaptainNum_1, result = false })
    else
        NetworkManager.C2SCaptainFullSoldierProto(captainId)
    end
end

-- 点触结束
local function stageTouchEnd()
    view.HandleTroopStat.selectedIndex = 0
end

-- 更新防御信息
local function updateDefenseInfo()
    if not _C.IsOpen then
        return
    end
    view.HandleStat.selectedIndex = 1

    -- 主城防御
    view.HomeDefenseTroopTip.visible = false
    view.HomeDefenseTroop.text = Localization.NoTroop
    if nil ~= monarchsData.HomeDefenseTroopId and monarchsData.HomeDefenseTroopId > 0 then
        view.HomeDefenseTroop.text = string.format(Localization.TroopId, monarchsData.HomeDefenseTroopId)
        if militaryAffairsInsData.Troops[monarchsData.HomeDefenseTroopId].OutSide then
            view.HomeDefenseTroopTip.visible = true
        end
    end

    -- 行营防御
    view.TentDefenseTroopTip.visible = false
    view.TentDefenseTroop.text = Localization.NoTroop

    -- 解锁判断
    if internalAffairsData.BuildingsInfo[BuildingType.Campsite] == nil then
        view.TentDefenseTroop.text = Localization.NotUnlock
        view.HandleStat.selectedIndex = 0
    elseif nil ~= monarchsData.TentDefenseTroopId and monarchsData.TentDefenseTroopId > 0 then
        view.TentDefenseTroop.text = string.format(Localization.TroopId, monarchsData.TentDefenseTroopId)
        if militaryAffairsInsData.Troops[monarchsData.TentDefenseTroopId].OutSide then
            view.TentDefenseTroopTip.visible = true
        end
    end
end
-- 更新部队信息
local function updateTroopInfo(troopId)
    if not _C.IsOpen then
        return
    end

    local troop = militaryAffairsInsData.Troops[troopId]
    local raceType = ""
    local totalFight, totalCurSolider, totalMaxSolider = 0, 0, 0

    view.Troops[troopId].RaceList:RemoveChildrenToPool()
    -- 获取阵上武将
    for k, v in pairs(troop.Captains) do
        if v <= 0 then
            raceType = ""
        else
            local captain = militaryAffairsInsData.Captains[v]
            totalFight = totalFight + captain.FightAmount
            totalCurSolider = totalCurSolider + captain.Soldier
            totalMaxSolider = totalMaxSolider + captain.MaxSoldier
            raceType = captain.Race
        end
        -- 更新兵种
        local item = view.Troops[troopId].RaceList:AddItemFromPool()
        item.icon = UIConfig.Race[raceType]
    end

    -- 更新兵力
    view.Troops[troopId].Solider.max = totalMaxSolider
    view.Troops[troopId].Solider.value = totalCurSolider
    -- 更新战斗力
    view.Troops[troopId].Fight.text = Localization.FightAmount .. totalFight
    -- 判断是否驻防
    view.Troops[troopId].TroopBtnStat.selectedIndex = 0
    view.Troops[troopId].TroopGarrisonStat.selectedIndex = 0
    if monarchsData.HomeDefenseTroopId == troopId then
        view.Troops[troopId].TroopBtnStat.selectedIndex = 1
        view.Troops[troopId].TroopGarrisonStat.selectedIndex = 1
    elseif monarchsData.TentDefenseTroopId == troopId then
        view.Troops[troopId].TroopBtnStat.selectedIndex = 1
        view.Troops[troopId].TroopGarrisonStat.selectedIndex = 2
    end
end

-- 更新全部部队信息
local function updateAllTroopInfo()
    if not _C.IsOpen then
        return
    end

    for i = 1, theNumTroops do
        updateTroopInfo(i)
    end
end

-- 更新面板信息
local function updatePanelInfo()
    if not _C.IsOpen then
        return
    end

    updateAllTroopInfo()
    updateDefenseInfo()
end

function _C:onCreat()
    view = _C.View

    for i = 1, theNumTroops do
        view.Troops[i].BtnGarrison.onClick:Add( function() btnGarrison(i) end)
        view.Troops[i].BtnRevocation.onClick:Add( function() btnRevocation(i) end)
        view.Troops[i].BtnAddSolider.onClick:Add( function() btnAddSolider(i) end)
    end
    view.BtnBack.onClick:Add(btnBack)
    view.BtnEmbattle.onClick:Add(btnEmbattle)
    view.BtnGarrisonHome.onTouchEnd:Add(btnGarrisonHome)
    view.BtnGarrisonTent.onTouchEnd:Add(btnGarrisonTent)

    Event.addListener(Event.TROOP_ADD_SOLIDER_SUCCEED, updateAllTroopInfo)
    Event.addListener(Event.WALL_DEFENSE_GARRISON_CHANGE, updatePanelInfo)
end

function _C:onShow()
    updatePanelInfo()
    Event.addListener(Event.STAGE_ON_TOUCH_END, stageTouchEnd)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onHide()
    Event.removeListener(Event.STAGE_ON_TOUCH_END, stageTouchEnd)
end
function _C:onDestroy()
    for i = 1, theNumTroops do
        view.Troops[i].BtnGarrison.onClick:Clear()
        view.Troops[i].BtnRevocation.onClick:Clear()
        view.Troops[i].BtnAddSolider.onClick:Clear()
    end
    view.BtnBack.onClick:Clear()
    view.BtnEmbattle.onClick:Clear()
    view.BtnGarrisonHome.onClick:Clear()
    view.BtnGarrisonTent.onClick:Clear()
    view.BtnHandleCancel.onClick:Clear()

    Event.removeListener(Event.TROOP_ADD_SOLIDER_SUCCEED, updateAllTroopInfo)
    Event.removeListener(Event.WALL_DEFENSE_GARRISON_CHANGE, updatePanelInfo)
end
