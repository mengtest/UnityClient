local _C = UIManager.Controller(UIManager.ControllerName.Pvp100RankLevel, UIManager.ViewName.Pvp100RankLevel)
_C.IsPopupBox = true

local view = nil

function _C:onCreat()
    view = _C.View
end

function _C:onOpen(data)
end

function _C:onDestroy()
end
