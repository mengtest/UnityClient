local ReplayHelp = require "LevelLogic.BattleReplayLogic".ReplayHelp
local ReplayLogic = require "LevelLogic.BattleReplayLogic".ReplayLogic
local LevelLogic = require "LevelLogic.LevelLogic"
local Battle1v1LevelLogic = LevelLogic:extend()

-- 战斗逻辑
local replayLogic = ReplayLogic()
-- 场景逻辑
local levelLogic = nil
-- 延时结束
local delayOverTime = 2

-- 结束战斗
local function over()
    -- 通知ui--
    Event.dispatch(Event.BATTLE_OVER)
end
-- 延时结束
local function delayOver()
    -- 延时结束
    TimerManager.waitTodo(delayOverTime, levelLogic.SpeedRate, function()
        over()
    end )
end
-- 快进战斗--
function Battle1v1LevelLogic:speed(speed)
    levelLogic.SpeedRate = speed
    -- 改变速率
    replayLogic:speed(speed)
    -- 通知场景中所有物体加速
    GameObjectManager.setPlaybackSpeed(speed)
end
-- 跳过战斗--
function Battle1v1LevelLogic:skip()
    replayLogic:pause()
    over()
end
-- 进行回放--
function Battle1v1LevelLogic:playBack()
    levelLogic.SpeedRate = 1
    replayLogic:playBack()
end
-- 进入场景--
function Battle1v1LevelLogic:onEnterScene(callBack)
    levelLogic = self
    -- 初始化池
    GameObjectManager.initialize()

    -- 初始化回放逻辑
    local levelConfig = LevelManager.CurrLevelConfig
    local battleReplay = LevelManager.IncomingInfo
    local mapGrid = ReplayHelp:creatGrid(battleReplay.XGridNum, battleReplay.YGridNum, levelConfig.MapGridWidth, levelConfig.MapGridHeight, 1, levelConfig.MapGridWidth)
    local camAnim = ReplayHelp:creatCamAnim(levelConfig.CameraAnimCtrl)
    -- 初始化回放逻辑
    replayLogic:initialize(battleReplay, levelConfig, mapGrid, camAnim, delayOver)

    -- 初始化场景逻辑
    levelLogic.super.initLevel(levelLogic, LevelManager.CurrLevelConfig)
    -- 逻辑处理完成
    callBack()
    -- 打开战斗界面--
    UIManager.openController(UIManager.ControllerName.Battle)
    -- 播放背景音乐
    AudioManager.PlaySound('BGM_Battle01', 1)
    -- 播放入场动画
    camAnim:SetInteger("MotionType", ReplayHelp.CamEffTyper.onEnter)
end
-- 退出场景--
function Battle1v1LevelLogic:onExitScene()
    -- 销毁对象池子--
    GameObjectManager.onDestroy()
    -- 重置回放逻辑
    replayLogic:reset()
end

return Battle1v1LevelLogic

