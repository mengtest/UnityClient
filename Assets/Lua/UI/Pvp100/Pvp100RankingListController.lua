local _C = UIManager.SubController(UIManager.ControllerName.Pvp100RankingList, nil)
_C.view = nil

-- 百战数据
local pvp100Data = DataTrunk.PlayerInfo.Pvp100Data
-- 玩家数据
local playerData = DataTrunk.PlayerInfo.MonarchsData

-- 刷新计时器
local refreshTimer = nil
-- 是否拖拽刷新
local isDragTop = false
local isDragBottom = false
-- 列表数据
local itemList = { }
-- item高度
local itemHeight = 0
-- 领先排名
local leadRankId = 0
-- 落后排名
local lagRankId = 0

-- 刷新自己军衔
local function updateSelfRank()
    _C.view.SelfRank.Name.text = string.format("[%s]%s", playerData.GuildFlagName, playerData.Name)
    _C.view.SelfRank.LevelupDesc.text = Localization.Pvp100Levelup_4
    _C.view.SelfRank.Point.text = pvp100Data.Point
    _C.view.SelfRank.Stat.selectedIndex = 3
    _C.view.SelfRank.Type.selectedIndex = 0
end
-- 刷新自己军衔
local function updateSelfRank_2(info)
    -- 自身状态
    if info.Ranking <= leadRankId then
        _C.view.SelfRank.Stat.selectedIndex = 0
        _C.view.SelfRank.LevelupDesc.text = Localization.Pvp100Levelup_1
    elseif info.Ranking > lagRankId then
        _C.view.SelfRank.Stat.selectedIndex = 2
        _C.view.SelfRank.LevelupDesc.text = string.format(Localization.Pvp100Levelup_3, pvp100Data.RankingList.RankConfig.LevelUpPoint - info.Point)
    else
        _C.view.SelfRank.Stat.selectedIndex = 1
        _C.view.SelfRank.LevelupDesc.text = string.format(Localization.Pvp100Levelup_2, pvp100Data.RankingList.RankConfig.LevelUpPoint - info.Point)
    end
    _C.view.SelfRank.Ranking.text = info.Ranking
end
-- 刷新排行榜
local function updateRankingList(startId)
    _C.view.ListRankTitle.text = pvp100Data.RankingList.RankConfig.Name

    -- 计时刷新
    refreshTimer:start()
    -- 排行分段
    leadRankId = math.ceil(pvp100Data.RankingList.TotalCount * pvp100Data.RankingList.RankConfig.LevelUpPercent * 0.01)
    lagRankId = math.ceil(pvp100Data.RankingList.TotalCount *(1 - pvp100Data.RankingList.RankConfig.LevelDownPercent) * 0.01)

    -- 获取滚动信息
    itemList = { }
    for k, v in pairs(pvp100Data.RankingList.Player) do
        -- 判断是否为主玩家
        if v.Basic.Id == playerData.Id then
            updateSelfRank_2(v)
        end

        -- 向列表中增加对象
        table.insert(itemList, v)
    end
    _C.view.ListRank.numItems = #itemList

    -- 是否有玩家上榜
    if _C.view.ListRank.numItems == 0 then
        _C.view.ListRankStat.selectedIndex = 1
    else
        _C.view.ListRankStat.selectedIndex = 0
    end
    -- 是否为拖拽刷新
    if isDragBottom then
        _C.view.ListRank.scrollPane:ScrollTop()
    elseif isDragTop then
        _C.view.ListRank.scrollPane:ScrollBottom()
    end
    isDragBottom = false
    isDragTop = false
end
-- 请求排行榜数据
local function syncRanklingList(startId, isSelf)
    NetworkManager.C2SRequestRankProto(isSelf, startId)
end

-- 已到刷新时间
local function onRefreshTimeComplete()
    if #itemList > 0 then
        syncRanklingList(itemList[1].Ranking, false)
    else
        syncRanklingList(0, true)
    end
end
-- 拉至最上刷新
local function onPullDownRelease()
    isDragTop = true
    local startId = #itemList
    if startId > 0 then
        startId = itemList[1].Ranking - Pvp100CommonConfig.Config.ShowRankCount
    end
    -- 请求
    syncRanklingList(startId, false)
end
-- 拉至最底刷新
local function onPullUpRelease()
    isDragBottom = true
    local startId = #itemList
    if startId > 0 then
        startId = itemList[#itemList].Ranking
    end
    -- 请求
    syncRanklingList(startId, false)
end

-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.name)
end
-- item渲染
local function onItemRender(index, obj)
    obj.name = tostring(index)

    local itemInfo = itemList[index + 1]
    obj:GetChild("Text_Ranking").text = itemInfo.Ranking
    obj:GetChild("Text_Points").text = itemInfo.Point
    obj:GetChild("Text_PlayerName").text = string.format("[%s]%s", itemInfo.Basic.GuildFlagName, itemInfo.Basic.Name)

    if itemInfo.Basic.Id == playerData.Id then
        obj:GetController("Type_C").selectedIndex = 0
    else
        obj:GetController("Type_C").selectedIndex = 1
    end
    if itemInfo.Ranking <= leadRankId then
        obj:GetController("State_C").selectedIndex = 0
    elseif itemInfo.Ranking > lagRankId then
        obj:GetController("State_C").selectedIndex = 2
    else
        obj:GetController("State_C").selectedIndex = 1
    end
end

function _C:onCreat()
    _C.view.ListRank.itemRenderer = onItemRender
    _C.view.ListRank.scrollPane.onPullDownRelease:Add(onPullDownRelease)
    _C.view.ListRank.scrollPane.onPullUpRelease:Add(onPullUpRelease)
    --   _C.view.ListRank.scrollPane.onScrollEnd:Add(onScrollEnd)
    _C.view.ListRank.onClickItem:Add(onItemClick)

    refreshTimer = TimerManager.newTimer(30, false, true, nil, nil, onRefreshTimeComplete, nil)

    Event.addListener(Event.PVP100_RANKINGLIST_REFRESH, updateRankingList)
end

function _C:onOpen(data)
    _C.view.ListRank.numItems = 0
    itemHeight = _C.view.ListRank.scrollPane.scrollStep
end

function _C:onShow()
    -- 更新自己军衔
    updateSelfRank()
    -- 从0开始请求
    syncRanklingList(0, true)
    -- 计时刷新
    refreshTimer:start()
end
function _C:onHide()
    -- 暂停计时
    refreshTimer:pause()
end

function _C:onDestroy()
    _C.view.ListRank.itemRenderer = nil
    _C.view.ListRank.scrollPane.onPullDownRelease:Clear()
    _C.view.ListRank.scrollPane.onPullUpRelease:Clear()
    --    _C.view.ListRank.scrollPane.onScrollEnd:Clear()
    _C.view.ListRank.onClickItem:Clear()

    TimerManager.disposeTimer(refreshTimer)

    Event.removeListener(Event.PVP100_RANKINGLIST_REFRESH, updateRankingList)
end

return _C
