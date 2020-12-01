local _C = UIManager.Controller(UIManager.ControllerName.Battle3V3Main, UIManager.ViewName.Battle3V3Main)
local _CHud = require(UIManager.ControllerName.BattleHUD)
table.insert(_C.SubCtrl, _CHud)

local view = nil
-- 回放信息
local battleReplayInfo = nil
-- 战报信息
local battleLogInfo = nil
-- 进度信息
local battleProgress = nil
-- 攻击队伍剩下
local attackerLeftNum = 0
-- 防御队伍剩下
local defenderLeftNum = 0

-- 所有攻击方队伍
local function btnAllAttacker()
    UIManager.openController(UIManager.ControllerName.Battle3V3Troops, { player = battleReplayInfo.AttackerPlayer, progress = battleProgress })
end
-- 所有防御方队伍
local function btnAllDefender()
    UIManager.openController(UIManager.ControllerName.Battle3V3Troops, { player = battleReplayInfo.DefenserPlayer, progress = battleProgress })
end
-- 战报
local function btnBattleLog()
    UIManager.openController(UIManager.ControllerName.Battle3V3Log, battleLogInfo)
end
-- 跳过
local function btnToSkip()
    -- 跳过
    LevelManager.CurrLevelLogic:skip()
end
-- 战斗结束
local function battleOver()
    if not _C.IsOpen then
        return
    end

    -- 战斗结束
    _C:close()
    if battleReplayInfo.Result.AttackerWin then
        UIManager.openController(UIManager.ControllerName.AfterBattle3V3Win, battleReplayInfo)
    else
        UIManager.openController(UIManager.ControllerName.AfterBattle3V3Fail, battleReplayInfo)
    end
end
-- 刷新玩家信息
local function refreshPlayerInfo(playerInfo)
    if not _C.IsOpen then
        return
    end

    local queueId = playerInfo.InTheQueueId
    if view.Attacker[queueId] ~= nil then
        if nil ~= playerInfo.AttackerPlayer.Head then
            view.Attacker[queueId].Head.url = playerInfo.AttackerPlayer.Head.SmallIcon
        end
        view.Attacker[queueId].Root.visible = true
        view.Attacker[queueId].Name.text = playerInfo.AttackerPlayer.Name
        view.Attacker[queueId].FightAmount.text = Localization.FightAmount .. playerInfo.AttackerPlayer.FightAmount
        view.Attacker[queueId].ResultStat.selectedIndex = 0
    end
    if view.Defender[queueId] ~= nil then
        if nil ~= playerInfo.DefenserPlayer.Head then
            view.Defender[queueId].Head.url = playerInfo.DefenserPlayer.Head.SmallIcon
        end
        view.Defender[queueId].Root.visible = true
        view.Defender[queueId].Name.text = playerInfo.DefenserPlayer.Name
        view.Defender[queueId].FightAmount.text = Localization.FightAmount .. playerInfo.DefenserPlayer.FightAmount
        view.Defender[queueId].ResultStat.selectedIndex = 0
    end
end
-- 刷新回放信息
local function refreshReplayInfo(replayInfo, progress)
    if not _C.IsOpen then
        return
    end

    battleReplayInfo = replayInfo
    battleProgress = progress

    attackerLeftNum = #replayInfo.AttackerPlayer
    defenderLeftNum = #replayInfo.DefenserPlayer

    -- 刷新对战双方团队
    if nil ~= replayInfo.Result.OtherResultInfo then
        view.HeaderStat.selectedIndex = 0
        view.AttackerInfo.title = replayInfo.Result.OtherResultInfo.AttackDesc
        view.DefenderInfo.title = replayInfo.Result.OtherResultInfo.DefendDesc
    else
        view.HeaderStat.selectedIndex = 1
    end
    view.ProBarPlayer.max = attackerLeftNum + defenderLeftNum
    view.ProBarPlayer.value = attackerLeftNum
end
-- 刷新战斗进展
local function refreshBattleProgressInfo(queueId, attackWin, progress)
    if not _C.IsOpen then
        return
    end

    battleProgress = progress

    -- 战败显示
    if attackWin then
        defenderLeftNum = defenderLeftNum - 1
        view.Defender[queueId].ResultStat.selectedIndex = 1
    else
        attackerLeftNum = attackerLeftNum - 1
        view.Attacker[queueId].ResultStat.selectedIndex = 1
    end
    -- 进度条
    if defenderLeftNum + attackerLeftNum == 0 then
        view.ProBarPlayer.max = 2
        view.ProBarPlayer.value = 1
    else
        view.ProBarPlayer.max = defenderLeftNum + attackerLeftNum
        view.ProBarPlayer.value = attackerLeftNum
    end
end
-- 刷新战报
local function refreshBattleLogInfo(logInfo)
    if not _C.IsOpen then
        return
    end

    battleLogInfo = logInfo
end
function _C:onCreat()
    view = self.View
    _CHud.view = view

    view.BtnAllAttacker.onClick:Add(btnAllAttacker)
    view.BtnAllDefender.onClick:Add(btnAllDefender)

    view.BtnBattleLog.onClick:Add(btnBattleLog)
    view.BtnSkip.onClick:Add(btnToSkip)

    Event.addListener(Event.BATTLE_PLAYER_MAIN_REFRESH, refreshReplayInfo)
    Event.addListener(Event.BATTLE_PLAYER_REFRESH, refreshPlayerInfo)
    Event.addListener(Event.BATTLEFIELD_INFO_REFRESH, refreshBattleProgressInfo)
    Event.addListener(Event.BATTLE_LOG_REFRESH, refreshBattleLogInfo)
    Event.addListener(Event.BATTLE_OVER, battleOver)
end

function _C:onOpen(data)
    for k,v in pairs(view.Attacker) do
        v.Root.visible = false
    end
    for k,v in pairs(view.Defender) do
        v.Root.visible = false
    end
end
function _C:onShow()
    -- 做保护
    if LevelManager.CurLevelType ~= LevelType.Battle then
        return
    end

    -- 开始回放
    LevelManager.CurrLevelLogic:playBack()
    -- 更改速率
    LevelManager.CurrLevelLogic:speed(LevelManager.CurrLevelLogic.SpeedRate)
end
function _C:onDestroy()
    view.BtnAllAttacker.onClick:Clear()
    view.BtnAllDefender.onClick:Clear()

    view.BtnBattleLog.onClick:Clear()
    view.BtnSkip.onClick:Clear()

    Event.removeListener(Event.BATTLE_PLAYER_MAIN_REFRESH, refreshReplayInfo)
    Event.removeListener(Event.BATTLE_PLAYER_REFRESH, refreshPlayerInfo)
    Event.removeListener(Event.BATTLEFIELD_INFO_REFRESH, refreshBattleProgressInfo)
    Event.removeListener(Event.BATTLE_LOG_REFRESH, refreshBattleLogInfo)
    Event.removeListener(Event.BATTLE_OVER, battleOver)
end