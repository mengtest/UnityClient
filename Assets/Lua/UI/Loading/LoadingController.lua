local _C = UIManager.Controller(UIManager.ControllerName.Loading, UIManager.ViewName.Loading)
local view = nil

-- 结束
local function loadComplete()
    if not _C.IsOpen then
        return
    end

    _C:close()
end

-- 进度
local function updateProgressInfo(p)
    if not _C.IsOpen then
        return
    end

    view.ProgressBar.value = p
end

function _C:onCreat()
    Event.addListener(Event.LOADING_COMPLETE, loadComplete)
    Event.addListener(Event.LOADING_UPDATE, updateProgressInfo)
end
function _C:onOpen(data)
    view = _C.View

    view.ProgressBar.value = 0
    view.ProgressBar.max = 100
end

function _C:onDestroy()
    Event.removeListener(Event.LOADING_COMPLETE, loadComplete)
    Event.removeListener(Event.LOADING_UPDATE, updateProgressInfo)

    view = nil
end