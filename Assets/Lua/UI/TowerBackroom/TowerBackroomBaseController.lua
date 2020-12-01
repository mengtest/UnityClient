
local _C = UIManager.SubController(UIManager.ControllerName.TowerBackroomBase, nil)
_C.view = nil

-- 君主实例化信息
local monarchsData = DataTrunk.PlayerInfo.MonarchsData
-- 密室实例化信息
local backroomInsInfo = DataTrunk.PlayerInfo.TowerBackroom
-- 加入队伍战前部署数据
local battleDeploymentInfo = BattleDeploymentInfo()
-- 当前楼层队伍信息
local curFloorTroopsInfo = nil
-- 当前楼层Id
local curFloorId = nil
-- 当前楼层是否为邀请楼层
local curFloorIsInvite = false
-- 刷新计时器
local refreshTimer = nil
-- 同步楼层队伍数据
local function c2SSyncFloorTroopsInfo()
    if not _C.IsShow then
        return
    end
    -- 请求楼层数据
    if nil ~= curFloorId then
        if curFloorIsInvite then
            NetworkManager.C2SRequestInviteLisProto()
        else
            NetworkManager.C2SRequestTeamListProto(curFloorId)
        end
    end
    -- 请求楼层队伍个数
    NetworkManager.C2SRequestFloorTeamCountProto()
end

-- 更新楼层信息
local function updateFloorTroopsInfo()
    if not _C.IsOpen then
        return
    end

    -- 计时刷新
    refreshTimer:start()
    _C:updateFloorTroopsInfo(curFloorId, curFloorIsInvite)
end

-- 加入队伍
local function btnToChallenge(teamId)
    -- 判断可用次数
    if backroomInsInfo.HelpTimes <= 0 and backroomInsInfo.ChallengeTimes <= 0 then
        UIManager.showTip( { content = Localization.BackroomNumEmpty, result = false })
        return
    end

    -- 清除数据
    battleDeploymentInfo:clear()

    -- 战斗类型
    battleDeploymentInfo.Type = BattleDeploymentType.PVE_TowerBackroom
    -- 布阵方式
    battleDeploymentInfo.FightAmountShowType = 1
    -- 请求加入
    battleDeploymentInfo.ToCombat = function(captainId, count, isGuild)
        print("加入队伍Id:", teamId)

        -- 同步
        NetworkManager.C2SJoinTeamProto(teamId, captainId)
        return true
    end
    -- 楼层配置
    local floorConfig = BackroomConfig:getConfigById(curFloorId)
    -- 获得道具
    award = function(t, cornerType)
        if nil ~= t then
            for k, v in pairs(t) do
                v.CornerType = cornerType
                table.insert(battleDeploymentInfo.Awards, v)
            end
        end
    end
    battleDeploymentInfo.Awards = { }
    -- 首胜道具
    if nil ~= floorConfig.FirstPassPrize then
        award(floorConfig.FirstPassPrize.Goods, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Equips, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Currencys, ItemCornerType.FirstWin)
    end
    -- 展示道具
    if nil ~= floorConfig.ShowPrize then
        award(floorConfig.ShowPrize.Goods, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Equips, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Currencys, ItemCornerType.Prob)
    end
    -- 超级大奖
    if nil ~= floorConfig.SuperPrize then
        award(floorConfig.SuperPrize.Goods, ItemCornerType.Noraml)
        award(floorConfig.SuperPrize.Equips, ItemCornerType.Noraml)
        award(floorConfig.SuperPrize.Currencys, ItemCornerType.Noraml)
    end
    -- 密室信息
    battleDeploymentInfo.Backroom = { }
    battleDeploymentInfo.Backroom.IsCreatTroop = false
    battleDeploymentInfo.Backroom.FloorId = curFloorId
    battleDeploymentInfo.Backroom.MinPlayerNum = floorConfig.MinAttackerCount
    battleDeploymentInfo.Backroom.MaxPlayerNum = floorConfig.MaxAttackerCount
    battleDeploymentInfo.Backroom.TroopsNum = #floorConfig.MonsterMasters
    battleDeploymentInfo.Backroom.MaxContinueNum = floorConfig.MaxContinueWinTimes

    -- 打开布阵
    UIManager.openController(UIManager.ControllerName.PreBattle, battleDeploymentInfo)
end
-- item渲染
local function onItemRender(index, obj)
    obj.name = tostring(index)
    local troopsInfo = curFloorTroopsInfo[index + 1]

    -- 基础信息
    obj:GetChild("TextField_Floor").text = string.format(Localization.BackroomFloor, troopsInfo.FloorId)
    obj:GetChild("TextField_Name").text = troopsInfo.LeaderInfo.Name
    obj:GetChild("TextField_Fight").text = troopsInfo.LeaderInfo.FightAmount

    -- 当前成员数
    local troopsNum = obj:GetChild("ProgressBar_TroopNumber")
    troopsNum.max = troopsInfo.MaxMemberCount
    troopsNum.value = troopsInfo.CurMemberCount

    -- 联盟信息
    if troopsInfo.LeaderInfo.GuildId ~= 0 then
        obj:GetChild("TextField_FlagName").text = string.format("[%s]", troopsInfo.LeaderInfo.GuildFlagName)
    else
        obj:GetChild("TextField_FlagName").text = ""
    end

    -- 限制信息
    if troopsInfo.GuildId > 0 then
        obj:GetController("State_C").selectedIndex = 2
    else
        obj:GetController("State_C").selectedIndex = 1
    end

    -- 加入信息
    if backroomInsInfo.TroopsDetailInfo.TeamId == troopsInfo.TeamId then
        obj:GetController("Join_C").selectedIndex = 1
    else
        obj:GetController("Join_C").selectedIndex = 0
    end

    -- 按钮监听
    obj:GetChild("Button_Join").onClick:Set( function()
        if troopsInfo.GuildId > 0 and troopsInfo.GuildId ~= monarchsData.GuildId then
            UIManager.showTip( { content = Localization.BackroomNotSameGuild, result = false })
        else
            btnToChallenge(troopsInfo.TeamId)
        end
    end )
    obj:GetChild("Button_BackToTroop").onClick:Set( function() UIManager.openController(UIManager.ControllerName.TowerBackroomTroopsMain) end)
end 

-- 更新楼层信息(参数一表示楼层，参数二表示是否为密室邀请)
function _C:updateFloorTroopsInfo(floorId, isInviteFloor)
    curFloorId = floorId
    curFloorIsInvite = isInviteFloor

    if curFloorIsInvite then
        -- 密室邀请楼层
        if nil == backroomInsInfo.InviteTroopsInfo or backroomInsInfo.InviteTroopsInfo.ShouldRefresh then
            c2SSyncFloorTroopsInfo()
            return
        end
        curFloorTroopsInfo = backroomInsInfo.InviteTroopsInfo.Troops
    else
        -- 普通楼层
        if nil == backroomInsInfo.FloorTroopsInfo[curFloorId] or backroomInsInfo.FloorTroopsInfo[curFloorId].ShouldRefresh then
            c2SSyncFloorTroopsInfo()
            return
        end
        curFloorTroopsInfo = backroomInsInfo.FloorTroopsInfo[curFloorId].Troops
    end
    -- 队伍个数判断
    local troopsNum = #curFloorTroopsInfo
    if troopsNum <= 0 then
        _C.view.FloorTroopStat.selectedIndex = 1
        return
    end
    _C.view.FloorTroopStat.selectedIndex = 0

    -- 刷新列表
    _C.view.FloorTroopsList.numItems = 0
    _C.view.FloorTroopsList.numItems = troopsNum
end

function _C:onCreat()
    _C.view.FloorTroopsList.itemRenderer = onItemRender

    Event.addListener(Event.TOWER_BACKROOM_TROOPS_REFRESH, updateFloorTroopsInfo)

    refreshTimer = TimerManager.newTimer(10, false, false, nil, nil, c2SSyncFloorTroopsInfo)
end

function _C:onShow()
    -- 刷新当前楼层部队
    local floorClick = curFloorId
    if nil == curFloorId then
        -- 最高楼层密室邀请
        floorClick = backroomInsInfo.OpenMaxFloor + 1
    end
    local floorItem = _C.view.FloorCountList:GetChild(tostring(floorClick))
    if nil ~= floorItem then
        floorItem.onClick:Call()
    end
end

function _C:onClose()
    curFloorId = nil
end

function _C:onDestroy()
    _C.view.FloorTroopsList.itemRenderer = nil

    Event.removeListener(Event.TOWER_BACKROOM_TROOPS_REFRESH, updateFloorTroopsInfo)

    TimerManager.disposeTimer(refreshTimer)
end

return _C
