local _C = UIManager.Controller(UIManager.ControllerName.Farm, UIManager.ViewName.Farm)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil

local function BackBtnOnClick()
    _C:close()
end

local function CheckBtnOnClick()
    _C:close()
    Event.dispatch(Event.ENTER_OUTSIDE)
end

local function GoldBtnOnClick()
    print("gold button on click")
end

local function WoodBtnOnClick()
    print("wood button on click")
end

local function FoodBtnOnClick()
    print("food button on click")
end

local function StoneBtnOnClick()
    print("stone button on click")
end

local resData = {
    coverArea = { },
    outPut = { },
    harvest = { },
    coverAreaConflict = { },
    outputConflict = { },
    harvestConflict = { },
}

local function OnResourcePointUpdate()
    if not _C.IsOpen then
        return
    end

    -- data
    -- 内政
    local data = DataTrunk.PlayerInfo.InternalAffairsData
    -- 城池等级
    local mainCityLev = DataTrunk.PlayerInfo.MonarchsData.BaseLevel
    -- 拥有土地数量
    local goundCount = BuildingLayoutConfig:getGroundCountByBaseLevel(mainCityLev)
    -- UI
    -- 城池等级
    view.MainCityLev.text = mainCityLev
    -- 拥有土地数量
    view.GroundCount.text = goundCount
    -- 冲突土地数量
    view.ConflictCount.text = Utils.GetTableLength(data.ConflictResourcePointIdList)
    -- 闲置土地数量
    view.UnusedCount.text = goundCount - Utils.GetTableLength(data.ResourcePointInfo)

    -- 保存数据
    -- 占地数
    local coverArea = {
        [BuildingType.GoldMine] = 0,
        [BuildingType.Cropland] = 0,
        [BuildingType.Sawmill] = 0,
        [BuildingType.StonePit] = 0,
    }
    -- 产量
    local outPut = {
        [BuildingType.GoldMine] = 0,
        [BuildingType.Cropland] = 0,
        [BuildingType.Sawmill] = 0,
        [BuildingType.StonePit] = 0,
    }
    -- 可收获
    local harvest = {
        [BuildingType.GoldMine] = 0,
        [BuildingType.Cropland] = 0,
        [BuildingType.Sawmill] = 0,
        [BuildingType.StonePit] = 0,
    }
    -- 冲突占地数
    local coverAreaConflict = {
        [BuildingType.GoldMine] = 0,
        [BuildingType.Cropland] = 0,
        [BuildingType.Sawmill] = 0,
        [BuildingType.StonePit] = 0,
    }
    -- 冲突产量
    local outputConflict = {
        [BuildingType.GoldMine] = 0,
        [BuildingType.Cropland] = 0,
        [BuildingType.Sawmill] = 0,
        [BuildingType.StonePit] = 0,
    }
    -- 冲突可收获量
    local harvestConflict = {
        [BuildingType.GoldMine] = 0,
        [BuildingType.Cropland] = 0,
        [BuildingType.Sawmill] = 0,
        [BuildingType.StonePit] = 0,
    }
    local resourceType = 0

    for k, v in pairs(data.ResourcePointInfo) do
        resourceType = v.BuildingConfig.BuildingType
        coverArea[resourceType] = coverArea[resourceType] + 1
        outPut[resourceType] = outPut[resourceType] + v.Output
        harvest[resourceType] = harvest[resourceType] + v.Amount

        if v.Conflict then
            coverAreaConflict[resourceType] = coverAreaConflict[resourceType] + 1
            outputConflict[resourceType] = outputConflict[resourceType] + v.Output
            harvestConflict[resourceType] = harvestConflict[resourceType] + v.Amount
        end
    end
    
    -- 显示数据
    for k, v in pairs(view.ButtonList) do
        v.coverArea.text = coverArea[k]
        v.output.text = outPut[k] .. "/小时"
        v.harvest.text = harvest[k]

        if coverAreaConflict[k] == 0  then
            v.coverAreaConflict.visible = false
        else
            v.coverAreaConflict.visible = true
            v.coverAreaConflict.title = coverAreaConflict[k]
        end

        if outputConflict[k] == 0  then
            v.outputConflict.visible = false
        else
            v.outputConflict.visible = true
            v.outputConflict.title = "-" .. math.ceil(outputConflict[k]/outPut[k]) .. "%"
        end
        
        if harvestConflict[k] == 0  then
            v.harvestConflict.visible = false
        else
            v.harvestConflict.visible = true
            v.harvestConflict.title = "-" .. math.ceil(harvestConflict[k]/harvest[k]) .. "%"
        end
    end

    -- 状态显示控制
    if Utils.GetTableLength(data.ConflictResourcePointIdList) == 0 then
        if goundCount - Utils.GetTableLength(data.ResourcePointInfo) == 0 then
            view.State_C.selectedIndex = 3
        else
            view.State_C.selectedIndex = 2
        end
    else
        if goundCount - Utils.GetTableLength(data.ResourcePointInfo) == 0 then
            view.State_C.selectedIndex = 1
        else
            view.State_C.selectedIndex = 0
        end
    end
end

function _C:onCreat()
    view = _C.View
    view.BackBtn.onClick:Set(BackBtnOnClick)
    view.CheckBtn.onClick:Set(CheckBtnOnClick)
    view.Gold.btn.onClick:Set(GoldBtnOnClick)
    view.Wood.btn.onClick:Set(WoodBtnOnClick)
    view.Food.btn.onClick:Set(FoodBtnOnClick)
    view.Stone.btn.onClick:Set(StoneBtnOnClick)

    NetworkManager.C2SResourceBuildingProto()
    OnResourcePointUpdate()
    Event.addListener(Event.ALL_RESOURCE_POINT_UPDATE, OnResourcePointUpdate)
    Event.addListener(Event.RESOURCE_POINT_UPDATE, OnResourcePointUpdate)
    Event.addListener(Event.CREATE_RESOURCE_POINT, OnResourcePointUpdate)
    Event.addListener(Event.REBUILD_RESOURCE_POINT, OnResourcePointUpdate)
    Event.addListener(Event.ON_RESOURCE_POINT_CONFLICT, OnResourcePointUpdate)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)      
    end
end

function _C:onDestroy()
    Event.removeListener(Event.ALL_RESOURCE_POINT_UPDATE, OnResourcePointUpdate)
    Event.removeListener(Event.RESOURCE_POINT_UPDATE, OnResourcePointUpdate)
    Event.removeListener(Event.CREATE_RESOURCE_POINT, OnResourcePointUpdate)
    Event.removeListener(Event.REBUILD_RESOURCE_POINT, OnResourcePointUpdate)
    Event.removeListener(Event.ON_RESOURCE_POINT_CONFLICT, OnResourcePointUpdate)
end