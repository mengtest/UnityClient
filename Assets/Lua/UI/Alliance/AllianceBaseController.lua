local _C = UIManager.SubController(UIManager.ControllerName.AllianceBaseController, nil)
_C.view = nil

local view = nil

function _C:onCreat()
    view = _C.view
end

function _C:onDestroy()
end

return _C