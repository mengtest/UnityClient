
local _C = UIManager.Controller(UIManager.ControllerName.ClimbingTowerStrategy, UIManager.ViewName.ClimbingTowerStrategy)
_C.IsPopupBox = true

local view = nil
-- 共楼层
local towerTotalFloor = MiscCommonConfig.Config.TowerTotalFloor
-- 楼层数据
local replayInfo = DataTrunk.PlayerInfo.TowerData.StrategyReplay
-- 当前楼层Id
local curFloorId = nil
-- 当前回放玩家
local curReplayPlayer = nil
-- 当前回放
local curReplay = BattleReplayInfo()

-- 返回
local function btnBack()
    _C:close()
end
-- 回放信息
local function replayAck(bytes)
    local battle = shared_pb.CombatProto()
    battle:ParseFromString(bytes)
    -- 看回放不显示结算
    -- curReplay:updatePVEAward(curReplayPlayer.Prize)
    -- 挑战回放
    curReplay:updateInfo(battle)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 打开战斗
    LevelManager.loadScene(curReplay.MapRes, curReplay)
end
-- 回放信息
local function replayError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
end
-- 请求回放
local function btnReplay(floorInfo)
    curReplayPlayer = floorInfo
    -- 战斗回放
    curReplay:clear()
    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 请求回放
    CS.LPCFramework.HttpHelper.CreateGetHttpResponse(floorInfo.Link, replayAck, replayError)
end
-- 更新楼层信息
local function updateFloorReplayInfo()
    if not _C.IsOpen then
        return
    end
    if nil == replayInfo[curFloorId] or replayInfo[curFloorId].ShouldRefresh then
        NetworkManager.C2SListPassReplayProto(curFloorId)
        return
    end

    -- 楼层
    view.FloorDesc.text = string.format(Localization.TowerCurFloor_2, curFloorId)
    -- 层数据
    local floorInsInfo = replayInfo[curFloorId]
    -- 刷新
    local refresh = function(item, info)
        item.Name.text = info.Name
        item.Head.url = info.Head.SmallIcon
        item.FightAmount.text = info.FightAmount
        item.Time.text = info.Time
        item.BtnRepaly.onClick:Set( function() btnReplay(info) end)
        -- 联盟
        if nil == info.GuildFlagName or info.GuildFlagName == "" then
            item.GuildFlagName.text = ""
        else
            item.GuildFlagName.text = string.format("[%s]", info.GuildFlagName)
        end
        -- 兵种
        for i = 1, 5 do
            item.Race[i].url = UIConfig.Race[info.Race[i]]
        end
    end
    -- 约定共4组数据
    for i = 1, 4 do
        if nil ~= floorInsInfo.Replay[i] then
            refresh(view.FloorReplay[i], floorInsInfo.Replay[i])
            view.FloorReplay[i].Stat.selectedIndex = 0
        else
            view.FloorReplay[i].Stat.selectedIndex = 2
        end
    end

    -- 极限通过
    if nil ~= floorInsInfo.LowestReplay and floorInsInfo.LowestReplay.Floor > 0 then
        refresh(view.FloorNbReplay, floorInsInfo.LowestReplay)
        view.FloorNbReplay.Stat.selectedIndex = 1
    else
        view.FloorNbReplay.Stat.selectedIndex = 2
    end
end
-- 检测楼层有效
local function checkFloorValid(floor)
    if floor <= 0 then
        UIManager.showTip( { content = Localization.TowerFloorButtom, result = false })
        return false
    elseif floor > towerTotalFloor then
        UIManager.showTip( { content = Localization.TowerFloorTop, result = false })
        return false
    end
    return true
end
-- 上一层
local function btnBefFloor()
    if not checkFloorValid(curFloorId - 1) then
        return
    end

    curFloorId = curFloorId - 1
    updateFloorReplayInfo()
end
-- 下一层
local function btnNextFloor()
    if not checkFloorValid(curFloorId + 1) then
        return
    end

    curFloorId = curFloorId + 1
    updateFloorReplayInfo()
end
function _C:onCreat()
    view = _C.View
    view.BtnBack.onClick:Add(btnBack)
    view.BtnNext.onClick:Add(btnNextFloor)
    view.BtnBef.onClick:Add(btnBefFloor)

    Event.addListener(Event.TOWER_STRATEGY_REPLAY, updateFloorReplayInfo)
end
function _C:onOpen(data)
    -- 约定共4组数据
    for i = 1, 4 do
        view.FloorReplay[i].Stat.selectedIndex = 2
    end
    view.FloorNbReplay.Stat.selectedIndex = 2

    curFloorId = data
    updateFloorReplayInfo()
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnNext.onClick:Clear()
    view.BtnBef.onClick:Clear()

    Event.removeListener(Event.TOWER_STRATEGY_REPLAY, updateFloorReplayInfo)
end
