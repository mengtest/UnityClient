local _C = UIManager.Controller(UIManager.ControllerName.GiveToAllianceWindow, UIManager.ViewName.GiveToAllianceWindow)
_C.IsPopupBox = true

local view = nil

-- 点击取消按钮/赠送成功
local function CancelBtnOnClick()
    _C:destroy(true)
end

-- 点击确认按钮
local function ConfirmBtnOnClick()
    if view.NameInput.text == "" then
        UIManager.showTip( { content = Localization.AllianceNameCannotBeEmpty, result = false })
    elseif view.SilverInput.text == "" then
        UIManager.showTip( { content = Localization.SilverCannotBeEmpty, result = false })
    elseif not tonumber(view.SilverInput.text) then
        UIManager.showTip( { content = Localization.SilverOnlyNumber, result = false })
    elseif tonumber(view.SilverInput.text) <= 0 then
        UIManager.showTip( { content = Localization.SilverCannotBeZero, result = false })
    else
        UIManager.showTip( { content = string.format("假装送银两,名字为%s,银两为%s,附言为%s", view.NameInput.text, view.SilverInput.text, view.DescInput.text), result = true })
    end
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set(CancelBtnOnClick)
    view.ConfirmBtn.onClick:Set(ConfirmBtnOnClick)
    view.CancelBtn.onClick:Set(CancelBtnOnClick)
    
    Event.addListener(Event.ON_GIVE_TO_ALLIANCE_SUCCESS, CancelBtnOnClick)
end

function _C:onDestroy()
    Event.removeListener(Event.ON_GIVE_TO_ALLIANCE_SUCCESS, CancelBtnOnClick)
end