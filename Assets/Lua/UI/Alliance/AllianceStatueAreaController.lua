local UIController = UIManager.Controller(UIManager.ControllerName.StatueArea, UIManager.ViewName.StatueArea)

UIController.area = nil

function UIController:onCreat()
    self.IsPopupBox = true
    self.View.StatueAreaBg.onClick:Set(self.OnBgClick)
    self.View.StatueAreaList:SetVirtual()
    self.View.StatueAreaList.itemRenderer = self.ItemRenderer
    Event.addListener(Event.GET_REGION_LIST, self.OnAreaUpdate)
end

function UIController:onOpen()
    UIController.OnAreaUpdate()
end

function UIController.OnBgClick()
    UIController:close()
end

function UIController.OnAreaUpdate()
    UIController.area = DataTrunk.PlayerInfo.RegionData.RegionSort
    UIController.View.StatueAreaList.numItems = #UIController.area
end

function UIController.ItemRenderer(index, obj)
    local regionId = UIController.area[index + 1]
    obj.onClick:Set( function() NetworkManager.C2SPlaceGuildStatueProto(regionId, 0, 0) end)
    obj.text = DataTrunk.PlayerInfo.RegionData:getRegionNameById(regionId)
end

function UIController:onDestroy()
    self.View.StatueAreaBg.onClick:Clear()
    self.View.StatueAreaList.itemRenderer = nil
    Event.removeListener(Event.GET_REGION_LIST, self.OnAreaUpdate)
end


return UIController