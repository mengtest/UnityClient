local UIController = UIManager.SubController(UIManager.ControllerName.InvadeListMain)
UIController.view = nil
UIController.InvadeData = { }
UIController.InvadeCount = 0
UIController.ViewOthers = false

function UIController:onCreat()
    UIController.view.ToggleCtr.selectedIndex = 1
    UIController.view.VisibleCtr.selectedIndex = 1
    UIController.view.ButtonExpandCtl.selectedIndex = 0
    UIController.view.MilitaryList.itemRenderer = self.MilityListRenderer
    UIController.view.MilitaryList.numItems = 0
    Event.addListener(Event.CAMPSITE_INVADE_INFO, self.InvadeInfo)
    Event.addListener(Event.CAMPSITE_INVADE_ADD, self.InvadeAdd)
    Event.addListener(Event.CAMPSITE_INVADE_REMOVE, self.InvadeRemove)
    Event.addListener(Event.ON_VIEW_OTHER_HERO, self.ViewOther)
    Event.addListener(Event.CHANGE_REGION, self.RegionChanged)
    Event.addListener(Event.OTHER_CHANGE_NAME_SUCCESS, self.UpdatePlayerName)
end

function UIController.InvadeInfo(data)
    UIController.InvadeCount = 0
    for i = 1, #data.hero_id do
        UIController.InvadeData[i] = UIController.SetInvadeData(data.hero_id[i], data.hero_name[i], data.flag_name[i], data.base_x[i], data.base_y[i])
        UIController.InvadeCount = UIController.InvadeCount + 1
    end
    UIController.view.MilitaryList.numItems = UIController.InvadeCount
    UIController.SetUIExpand()
end

function UIController.InvadeAdd(data)
    for i, v in ipairs(UIController.InvadeData) do
        if v.ID == data.hero_id then
            UIController.InvadeData[i] = UIController.SetInvadeData(data.hero_id, data.hero_name, data.flag_name, data.base_x, data.base_y)
            UIController.view.MilitaryList.numItems = UIController.InvadeCount
            return
        end
    end

    table.insert(UIController.InvadeData, UIController.SetInvadeData(data.hero_id, data.hero_name, data.flag_name, data.base_x, data.base_y))
    UIController.InvadeCount = UIController.InvadeCount + 1
    UIController.view.MilitaryList.numItems = UIController.InvadeCount
    UIController.view.EventCount.text = UIController.InvadeCount
end

function UIController.InvadeRemove(data)
    for i, v in ipairs(UIController.InvadeData) do
        if v ~= nil and v.ID == data.hero_id then
            UIController.InvadeData[i] = nil
            UIController.InvadeCount = UIController.InvadeCount - 1
            UIController.view.MilitaryList.numItems = UIController.InvadeCount
            UIController.view.EventCount.text = UIController.InvadeCount
            break
        end
    end
end

function UIController.UpdatePlayerName(data)
    for i, v in ipairs(UIController.InvadeData) do
        if v.ID == data.id then
            v.Name = data.name
            break
        end
    end
    UIController.view.MilitaryList.numItems = UIController.InvadeCount
end

function UIController.SetUIExpand()
    if UIController.InvadeCount > 0 then
        -- 面板展开
        UIController.view.ToggleCtr.selectedIndex = 0
        -- 点击按钮显示
        UIController.view.ButtonExpandCtl.selectedIndex = 0
        -- 显示个数
        UIController.view.VisibleCtr.selectedIndex = 0
        UIController.view.EventCount.text = UIController.InvadeCount
    else
        -- 面板收起
        UIController.view.ToggleCtr.selectedIndex = 1
        -- 点击按钮隐藏
        UIController.view.ButtonExpandCtl.selectedIndex = 1
    end
end

function UIController.ViewOther(data)
    if data == nil or not UIController.IsOpen or not UIController.ViewOthers then
        return
    end
    UIController.ViewOthers = false
    UIManager.openController(UIManager.ControllerName.Lords, data)
end

function UIController.RegionChanged(id)
    UIController.view.InvadeItem.visible = id == DataTrunk.PlayerInfo.MonarchsData.BaseMapId
end

function UIController.SetInvadeData(id, name, flag, x, y)
    local data = { }
    data.ID = id
    data.Name = name
    data.Flag = flag
    data.PosX = x
    data.PosY = y
    return data
end

function UIController.MilityListRenderer(index, obj)
    if UIController.InvadeData[index + 1].Flag == "" then
        obj:GetChild("text_lianmengmingzi").text = UIController.InvadeData[index + 1].Name
    else
        obj:GetChild("text_lianmengmingzi").text = string.format(Localization.AlliancePlayerName, UIController.InvadeData[index + 1].Flag, UIController.InvadeData[index + 1].Name)
    end
    obj:GetChild("text_zuobiao").text = string.format(Localization.LordsCoord, UIController.InvadeData[index + 1].PosX, UIController.InvadeData[index + 1].PosY)
    obj:GetChild("btn_komg1").onClick:Set(function() 
        NetworkManager.C2SViewOtherHero(UIController.InvadeData[index + 1].ID)
        UIController.ViewOthers = true
        end)
    obj:GetChild("btn_kong2").onClick:Set(function()
        LevelManager.CurrLevelLogic:moveCameraTo(UIController.InvadeData[index + 1].PosX, UIController.InvadeData[index + 1].PosY)
    end)
end

function UIController:onDestroy()
    UIController.view.MilitaryList.itemRenderer = nil
    Event.removeListener(Event.CAMPSITE_INVADE_INFO, self.InvadeInfo)
    Event.removeListener(Event.CAMPSITE_INVADE_ADD, self.InvadeAdd)
    Event.removeListener(Event.CAMPSITE_INVADE_REMOVE, self.InvadeRemove)
    Event.removeListener(Event.ON_VIEW_OTHER_HERO, self.ViewOther)
    Event.removeListener(Event.CHANGE_REGION, self.RegionChanged)
    Event.removeListener(Event.OTHER_CHANGE_NAME_SUCCESS, self.UpdatePlayerName)

    UIController.InvadeData = { }
    UIController.InvadeCount = 0
end

return UIController