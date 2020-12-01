local _C = UIManager.Controller(UIManager.ControllerName.GeneralChangeRace, UIManager.ViewName.GeneralChangeRace)
local view = nil

-- 武将数据
local captainsData = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains
-- 道具数据
local itemsData = DataTrunk.PlayerInfo.ItemsData
-- 当前武将数据
local selectedCaptainData = nil
-- 当前选中的index
local selectedCaptainIndex = 0
-- 武将id
local myData = { }
-- 当前选中职业
local selectedRace
-- 点击职业
local clickedRace
-- 是否使用道具转职
local isUseYuanbao = nil
-- Cd时间变量声明
local changeRaceTimer = nil

local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    local itemInfo = captainsData[myData[index + 1]]
    -- 填充数据
    local levelLab = obj:GetChild("txt_gji")
    levelLab.text = itemInfo.Level
    local qualityCtrl = obj:GetController("pinzhi")
    qualityCtrl.selectedIndex = itemInfo.Quality - 2
    local headIcon = obj:GetChild("loader_wujiang")
    headIcon.url = itemInfo.Head
    local nameLable = obj:GetChild("title")
    nameLable.text = itemInfo.Name
end

-- 更新武将id(武将更新)
local function UpdateGeneralIDList()

    -- 没有武将关闭界面
    if Utils:GetTableLength(captainsData) == 0 then
        _C:close()
        return
    end
    myData = { }
    for k, v in pairs(captainsData) do
        if v == nil then
            break
        end
        table.insert(myData, k)
    end
end

local function TimerStart()
    view.UI:GetController("State_C").selectedIndex = 1
    view.ChangeRaceBtn.grayed = true
    view.ChangeRaceBtn.touchable = false
    view.ConditionTimeLab.visible = true
end

local function TimerUpdate( t, p )
    view.ConditionTimeLab.text = Utils.secondConversion(math.ceil(p))
end

local function TimerComplete()
    view.UI:GetController("State_C").selectedIndex = 0
    view.ChangeRaceBtn.grayed = false
    view.ChangeRaceBtn.touchable = true
    view.ConditionTimeLab.visible = false
end

local function TimerMaker()
    if selectedCaptainData == nil then
        return
    end
    -- 判断是否在CD时间内
    local time = selectedCaptainData.RaceCdEndTime - TimerManager.currentTime
    if time > 0 then
        changeRaceTimer = TimerManager.newTimer(time, false, true, TimerStart, TimerUpdate, TimerComplete)
        changeRaceTimer:start()
    else
        view.UI:GetController("State_C").selectedIndex = 0
    end
end

local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    selectedCaptainIndex = index
    selectedCaptainData = captainsData[myData[index + 1]]
    view.SelectedGeneralQualityControl.selectedIndex = selectedCaptainData.Quality - 1
    view.GeneralHeadIcon.url = selectedCaptainData.Head
    view.GeneralRaceIcon.url = UIConfig.Race[selectedCaptainData.Race]
    view.GeneralLevelLab.text = selectedCaptainData.Level
    for i = 1, 5 do
        if i == selectedCaptainData.Race then
            view.RaceBtnList[i].selected = true
            selectedRace = i
        else
            view.RaceBtnList[i].selected = false
        end
    end
    -- 等级判断
    if selectedCaptainData.Level >= MiscCommonConfig.Config.CaptainChangeRaceLevel then
        view.ConditionLevelLab.visible = false
        view.ConditionDescLab.visible = false
    else
        view.ConditionLevelLab.visible = true
        view.ConditionDescLab.visible = true
        view.ConditionLevelLab.text = MiscCommonConfig.Config.CaptainChangeRaceLevel
    end
    TimerComplete()
    TimerMaker()   
end

local function onTryClickRace()
    if clickedRace == selectedRace then
        return
    end
    for i = 1, 5 do
        if i == clickedRace then
            view.RaceBtnList[i].selected = true
            selectedRace = i
        else
            view.RaceBtnList[i].selected = false
        end
    end
end

local function onConfirmToChangeRace()
     NetworkManager.C2SChangeCaptainRaceProto(selectedCaptainData.Id, selectedRace, isUseYuanbao)
end

local function onChangeRace()
    -- 武将不在主城
    if selectedCaptainData.OutSide then
        UIManager.showTip(Localization.GeneralOutSide)
        return
    end
    -- 检查是否有转职卡
    -- TODO:转职道具ID
    if itemsData:checkItemExists(GoodsCommonConfig.Config.CaptainChangeRaceGood.Id, 1) then
        isUseYuanbao = false
        local data = {
            UIManager.PopupStyle.ContentYesNo,
            content = string.format(Localization.UseItemToChangeRace,MiscCommonConfig.Config.CaptainChangeRaceCD),
            btnTitle = { Localization.Cancel, Localization.Confirm },
            btnFunc = onConfirmToChangeRace,
        }
         UIManager.openController(UIManager.ControllerName.Popup, data)
    else if ItemsConfig.Config[GoodsCommonConfig.Config.CaptainChangeRaceGood.Id].YuanBaoPrice <= DataTrunk.PlayerInfo.MonarchsData.Money then
    -- 使用元宝
        isUseYuanbao = true
        local data = {
            UIManager.PopupStyle.ContentYesNo,
            content = string.format(Localization.UseYuanBaoToChangeRace,ItemsConfig.Config[GoodsCommonConfig.Config.CaptainChangeRaceGood.Id].YuanBaoPrice,MiscCommonConfig.Config.CaptainChangeRaceCD),
            btnTitle = { Localization.Cancel, Localization.Confirm },
            btnFunc = onConfirmToChangeRace,
        }
         UIManager.openController(UIManager.ControllerName.Popup, data)
    else
        UIManager.showTip(Localization.ItemNotEnough)
    end
end
end

local function ChangeRaceSucc(data)
    UIManager.showTip(Localization.ChangeRaceSuccess)
    selectedCaptainData.Race = data.race
    selectedCaptainData.RaceCdEndTime = data.cooldown
    view.GeneralList:RefreshVirtualList()
    view.GeneralList:GetChildAt(selectedCaptainIndex).onClick:Call()
end

function _C:onCreat()
    view = _C.View

    view.BackBtn.onClick:Set( function() _C:close() end)
    view.ChangeRaceBtn.onClick:Set(onChangeRace)
    Event.addListener(Event.GENERAL_CHANGE_RACE_SUCCESS, ChangeRaceSucc)
end

function _C:onOpen(index)
    UpdateGeneralIDList()  
    view.GeneralList.onClickItem:Add(onItemClick)
    view.GeneralList.itemRenderer = onItemRender 
    view.GeneralList.numItems = #myData
    if #myData > 0 then
        view.GeneralList:GetChildAt(selectedCaptainIndex).onClick:Call()
    end

    for i = 1, 5 do
        view.RaceBtnList[i].onClick:Set(
        function()
            clickedRace = i
            onTryClickRace()
        end)
    end
end
function _C:onInteractive(isOk)
end
function _C:onDestroy()
    TimerManager.disposeTimer(changeRaceTimer)

    Event.removeListener(Event.GENERAL_CHANGE_RACE_SUCCESS, ChangeRaceSucc)
end