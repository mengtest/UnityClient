local _C = UIManager.Controller(UIManager.ControllerName.Notice, UIManager.ViewName.Notice)
local view = nil
_C.IsPopupBox = true

--关闭
local function BtnClose()
	_C:close()
end

function _C:onCreat()
    view = _C.View
   
	view.BtnBack.onClick:Add(BtnClose)
end

function _C:onOpen()
	view.Content.text = "测试文本"	
end

function _C:onDestroy()
	view.BtnBack.onClick:Clear()
	
    view = nil
end
