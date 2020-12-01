local _C = UIManager.Controller(UIManager.ControllerName.GeneralSoulObtain, UIManager.ViewName.GeneralSoulObtain)
_C.IsPopupBox = true
local view = nil

function _C:onCreat()
    view = _C.View
    -- 按钮绑定
    view.BackBtn.onClick:Set( function() _C:close() end)
    -- 事件监听
    --Event.addListener(Event.GENERAL_RENAME_CUCCESS, GeneralRenameSucc)
end

function _C:onOpen(index)

end

function _C:onInteractive(isOk)
end

function _C:onDestroy()
    --Event.removeListener(Event.GENERAL_RENAME_CUCCESS, GeneralRenameSucc)
end