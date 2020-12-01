local _C = UIManager.Controller(UIManager.ControllerName.PracticeHall, UIManager.ViewName.PracticeHall)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
local _CpracticeHallPractice = require(UIManager.ControllerName.PracticeHallPractice)
table.insert(_C.SubCtrl, _CchatBrief)
table.insert(_C.SubCtrl, _CpracticeHallPractice)

local view = nil

-- 返回按钮
local function BackBtnOnClick()
    _C:close()
end

function _C:onCreat()
    view = _C.View
    _CpracticeHallPractice.view = view

    view.BackBtn.onClick:Set(BackBtnOnClick)

    -- 临时代码
    view.UI:GetChild("btn_zhuansheng").visible = false
    view.UI:GetChild("btn_zhuanzhi").visible = false
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end