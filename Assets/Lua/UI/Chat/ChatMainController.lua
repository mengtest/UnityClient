local _C = UIManager.Controller(UIManager.ControllerName.ChatMain, UIManager.ViewName.ChatMain)
local _CRecently = require(UIManager.ControllerName.ChatRecently)
local _CContents = require(UIManager.ControllerName.ChatContents)
table.insert(_C.SubCtrl, _CRecently)
table.insert(_C.SubCtrl, _CContents)

local view

-- 返回
local function btnBack()
    _C:close()
end

function _C:onCreat()
    view = _C.View
    _CRecently.view = view
    _CContents.view = view
    _CRecently.Contents = _CContents

    view.BtnBack.onClick:Add(btnBack)
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()
end

