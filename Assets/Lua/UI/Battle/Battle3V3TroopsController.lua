local _C = UIManager.Controller(UIManager.ControllerName.Battle3V3Troops, UIManager.ViewName.Battle3V3Troops)
_C.IsPopupBox = true

local view = nil
local players = nil
local playerProgress = nil

-- 返回
local function btnBack()
    if not _C.IsOpen then
        return
    end
    _C:close()
end

-- item渲染
local function onItemRender(index, obj)
    local curProgress = playerProgress[players[index + 1].Id]

    -- 君主信息
    obj:GetChild("TextFiled_Name").text = curProgress.Player.Name
    obj:GetChild("TextField_Fight").text = Localization.FightAmount_1 .. curProgress.Player.FightAmount

    -- 武将类型
    local race = obj:GetChild("Component_Race")
    for i = 1, 5 do
        if nil == curProgress.Player.TroopsList[i] or nil == curProgress.Player.TroopsList[i].Captain then
            race:GetChild("loader_icon" .. i).url = ""
        else
            race:GetChild("loader_icon" .. i).url = UIConfig.Race[curProgress.Player.TroopsList[i].Captain.RaceType]
        end
    end

    -- 当前状态
    if curProgress.HaveBattlesNum > 0 then
        if curProgress.ContinueWinNum < 1 then
            obj:GetController("State_C").selectedIndex = 3
        else
            obj:GetController("State_C").selectedIndex = 2
            obj:GetChild("TextField_Wait").text = string.format(Localization.WinNum, curProgress.ContinueWinNum)
        end
    elseif curProgress.InTheBattle then
        obj:GetController("State_C").selectedIndex = 1
    else
        obj:GetController("State_C").selectedIndex = 0
    end
end

-- 队伍信息
local function getTroopsInfo()
    view.TroopsList.numItems = 0
    if nil ~= players then
        view.TroopsList.numItems = #players
    end
end
-- 刷新战斗进展
local function refreshProgressInfo(queueId, attackWin, progress)
    if not _C.IsOpen then
        return
    end

    playerProgress = progress
    getTroopsInfo()
end
function _C:onCreat()
    view = self.View

    view.BtnBack.onClick:Add(btnBack)
    view.TroopsList.itemRenderer = onItemRender
    Event.addListener(Event.BATTLEFIELD_INFO_REFRESH, refreshProgressInfo)
    Event.addListener(Event.BATTLE_OVER, btnBack)
end

function _C:onOpen(data)
    players = data.player
    playerProgress = data.progress

    getTroopsInfo()
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.TroopsList.itemRenderer = nil
    Event.removeListener(Event.BATTLEFIELD_INFO_REFRESH, refreshProgressInfo)
    Event.removeListener(Event.BATTLE_OVER, btnBack)
end