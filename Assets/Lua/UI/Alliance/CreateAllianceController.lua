local _C = UIManager.Controller(UIManager.ControllerName.CreateAlliance, UIManager.ViewName.CreateAlliance)
local view = nil
_C.IsPopupBox = true

local flagNameMinLength = 2
local flagNameMaxLength = 4
-- 联盟数据
local allianceData = nil

-- 创建按钮点击
local function CreateBtnOnClick()
    -- 联盟名称合法性 + 联盟旗号合法性 + 联盟旗号中文
    if Utils.isLegalName(view.NameLabel.text) and Utils.isLegalName(view.FlagNameLabel.text, flagNameMinLength, flagNameMaxLength) and Utils.isChinese(view.FlagNameLabel.text) then
        _C:close()
        NetworkManager.C2SCreateGuildProto(view.NameLabel.text, view.FlagNameLabel.text)
    end
end

-- 取消按钮点击
local function CancelBtnOnClick()
    _C:close()
end

function _C:onCreat()
    _C.IsPopupBox = true

    view = _C.View

    view.CreateBtn.onClick:Set(CreateBtnOnClick)
    view.BG.onClick:Set(CancelBtnOnClick)
    view.CloseBtn.onClick:Set(CancelBtnOnClick)
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData
    view.NameLabel.text = ""
    view.FlagNameLabel.text = ""
end