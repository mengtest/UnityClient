local _C = UIManager.Controller(UIManager.ControllerName.GeneralRename, UIManager.ViewName.GeneralRename)
_C.IsPopupBox = true
local view = nil
-- 武将数据
local captainsData = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains
-- 当前武将数据
local curCaptainData = nil

local function Rename()
    local newName = view.InputNewName.text

    if Utils.isLegalName(newName,1) then
        NetworkManager.C2SChangeCaptanNameProto(curCaptainData.Id, newName)
    end
end

local function GeneralRenameSucc(id, name)
    curCaptainData.Name = name

    _C:close()
end

function _C:onCreat()
    view = _C.View

    view.BtnRename.onClick:Set(Rename)
    view.BtnClose.onClick:Set( function() _C:close() end)

    Event.addListener(Event.GENERAL_RENAME_SUCCESS, GeneralRenameSucc)
end

function _C:onOpen(generalId)
    curCaptainData = captainsData[generalId]
    view.Price.title = MiscCommonConfig.Config.ChangeCaptainNameCost.YuanBao
end

function _C:onInteractive(isOk)
end

function _C:onDestroy()
    Event.removeListener(Event.GENERAL_RENAME_SUCCESS, GeneralRenameSucc)
end