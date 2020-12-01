local _C = UIManager.Controller(UIManager.ControllerName.MutualRestraint, UIManager.ViewName.MutualRestraint)
_C.IsPopupBox = true
local view = nil

local function CloseBtnOnClick()
    _C:close()
end

function _C:onCreat()
    view = _C.View

    view.CloseBtn.onClick:Set(CloseBtnOnClick)
end