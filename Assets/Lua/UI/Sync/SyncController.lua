local _C = UIManager.Controller(UIManager.ControllerName.Sync, UIManager.ViewName.Sync)
local timer = nil

_C.IsPopupBox = true

local function syncClose()
    if not _C.IsOpen then
        return
    end

    _C:close()
end

local function syncHide()
    _C.View:hide()
end
local function syncShow()
    _C.View:show()
end

function _C:onCreat()
    _C.View.Effect.autoPlayRepeat = -1
    _C.View.Effect.autoPlay = true

    Event.addListener(Event.SYNC_CLOSE, syncClose)

    timer = TimerManager.newTimer(0.5, false, true, syncHide, nil, syncShow)
end
function _C:onShow()
    timer:reset()
    timer:start()
end
function _C:onHide()
    timer:pause()
end
function _C:onDestroy()
    Event.removeListener(Event.SYNC_CLOSE, syncClose)

    TimerManager.disposeTimer(timer)
end
