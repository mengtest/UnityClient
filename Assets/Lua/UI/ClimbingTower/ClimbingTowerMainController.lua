local _C = UIManager.Controller(UIManager.ControllerName.ClimbingTowerMain, UIManager.ViewName.ClimbingTowerMain)
local _CSub = require(UIManager.ControllerName.ClimbingTowerBase)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CSub)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 共楼层
local towerTotalFloor = MiscCommonConfig.Config.TowerTotalFloor
-- 层数据
local floorList = { }
-- 层类型
local floorType = { BottomUI = 0, LeftUI = 1, RightUI = 2, TopUI = 3 }
-- 重楼实例化信息
local towerInsInfo = DataTrunk.PlayerInfo.TowerData
-- 最后点击对象
local lastClickItem = nil

-- 返回
local function btnBack()
    _C:close()
end
-- 设置当前塔层选择
local function setTowerFloor(floor)
    if floor > towerTotalFloor then
        floor = towerTotalFloor
    elseif floor < 0 then
        floor = 1
    end

    view.TowerFloorList:AddSelection(towerTotalFloor - floor, true)

    -- 选中当前
    local item = view.TowerFloorList:GetChild(tostring(floor))
    if nil ~= item then
        -- 执行事件
        item.onClick:Call()
    end
    -- 之前设置
    item = view.TowerFloorList:GetChild(tostring(floor - 1))
    if nil ~= item then
        -- 设置通过状态
        item:GetChild("Button_Mission"):GetController("State_C").selectedIndex = 2
    end
end
-- 更新当前爬塔楼层
local function updateTowerBaseInfo()
    if not _C.IsOpen then
        return
    end

    setTowerFloor(towerInsInfo.CurrentFloor + 1)
end
-- item点击
local function onItemClick(item)
    if nil ~= lastClickItem then
        lastClickItem:GetTransition("Selected_T"):Stop()
    end

    -- 最后一次点击对象
    lastClickItem = item.data
    -- 当前选中对象
    item.data:GetTransition("Selected_T"):Play(-1, 0, nil)
    -- 更新
    _CSub:updateFloorAwardInfo(tonumber(item.data.name))
end
-- item渲染
local function onItemRender(index, obj)
    local floorId = towerTotalFloor - index

    obj.name = tostring(floorId)

    obj:GetTransition("Selected_T"):Stop()
    local floorInfo = floorList[floorId]
    local floorDesc = obj:GetChild("Component_Description")
    floorDesc:GetChild("TextField_Number").text = floorInfo.Config.MonsterMaster.FightAmount
    floorDesc:GetChild("TextField_Description").text = floorInfo.Config.Desc

    local floorUI = obj:GetChild("Button_Mission")
    floorUI:GetChild("TextField_Floor").text = string.format(Localization.TowerCurFloor_1, floorId)
    -- 已经通过
    if towerInsInfo.HistoryMaxFloor >= floorId then
        floorUI:GetController("State_C").selectedIndex = 2
    else
        floorUI:GetController("State_C").selectedIndex = 0
    end
    -- 当前楼层
    if towerInsInfo.CurrentFloor + 1 == floorId and towerInsInfo.HistoryMaxFloor <= towerInsInfo.CurrentFloor then
        floorUI:GetController("State_C").selectedIndex = 1
    end
end 
-- item供应者
local function onItemProvider(index)
    local floor = floorList[index + 1]
    if floor.Type == floorType.BottomUI then
        return view.BottomUI
    elseif floor.Type == floorType.LeftUI then
        return view.LeftUI
    elseif floor.Type == floorType.RightUI then
        return view.RightUI
    elseif floor.Type == floorType.TopUI then
        return view.TopUI
    end
end
-- 获取千重楼信息
local function getFloorInfo()
    local iquo, irem
    for i = 1, towerTotalFloor, 1 do
        iquo, irem = math.modf(i / 2)
        if i == 1 then
            table.insert(floorList, { Type = floorType.TopUI, Config = TowerConfig:getConfigById(i) })
        elseif i == towerTotalFloor then
            table.insert(floorList, { Type = floorType.BottomUI, Config = TowerConfig:getConfigById(i) })
        else
            if irem == 0 then
                table.insert(floorList, { Type = floorType.LeftUI, Config = TowerConfig:getConfigById(i) })
            else
                table.insert(floorList, { Type = floorType.RightUI, Config = TowerConfig:getConfigById(i) })
            end
        end
    end
    view.TowerFloorList.scrollPane.snapToItem = false
    view.TowerFloorList.numItems = towerTotalFloor
end
-- 每日重置
local function dailyReset()
    if not _C.IsOpen then
        return
    end
    _C.onOpen(nil)
end

function _C:onCreat()
    view = _C.View
    _CSub.view = view

    view.BtnBack.onClick:Add(btnBack)
    view.TowerFloorList.itemRenderer = onItemRender
    view.TowerFloorList.itemProvider = onItemProvider
    view.TowerFloorList.onClickItem:Add(onItemClick)

    Event.addListener(Event.TOWER_CHALLENGE_SUCCEED, updateTowerBaseInfo)
    Event.addListener(Event.TOWER_AUTO_CHALLENGE_SUCCEED, updateTowerBaseInfo)
    Event.addListener(Event.TOWER_DAILY_RESET, _C.onOpen)
end
function _C:onOpen(data)
    getFloorInfo()
    setTowerFloor(towerInsInfo.CurrentFloor + 1)
    -- 处于战斗状态
    DataTrunk.PlayerInfo.MilitaryAffairsData.IsBattleState = true
end

function _C:onClose()
    DataTrunk.PlayerInfo.MilitaryAffairsData.IsBattleState = false
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.TowerFloorList.itemRenderer = nil
    view.TowerFloorList.itemProvider = nil
    view.TowerFloorList.onClickItem:Clear()

    Event.removeListener(Event.TOWER_CHALLENGE_SUCCEED, updateTowerBaseInfo)
    Event.removeListener(Event.TOWER_AUTO_CHALLENGE_SUCCEED, updateTowerBaseInfo)
    Event.removeListener(Event.TOWER_DAILY_RESET, _C.onOpen)
end
