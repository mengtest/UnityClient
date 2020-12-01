local _SubC = UIManager.SubController(UIManager.ControllerName.Outside, nil)
-- 玩家主城
local playerCityObj = nil
_SubC.view = nil
local _subOutsideMenu = require(UIManager.ControllerName.CityMenu)
table.insert(_SubC.SubCtrl, _subOutsideMenu)

-- 点到了城池模型
local function onCityClicked()
    if not _SubC.IsOpen then
        return
    end

    _subOutsideMenu:onClickGround()
end

-- 点到了资源点
local function onResourcePointClicked()
    if not _SubC.IsOpen then
        return
    end

    -- 打开菜单
    UIManager.openController(UIManager.ControllerName.ResourceMenu)
end

-- 点到了空地
local function onOpenSpaceClicked()
    if not _SubC.IsOpen then
        return
    end

    _subOutsideMenu:onClickGround()
end

-- 点到了行营
local function onCampsiteClick()
    if not _SubC.IsOpen then
        return
    end

    _subOutsideMenu:onClickGround()
end

-- 定位按钮点击
local function NavOnClick()
    local regionData = DataTrunk.PlayerInfo.RegionData
    local monarchData = DataTrunk.PlayerInfo.MonarchsData
    if regionData:getSelectRegion() == monarchData.BaseMapId or
       regionData:getSelectRegion() == monarchData.CampMap then 
        LevelManager.CurrLevelLogic.backCameraToMyCity()
    else
        regionData:setSelectRegion(monarchData.BaseMapId)
        LevelManager.loadScene(LevelType.WorldMap)
    end
end
-- 更新定位公里数字
local function UpdateNavMiles(miles)
    if not _SubC.IsOpen then
        return
    end
    if miles == -1 then
        _SubC.view.NavBtn.title = Localization.BackToMyBase
    else
        _SubC.view.NavBtn.title = string.format(Localization.WorldMapNavMiles, miles)    
    end
end

-- 势力按钮点击
local function InfluenceOnClick()
    LevelManager.CurrLevelLogic.showCityInfluenceInRange()
end

-- 势力按钮停止点击
local function InfluenceRelease()
    LevelManager.CurrLevelLogic.hideCityInfluenceInRange()
end

function _SubC:onCreat()
    _SubC.view.NavBtn.onClick:Set(NavOnClick)
    _SubC.view.InfluenceBtn.onTouchBegin:Set(InfluenceOnClick)
    _SubC.view.InfluenceBtn.onTouchEnd:Set(InfluenceRelease)

    Event.addListener(Event.HIT_CITY, onCityClicked)
    Event.addListener(Event.HIT_RESOURCE, onResourcePointClicked)
    Event.addListener(Event.HIT_OPEN_SPACE, onOpenSpaceClicked)
    Event.addListener(Event.UPDATE_NAV_MILES, UpdateNavMiles)
    Event.addListener(Event.HIT_CAMPSITE, onCampsiteClick)
end

function _SubC:onOpen()
    
end

function _SubC:onDestroy()
    Event.removeListener(Event.HIT_CITY, onCityClicked)
    Event.removeListener(Event.HIT_RESOURCE, onResourcePointClicked)
    Event.removeListener(Event.HIT_OPEN_SPACE, onOpenSpaceClicked)
    Event.removeListener(Event.UPDATE_NAV_MILES, UpdateNavMiles)
    Event.removeListener(Event.HIT_CAMPSITE, onCampsiteClick)
end

return _SubC