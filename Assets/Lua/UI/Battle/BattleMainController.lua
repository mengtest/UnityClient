local _C = UIManager.Controller(UIManager.ControllerName.Battle, UIManager.ViewName.Battle)
local _CHud = require(UIManager.ControllerName.BattleHUD)
local _CGenerals = require(UIManager.ControllerName.BattleGenerals)
table.insert(_C.SubCtrl, _CHud)
table.insert(_C.SubCtrl, _CGenerals)

-- view
local view = nil
-- 倍率
local speedRate = 1
-- 当前战斗信息
local battleProgress = nil
-- 回放信息
local battleInfo =
{
    replayInfo = { },
    actors = { },
    progress = { },
}
-- 战斗进展信息
local function btnToBattleProgress()
    UIManager.openController(UIManager.ControllerName.BattleProgress, battleProgress)
end

-- 战斗结束
local function battleOver()
    if not _C.IsOpen then
        return
    end

    -- 战斗结束
    _C:close()
    if battleInfo.replayInfo.Result.AttackerWin then
        UIManager.openController(UIManager.ControllerName.AfterBattleWin, battleInfo)
    else
        UIManager.openController(UIManager.ControllerName.AfterBattleFail, battleInfo)
    end
end
-- 更新战斗进展
local function updateProgressInfo(progress)
    if not _C.IsOpen then
        return
    end

    battleProgress = progress
    battleInfo.progress = battleProgress
end
-- 更新玩家信息--
local function updatePlayerInfo(replayInfo)
    if not _C.IsOpen then
        return
    end

    battleInfo.replayInfo = replayInfo
    if nil == replayInfo then
        return
    end

    -- 玩家信息
    local attack = replayInfo.AttackerPlayer
    view.AttackerName.title = attack.Name
    view.AttackerFightAmount.title = attack.FightAmount
    view.AttackerCountry.url = attack.Guild
    view.AttackerSoliderBar.value = attack.TotalSolider
    view.AttackerSoliderBar.max = attack.TotalSolider
    if nil ~= attack.Head then
        view.AttackerHead.icon = attack.Head.SmallIcon
    end

    local defenser = replayInfo.DefenserPlayer
    view.DefenderName.title = defenser.Name
    view.DefenderFightAmount.title = defenser.FightAmount
    view.DefenderCountry.url = defenser.Guild
    view.DefenderSoliderBar.value = defenser.TotalSolider
    view.DefenderSoliderBar.max = replayInfo.DefenserPlayer.TotalSolider
    if nil ~= defenser.Head then
        view.DefenderHead.icon = defenser.Head.SmallIcon
    end

    print("更新玩家！！")
end

-- 更新武將信息
local function updateGeneralInfo(actor)
    if not _C.IsOpen then
        return
    end

    if nil == actor then
        return
    end
    local property = actor.propertyController

    battleInfo.actors[property.InsInfo.InsId] = property
end
-- 掉血--
local function updatePlayerHp(property, hurtType, damage, soliderDie)
    if not _C.IsOpen then
        return
    end

    -- 下方血条
    local bar = view.AttackerSoliderBar
    if property.InsInfo.Camp ~= CampType.Attacker then
        bar = view.DefenderSoliderBar
    end
    bar.value = tonumber(bar.value) - soliderDie
end

-- 快进--
local function btnToSpeedUp(speed)
    if type(speed) == "number" then
        speedRate = speed
    else
        speedRate = speedRate * 2
    end
    if speedRate > 4 then
        speedRate = 1
    end
    LevelManager.CurrLevelLogic:speed(speedRate)

    view.SpeedUpBtn.title = string.format(Localization.Rate, speedRate)
end
-- 跳过--
local function btnToSkip()
    LevelManager.CurrLevelLogic:skip()
end

function _C:onCreat()
    view = self.View
    _CHud.view = view
    _CGenerals.view = view

    view.SpeedUpBtn.onClick:Add(btnToSpeedUp)
    view.SkipBtn.onClick:Add(btnToSkip)
    view.BtnBattleProgress.onClick:Add(btnToBattleProgress)

    Event.addListener(Event.BATTLE_DROP_OF_BLOOD, updatePlayerHp)
    Event.addListener(Event.BATTLE_CAPTAIN_REFRESH, updateGeneralInfo)
    Event.addListener(Event.BATTLE_OVER, battleOver)
    Event.addListener(Event.BATTLE_PLAYER_REFRESH, updatePlayerInfo)
    Event.addListener(Event.BATTLE_PROGRESS_REFRESH, updateProgressInfo)
end

function _C:onShow()
    -- 做保护
    if LevelManager.CurLevelType ~= LevelType.Battle then
        return
    end

    -- 清空
    battleInfo.replayInfo = { }
    battleInfo.actors = { }

    -- 开始回放
    LevelManager.CurrLevelLogic:playBack()
    -- 更改速率
    btnToSpeedUp(LevelManager.CurrLevelLogic.SpeedRate)
end

function _C:onDestroy()
    view.SpeedUpBtn.onClick:Clear()
    view.SkipBtn.onClick:Clear()
    view.BtnBattleProgress.onClick:Clear()

    Event.removeListener(Event.BATTLE_DROP_OF_BLOOD, updatePlayerHp)
    Event.removeListener(Event.BATTLE_CAPTAIN_REFRESH, updateGeneralInfo)
    Event.removeListener(Event.BATTLE_OVER, battleOver)
    Event.removeListener(Event.BATTLE_PLAYER_REFRESH, updatePlayerInfo)
    Event.removeListener(Event.BATTLE_PROGRESS_REFRESH, updateProgressInfo)
end