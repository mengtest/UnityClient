local _C = UIManager.Controller(UIManager.ControllerName.Pvp100Main, UIManager.ViewName.Pvp100Main)
local view = nil
-- 玩家数据
local pvp100Data = DataTrunk.PlayerInfo.Pvp100Data

-- 挑战次数恢复计时
local recoverTimer = nil
-- 挑战恢复次数
local recoverCount = 0

-- 返回
local function btnBack()
    _C:close()
end
-- 打开排行榜
local function btnToRankingList()
    -- UIManager.openController(UIManager.ControllerName.Pvp100Record)
end
-- 打开百战记录
local function btnToRecord()
    UIManager.openController(UIManager.ControllerName.Pvp100Record)
end
-- 打开军衔俸禄
local function btnToSalary()
    UIManager.openController(UIManager.ControllerName.Pvp100RankSalary)
end
-- 打开军衔奖励
local function btnToRankPrize()
    UIManager.openController(UIManager.ControllerName.Pvp100NewRecord)
end
-- 打开百战匹配
local function btnToChallenge()
    UIManager.openController(UIManager.ControllerName.Pvp100Matching)
end

-- 更新军衔名称
local function updateRankTitle()
    for k, v in pairs(Pvp100RankLevelConfig.Config) do
        -- 更新面板
        view.RankTitle[v.Level].Title.text = v.Name
        view.RankTitle[v.Level].Stat.selectedIndex = 0

        -- 军衔相等
        if pvp100Data.RankLv == v.Level then
            view.RankTitle[v.Level].Stat.selectedIndex = 1
        end
    end
end

-- 更新军衔进展
local function updateRankProgress()
    local rankPrizeConfig = Pvp100RankPrizeConfig:getConfigById(pvp100Data.LastCollectedPrizeId + 1)
    if nil ~= rankPrizeConfig then
        view.RankPrizeStat.selectedIndex = 0
        -- 奖励进度
        local rankConfig = Pvp100RankLevelConfig:getConfigByLevel(rankPrizeConfig.RankLv)
        view.RankPointMax_2.text = string.format(Localization.Pvp100RankPrize, rankConfig.Name, rankPrizeConfig.Point)
        view.RankPointBar.max = rankPrizeConfig.Point
        view.RankPointMax.text = rankPrizeConfig.Point
        view.RankPointBar.value = pvp100Data.Point
        view.RankPointCur.text = pvp100Data.Point
        -- 判断军衔
        if rankPrizeConfig.RankLv < pvp100Data.RankLv or pvp100Data.Point > rankPrizeConfig.Point then
            view.RankPointBar.value = rankPrizeConfig.Point
            view.RankPointCur.text = rankPrizeConfig.Point
        end
    else
        view.RankPrizeStat.selectedIndex = 1
    end
end

-- 更新挑战进展
local function updateChallengeBase()
    local rankConfig = Pvp100RankLevelConfig:getConfigByLevel(pvp100Data.RankLv)
    view.RankIcon.url = rankConfig.Icon
    view.WinPoint.text = Pvp100CommonConfig.Config.WinPoint
    view.FailPoint.text = Pvp100CommonConfig.Config.FailPoint

    view.TodayRankPoint.text = pvp100Data.Point
end

-- 请求挑战次数
local function updateChallengeTime()
    -- 恢复计时
    local timeCd = 0
    local zeroTimeSec = TimerManager.getTodayZeroTime()
    local totalChallengeTime = 0
    for k, v in pairs(Pvp100CommonConfig.Config.RecoverTimes) do
        recoverCount = v
        timeCd =(zeroTimeSec + k) - TimerManager.currentTime
        if timeCd > 0 then
            break
        end
        totalChallengeTime = totalChallengeTime + v
    end
    if timeCd >= 0 then
        view.NextTimeRecoverCd.visible = true

        recoverTimer:addCd(timeCd - recoverTimer.MaxCd)
        recoverTimer:start()
    else
        view.NextTimeRecoverCd.visible = false
        recoverTimer:pause()
    end

    view.TodayLeftTime.text = totalChallengeTime - pvp100Data.ChallengeTimes
end

-- 更新面板信息
local function updatePanelInfo()
    updateChallengeBase()
    updateChallengeTime()
    updateRankProgress()
    updateRankTitle()
end

-- 请求百战数据
local function syncPvp100Info()
    if pvp100Data.ShouldRefresh then
        NetworkManager.C2SQueryBaiZhanInfoProto()
    else
        updatePanelInfo()
    end
end

function _C:onCreat()
    view = _C.View
    view.BtnBack.onClick:Add(btnBack)
    view.BtnRanking.onClick:Add(btnToRankingList)
    view.BtnRecord.onClick:Add(btnToRecord)
    view.BtnSalary.onClick:Add(btnToSalary)
    view.BtnRankPrize.onClick:Add(btnToRankPrize)
    view.BtnChallenge.onClick:Add(btnToChallenge)

    -- 恢复计时
    recoverTimer = TimerManager.newTimer(0, true, true, nil,
    function(t, f)
        view.NextTimeRecoverCd.text = string.format(Localization.Pvp100ChallengeTime, Utils.secondConversion(math.ceil(f)), recoverCount)
    end ,
    function()
        -- 次数累加
        pvp100Data.ShouldRefresh = true
        if not _C.IsOpen then
            return
        end
        -- 更新下一次挑战计时
        updateChallengeTime()
    end
    )
    -- 更新面板
    Event.addListener(Event.PVP100_MAIN_REFRESH, updatePanelInfo)
end

function _C:onShow()
    syncPvp100Info()
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnRanking.onClick:Clear()
    view.BtnRecord.onClick:Clear()
    view.BtnSalary.onClick:Clear()
    view.BtnRankPrize.onClick:Clear()
    view.BtnChallenge.onClick:Clear()

    TimerManager.disposeTimer(recoverTimer)
    recoverTimer = nil

    Event.removeListener(Event.PVP100_MAIN_REFRESH, updatePanelInfo)
end
