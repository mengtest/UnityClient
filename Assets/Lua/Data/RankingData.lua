local RankingData = { }
RankingData.CurrentRankingType = nil
RankingData.RankingDataCount = 0
RankingData.RankingType = 
{
    Country = 0,        -- 国家排行榜
    Alliance = 1,       -- 联盟排行榜
    SecretTower = 2,    -- 千重楼
    HundredsWar = 3,    -- 百战千军
}

function RankingData:Clear()
    self.CurrentRankingType = nil
end

-----------------服务器数据回复解析 BEGIN-----------------

-- 排行榜数据
-- moduleId = 23, msgId = 2
-- rank: bytes // 返回数据，客户端解析成 RankProto，收到该数据后，客户端清掉其他排行榜的缓存
local function S2CRequestRankProto(data)
    if data == nil then
        return
    end

    local rankData = shared_pb.RankProto()
    rankData:ParseFromString(data.rank)
    
    if RankingData.CurrentRankingType == RankingData.RankingType.Country then
        Event.dispatch(Event.GET_RANKING, rankData.start_rank, rankData.country)
    elseif RankingData.CurrentRankingType == RankingData.RankingType.Alliance then
        Event.dispatch(Event.GET_RANKING, rankData.start_rank, rankData.guild)
    elseif RankingData.CurrentRankingType == RankingData.RankingType.SecretTower then
        Event.dispatch(Event.GET_RANKING, rankData.start_rank, rankData.tower)
    elseif RankingData.CurrentRankingType == RankingData.RankingType.HundredsWar then
        Event.dispatch(Event.GET_RANKING, rankData.start_rank, rankData.bai_zhan)
    end
end
rank_decoder.RegisterAction(rank_decoder.S2C_REQUEST_RANK, S2CRequestRankProto)

-- 请求排行榜数据失败
-- moduleId = 23, msgId = 3
-- unknown_rank_type: 未知的排行榜类型
-- target_not_found: 目标不存在
-- target_not_in_rank_list: 目标不在榜单上
-- server_error: 服务器繁忙，请稍后再试
local function S2CRequestRankFailProto(code)
    UIManager.showNetworkErrorTip(rank_decoder.ModuleID, rank_decoder.S2C_FAIL_REQUEST_RANK, code)
    
    if RankingData.CurrentRankingType == RankingData.RankingType.Country then
        Event.dispatch(Event.GET_RANKING_FAIL)
    elseif RankingData.CurrentRankingType == RankingData.RankingType.Alliance then
        Event.dispatch(Event.GET_RANKING_FAIL)
    elseif RankingData.CurrentRankingType == RankingData.RankingType.SecretTower then
        Event.dispatch(Event.GET_RANKING_FAIL)
    elseif RankingData.CurrentRankingType == RankingData.RankingType.HundredsWar then
        Event.dispatch(Event.GET_RANKING_FAIL)
    end
end
rank_decoder.RegisterAction(rank_decoder.S2C_FAIL_REQUEST_RANK, S2CRequestRankFailProto)

-----------------服务器数据回复解析 END-----------------

return RankingData