local _C = UIManager.Controller(UIManager.ControllerName.AllianceRankingWindow, UIManager.ViewName.AllianceRankingWindow)
_C.view = nil

local view = nil

function _C:onCreat()
    view = _C.view
end

function _C:onDestroy()
end