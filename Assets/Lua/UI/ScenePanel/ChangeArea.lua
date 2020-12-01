local UIController = UIManager.SubController(UIManager.ControllerName.ChangeArea)
UIController.view = nil
UIController.regions = nil
UIController.selected = 0

function UIController:onCreat()
    self.view.changeAreaButtonWorld.onClick:Set(self.OnClickButtonWorld)
    self.view.changeAreaLeftArrow.onClick:Set(self.OnLeftArrowClick)
    self.view.changeAreaRightArrow.onClick:Set(self.OnRightArrowClick)
    self.view.changeAreaList:SetVirtual()
    self.view.changeAreaList.itemRenderer = self.ItemRenderer
    Event.addListener(Event.GET_REGION_LIST, self.OnRegionListUpdate)
    Event.addListener(Event.CHANGE_REGION, self.OnRegionChange)
end

function UIController.OnClickButtonWorld()
    -- 名城UI入口
end

function UIController.OnLeftArrowClick()
    -- 往左切换
    local regionId = nil
    if UIController.selected == 1 then
        regionId = UIController.regions[#UIController.regions]
    else
        regionId = UIController.regions[UIController.selected - 1]
    end
    UIController.GoToRegion(regionId)
end

function UIController.OnRightArrowClick()
    -- 往右切换
    local regionId = nil
    if UIController.selected == #UIController.regions then
        regionId = UIController.regions[1]
    else
        regionId = UIController.regions[UIController.selected + 1]
    end
    UIController.GoToRegion(regionId)
end

function UIController.ItemRenderer(index, obj)
    if index + 1 == UIController.selected then
        obj.grayed = true
        obj.onClick:Clear()
    else
        obj.grayed = false
        obj.onClick:Set(function()
            DataTrunk.PlayerInfo.RegionData:setSelectRegion(UIController.regions[index + 1])
            LevelManager.loadScene(LevelType.WorldMap)
        end)
    end
    obj.text = DataTrunk.PlayerInfo.RegionData:getRegionNameById(UIController.regions[index + 1])
end

-- 切换地区
function UIController.GoToRegion(id)
    DataTrunk.PlayerInfo.RegionData:setSelectRegion(id)
    LevelManager.loadScene(LevelType.WorldMap)
end

-- 收到地区更新时获取地区列表
function UIController.OnRegionListUpdate()
    UIController.regions = DataTrunk.PlayerInfo.RegionData:getRegionSort()
end

-- 当地区切换时更新选中地区和地区列表
function UIController.OnRegionChange(id)
    for i, v in ipairs(UIController.regions) do
        if v == id then
            UIController.selected = i
            break
        end
    end

    UIController.view.changeAreaList.numItems = #UIController.regions
    UIController.view.changeAreaCurrent.text = DataTrunk.PlayerInfo.RegionData:getRegionNameById(id)
end

function UIController:onDestroy()
    self.view.changeAreaButtonWorld.onClick:Clear()
    self.view.changeAreaLeftArrow.onClick:Clear()
    self.view.changeAreaRightArrow.onClick:Clear()
    self.view.changeAreaList.itemRenderer = nil
    Event.removeListener(Event.GET_REGION_LIST, self.OnRegionListUpdate)
    Event.removeListener(Event.CHANGE_REGION, self.OnRegionChange)
end

return UIController