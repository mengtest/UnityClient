local _C = UIManager.Controller(UIManager.ControllerName.MainCity, UIManager.ViewName.MainCity)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
local outsideCtrl = require(UIManager.ControllerName.Outside)
local _CBuilders = require(UIManager.ControllerName.MainCityBuilders)
-- local _CEmergencySituation = require(UIManager.ControllerName.MainCityEmergencySituation)
local _CGM = require(UIManager.ControllerName.MainCityGM)
local _CInvade = require(UIManager.ControllerName.InvadeListMain)
local _CDebugTool = require(UIManager.ControllerName.MainCityDebugTool)
local _CChangeArea = require(UIManager.ControllerName.ChangeArea)

table.insert(_C.SubCtrl, _CchatBrief)
table.insert(_C.SubCtrl, outsideCtrl)
table.insert(_C.SubCtrl, _CBuilders)
-- table.insert(_C.SubCtrl, _CEmergencySituation)
table.insert(_C.SubCtrl, _CGM)
table.insert(_C.SubCtrl, _CInvade)
table.insert(_C.SubCtrl, _CDebugTool)
table.insert(_C.SubCtrl, _CChangeArea)

local view = nil
-- 玩家数据
local playerData = DataTrunk.PlayerInfo.MonarchsData
-- 内政数据
local internalData = DataTrunk.PlayerInfo.InternalAffairsData
-- 任务数据
local taskData = DataTrunk.PlayerInfo.TaskData
-- 军情数据
local regionMilitaryInfoData = DataTrunk.PlayerInfo.MilitaryInfoData
-- 千重楼信息 
local towerData = DataTrunk.PlayerInfo.TowerData
-- 军情UI
local warSituationUI = { }

local function StageOnClick()
    if Stage.isTouchOnUI or not _C.IsOpen then
        return
    end

    local hitObj = CS.LPCFramework.InputController.HitObj()

    if hitObj ~= nil then
        if hitObj.name == "Bazaar" then
            UIManager.openController(UIManager.ControllerName.Bazaar)
        elseif hitObj.name == "ClimbingTower" then
            -- 此处做判断,重楼密室
            if towerData:backRoomIsOpen() then
                UIManager.openController(UIManager.ControllerName.InsideMenu, hitObj)
            else
                UIManager.openController(UIManager.ControllerName.ClimbingTowerMain)
            end
        elseif internalData.BuildingsInfo[BuildingType[hitObj.name]] ~= nil then
            -- 打开菜单
            UIManager.openController(UIManager.ControllerName.InsideMenu, hitObj)
        else
            print("尚未解锁", hitObj.name)
        end
    end
end

-- 更新玩家信息
local function UpdatePlayerInfo()
    if not _C.IsOpen then
        return
    end
    -- 头像
    view.PlayerIcon.icon = playerData.Head.SmallIcon
    -- 名字
    view.PlayerName.text = playerData.Name
    -- 等级
    local level = playerData.Level
    view.PlayerIcon.title = level
    -- 经验条
    view.ExpBar.value = playerData.Exp
    view.ExpBar.max = MonarchsConfig.LevelConfig[level].UpgradeExp

    -- 联盟名字
    if playerData.Guild == "" then
        view.AllianceName.visible = false
    else
        view.AllianceName.visible = true
        view.AllianceName.title = playerData.Guild
    end

    -- 防御力
    view.DefensivePower.title = playerData.FightAmount
    -- 元宝
    view.YuanBaoCount.title = playerData.Money
end

-- 更新货币信息
local function UpdateCurrencyInfo()
    if not _C.IsOpen then
        return
    end

    local data = internalData.CurrencyCurrInfo
    view.Gold.title = data[CurrencyType.Gold]
    view.Wood.title = data[CurrencyType.Wood]
    view.Food.title = data[CurrencyType.Food]
    view.Stone.title = data[CurrencyType.Stone]
end

-- 更新繁荣度信息
local function UpdateProsperityInfo()
    if not _C.IsOpen then
        return
    end

    -- 繁荣度
    if playerData.BaseLevel == 0 then
        view.ProsperityBar.value = 0
        view.ProsperityBar.max = 0
        view.CityUpgradeEffect.visible = false
    else
        -- 当前繁荣度
        local v = internalData.Prosperity
        -- 当前等级繁荣度上限
        local m = MainCityLevelConfig.Config[playerData.BaseLevel].RequireProsperity
        view.ProsperityBar.value = v
        view.ProsperityBar.max = m

        -- 可升级提示
        if v >= m and playerData.BaseLevel ~= #MainCityLevelConfig.Config then
            view.CityUpgradeEffect.visible = true
        else
            view.CityUpgradeEffect.visible = false
        end
    end

    -- 当日最大繁荣度
    view.ProsperityHighestBar.value = internalData.HighestProsperity
    view.ProsperityHighestBar.max = view.ProsperityBar.max

    -- 主城等级
    view.CityBtn.title = playerData.BaseLevel
end

-- 切换城内城外控制器
local function ChangeCtrollerState(inMaincity)
    if inMaincity then
        -- 切到城内控制器
        view.State_C.selectedIndex = 0
        view.changeAreaSwitch_C.selectedIndex = 0
        -- 设置按钮显示出城
        view.SwitchBtn:GetController("State_C").selectedIndex = 0
    else
        -- 切到城外控制器
        view.State_C.selectedIndex = 1
        -- 设置按钮显示回城
        view.SwitchBtn:GetController("State_C").selectedIndex = 1
    end
end

-- 更新建筑标签
local function UpdateBuildingTags()
    if not _C.IsOpen then
        return
    end

    local tagObject = CS.UnityEngine.GameObject.Find("BuildingsTag")
    if nil == tagObject then
        return
    end
    local tagTrans = tagObject.transform
    local tagName = ""
    local tagUI = nil

    for i = 0, tagTrans.childCount - 1 do
        tagName = tagTrans:GetChild(i).name
        tagUI = tagTrans:GetChild(i):Find("TagUI").gameObject:GetComponent("UIPanel").ui
        -- 0:有等级 1:没等级
        local type_C = tagUI:GetController("Type_C")

        -- 千重楼不显示等级(删除农场)
        if tagName ~= "ClimbingTower" and tagName ~= "Bazaar" then
            type_C.selectedIndex = 0

            if internalData.BuildingsInfo[BuildingType[tagName]] ~= nil then
                tagUI:GetChild("Text_Level").text = internalData.BuildingsInfo[BuildingType[tagName]].Level
            end
        else
            type_C.selectedIndex = 1
        end

        tagUI.title = Localization["BuildingName" .. BuildingType[tagName]]
    end

    ChangeCtrollerState(true)
end

-- 更新任务信息
local function UpdateCurrentTaskInfo()
    if not _C.IsOpen then
        return
    end

    local mainTaskConfig = TaskConfig:getMainTaskConfigById(taskData.MainTaskId)
    if mainTaskConfig ~= nil then
        if taskData.MainTaskCompleted then
            view.TaskCompletedEffect.visible = true
            view.CurrentTaskBtn.title = string.format(Localization.MainTaskCompletedColor, mainTaskConfig.Name)
        else
            view.TaskCompletedEffect.visible = false
            view.CurrentTaskBtn.title = string.format(Localization.MainTaskInProgressColor, mainTaskConfig.Name)
        end
    end
end

-- 任务按钮点击
local function TaskBtnOnClick()
    UIManager.openController(UIManager.ControllerName.Task)
end

-- 回我的主城
local function GotoMyCity()
    ChangeCtrollerState(true)
    DataTrunk.PlayerInfo.RegionData:setSelectRegion(nil)
    -- 加载场景
    LevelManager.loadScene(LevelType.MainCity)
end

-- 去世界地图
local function GotoWorldMap()
    ChangeCtrollerState(false)
    DataTrunk.PlayerInfo.RegionData:setSelectRegion(DataTrunk.PlayerInfo.MonarchsData.BaseMapId)

    --    -- 获取野外信息, 获取资源点信息
    --    NetworkManager.C2SSwitchMapProto(DataTrunk.PlayerInfo.MonarchsData.BaseMapId)
    --    NetworkManager.C2SResourceBuildingProto()
    -- 加载场景
    LevelManager.loadScene(LevelType.WorldMap)
end

-- 出城按钮
local function SwitchBtnOnClick()
    if not _C.IsOpen then
        return
    end

    -- 城内
    if view.State_C.selectedIndex == 0 then
        GotoWorldMap()
        -- 世界
    elseif view.State_C.selectedIndex == 1 then
        GotoMyCity()
    end
end

-- 主城升级成功
local function MainCityUpgradeSuccess()
    if not _C.IsOpen then
        return
    end

    -- 打开升级面板
    UIManager.openController(UIManager.ControllerName.MonarchOrMainCityUpgrade, 1)
    -- 更新繁荣度
    UpdateProsperityInfo()
end

-- 流亡状态
local function OnExile()
    -- 内容 + 确认
    local data = {
        UIManager.PopupStyle.ContentUnquitConfirm,
        content = Localization.ConfirmExileState,
        btnTitle = Localization.Confirm,
        btnFunc = function()
            -- 发送随机创建主城请求
            NetworkManager.C2SCreateBaseProto(0, 0, 0)
        end
    }

    UIManager.openController(UIManager.ControllerName.Popup, data)
end

local function UpdateBaseState()
    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    if monarchsData.BaseMapId == 0 or
        monarchsData.BaseLevel == 0 or
        monarchsData.BaseProsperity == 0 then
        OnExile()
    end
end

-- 军情更新
function warSituationUI:UpdateWarSituationList()
    if not _C.IsOpen then
        return
    end
    warSituationUI:RemoveTimer()
    view.WarList:RemoveChildrenToPool()
    local data = regionMilitaryInfoData:GetMyMilitaryUIData()

    if data == nil or Utils.GetTableLength(data.Datas) == 0 then
        view.WarList.visible = false
        return
    else
        view.WarList.visible = true
    end

    for k, v in pairs(data) do
        if v ~= nil then
            local item = view.WarList:AddItemFromPool()
            item.onClick:Set( function()
                UIManager.openController(UIManager.ControllerName.WarSituation)
            end )
            local icon = item:GetChild('Loader_Icon')
            local label = item:GetChild('Label_Time')
            if v.MoveType == MilitaryMoveType.Forward then
                if v.Action == MilitaryActionType.Invasion then
                    -- 行军中
                    icon.url = UIConfig.MainUI_MilitaryState_Marching
                    warSituationUI:ShowWarTimer(v.CombineID, label, v.ArrivedTime, false)
                    -- 援助中
                elseif v.Action == MilitaryActionType.Assist then
                    icon.url = UIConfig.MainUI_MilitaryState_Assistance
                    warSituationUI:ShowWarTimer(v.CombineID, label, v.ArrivedTime, false)
                end
            elseif v.MoveType == MilitaryMoveType.Arrived then
                if v.Action == MilitaryActionType.Invasion then
                    -- 掠夺中
                    icon.url = UIConfig.MainUI_MilitaryState_Invasion
                    warSituationUI:ShowWarTimer(v.CombineID, label, v.ArrivedTime, true)
                elseif v.Action == MilitaryActionType.Assist then
                    -- 驻扎中
                    icon.url = UIConfig.MainUI_MilitaryState_Basing
                    warSituationUI:ShowWarTimer(v.CombineID, label, v.ArrivedTime, true)
                end
                -- 返回中
            elseif v.MoveType == MilitaryMoveType.Back then
                icon.url = UIConfig.MainUI_MilitaryState_Back
                warSituationUI:ShowWarTimer(v.CombineID, label, v.ArrivedTime, false)
            end
        end
    end
end

function warSituationUI:ShowWarTimer(id, timerText, endTime, isAscend)
    if id == nil or timerText == nil or endTime == nil then
        return
    end

    local remainSeconds = math.abs(TimerManager.currentTime - endTime)
    remainSeconds = math.floor(remainSeconds + 0.5)
    local maxCount = remainSeconds
    if isAscend then
        maxCount = 999999
    end
    if self.marchTimerList == nil then
        self.marchTimerList = { }
    end
    if self.marchTimerList[id] == nil then
        self.marchTimerList[id] = TimerManager.newTimer(remainSeconds, false, true, nil,
        -- update
        function(t, f)
            timerText.visible = true
            timerText.text = Utils.secondConversion(math.floor(f))
        end
        ,
        -- end
        function(t)
            timerText.visible = false
        end
        , self, isAscend)
    end

    if self.marchTimerList[id].MaxCd ~= maxCount then
        self.marchTimerList[id]:resetMax(maxCount)
    end

    if not self.marchTimerList[id].IsStart then
        self.marchTimerList[id]:start(remainSeconds)
    end
end

function warSituationUI:RemoveTimer()
    if self.marchTimerList ~= nil then
        for k, v in pairs(self.marchTimerList) do
            if v ~= nil then
                TimerManager.disposeTimer(v)
            end
        end
        self.marchTimerList = { }
    end
end

local function UpgradeBuildingSuccess()
    UpdateBuildingTags()
end

function _C:onCreat()
    view = _C.View
    outsideCtrl.view = view
    _CBuilders.view = view
    --    _CEmergencySituation.view = view
    _CGM.view = view
    _CInvade.view = view
    _CDebugTool.view = view
    _CChangeArea.view = view
    -- top right
    view.CityBtn.onClick:Set( function()
        NetworkManager.C2SUpgradeMainCityProto()
    end )

    -- bottom left
    view.TaskBtn.onClick:Set(TaskBtnOnClick)
    view.CurrentTaskBtn.onClick:Set(TaskBtnOnClick)

    -- bottom right
    view.EquipBtn.onClick:Set( function()
        UIManager.openController(UIManager.ControllerName.Pvp100Main)
--        -- 武将个数判断
--        if #DataTrunk.PlayerInfo.MilitaryAffairsData.Captains > 0 then
--            UIManager.openController(UIManager.ControllerName.CaptainEquipMain)
--        else
--            UIManager.showTip( { content = Localization.CaptainNumZero, result = false })
--        end
    end )
    view.PlayerIcon.onClick:Set( function() UIManager.openController(UIManager.ControllerName.Lords, playerData) end)
    view.LordBtn.onClick:Set( function() UIManager.openController(UIManager.ControllerName.Lords, playerData) end)
    view.GeneralBtn.onClick:Set( function() UIManager.openController(UIManager.ControllerName.General) end)
    view.AllianceBtn.onClick:Set(
    function()
        -- 未加入联盟，打开选择联盟界面；否则打开我的联盟界面
        if playerData.GuildId == 0 then
            UIManager.openController(UIManager.ControllerName.CreateOrJoinAlliance)
        else
            UIManager.openController(UIManager.ControllerName.Alliance)
        end
    end )

    NetworkManager.C2SRegionLevelCount()
    view.WarSituationBtn.onClick:Set( function() UIManager.openController(UIManager.ControllerName.WarSituation) end)
    -- 策划说这个按钮先改为农场
    view.BattleBtn.onClick:Add( function()
        UIManager.openController(UIManager.ControllerName.Farm)
    end )
    view.BagBtn.onClick:Set( function() UIManager.openController(UIManager.ControllerName.BagMain) end)
    view.MailBtn.onClick:Set( function() UIManager.openController(UIManager.ControllerName.Mail) end)
    view.RankingBtn.onClick:Set( function() 
            UIManager.openController(UIManager.ControllerName.Ranking, DataTrunk.PlayerInfo.RankingData.RankingType.Alliance)
        end)
    view.SwitchBtn.onClick:Set(SwitchBtnOnClick)

    Event.addListener(Event.PLAYER_INFO_UPDATE, UpdatePlayerInfo)
    Event.addListener(Event.CURRENCY_CURRENT_UPDATE, UpdateCurrencyInfo)
    Event.addListener(Event.PROSPERITY_UPDATE, UpdateProsperityInfo)
    Event.addListener(Event.BUILDING_UPGRADE, UpgradeBuildingSuccess)
    Event.addListener(Event.ENTER_MAIN_CITY, GotoMyCity)
    Event.addListener(Event.ENTER_OUTSIDE, GotoWorldMap)
    Event.addListener(Event.LOADING_MAINCITY_SUCCESS, UpdateBuildingTags)
    Event.addListener(Event.UDPATE_TASK, UpdateCurrentTaskInfo)
    Event.addListener(Event.NEW_TASK, UpdateCurrentTaskInfo)
    Event.addListener(Event.UPGRADE_BASE, MainCityUpgradeSuccess)
    Event.addListener(Event.ON_JOINED_GUILD, UpdatePlayerInfo)
    Event.addListener(Event.ON_LEAVE_GUILD, UpdatePlayerInfo)
    Event.addListener(Event.MONARCHS_UPDATE_HERO_FIGHT_AMOUNT, UpdatePlayerInfo)
    Event.addListener(Event.YUANBAO_UPDATE, UpdatePlayerInfo)
    Event.addListener(Event.ON_WAR_SITUATION_UPDATE, warSituationUI.UpdateWarSituationList)
    Event.addListener(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS, UpdatePlayerInfo)
    Event.addListener(Event.BASE_EXILE, OnExile)
    -- 背景特效
    -- UIManager.creatParticle(view.EffectBg, UIManager.ParticlePath.MainCity_Bg)
end

function _C:onOpen()
    view.State_C.selectedIndex = 0
    UpdatePlayerInfo()
    UpdateCurrencyInfo()
    UpdateProsperityInfo()
    UpdateBuildingTags()
    UpdateCurrentTaskInfo()
    warSituationUI:UpdateWarSituationList()
end

function _C:onShow()
    UpdateBaseState()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
        Event.addListener(Event.STAGE_ON_CLICK, StageOnClick)
    else
        Event.removeListener(Event.STAGE_ON_CLICK, StageOnClick)
    end
end

function _C:onDestroy()
    Event.removeListener(Event.PLAYER_INFO_UPDATE, UpdatePlayerInfo)
    Event.removeListener(Event.CURRENCY_CURRENT_UPDATE, UpdateCurrencyInfo)
    Event.removeListener(Event.PROSPERITY_UPDATE, UpdateProsperityInfo)
    Event.removeListener(Event.BUILDING_UPGRADE, UpgradeBuildingSuccess)
    Event.removeListener(Event.ENTER_MAIN_CITY, GotoMyCity)
    Event.removeListener(Event.ENTER_OUTSIDE, GotoWorldMap)
    Event.removeListener(Event.LOADING_MAINCITY_SUCCESS, UpdateBuildingTags)
    Event.removeListener(Event.UDPATE_TASK, UpdateCurrentTaskInfo)
    Event.removeListener(Event.NEW_TASK, UpdateCurrentTaskInfo)
    Event.removeListener(Event.UPGRADE_BASE, MainCityUpgradeSuccess)
    Event.removeListener(Event.ON_JOINED_GUILD, UpdatePlayerInfo)
    Event.removeListener(Event.ON_LEAVE_GUILD, UpdatePlayerInfo)
    Event.removeListener(Event.MONARCHS_UPDATE_HERO_FIGHT_AMOUNT, UpdatePlayerInfo)
    Event.removeListener(Event.YUANBAO_UPDATE, UpdatePlayerInfo)
    Event.removeListener(Event.ON_WAR_SITUATION_UPDATE, warSituationUI.UpdateWarSituationList)
    Event.removeListener(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS, UpdatePlayerInfo)
    Event.removeListener(Event.BASE_EXILE, OnExile)
end