local _C = UIManager.Controller(UIManager.ControllerName.Pvp100RankSalary, UIManager.ViewName.Pvp100RankSalary)
_C.IsPopupBox = true

local view = nil

-- θΏε
local function btnBack()
    _C:close()
end
-- ι’ε
local function btnToCollect()
end

function _C:onCreat()
    view = _C.View
    view.BtnBack.onClick:Add(btnBack)
    view.BtnBack_2.onClick:Add(btnBack)
end

function _C:onOpen(data)
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnBack_2.onClick:Clear()
end
