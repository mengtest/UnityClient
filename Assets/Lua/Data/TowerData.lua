---------------------------------------------------------------
--- 重楼信息----------------------------------------------------
---------------------------------------------------------------

-- 获取下一楼层大宝箱奖励
local function getNextBoxFloorId(curBoxFloorId)
    local floorInfo
    for i = curBoxFloorId + 1, MiscCommonConfig.Config.TowerTotalFloor do
        floorInfo = TowerConfig:getConfigById(i)
        if nil ~= floorInfo and nil ~= floorInfo.BoxPrize then
            return floorInfo.Floor
        end
    end

    return nil
end

-- 重楼实例化信息--
local TowerData = { }

-- 千重楼------------------------------------------------------------------
-- 当前挑战次数，最大挑战次数Config.MiscConfig.TowerChallengeMaxTimes
TowerData.ChallengeTimes = 0
-- 当前第几层，0表示还没开始打，最高层表示已经全部通关
TowerData.CurrentFloor = 0
-- 历史到达的最高层
TowerData.HistoryMaxFloor = 0
-- 可以扫荡到的哪一层
TowerData.AutoMaxFloor = 0
-- 已领取的最高层宝箱，10表示已领取第10层的宝箱,这里经z过客户端处理，显示下一大宝箱楼层Id
TowerData.BoxFloor = 0
-- 楼层攻略回放
TowerData.StrategyReplay = { }
-- 当前挑战武将
TowerData.ChallengeCaptains = nil
-- 当前挑战回放
TowerData.ChallengeReplay = BattleReplayInfo()
-- 最近的扫荡
TowerData.LatestMoopingUp = { }

-- 重楼密室------------------------------------------------------------------
-- 密室回放
TowerData.BackroomReplay = MultiBattleReplayInfo()

-- 清除--
function TowerData:clear()
    self.ChallengeTimes = 0
    self.CurrentFloor = 0
    self.HistoryMaxFloor = 0
    self.AutoMaxFloor = 0
    self.BoxFloor = 0
end
-- 重楼数据更新
function TowerData:updateInfo(data)
    self.ChallengeTimes = data.challenge_times
    self.CurrentFloor = data.current_floor
    self.HistoryMaxFloor = data.history_max_floor
    self.AutoMaxFloor = data.auto_max_floor
    self.BoxFloor = getNextBoxFloorId(data.box_floor)
    print("千重楼信息", "当前楼层", data.current_floor, "可扫荡楼层", data.auto_max_floor, "历史最高楼层", data.history_max_floor, "大宝箱楼层", data.box_floor)
end

-- 重楼重置
local function TowerReset()
    TowerData.CurrentFloor = 0
    TowerData.ChallengeTimes = 0
    -- 抛出事件
    Event.dispatch(Event.TOWER_DAILY_RESET)
end
Event.addListener(Event.DAILY_RESET, TowerReset)

-- 重楼密室是否开启
function TowerData:backRoomIsOpen()
    return true
end

-- 挑战战斗回放
local function GetChallengeReplayAck(bytes)
    local battle = shared_pb.CombatProto()
    battle:ParseFromString(bytes)
    -- 挑战回放
    TowerData.ChallengeReplay:updateInfo(battle)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    Event.dispatch(Event.TOWER_BATTLE_REPLAY_ACK)
end
-- 获取回放失败
local function GetChallengeReplayError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
end                                                                                   
-- 楼层挑战结果成功--moduleId = 14, msgId = 2
local function S2CChallengeProto(data)
    -- 首胜奖励
    local firstPassPrize = shared_pb.PrizeProto()
    firstPassPrize:ParseFromString(data.first_pass_prize)
    -- 展示奖励
    local prize = shared_pb.PrizeProto()
    prize:ParseFromString(data.prize)

    -- 战斗回放
    TowerData.ChallengeReplay:clear()
    -- 战斗奖励
    local totalPrize = PrizeClass()
    totalPrize:updateInfo(firstPassPrize)
    totalPrize:updateInfo(prize)
    -- 上阵武将
    totalPrize.Captains = TowerData.ChallengeCaptains
    -- 更新结算
    TowerData.ChallengeReplay:updatePVEAward(totalPrize)

    -- 首次挑战且本层攻略不为空
    if TowerData.HistoryMaxFloor <= TowerData.CurrentFloor and nil ~= TowerData.StrategyReplay[TowerData.CurrentFloor + 1] then
        TowerData.StrategyReplay[TowerData.CurrentFloor + 1].ShouldRefresh = true
    end

    -- 当前挑战楼层,自动加1
    TowerData.CurrentFloor = TowerData.CurrentFloor + 1
    -- 历史最高层
    TowerData.HistoryMaxFloor = TowerData.CurrentFloor
    -- 可扫荡楼层
    TowerData.AutoMaxFloor = data.auto_max_floor

    print("挑战成功！！", data.link)
    Event.dispatch(Event.TOWER_CHALLENGE_SUCCEED)

    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 请求回放
    CS.LPCFramework.HttpHelper.CreateGetHttpResponse(data.link, GetChallengeReplayAck, GetChallengeReplayError)
end
tower_decoder.RegisterAction(tower_decoder.S2C_CHALLENGE, S2CChallengeProto)

-- 楼层挑战结果失败--moduleId = 14, msgId = 3
local function S2CFailureChallengeProto(data)
    -- 战斗回放
    TowerData.ChallengeReplay:clear()

    -- 可挑战次数
    TowerData.ChallengeTimes = data.challenge_times

    print("挑战失败！！", data.link)
    Event.dispatch(Event.TOWER_CHALLENGE_FAILURE)

    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 请求回放
    CS.LPCFramework.HttpHelper.CreateGetHttpResponse(data.link, GetChallengeReplayAck, GetChallengeReplayError)
end
tower_decoder.RegisterAction(tower_decoder.S2C_FAILURE_CHALLENGE, S2CFailureChallengeProto)

-- 楼层挑战请求失败--moduleId = 14, msgId = 4
-- 14-4-1: 当前楼层无效
-- 14-4-2: 没有挑战次数了
-- 14-4-3: 领取重楼宝箱
-- 14-4-4: 服务器忙，请稍后再试
-- 14-4-5: 上阵武将未满
-- 14-4-6: 上阵武将不存在
-- 14-4-7: 上阵武将id重复
-- 14-4-8: 上阵武将超出上限
-- 14-4-9: 已经到达最高层
local function S2CFailChallengeProto(code)
    UIManager.showNetworkErrorTip(tower_decoder.ModuleID, tower_decoder.S2C_FAIL_CHALLENGE, code)
end
tower_decoder.RegisterAction(tower_decoder.S2C_FAIL_CHALLENGE, S2CFailChallengeProto)

-- 扫荡成功--moduleId = 14, msgId = 6
local function S2CAutoChallengeProto(data)
    -- 最新楼层
    TowerData.CurrentFloor = data.floor

    -- 获得的奖励
    local floor = #data.prize
    local prize
    for i = 1, floor do
        prize = shared_pb.PrizeProto()
        prize:ParseFromString(data.prize[i])

        local award = PrizeClass()
        award:updateInfo(prize)
        TowerData.LatestMoopingUp[i] = award
    end

    Event.dispatch(Event.TOWER_AUTO_CHALLENGE_SUCCEED)
end
tower_decoder.RegisterAction(tower_decoder.S2C_AUTO_CHALLENGE, S2CAutoChallengeProto)

-- 扫荡失败--moduleId = 14, msgId = 7
-- 14-7-1: 已经到达扫荡最高层
-- 14-7-2: 服务器忙，请稍后再试
-- 14-7-3: 上阵武将未满
-- 14-7-4: 上阵武将不存在
-- 14-7-5: 上阵武将id重复
-- 14-7-6: 上阵武将超出上限
local function S2CFailAutoChallengeProto(code)
    UIManager.showNetworkErrorTip(tower_decoder.ModuleID, tower_decoder.S2C_FAIL_AUTO_CHALLENGE, code)
    Event.dispatch(Event.TOWER_AUTO_CHALLENGE_FAILURE)
end
tower_decoder.RegisterAction(tower_decoder.S2C_FAIL_AUTO_CHALLENGE, S2CFailAutoChallengeProto)

-- 更新重楼宝箱奖励--moduleId = 14, msgId = 9
local function S2CCollectBoxProto(data)
    -- 更新下一楼层大宝箱
    TowerData.BoxFloor = getNextBoxFloorId(data.box_floor)

    -- 楼层宝箱更新
    Event.dispatch(Event.TOWER_AWARD_BOX_UPDATE)
end
tower_decoder.RegisterAction(tower_decoder.S2C_COLLECT_BOX, S2CCollectBoxProto)

-- 重楼宝箱领取失败--moduleId = 14, msgId = 10
-- 14-10-1: 当前楼层没有宝箱
-- 14-10-2: 重楼宝箱已经领取过了
-- 14-10-3: 服务器忙，请稍后再试
local function S2CFailCollectBoxProto(code)
    UIManager.showNetworkErrorTip(tower_decoder.ModuleID, tower_decoder.S2C_FAIL_COLLECT_BOX, code)
end
tower_decoder.RegisterAction(tower_decoder.S2C_FAIL_COLLECT_BOX, S2CFailCollectBoxProto)

-- 获取楼层攻略信息--moduleId = 14, msgId = 12
local function S2CListPassReplayProto(data)
    -- 回放信息
    local replay = shared_pb.TowerFloorReplayProto()
    replay:ParseFromString(data.data)

    local replayInsInfo = TowerFloorReplayClass()
    replayInsInfo:updateInfo(replay)
    TowerData.StrategyReplay[data.floor] = replayInsInfo

    Event.dispatch(Event.TOWER_STRATEGY_REPLAY)
end
tower_decoder.RegisterAction(tower_decoder.S2C_LIST_PASS_REPLAY, S2CListPassReplayProto)

-- 获取楼层回放信息失败--moduleId = 14, msgId = 13
-- 14-13-1: 无效的楼层
local function S2CFailListPassReplayProto(code)
    UIManager.showNetworkErrorTip(tower_decoder.ModuleID, tower_decoder.S2C_FAIL_LIST_PASS_REPLAY, code)
end
tower_decoder.RegisterAction(tower_decoder.S2C_FAIL_LIST_PASS_REPLAY, S2CFailListPassReplayProto)

---------------------------------------------------------------
--- 重楼密室信息----------------------------------------------------
---------------------------------------------------------------

-- 密室战斗回放
local function GetBackroomReplayAck(bytes)
    local battle = shared_pb.CombatProto()
    battle:ParseFromString(bytes)
    -- 密室回放
    TowerData.BackroomReplay:updateInfo(battle)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- Event.dispatch(Event.TOWER_BATTLE_REPLAY_ACK)
end
-- 获取回放失败
local function GetBackroomReplayError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
end                                                                                   
-- 密室结果成功--moduleId = 14, msgId = 2
local function S2CBackroomProto(data)
    -- 战斗回放
    TowerData.BackroomReplay:clear()

    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 请求回放
    CS.LPCFramework.HttpHelper.CreateGetHttpResponse(data.link, GetBackroomReplayAck, GetBackroomReplayError)
end

return TowerData