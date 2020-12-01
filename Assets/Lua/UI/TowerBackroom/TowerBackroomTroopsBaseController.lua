local _C = UIManager.SubController(UIManager.ControllerName.TowerBackroomTroopsBase, nil)
_C.view = nil

-- 君主实例化信息
local monarchsData = DataTrunk.PlayerInfo.MonarchsData
-- 密室实例化信息
local backroomInsInfo = DataTrunk.PlayerInfo.TowerBackroom

-- 刷新计时器
local refreshTimer = nil
-- 是否为队长
local isLeader = false

-- 同步队伍信息
local function c2SSyncTroopsDetailInfo()
    if not _C.IsOpen or backroomInsInfo.TroopsDetailInfo.TeamId <= 0 then
        return
    end
    -- 请求队伍数据
    NetworkManager.C2SRequestTeamDetailProto()
end
-- 更新队伍信息
local function updateTroopsDetailInfo()
    if not _C.IsOpen then
        return
    end
    -- 计时刷新
    refreshTimer:start()

    -- 队长判断
    isLeader = backroomInsInfo.TroopsDetailInfo.LeaderId == monarchsData.Id or false
    _C.view.AttackerTroopsList.numItems = #backroomInsInfo.TroopsDetailInfo.Members
    _C.view.DefenderTroopsList.numItems = #backroomInsInfo.TroopsDetailInfo.FloorConfig.MonsterMasters

    if #backroomInsInfo.TroopsDetailInfo.Members < backroomInsInfo.TroopsDetailInfo.FloorConfig.MinAttackerCount or not isLeader then
        _C.view.BtnStart.grayed = true
    else
        _C.view.BtnStart.grayed = false
    end
end

-- 模式改变
local function btnModeChange()
    if isLeader then
        UIManager.showTip( { content = Localization.BackroomLeaderCanntChangeMode, result = false })
        return
    end
    -- 判断模式改变条件
    if _C.view.TroopsModeStat.selectedIndex == 0 then
        if backroomInsInfo.HelpTimes <= 0 then
            UIManager.showTip( { content = Localization.BackroomHelpNumEmpty, result = false })
            return
        end
        NetworkManager.C2SChangeModeProto(TowerBackroomBattleMode.Help)
    else
        if backroomInsInfo.ChallengeTimes <= 0 then
            UIManager.showTip( { content = Localization.BackroomChallengeNumEmpty, result = false })
            return
        end
        NetworkManager.C2SChangeModeProto(TowerBackroomBattleMode.Challenge)
    end
end
-- item渲染
local function onItemRender(index, obj, campType)
    obj.name = tostring(index)

    -- 显示类型，下方上下移动
    obj:GetController("State_C").selectedIndex = 0
    -- 攻击方设置
    if campType == CampType.Attacker then
        local troop = backroomInsInfo.TroopsDetailInfo.Members[index + 1]
        -- 基础信息
        obj:GetChild("TextField_Name").text = troop.Name
        obj:GetChild("TextField_FightAmount").text = Localization.FightAmount .. troop.FightAmount

        if troop.GuildId <= 0 then
            obj:GetChild("TextField_FlagName").text = ""
        else
            obj:GetChild("TextField_FlagName").text = troop.GuildFlagName
        end
        -- 队长判断
        if backroomInsInfo.TroopsDetailInfo.LeaderId == troop.Id then
            obj:GetController("Header_C").selectedIndex = 0
        else
            obj:GetController("Header_C").selectedIndex = 1
        end

        -- 武将职业
        local race = obj:GetChild("Component_Race")
        for i = 1, #troop.CaptainsRaceType do
            race:GetChild("loader_icon" .. i).url = UIConfig.Race[troop.CaptainsRaceType[i]]
        end

        -- 类型判断
        obj:GetController("Mode_C").selectedIndex = troop.Mode

        -- 显示模式
        if isLeader then
            obj:GetController("State_C").selectedIndex = 1

            obj:GetChild("Button_Up").onClick:Set( function() NetworkManager.C2SMoveMemberProto(troop.Id, true) end)
            obj:GetChild("Button_Down").onClick:Set( function() NetworkManager.C2SMoveMemberProto(troop.Id, false) end)
            obj:GetChild("Button_Fire").onClick:Set( function() NetworkManager.C2SKickMemberProto(troop.Id) end)
        else
            obj:GetController("State_C").selectedIndex = 0
        end

        -- 自身判断
        if troop.Id == monarchsData.Id then
            _C.view.TroopsModeStat.selectedIndex = troop.Mode
            if TowerBackroomBattleMode.Challenge == troop.Mode then
                _C.view.RoomNum.text = string.format(Localization.BackroomChallengeNum, backroomInsInfo.ChallengeTimes)
            else
                _C.view.RoomNum.text = string.format(Localization.BackroomHelpNum, backroomInsInfo.HelpTimes)
            end
        end
    else
        local troop = backroomInsInfo.TroopsDetailInfo.FloorConfig.MonsterMasters[index + 1]
        obj:GetController("State_C").selectedIndex = 0
        obj:GetChild("TextField_Name").text = troop.Name
        obj:GetChild("TextField_FightAmount").text = Localization.FightAmount .. troop.FightAmount
        obj:GetChild("TextField_FlagName").text = ""

        if backroomInsInfo.TroopsDetailInfo.FloorConfig.LeaderId == troop.Id then
            obj:GetController("Header_C").selectedIndex = 0
        else
            obj:GetController("Header_C").selectedIndex = 1
        end

        local race = obj:GetChild("Component_Race")
        for i = 1, #troop.Troops do
            race:GetChild("loader_icon" .. i).url = UIConfig.Race[troop.Troops[i].Race]
        end
    end
end 
function _C:onCreat()
    _C.view.AttackerTroopsList.itemRenderer = function(index, obj) onItemRender(index, obj, CampType.Attacker) end
    _C.view.DefenderTroopsList.itemRenderer = function(index, obj) onItemRender(index, obj, CampType.Defender) end
    _C.view.BtnTroopsMode.onClick:Add(btnModeChange)

    Event.addListener(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH, updateTroopsDetailInfo)

    refreshTimer = TimerManager.newTimer(10, false, false, nil, nil, c2SSyncTroopsDetailInfo)
end
function _C:onOpen(data)
    updateTroopsDetailInfo()
end
function _C:onDestroy()
    _C.view.AttackerTroopsList.itemRenderer = nil
    _C.view.DefenderTroopsList.itemRenderer = nil
    _C.view.BtnTroopsMode.onClick:Clear()

    Event.removeListener(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH, updateTroopsDetailInfo)

    TimerManager.disposeTimer(refreshTimer)
end

return _C
