local _C = UIManager.Controller(UIManager.ControllerName.BagMain, UIManager.ViewName.BagMain)
local _CDefault = require(UIManager.ControllerName.BagDefault)
local _CEquip = require(UIManager.ControllerName.BagEquip)
local _CTemp = require(UIManager.ControllerName.BagTemp)
local _CHandle = require(UIManager.ControllerName.BagHandle)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
local _CGem = require(UIManager.ControllerName.BagGem)
table.insert(_C.SubCtrl, _CDefault)
table.insert(_C.SubCtrl, _CEquip)
table.insert(_C.SubCtrl, _CGem)
table.insert(_C.SubCtrl, _CTemp)
table.insert(_C.SubCtrl, _CHandle)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil

-- 返回
local function btnBack()
    _C:close()
end
-- 当滚动进行
local function onListScroll()
    view:stopEffect()
end
-- 当滚动结束
local function onListScrollEnd()
    view.BagStat.selectedIndex = view.BagList.scrollPane.currentPageX
    view.BagEquipList:SelectNone()
    view.BagDefaultList:SelectNone()
    view.BagGemList:SelectNone()
    if nil ~= view.BagTempList then view.BagTempList:SelectNone() end
end
-- 按钮切换
local function btnToList(index)
    view.BagList:AddSelection(index, true)
end

function _C:onCreat(data)
    view = _C.View
    _CDefault.view = view
    _CEquip.view = view
    _CTemp.view = view
    _CGem.view = view
    _CHandle.view = view
    _CDefault.handle = _CHandle
    _CEquip.handle = _CHandle
    _CGem.handle = _CHandle
    _CTemp.handle = _CHandle

    view.BtnBack.onClick:Add(btnBack)
    view.BtnDefault.onClick:Add( function() btnToList(0) end)
    view.BtnEquip.onClick:Add( function() btnToList(1) end)
    view.BtnGemBag.onClick:Add( function() btnToList(2) end)
    view.BtnTempBag.onClick:Add( function() btnToList(3) end)
    view.BagList.scrollPane.onScroll:Add(onListScroll)
    view.BagList.scrollPane.onScrollEnd:Add(onListScrollEnd)
end

function _C:onOpen(data)
    view:initStat()
    view.BtnDefault.onClick:Call()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnDefault.onClick:Clear()
    view.BtnEquip.onClick:Clear()
    view.BtnGemBag.onClick:Clear()
    view.BtnTempBag.onClick:Clear()
    view.BagList.scrollPane.onScroll:Clear()
    view.BagList.scrollPane.onScrollEnd:Clear()
end