local _C = UIManager.SubController(UIManager.ControllerName.CaptainPart, nil)
_C.view = nil
_C.parent = nil

local handleCaptainIns = nil
local itemsInsData = DataTrunk.PlayerInfo.ItemsData

-- 套装界面
local function btnTaoZ()
    UIManager.openController(UIManager.ControllerName.CaptainPartTaoZ, handleCaptainIns)
end

-- 更新套装信息
local function updateTaoZInfo()
    if nil == handleCaptainIns.EquipTaoZ then
        _C.view:updateStarLv(_C.view.EquipTaoZLvList, 10, 0, UIConfig.Item.StarMiddleSize)
        _C.view.GeneralMorale.text = 0

    else
        _C.view:updateStarLv(_C.view.EquipTaoZLvList, 10, handleCaptainIns.EquipTaoZ.Level, UIConfig.Item.StarMiddleSize)
        _C.view.GeneralMorale.text = handleCaptainIns.EquipTaoZ.Morale
    end
end

-- 装备替换成功，升级成功，强化成功
local function onEquipInfoSyncAck(equipType)
    if not _C.IsOpen then
        return
    end

    _C.view:updatePartEquipInfo(_C.view.CaptainPart[itemsInsData:getPartEquipPanelId(equipType)], handleCaptainIns.Equips[equipType], Localization["EquipType" .. equipType])

    updateTaoZInfo()
end

-- 武将点击
function _C:onGeneralClick(captainInsInfo, partType)
    print("更新部件信息！！")
    handleCaptainIns = captainInsInfo
    if nil == captainInsInfo then
        return
    end
    for k, v in pairs(EquipType) do
        if v ~= EquipType.None then
            _C.view:updatePartEquipInfo(_C.view.CaptainPart[itemsInsData:getPartEquipPanelId(v)], handleCaptainIns.Equips[v], Localization["EquipType" .. v])
        end
    end
    updateTaoZInfo()
end

function _C:onCreat()
    _C.view.BtnTaoZ_1.onClick:Add(btnTaoZ)

    Event.addListener(Event.EQUIP_REPLACE_SUCCEED, onEquipInfoSyncAck)
    Event.addListener(Event.EQUIP_UPGRADE_SUCCEED, onEquipInfoSyncAck)
    Event.addListener(Event.EQUIP_REFINE_SUCCEED, onEquipInfoSyncAck)
end

function _C:onOpen()
end

function _C:onDestroy()
    _C.view.BtnTaoZ_1.onClick:Clear()
    Event.removeListener(Event.EQUIP_REPLACE_SUCCEED, onEquipInfoSyncAck)
    Event.removeListener(Event.EQUIP_UPGRADE_SUCCEED, onEquipInfoSyncAck)
    Event.removeListener(Event.EQUIP_REFINE_SUCCEED, onEquipInfoSyncAck)
end

return _C