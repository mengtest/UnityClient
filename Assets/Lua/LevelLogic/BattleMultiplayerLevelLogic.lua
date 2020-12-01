-- 战报
local BattleLogInfo = Class()
-- 攻击方胜利
BattleLogInfo.IsAttackerWin = false
-- 攻击者
BattleLogInfo.Attacker = nil
-- 攻击方连胜次数
BattleLogInfo.AttackerContinueWinNum = 0
-- 攻击方连胜离场
BattleLogInfo.AttackerContinueWinLeave = false
-- 防御者
BattleLogInfo.Defender = nil
-- 防御方连胜次数
BattleLogInfo.DefenderContinueWinNum = 0
-- 防御方连胜离场
BattleLogInfo.DefenderContinueWinLeave = false

-- 玩家战斗进展
local BattlePlayerProgress = Class()
-- 玩家
BattlePlayerProgress.Player = nil
-- 当前战斗是否胜利
BattlePlayerProgress.IsFightWin = false
-- 连胜离场
BattlePlayerProgress.ContinueWinLeave = false
-- 已连胜次数
BattlePlayerProgress.ContinueWinNum = 0
-- 处于战斗中
BattlePlayerProgress.InTheBattle = false
-- 已战斗次数
BattlePlayerProgress.HaveBattlesNum = 0
-- 重置
function BattlePlayerProgress:reset()
    self.IsFightWin = false
    self.ContinueWinLeave = false
    self.ContinueWinNum = 0
    self.InTheBattle = false
    self.HaveBattlesNum = 0
end

-- 战斗参数信息
local BattleArgsInfo = Class()
-- 队列Id--
BattleArgsInfo.queueId = 0
-- 当前战斗Id--
BattleArgsInfo.curFightId = 0
-- 所有战斗信息--
BattleArgsInfo.allFightInfo = { }
-- 上一战斗信息--
BattleArgsInfo.prevFightInfo = nil
-- 当前战斗信息--
BattleArgsInfo.curFightInfo = nil
-- 回放逻辑
BattleArgsInfo.replayLogic = false
-- 处于战斗中
BattleArgsInfo.inTheBattle = false
-- 下一场战斗
function BattleArgsInfo:onlyGetNextFight()
    return self.allFightInfo[self.curFightId + 1]
end
-- 下一场战斗
function BattleArgsInfo:getNextFight()
    self.prevFightInfo = self.curFightInfo

    self.curFightId = self.curFightId + 1
    self.curFightInfo = self.allFightInfo[self.curFightId]

    print("所在队列：", self.queueId, "正进行战斗场次", self.curFightId)
    return self.curFightInfo
end
-- 重置
function BattleArgsInfo:reset()
    self.prevFightInfo = nil
    self.curFightInfo = nil
    self.inTheBattle = false
    self.curFightId = 0
end

---------------------------------------------------------
--- 队列战斗过程  ----------------------------------------
---------------------------------------------------------

local ReplayHelp = require "LevelLogic.BattleReplayLogic".ReplayHelp
local ReplayLogic = require "LevelLogic.BattleReplayLogic".ReplayLogic
local LevelLogic = require "LevelLogic.LevelLogic"
local BattleMultiplayerLevelLogic = LevelLogic:extend()

-- 场景逻辑
local levelLogic = nil
-- 场景配置
local levelConfig = nil
-- 地面网格
local multiMapGrid = nil
-- 摄像机动画
local multiCamAnim = nil
-- 回放信息--
local multiBattleReplayInfo = nil
-- 队列参数
local multiQueueArgs = nil

-- 当前玩家进展
local battlePlayerProgress = nil
-- 当前战报记录
local battleLogInfo = nil

-- 队列个数
local queueNum = 1
-- 延时结束
local delayOverTime = 2
-- 两场战斗时隔
local fightIntervalTime = 2
-- 延时结束回调
local delayDoOver = nil

-- 更新战斗进展--
local function updateProgressByQueueId(id)
    local fight = multiQueueArgs[id].curFightInfo
    local attackerProgress = battlePlayerProgress[fight.AttackerPlayer.Id]
    local defenderProgress = battlePlayerProgress[fight.DefenserPlayer.Id]

    multiQueueArgs[id].inTheBattle = false

    -- 军队进度
    local updateProgress = function(player, win)
        player.InTheBattle = false
        player.HaveBattlesNum = player.HaveBattlesNum + 1

        player.IsFightWin = win
        player.ContinueWinLeave = false
        if win then
            player.ContinueWinNum = fight.WinnerContinueWinNum
            player.ContinueWinLeave = fight.WinnerContinueWinLeave
        end
    end

    if fight.Result.AttackerWin then
        updateProgress(attackerProgress, true)
        updateProgress(defenderProgress, false)
    else
        updateProgress(defenderProgress, true)
        updateProgress(attackerProgress, false)
    end

    -- 通知UI，战场信息更新
    Event.dispatch(Event.BATTLEFIELD_INFO_REFRESH, id, fight.Result.AttackerWin, battlePlayerProgress)

    -- 战报进度
    local logInfo = BattleLogInfo()
    logInfo.IsAttackerWin = fight.Result.AttackerWin
    logInfo.Attacker = attackerProgress.Player
    logInfo.AttackerContinueWinNum = attackerProgress.ContinueWinNum
    logInfo.AttackerContinueWinLeave = attackerProgress.ContinueWinLeave

    logInfo.Defender = defenderProgress.Player
    logInfo.DefenderContinueWinNum = defenderProgress.ContinueWinNum
    logInfo.DefenderContinueWinLeave = defenderProgress.ContinueWinLeave
    table.insert(battleLogInfo, logInfo)

    -- 通知UI，战报更新
    Event.dispatch(Event.BATTLE_LOG_REFRESH, battleLogInfo)
end

-- 开始下一场战斗
local function startTheNextByQueueId(id, delayTime)
    -- 当前队列正在战斗中
    if multiQueueArgs[id].inTheBattle then
        return false
    end

    -- 获取下一战斗
    local fightInfo = multiQueueArgs[id]:onlyGetNextFight()
    -- 检测队列上战斗
    if nil == fightInfo then
        return false
    end

    -- 检测攻击方是否处在战斗中
    local playerProgress = battlePlayerProgress[fightInfo.AttackerPlayer.Id]
    if playerProgress.InTheBattle then
        return false
    end
    -- 检测防御方是否处在战斗中
    playerProgress = battlePlayerProgress[fightInfo.DefenserPlayer.Id]
    if playerProgress.InTheBattle then
        return false
    end

    -- 获取下一战斗
    fightInfo = multiQueueArgs[id]:getNextFight()

    -- 置为战斗状态
    multiQueueArgs[id].inTheBattle = true
    battlePlayerProgress[fightInfo.AttackerPlayer.Id].InTheBattle = true
    battlePlayerProgress[fightInfo.DefenserPlayer.Id].InTheBattle = true

    -- 初始化
    multiQueueArgs[id].replayLogic:initialize(fightInfo, levelConfig, multiMapGrid[id], multiCamAnim, function() delayDoOver(id) end)
    -- 延时开始
    TimerManager.waitTodo(delayTime, levelLogic.SpeedRate, function()
        -- 关闭上一场战斗信息
        local prevFightInfo = multiQueueArgs[id].prevFightInfo
        if nil ~= prevFightInfo then
            -- 设置对象不可见
            for k, v in pairs(prevFightInfo.AttackerPlayer.TroopsList) do
                GameObjectManager.setActorActive(v.InsId, false)
            end
            for k, v in pairs(prevFightInfo.DefenserPlayer.TroopsList) do
                GameObjectManager.setActorActive(v.InsId, false)
            end
        end
        -- 开始回放
        multiQueueArgs[id].replayLogic:playBack()
    end )

    return true
end
-- 结束战斗
local function over()
    -- 通知ui--
    Event.dispatch(Event.BATTLE_OVER)
end
-- 延时结束
delayDoOver = function(id)
    -- 更新战斗进展
    updateProgressByQueueId(id)

    -- 判断结束
    for k, v in pairs(multiQueueArgs) do
        -- 开始下一场战斗
        startTheNextByQueueId(v.queueId, fightIntervalTime)
    end
    -- 判断是否全部结束
    for k, v in pairs(multiQueueArgs) do
        if v.inTheBattle then
            return
        end
    end
    -- 延时结束
    TimerManager.waitTodo(delayOverTime, levelLogic.SpeedRate, over)
end
-- 快进战斗--
function BattleMultiplayerLevelLogic:speed(speed)
    levelLogic.SpeedRate = speed
    for k, v in pairs(multiQueueArgs) do
        v.replayLogic:speed(speed)
    end
    -- 通知场景中所有物体加速
    GameObjectManager.setPlaybackSpeed(speed)
end
-- 跳过战斗--
function BattleMultiplayerLevelLogic:skip()
    -- 结束
    for k, v in pairs(multiQueueArgs) do
        v.replayLogic:pause()
    end
    over()
end
-- 回放战斗--
function BattleMultiplayerLevelLogic:playBack()
    levelLogic.SpeedRate = 1
    -- 战报重置
    battleLogInfo = { }
    -- 进展重置
    for k, v in pairs(battlePlayerProgress) do
        v:reset()
    end

    -- 开始回放
    for k, v in pairs(multiQueueArgs) do
        v:reset()
        startTheNextByQueueId(v.queueId, 0)
    end

    -- 通知ui更新回放--
    Event.dispatch(Event.BATTLE_PLAYER_MAIN_REFRESH, multiBattleReplayInfo, battlePlayerProgress)
end
-- 进入场景--
function BattleMultiplayerLevelLogic:onEnterScene(callBack)
    levelLogic = self
    -- 初始化池
    GameObjectManager.initialize()

    -- 多人回放信息
    multiBattleReplayInfo = LevelManager.IncomingInfo
    -- 取战斗队列个数
    queueNum = multiBattleReplayInfo.QueueNum
    -- 场景逻辑
    levelConfig = LevelManager.CurrLevelConfig
    -- 地图网格
    multiMapGrid = ReplayHelp:creatGrid(multiBattleReplayInfo.XGridNum, multiBattleReplayInfo.YGridNum, levelConfig.MapGridWidth, levelConfig.MapGridHeight, queueNum, levelConfig.MapGridWidth)
    -- 摄像机动画
    multiCamAnim = ReplayHelp:creatCamAnim(levelConfig.CameraAnimCtrl)

    -- 队列参数初始化
    multiQueueArgs = { }
    for i = 1, queueNum do
        local args = BattleArgsInfo()
        args.queueId = i
        args.replayLogic = ReplayLogic()

        multiQueueArgs[i] = args
    end
    -- 队列场次信息
    for k, v in pairs(multiBattleReplayInfo.FightList) do
        table.insert(multiQueueArgs[v.InTheQueueId].allFightInfo, v)
    end
    -- 移除场次为0的队列
    for i = #multiQueueArgs, 1, -1 do
        if #(multiQueueArgs[i].allFightInfo) <= 0 then
            table.remove(multiQueueArgs, i)
        end
    end

    -- 战斗进展初始化
    battlePlayerProgress = { }
    for k, v in pairs(multiBattleReplayInfo.AttackerPlayer) do
        local process = BattlePlayerProgress()
        process.Player = v
        battlePlayerProgress[v.Id] = process
    end
    for k, v in pairs(multiBattleReplayInfo.DefenserPlayer) do
        local process = BattlePlayerProgress()
        process.Player = v
        battlePlayerProgress[v.Id] = process
    end

    -- 初始化场景逻辑
    levelLogic.super.initLevel(levelLogic, levelConfig)
    -- 逻辑处理完成
    callBack()
    -- 打开战斗界面--
    UIManager.openController(UIManager.ControllerName.Battle3V3Main)
    -- 播放背景音乐
    AudioManager.PlaySound('BGM_Battle01', 1)
end
-- 退出场景--
function BattleMultiplayerLevelLogic:onExitScene()
    -- 销毁对象池子--
    GameObjectManager.onDestroy()
    for k, v in pairs(multiQueueArgs) do
        -- 重置回放逻辑
        v.replayLogic:reset()
    end
end

return BattleMultiplayerLevelLogic

