local _C = UIManager.Controller(UIManager.ControllerName.Battle3V3Log, UIManager.ViewName.Battle3V3Log)
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
-- 更新
local function updatePlayer(playerView, playerInfo, continumWinNum, campType)
    playerView:GetChild("TextField_WinNumber").text = "(" .. string.format(Localization.WinNum, continumWinNum) .. ")"
    if continumWinNum <= 0 then
        playerView:GetChild("TextField_WinNumber").text = ""
    end

    if nil ~= playerInfo.GuildFlagName and "" ~= playerInfo.GuildFlagName then
        playerView:GetChild("TextField_NameInfo").text = string.format("[%s]%s", playerInfo.GuildFlagName, playerInfo.Name)
    else
        playerView:GetChild("TextField_NameInfo").text = string.format("%s", playerInfo.Name)
    end

    playerView:GetController("State_C").selectedIndex = 0
    if continumWinNum >= 3 then
        playerView:GetController("State_C").selectedIndex = 1
    end

    if campType == CampType.Attacker then
        playerView:GetController("Type_C").selectedIndex = 0
    else
        playerView:GetController("Type_C").selectedIndex = 1
    end
end
-- item渲染
local function onItemRender(index, obj)
    local log = battleLog[index + 1]
    if log.IsAttackerWin then

        updatePlayer(obj:GetChild("Component_Winner"), log.Attacker, log.AttackerContinueWinNum, CampType.Attacker)
        updatePlayer(obj:GetChild("Component_Loser"), log.Defender, log.DefenderContinueWinNum, CampType.Defender)
    else
        updatePlayer(obj:GetChild("Component_Winner"), log.Defender, log.DefenderContinueWinNum, CampType.Defender)
        updatePlayer(obj:GetChild("Component_Loser"), log.Attacker, log.AttackerContinueWinNum, CampType.Attacker)
    end
end

-- 战报信息
local function getBattleLogInfo()
    view.BattleLogList.numItems = 0
    if nil ~= battleLog then
        view.BattleLogList.numItems = #battleLog
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
    view.BattleLogList.itemRenderer = onItemRender
    Event.addListener(Event.BATTLE_LOG_REFRESH, refreshLogInfo)
    Event.addListener(Event.BATTLE_OVER, btnBack)
end

function _C:onOpen(data)
    battleLog = data
    getBattleLogInfo()
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BattleLogList.itemRenderer = nil
    Event.removeListener(Event.BATTLE_LOG_REFRESH, refreshLogInfo)
    Event.removeListener(Event.BATTLE_OVER, btnBack)
end