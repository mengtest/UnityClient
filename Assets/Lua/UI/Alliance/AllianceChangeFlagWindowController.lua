local _C = UIManager.Controller(UIManager.ControllerName.AllianceChangeFlagWindow, UIManager.ViewName.AllianceChangeFlagWindow)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil

-- 点击关闭按钮
local function CloseBtnOnClick()
    _C:destroy(true)
end

-- 点击确认按钮
local function ConfirmBtnOnClick()
    local content = view.Input.text

    if Utils.isLegalName(content,2,4) then
        NetworkManager.C2SUpdateGuildNameProto(allianceData.Name, content)
        CloseBtnOnClick()
    end
end

-- 主要检测内容是否为空
local function InputOnChanged()
    view.ConfirmBtn.touchable = view.Input.text ~= ""
    view.ConfirmBtn.grayed = view.Input.text == ""
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set(CloseBtnOnClick)
    view.Input.onChanged:Set(InputOnChanged)
    view.ConfirmBtn.onClick:Set(ConfirmBtnOnClick)
    view.CloseBtn.onClick:Set(CloseBtnOnClick)
end

function _C:onOpen(data)
    allianceData = DataTrunk.PlayerInfo.AllianceData.MyAlliance
    -- 名字
    view.Name.text = allianceData.FlagName
    -- 消耗元宝
    view.YuanBao.text = GuildConfig.Config.ChangeGuildNameCost.YuanBao
    -- 状态重置
    view.Input.text = ""
    view.ConfirmBtn.touchable = false
    view.ConfirmBtn.grayed = true
end