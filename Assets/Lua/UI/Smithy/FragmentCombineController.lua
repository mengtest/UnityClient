local _C = UIManager.Controller(UIManager.ControllerName.FragmentCombine, UIManager.ViewName.FragmentCombine)
_C.suitsData = { }
_C.selecltedSuite = nil

function _C:onCreat()
    Event.addListener(Event.SMITHY_COMBINE_SUITS_UPDATE, _C.OnUpdateSuits)
    Event.addListener(Event.SMITHY_COMBINE_SUIT_SUCCESS, _C.OnCombineSuccess)
    _C.View.BtnReturn.onClick:Set( function() _C:close() end)
    _C.View.BtnEquip.onClick:Set(_C.OpenEquipUI)

    _C.View.ListTab.itemRenderer = _C.TabItemRendererCallBack
    _C.View.ListFragment.itemRenderer = _C.FragmentItemRendererCallBack
end

function _C.OpenEquipUI()
    -- 武将个数判断
    if #DataTrunk.PlayerInfo.MilitaryAffairsData.Captains > 0 then
        UIManager.openController(UIManager.ControllerName.CaptainEquipMain)
    else
        UIManager.showTip( { content = Localization.CaptainNumZero, result = false })
    end
end

function _C:onOpen()
    if not _C:InitData() then
        UIManager.showTip( { content = Localization.FragementNotEnough, result = false })
        _C:close()
        return
    end
    _C.View.ListTab.selectedIndex = 0
    _C.OnSuiteBtnClick(1)
end

function _C:onDestroy()
    Event.removeListener(Event.SMITHY_COMBINE_SUITS_UPDATE, _C.OnUpdateSuits)
    Event.removeListener(Event.SMITHY_COMBINE_SUIT_SUCCESS, _C.OnCombineSuccess)

    _C.View.ListTab.itemRenderer = nil
    _C.View.ListFragment.itemRenderer = nil
end

function _C:InitData()
    local openedSuits = DataTrunk.PlayerInfo.ItemsData.SmithyCombineSuits
    if openedSuits == nil or Utils:GetTableLength(openedSuits) == 0 then
        return false
    end
    _C.suitsData = { }
    for i, v in ipairs(openedSuits) do
        table.insert(_C.suitsData, SmithyCombineConfig:getConfigById(v))
    end
    self:UpdateTabList()
    return true
end

function _C:UpdateTabList()
    self.View.ListTab.numItems = #self.suitsData
end

function _C.OnUpdateSuits()
    if not _C.IsOpen then
        return
    end
    self:UpdateTabList()
end

function _C.OnCombineSuccess()
    UIManager.showTip( { content = Localization.FragmentCombineSuccess, result = true })
    _C.UpdateFragmentCount()
end

function _C.TabItemRendererCallBack(index, obj)
    local title = obj:GetChild("Text_Title")
    if _C.suitsData[index + 1] ~= nil then
        title.text = _C.suitsData[index + 1].SuitName
    end

    obj.onClick:Add( function() _C.OnSuiteBtnClick(index + 1) end)
end

function _C.OnSuiteBtnClick(index)
    _C.selecltedSuite = _C.suitsData[index]
    if _C.selecltedSuite ~= nil then
        _C.View.ListFragment:ScrollToView(0)
        _C.View.ListFragment.numItems = #_C.selecltedSuite.EquipInfo
        _C.UpdateFragmentCount()
    end
end

function _C.UpdateFragmentCount()
    local count = 0
    if DataTrunk.PlayerInfo.ItemsData.Default[_C.selecltedSuite.FragmentId] ~= nil then
        count = DataTrunk.PlayerInfo.ItemsData.Default[_C.selecltedSuite.FragmentId].Amount
    end
    _C.View.FragmentCount.text = string.format(Localization.FragementCount, _C.selecltedSuite.SuitName, count)
end

function _C.FragmentItemRendererCallBack(index, obj)
    local equipInfo = _C.selecltedSuite.EquipInfo[index + 1]
    if equipInfo == nil then
        return
    end
    local equip = EquipsConfig:getConfigById(equipInfo.equipId)
    if equip == nil then
        return
    end
    obj:GetChild("Text_EquipmentName").text = equip.Name
    obj:GetChild("Text_EquipmentDescription").text = equip.Desc
    obj:GetChild("Text_EquipmentProperty").text = string.format(Localization.FragmentCombineAttriAdd, equip.BaseStat.Attack, equip.BaseStat.Strength)
    obj:GetChild("Text_Cost").text = string.format(Localization.FragmentCombineConsume, equipInfo.combineCost)
    obj:GetChild("Component_EquipmentIcon"):GetChild("Loader_Icon").icon = equip.Icon
    obj:GetChild("Button_Compound").onClick:Set( function() _C.OnMixBtnClick(equipInfo.combineId) end)
end

function _C.OnMixBtnClick(id)
    UIManager.openController(UIManager.ControllerName.Popup, { UIManager.PopupStyle.ContentYesNo, btnFunc = function() _C.SendMsgToServer(id) end, content = Localization.FragmentCombineConfirm })
end

function _C.SendMsgToServer(id)
    NetworkManager.C2SGoodsCombineProto(id, 1)
end