local _C = UIManager.Controller(UIManager.ControllerName.BattleProgress, UIManager.ViewName.BattleProgress)
_C.IsPopupBox = true

local view = nil
local battleLog = nil

-- 返回
local function btnBack()
    if not _C.IsOpen then
        return
    end
    _C:close()
end
-- item渲染
local function onItemRender(index, obj)
    local log = battleLog[index + 1]

    obj:GetChild("Text_Details").text = log
end

-- 战报信息
local function getBattleLogInfo()
    if nil ~= battleLog then
        -- 滚动至底部
        view.BattleLogList.numItems = #battleLog
        view.BattleLogList:ScrollToView(#battleLog - 1, true)
    end
end
-- 刷新战报
local function refreshLogInfo(logInfo)
    if not _C.IsOpen then
        return
    end

    battleLog = logInfo
    getBattleLogInfo()
end
function _C:onCreat()
    view = self.View

    view.BtnBack.onClick:Add(btnBack)
    view.BtnBack_2.onClick:Add(btnBack)

    view.BattleLogList.itemRenderer = onItemRender
    Event.addListener(Event.BATTLE_PROGRESS_REFRESH, refreshLogInfo)
    Event.addListener(Event.BATTLE_OVER, btnBack)
end

function _C:onOpen(data)
    view.BattleLogList.numItems = 0
    
    battleLog = data
    getBattleLogInfo()
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnBack_2.onClick:Clear()

    view.BattleLogList.itemRenderer = nil
    Event.removeListener(Event.BATTLE_PROGRESS_REFRESH, refreshLogInfo)
    Event.removeListener(Event.BATTLE_OVER, btnBack)
end