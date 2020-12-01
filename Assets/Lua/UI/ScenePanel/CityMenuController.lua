local _C = UIManager.SubController(UIManager.ControllerName.CityMenu, UIManager.ViewName.CityMenu)
local view = nil

-- 玩家城池信息
local clickedAreaInfo = nil
local qiHao = nil
local name = nil
local coordinates = nil
local noQiHao = ""
local noName = ""

-- 跳转到的面板类型
local gotoPanelType =
{
    Lord = 0,
    PreBattle_Invasion = 1,
    PreBattle_Assist = 2
}
local gotoPanel = nil
-- 出征数据
local combatInfo = BattleDeploymentInfo()

-- 边缘处理
local function edgeProcessing()
    if (view.OutsideMenu.position.y - view.OutsideMenu.height / 2) < 0 then
        view.OutsideMenu.position = CS.UnityEngine.Vector3(view.OutsideMenu.position.x, view.OutsideMenu.height / 2)
    elseif (view.OutsideMenu.position.y + view.OutsideMenu.height / 2) > GRoot.inst.height then
        view.OutsideMenu.position = CS.UnityEngine.Vector3(view.OutsideMenu.position.x, GRoot.inst.height - view.OutsideMenu.height / 2)
    elseif (view.OutsideMenu.position.x - view.OutsideMenu.width / 2) < 0 then
        view.OutsideMenu.position = CS.UnityEngine.Vector3(view.OutsideMenu.width / 2, view.OutsideMenu.position.y)
    elseif (view.OutsideMenu.position.x + view.OutsideMenu.width / 2) > GRoot.inst.width then
        view.OutsideMenu.position = CS.UnityEngine.Vector3(GRoot.inst.width - view.OutsideMenu.width / 2, view.OutsideMenu.position.y)
    end
end

-- 关闭自己
local function hideSelf()
    view.Visible_C.selectedIndex = 0
end

-- 进入主城
local function onEnterMainCity()
    Event.dispatch(Event.ENTER_MAIN_CITY)
end

-- 打开出征面板
local function onOpenPreBattlePanel(data, combatType)
    if clickedAreaInfo == nil or clickedAreaInfo.m_sGroundItemOwner == nil or combatType == nil then
        return
    end

    local isInvasion = false
    if combatType == BattleDeploymentType.PVP_Invasion then
        isInvasion = true
    end

    combatInfo:clear()

    -- 战斗类型
    combatInfo.Type = combatType
    -- 请求出征
    combatInfo.ToCombat = function(captainId, count, isSelected, troopId)
        local mapId = nil
        if DataTrunk.PlayerInfo.RegionData:getSelectRegion() == nil then
            mapId = DataTrunk.PlayerInfo.MonarchsData.BaseMapId
        else
            mapId = DataTrunk.PlayerInfo.RegionData:getSelectRegion()
        end
        NetworkManager.C2SInvasionProto(isInvasion, clickedAreaInfo.m_sGroundItemOwner, mapId, troopId)
        return true
    end
    -- 对方君主信息
    combatInfo.Monarch = { }
    combatInfo.Monarch.Name = data.Name
    combatInfo.Monarch.Head = data.Head
    combatInfo.Monarch.Guild = data.Guild
    combatInfo.Monarch.Level = data.Level
    combatInfo.Monarch.MainCityLevel = data.BaseLevel
    combatInfo.Monarch.FightAmount = 0
    combatInfo.Monarch.TowerFloor = 0
    combatInfo.Monarch.Rank = Localization.None
    -- 出征目标信息
    combatInfo.Expedition = { }
    combatInfo.Expedition.Name = ""
    combatInfo.Expedition.PosX = 10
    combatInfo.Expedition.PosY = 10
    combatInfo.Expedition.Time = 10

    -- 打开布阵
    UIManager.openController(UIManager.ControllerName.PreBattle, combatInfo)
end

-- 发送查看别人城池信息的请求
local function sendCheckOtherCityRequest()
    if clickedAreaInfo == nil and clickedAreaInfo.m_sGroundItemOwner == nil then
        return
    end

    NetworkManager.C2SViewOtherHero(clickedAreaInfo.m_sGroundItemOwner)
end

-- 获取其他君主信息
local function onGetOtherPlayerInfo(data)
    if data == nil or not _C.IsOpen or gotoPanel == nil then
        return
    end
    if gotoPanel == gotoPanelType.Lord then
        UIManager.openController(UIManager.ControllerName.Lords, data)
    elseif gotoPanel == gotoPanelType.PreBattle_Assist then
        onOpenPreBattlePanel(data, BattleDeploymentType.PVP_Assist)
    elseif gotoPanel == gotoPanelType.PreBattle_Invasion then
        onOpenPreBattlePanel(data, BattleDeploymentType.PVP_Invasion)
    end
end

-- 打开确认迁移面板
local function onOpenMoveCityPanel()
    LevelManager.CurrLevelLogic:advancedMoveBase(BuildingType.MainCity)
end

-- 打开行营迁徙确认
local function onOpenMoveCampsitePanel()
    if LevelManager.CurrLevelLogic.getCurrentMapId ~= nil then
        local curMapId = LevelManager.CurrLevelLogic.getCurrentMapId()
        local myMapId = DataTrunk.PlayerInfo.MonarchsData.BaseMapId
        if curMapId == myMapId then
            UIManager.showTip( { result = false, content = Localization.TheSameRegionWithMainCity} )
            return
        end
    end

    LevelManager.CurrLevelLogic:advancedMoveBase(BuildingType.Campsite)
end

local function onCampsiteInvasion()
    gotoPanel = gotoPanelType.PreBattle_Invasion
    sendCheckOtherCityRequest()
end

local function onCampsiteAssistance()
    gotoPanel = gotoPanelType.PreBattle_Assist
    sendCheckOtherCityRequest()
end

local function onCampsiteOpen()
    UIManager.openController(UIManager.ControllerName.Campsite, clickedAreaInfo.m_sGroundItemOwner)
end

local function onCampsiteBuildSpeedUp()
    local data = { }
    data[1] = UIManager.PopupStyle.ContentYesNo
    data.btnFunc = function() NetworkManager.CMiaoTentBuildingCd() end
    local buildingEndTime = DataTrunk.PlayerInfo.MonarchsData.CampMoveTime
    local buildingDuration = RegionCommonConfig.Config.CampsiteBuildingDuration
    local totalCost = RegionCommonConfig.Config.CampsiteBuildingCost.YuanBao
    local cost = ((math.max(buildingEndTime - TimerManager.currentTime, 0) + buildingDuration - 1) / buildingDuration) * totalCost
    data.content = string.format(Localization.CampsiteSpeedUpTips, math.floor(cost))  
    UIManager.openController(UIManager.ControllerName.Popup, data)
end

local function onCampsiteComeBack()
    NetworkManager.C2SRemoveTentProto()
end

local function onCampsiteDispatch()
    UIManager.openController(UIManager.ControllerName.WallDefense)
end

local function onViewCampsiteInfo()
    if tonumber(clickedAreaInfo.m_sGroundItemOwner) == nil then
        UIManager.showTip( { result = false, content = LocalizitionServerErrorResponse.Error2_37_1 } )
        return
    end

    UIManager.openController(UIManager.ControllerName.Campsite, clickedAreaInfo.m_sGroundItemOwner)
end

local function onViewLordInfo()
    gotoPanel = gotoPanelType.Lord
    sendCheckOtherCityRequest()
end

function _C:onClickGround()
    -- 互斥，关闭城池菜单
    Event.dispatch(Event.CLOSE_RESOURCE_MENU)
    view.Visible_C.selectedIndex = 1
    -- 获取点击的区域信息
    clickedAreaInfo = LevelManager.CurrLevelLogic.getCurrentClickedAreaInfo()
    if clickedAreaInfo == nil then
        hideSelf()
    end

    -- 设置弹出UI位置
    view.OutsideMenu.position = CS.LPCFramework.InputController.WorldToScreenPoint(clickedAreaInfo.m_vGroundItemPos)
    edgeProcessing()

    name = noName
    qiHao = noQiHao
    coordinates = string.format("(%d, %d)", clickedAreaInfo.m_iOddQX, clickedAreaInfo.m_iOddQY)

    local targetCityRegionInfo = DataTrunk.PlayerInfo.RegionBaseData:getBaseInfo(LevelManager.CurrLevelLogic.getCurrentMapId(), clickedAreaInfo.m_sGroundItemOwner)
    if targetCityRegionInfo ~= nil then
        name = targetCityRegionInfo.Name
    end

    -- 空地菜单
    if clickedAreaInfo.m_byGroundItemType == nil then
        -- 流亡状态
        if DataTrunk.PlayerInfo.MonarchsData.BaseLevel == 0 then
            view.Type_C.selectedIndex = 0
            -- 重建
            view.Btn1Ctrl.selectedIndex = 11
            view.Btn1.onClick:Set(onOpenMoveCityPanel)
        else
            view.Type_C.selectedIndex = 1
            -- 迁行营
            view.Btn2Ctrl.selectedIndex = 4
            view.Btn2.onClick:Set(onOpenMoveCampsitePanel)
            -- 迁主城
            view.Btn4Ctrl.selectedIndex = 3
            view.Btn4.onClick:Set(onOpenMoveCityPanel)
        end

        view.Name.text = ""
        view.Coordinate.text = coordinates

        return
    end

    if clickedAreaInfo.m_byGroundItemType == BuildingType.MainCity then
        -- 我的主城菜单
        if clickedAreaInfo.m_bIsPlayerMainCity then
            -- 进入主城
            view.Type_C.selectedIndex = 0
            view.Btn2Ctrl.selectedIndex = 0
            view.Btn2.onClick:Set(onEnterMainCity)
        else
            -- 盟友菜单
            if Utils.IsTheSameGuild(clickedAreaInfo.m_iGroundItemUnionId, DataTrunk.PlayerInfo.MonarchsData.GuildId) then
                view.Type_C.selectedIndex = 1

                -- 查看君主信息
                view.Btn4Ctrl.selectedIndex = 1
                view.Btn4.onClick:Set( function()
                    gotoPanel = gotoPanelType.Lord
                    sendCheckOtherCityRequest()
                end )

                -- 援助
                view.Btn2Ctrl.selectedIndex = 5
                view.Btn2.onClick:Set( function()
                    gotoPanel = gotoPanelType.PreBattle_Assist
                    sendCheckOtherCityRequest()
                end )

            -- 敌人菜单
            else
                view.Type_C.selectedIndex = 1

                -- 查看君主信息
                view.Btn4Ctrl.selectedIndex = 1
                view.Btn4.onClick:Set( function()
                    gotoPanel = gotoPanelType.Lord
                    sendCheckOtherCityRequest()
                end )

                -- 出征
                view.Btn2Ctrl.selectedIndex = 10
                view.Btn2.onClick:Set( function()
                    gotoPanel = gotoPanelType.PreBattle_Invasion
                    sendCheckOtherCityRequest()
                end )
            end
        end
    elseif clickedAreaInfo.m_byGroundItemType == BuildingType.Campsite then
        view.Type_C.selectedIndex = 2
        -- 我的行营菜单
        if clickedAreaInfo.m_bIsPlayerMainCity then
            -- 派遣
            view.Btn4Ctrl.selectedIndex = 12
            view.Btn4.onClick:Set(onCampsiteDispatch)

            -- 行营
            view.Btn2Ctrl.selectedIndex = 9
            view.Btn2.onClick:Set(onCampsiteOpen)
            -- 迁徙中
            local monarchsData = DataTrunk.PlayerInfo.MonarchsData
            local regionData = DataTrunk.PlayerInfo.RegionData
            local regionBaseData = DataTrunk.PlayerInfo.RegionBaseData
            local campsiteData = regionBaseData:getBaseInfo(regionData:getSelectRegion(), monarchsData.Id)
            if campsiteData.CampsiteValidTime == 0 or TimerManager.currentTime > campsiteData.CampsiteValidTime then
                -- 迁回主城
                view.Btn5Ctrl.selectedIndex = 8
                view.Btn5.onClick:Set(onCampsiteComeBack)
            else
                -- 加速
                view.Btn5Ctrl.selectedIndex = 13
                view.Btn5.onClick:Set(onCampsiteBuildSpeedUp)
            end
        else
            -- 查看行营
            view.Btn2Ctrl.selectedIndex = 9
            view.Btn2.onClick:Set(onViewCampsiteInfo)
            -- 查看君主
            view.Btn5Ctrl.selectedIndex = 1
            view.Btn5.onClick:Set(onViewLordInfo)

            -- 盟友菜单
            if Utils.IsTheSameGuild(clickedAreaInfo.m_iGroundItemUnionId, DataTrunk.PlayerInfo.MonarchsData.GuildId) then
                -- 援助
                view.Btn4Ctrl.selectedIndex = 5
                view.Btn4.onClick:Set(onCampsiteAssistance)
            -- 敌人菜单
            else
                -- 出征
                view.Btn4Ctrl.selectedIndex = 10
                view.Btn4.onClick:Set(onCampsiteInvasion)
            end
        end
    end
    view.Name.text = qiHao .. name
    view.Coordinate.text = coordinates
end

local function StageOnTouchBegin()
    if not Stage.isTouchOnUI then
        hideSelf()
    end
end

local function OnOutsideUIClick()
    hideSelf()
end

function _C:onCreat()
    view = _C.View

    Event.addListener(Event.ON_VIEW_OTHER_HERO, onGetOtherPlayerInfo)
    Event.addListener(Event.STAGE_ON_TOUCH_BEGIN, StageOnTouchBegin)
    Event.addListener(Event.CLOSE_CITY_MENU, hideSelf)
    view.UI.onClick:Set(OnOutsideUIClick)
end

function _C:onDestroy()
    Event.removeListener(Event.ON_VIEW_OTHER_HERO, onGetOtherPlayerInfo)
    Event.removeListener(Event.STAGE_ON_TOUCH_BEGIN, StageOnTouchBegin)
    Event.removeListener(Event.CLOSE_CITY_MENU, hideSelf)
    view.UI.onClick:Clear()
end

return _C