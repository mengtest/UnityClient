local _C = UIManager.Controller(UIManager.ControllerName.CaptainEquipMain, UIManager.ViewName.CaptainEquipMain)
local _CCaptainList = require(UIManager.ControllerName.CaptainList)
local _CCaptainPart = require(UIManager.ControllerName.CaptainPart)
local _CEquipList = require(UIManager.ControllerName.CaptainEquipList)
local _CStrength = require(UIManager.ControllerName.CaptainEquipStrength)
--local _CGemList = require(UIManager.ControllerName.CaptainGemList)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CCaptainList)
table.insert(_C.SubCtrl, _CCaptainPart)
table.insert(_C.SubCtrl, _CEquipList)
table.insert(_C.SubCtrl, _CStrength)
table.insert(_C.SubCtrl, _CchatBrief)
--table.insert(_C.SubCtrl, _CGemList)

-- 外部传入数据 {CaptainId = 0,PartType = 0 }
_C.incomingInfo = nil

local view = nil

-- 返回
local function btnBack()
    _C:close()
end
-- 打开面板
local function btnToEquipGemPanel()
    view.EquipPanelStat.selectedIndex = 3
end
-- 打开面板
local function btnToEquipRefinePanel()
    view.EquipPanelStat.selectedIndex = 2
end
-- 打开面板
local function btnToEquipUpgradePanel()
    view.EquipPanelStat.selectedIndex = 1
end
-- 打开面板
local function btnToEquipInfoPanel()
    view.EquipPanelStat.selectedIndex = 0
end

-- 武将点击
function _C:onGeneralClick(insInfo, partType)
    _CCaptainPart:onGeneralClick(insInfo, partType)
    _CEquipList:onGeneralClick(insInfo, partType)
    _CStrength:onGeneralClick(insInfo, partType)
--    _CGemList:onGeneralClick(insInfo, partType)
end
-- 槽位点击
function _C:onPartClick(partType)
    _CStrength:onPartClick(partType)
--    _CGemList:onPartClick(partType)
end
function _C:onCreat()
    view = _C.View
    _CCaptainList.view = view
    _CCaptainPart.view = view
    _CEquipList.view = view
    _CStrength.view = view
--    _CGemList.view = view
    _CCaptainList.parent = _C
    _CCaptainPart.parent = _C
    _CEquipList.parent = _C
    _CStrength.parent = _C
--    _CGemList.parent = _C

    view.BtnBack.onClick:Add(btnBack)
    view.BtnEquip.onClick:Add(btnToEquipInfoPanel)
    view.BtnRefine.onClick:Add(btnToEquipRefinePanel)
    view.BtnUpdate.onClick:Add(btnToEquipUpgradePanel)
    view.BtnGem.onClick:Add(btnToEquipGemPanel)
end

function _C:onOpen(data)
    _C.incomingInfo = data
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnEquip.onClick:Clear()
    view.BtnRefine.onClick:Clear()
    view.BtnUpdate.onClick:Clear()
    view.BtnGem.onClick:Clear()
end
