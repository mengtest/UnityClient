
-- 百战千军实例化信息--
local Pvp100Data = { }
-- 军衔等级
Pvp100Data.RankLv = 0
-- 上次的军衔等级，如果是非0，跟当前等级的军衔比较，提示军衔升级还是降级
Pvp100Data.LastRankLv = 0
-- 已经挑战次数
Pvp100Data.ChallengeTimes = 0
-- 当前积分
Pvp100Data.Point = 0
-- 是否有领取俸禄
Pvp100Data.IsCollectSalary = false
-- 最后领取的军衔奖励id，0表示没有领取,下一个奖励是last_collected_jun_xian_prize_id+1
Pvp100Data.LastCollectedPrizeId = 0
-- 是否应该刷新数据
Pvp100Data.ShouldRefresh = true
-- 军衔排行榜
Pvp100Data.RankingList = nil
-- 当前挑战回放
Pvp100Data.ChallengeReplay = BattleReplayInfo()

-- 清除--
function Pvp100Data:clear()
    Pvp100Data.RankLv = 0
    Pvp100Data.LastRankLv = 0
    Pvp100Data.ChallengeTimes = 0
    Pvp100Data.Point = 0
    Pvp100Data.IsCollectSalary = false
    Pvp100Data.LastCollectedPrizeId = 0
    Pvp100Data.ShouldRefresh = true
    Pvp100Data.RankingList = nil
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_RESET, Pvp100Data.clear)

-- 请求百战数据
-- bytes // shared_proto.BaiZhanObjProto
local function S2CQueryBaiZhanInfoProto(data)
    local info = shared_pb.BaiZhanObjProto()
    info:ParseFromString(data.data)

    Pvp100Data.ChallengeTimes = info.challenge_times
    Pvp100Data.Point = info.point
    Pvp100Data.IsCollectSalary = info.is_collect_salary
    Pvp100Data.LastCollectedPrizeId = info.last_collected_jun_xian_prize_id
    Pvp100Data.RankLv = info.jun_xian_level
    Pvp100Data.LastRankLv = info.last_jun_xian_level
    Pvp100Data.ShouldRefresh = false

    Event.dispatch(Event.PVP100_MAIN_REFRESH)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_QUERY_BAI_ZHAN_INFO, S2CQueryBaiZhanInfoProto)

-- 请求百战数据失败
local function S2CFailQueryBaiZhanInfoProto(code)
    UIManager.showNetworkErrorTip(bai_zhan_decoder.ModuleID, bai_zhan_decoder.S2C_FAIL_QUERY_BAI_ZHAN_INFO, code)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_FAIL_QUERY_BAI_ZHAN_INFO, S2CFailQueryBaiZhanInfoProto)

-- 挑战战斗回放
local function GetChallengeReplayAck(bytes)
    local battle = shared_pb.CombatProto()
    battle:ParseFromString(bytes)
    -- 挑战回放
    Pvp100Data.ChallengeReplay:updateInfo(battle)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    Event.dispatch(Event.PVP100_CHALLENGE_ACK)
end
-- 获取回放失败
local function GetChallengeReplayError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
end     

-- 百战挑战成功
-- win: bool // 是否赢了 true(赢了)/false(输了)
-- challenge_times: int // 当前的挑战次数
-- link: string // 战斗数据存放位置，通过http获取回放数据
-- point: int // 新的积分
local function S2CBaiZhanChallengeProto(data)
    -- 新的挑战次数和积分
    Pvp100Data.ChallengeTimes = data.challenge_times
    Pvp100Data.Point = data.point

    -- 战斗回放
    Pvp100Data.ChallengeReplay:clear()
    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 请求回放
    CS.LPCFramework.HttpHelper.CreateGetHttpResponse(data.link, GetChallengeReplayAck, GetChallengeReplayError)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_BAI_ZHAN_CHALLENGE, S2CBaiZhanChallengeProto)

-- 百战挑战失败
local function S2CFailBaiZhanChallengeProto(code)
    UIManager.showNetworkErrorTip(bai_zhan_decoder.ModuleID, bai_zhan_decoder.S2C_FAIL_BAI_ZHAN_CHALLENGE, code)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_FAIL_BAI_ZHAN_CHALLENGE, S2CFailBaiZhanChallengeProto)

-- 领取俸禄成功
local function S2CCollectSalaryProto(data)

end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_COLLECT_SALARY, S2CCollectJunXianPrizeProto)

-- 领取俸禄失败
local function S2CFailCollectSalaryProto(code)
    UIManager.showNetworkErrorTip(bai_zhan_decoder.ModuleID, bai_zhan_decoder.S2C_FAIL_COLLECT_SALARY, code)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_FAIL_COLLECT_SALARY, S2CFailCollectSalaryProto)

-- 领取军衔奖励
-- int32 id // 要领取奖励的id
local function S2CCollectJunXianPrizeProto(data)

end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_COLLECT_JUN_XIAN_PRIZE, S2CCollectJunXianPrizeProto)

-- 领取俸禄失败
local function S2CFailCollectJunXianPrizeProto(code)
    UIManager.showNetworkErrorTip(bai_zhan_decoder.ModuleID, bai_zhan_decoder.S2C_FAIL_COLLECT_JUN_XIAN_PRIZE, code)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_FAIL_COLLECT_JUN_XIAN_PRIZE, S2CFailCollectJunXianPrizeProto)

-- 获取百战记录
-- version: int // 服务器当前版本号，如果服务器版本号跟客户端版本号一致，则后面的data为空
-- data: bytes[] // shared_proto.BaiZhanReplayProto，时间越早的在前面
local function S2CSelfRecord(data)

end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_SELF_RECORD, S2CSelfRecord)

-- 获取百战记录无变化
-- 版本没有变化，没有新的挑战记录，用旧的缓存
local function S2CSelfRecordNoChange(data)

end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_NO_CHANGE_SELF_RECORD, S2CSelfRecordNoChange)

-- 获取百战记录失败
local function S2CFailSelfRecord(code)
    UIManager.showNetworkErrorTip(bai_zhan_decoder.ModuleID, bai_zhan_decoder.S2C_FAIL_SELF_RECORD, code)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_FAIL_SELF_RECORD, S2CFailSelfRecord)

-- 百战防守记录变更,当收到此条消息时，如果开着挑战面板，可以直接再请求一次获取百战记录
local function S2CDefenceRecordChangeProto(data)

end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_SELF_DEFENCE_RECORD_CHANGED, S2CDefenceRecordChangeProto)

-- 获取百战排名
-- version: int // 服务器当前版本号，如果服务器版本号跟客户端版本号一致，则后面的data为空
-- jun_xian_level: int // 该排行榜的军衔等级
-- start_rank: int // 开始的排名
-- total_rank_count: int // 总共排的人数
-- data: bytes[] // shared_proto.BaiZhanRankObjProto
local function S2CRequestRankProto(data)
    if nil == Pvp100Data.RankingList then
        Pvp100Data.RankingList = Pvp100RankingListClass()
    end

    Pvp100Data.RankingList:updateInfo(data)

    -- 通知刷新
    Event.dispatch(Event.PVP100_RANKINGLIST_REFRESH, data.start_rank)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_REQUEST_RANK, S2CRequestRankProto)

-- 获取百战排名失败
local function S2CFailRequestRankProto(code)
    UIManager.showNetworkErrorTip(bai_zhan_decoder.ModuleID, bai_zhan_decoder.S2C_FAIL_REQUEST_RANK, code)
end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_FAIL_REQUEST_RANK, S2CFailRequestRankProto)

-- 自己的百战排名
-- rank: int // 排名
local function S2CRequestSelfRankProto(data)

end
bai_zhan_decoder.RegisterAction(bai_zhan_decoder.S2C_REQUEST_SELF_RANK, S2CRequestSelfRankProto)

return Pvp100Data