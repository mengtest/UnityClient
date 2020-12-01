local _C = UIManager.SubController(UIManager.ControllerName.AllianceCityController, nil)
_C.view = nil

local view = nil

function _C:onCreat()
    view = _C.view
end

function _C:onDestroy()
end

return _C