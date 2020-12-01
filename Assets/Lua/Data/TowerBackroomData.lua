---------------------------------------------------------------
--- 重楼信息----------------------------------------------------
---------------------------------------------------------------

-- 重楼密室剩余挑战次数
local function getChallengeTimes(startRecoveryTime)
    local times = math.floor((TimerManager.currentTime - startRecoveryTime) / BackroomCommonConfig.Config.RecoverDuration)
    if times > BackroomCommonConfig.Config.MaxChallengeTimes then
        times = BackroomCommonConfig.Config.MaxChallengeTimes
    end
    return times
end
-- 重楼密室下一次挑战次数恢复时间
local function getChallengeNextRecoverLeftTime(startRecoveryTime)
    local times = getChallengeTimes(startRecoveryTime)
    if times >= BackroomCommonConfig.Config.MaxChallengeTimes then
        return 0
    else
        return(times + 1) * BackroomCommonConfig.Config.RecoverDuration + startRecoveryTime - TimerManager.currentTime
    end
end

-- 重楼实例化信息--
local TowerBackroomData = { }
-- 最大开启的密室id，0表示没开启密室，判断某个密室能否进去，通过 目标密室id <= OpenMaxFloor 判断
TowerBackroomData.OpenMaxFloor = 0
-- 协助次数
TowerBackroomData.HelpTimes = 0
-- 挑战次数
TowerBackroomData.ChallengeTimes = 0
-- 开始恢复时间
TowerBackroomData.StartRecoverTime = 0
-- 挑战次数恢复计时器
TowerBackroomData.ChallengeRecoverTimer = nil
-- 首胜奖励已领取
TowerBackroomData.FloorFirstPrizeCollected = nil
-- 楼层队伍信息
TowerBackroomData.FloorTroopsInfo = { }
-- 邀请队伍详细信息
TowerBackroomData.InviteTroopsInfo = nil
-- 当前加入队伍详细信息
TowerBackroomData.TroopsDetailInfo = TowerBackroomTroopsDetailClass()
-- 密室回放信息
TowerBackroomData.BackroomReplay = MultiBattleReplayInfo()
-- 密室邀请结果状态
TowerBackroomData.InviteResultType = {
    -- 邀请
    Invite = 0,
    -- 已邀请
    Invited = 1,
    -- 未开启
    NotOpen = 2,
    -- 无次数
    NotNum = 3
}
-- 清除--
function TowerBackroomData:clear()
    self.OpenMaxFloor = 0
    self.HelpTimes = 0
    self.ChallengeTimes = 0
    self.ChallengeTimes = 0
    self.FloorTroopsInfo = { }
    self.InviteTroopsInfo = { }
    self.BackroomReplay:clear()
    self.TroopsDetailInfo.TeamId = -1
end
-- 重楼密室数据更新
function TowerBackroomData:updateInfo(data)
    self.OpenMaxFloor = data.max_open_tower_id
    self.HelpTimes = BackroomCommonConfig.Config.MaxHelpTimes - data.help_times
    self.StartRecoverTime = data.start_recover_time
    self.ChallengeTimes = getChallengeTimes(data.start_recover_time)
    -- 挑战次数恢复计时
    self:startChallengeRecoverTimer()
    -- 密室邀请列表
    self.InviteTroopsInfo = TowerBackroomFloorClass()

    -- 楼层首胜奖励
    for i = 1, #data.collected_first_prize_id do
        local floorTroops = TowerBackroomData.FloorTroopsInfo[data.collected_first_prize_id[i]]
        if nil == floorTroops then
            floorTroops = TowerBackroomFloorClass()
        end
        floorTroops.FirstPrizeCollected = true

        TowerBackroomData.FloorTroopsInfo[data.collected_first_prize_id[i]] = floorTroops
    end

    print("重楼密室开放！！", data.max_open_tower_id)
end
-- 重楼密室数据更新
function TowerBackroomData:startChallengeRecoverTimer()
    -- 挑战次数更改
    local changeChallengeNum = function()
        self.ChallengeTimes = getChallengeTimes(self.StartRecoverTime)
        local nextTime = getChallengeNextRecoverLeftTime(self.StartRecoverTime)

        if nextTime >= 0 then
            self.ChallengeRecoverTimer:addCd(nextTime - self.ChallengeRecoverTimer.MaxCd)
            self.ChallengeRecoverTimer:start()
        end

        Event.dispatch(Event.TOWER_BACKROOM_BASE_INFO_REFRESH)
    end

    -- 挑战次数恢复计时
    if nil == self.ChallengeRecoverTimer then
        self.ChallengeRecoverTimer = TimerManager.newTimer(getChallengeNextRecoverLeftTime(self.StartRecoverTime), false, true, nil, nil, changeChallengeNum)
    else
        changeChallengeNum()
    end

    -- 开始计时
    self.ChallengeRecoverTimer:start()
end

-- 重楼密室每日重置
local function TowerBackroomReset()
    TowerBackroomData.HelpTimes = BackroomCommonConfig.Config.MaxHelpTimes
    -- 抛出事件
    Event.dispatch(Event.TOWER_BACKROOM_BASE_INFO_REFRESH)
end
Event.addListener(Event.DAILY_RESET, TowerBackroomReset)

-- 解锁新的密室Id
-- secret_tower_id: int // 解锁的密室id<=该密室id的密室全部都解锁了，收到该消息之后，客户端本地缓存该数据
local function S2CUnlockSecretTowerProto(data)
    TowerBackroomData.OpenMaxFloor = data.secret_tower_id
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_UNLOCK_SECRET_TOWER, S2CUnlockSecretTowerProto)

-- 请求密室队伍数量，客户端缓存一定的时间，缓存10s，10s之后如果还是打开着这个面板，可以继续来请求一次
-- 收到返回后，如果该密室的队伍数量跟 request_team_list 缓存的密室的队伍数量不匹配，将 request_team_count 该密室的队伍数量设置为该密室队伍数量
-- secret_tower_id: int // 密室id
-- team_count: int // 队伍数量，跟密室id一一对应
local function S2CRequestTeamCountProto(data)
    for i = 1, #data.secret_tower_id do
        local floorTroops = TowerBackroomData.FloorTroopsInfo[data.secret_tower_id[i]]
        if nil == floorTroops then
            floorTroops = TowerBackroomFloorClass()
        end

        -- 如果不是正在打开的楼层
        if i ~= TowerBackroomData.TroopsDetailInfo.TeamId then
            floorTroops.TroopsCount = data.team_count[i]
        end

        TowerBackroomData.FloorTroopsInfo[data.secret_tower_id[i]] = floorTroops
    end
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_REQUEST_TEAM_COUNT, S2CRequestTeamCountProto)

-- 请求密室队伍数量失败
local function S2CFailRequestTeamCountProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_COUNT, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_COUNT, S2CFailRequestTeamCountProto)

-- 请求队伍列表，清空掉所有的密室队伍列表，缓存新的列表，缓存10s，10s之后如果还是打开着这个面板，可以继续来请求一次，如果玩家点击了刷新按钮，如果时间没到，用缓存来显示，否则来请求
-- 收到返回后，如果该密室的队伍数量跟 request_team_count 返回的丢无数量不匹配，将 request_team_count 该密室的队伍数量设置为该密室队伍数量
-- secret_tower_id: int // 密室id
-- team_list: int // 队伍列表, []shared_proto.SecretTeamShowProto
local function S2CRequestTeamListProto(data)
    if TowerBackroomData.FloorTroopsInfo[data.secret_tower_id] ~= nil then
        TowerBackroomData.FloorTroopsInfo[data.secret_tower_id]:updateInfo(data, TowerBackroomData.TroopsDetailInfo.TeamId)
    else
        local floorTroops = TowerBackroomFloorClass()
        floorTroops:updateInfo(data, TowerBackroomData.TroopsDetailInfo.TeamId)
        TowerBackroomData.FloorTroopsInfo[data.secret_tower_id] = floorTroops
    end

    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_REQUEST_TEAM_LIST, S2CRequestTeamListProto)

-- 请求队伍列表失败
local function S2CFailRequestTeamListProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_LIST, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_LIST, S2CFailRequestTeamListProto)

-- 创建队伍
-- team_detail: string // 队伍详细信息, shared_proto.SecretTeamDetailProto，收到消息后，客户端缓存10s，如有需要，可以再来请求一次 此处同request_team_detail
local function S2CCreateTeamProto(data)
    local bytes = shared_pb.SecretTeamDetailProto()
    bytes:ParseFromString(data.team_detail)

    TowerBackroomData.TroopsDetailInfo:updateInfo(bytes)
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true

    -- 加入队伍成功
    Event.dispatch(Event.TOWER_BACKROOM_JOIN_TROOPS_SUCCEED)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_CREATE_TEAM, S2CCreateTeamProto)

-- 创建队伍失败
local function S2CFailCreateTeamProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_CREATE_TEAM, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_CREATE_TEAM, S2CFailCreateTeamProto)

-- 加入队伍
-- team_detail: string // 队伍详细信息, shared_proto.SecretTeamDetailProto, 收到消息后，客户端缓存10s，如有需要，可以再来请求一次 此处同request_team_detail
local function S2CJoinTeamProto(data)
    local bytes = shared_pb.SecretTeamDetailProto()
    bytes:ParseFromString(data.team_detail)

    TowerBackroomData.TroopsDetailInfo:updateInfo(bytes)
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true
    TowerBackroomData.InviteTroopsInfo.ShouldRefresh = true

    -- 加入队伍成功
    Event.dispatch(Event.TOWER_BACKROOM_JOIN_TROOPS_SUCCEED)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_JOIN_TEAM, S2CJoinTeamProto)

-- 其他人加入队伍
-- member: string // 队伍详细信息, shared_proto.SecretTeamMemberProto
-- protect_end_time: int // 新的保护结束unix时间戳
local function S2COtherJoinJoinTeamProto(data)
    local bytes = shared_pb.SecretTowerTeamMemberProto()
    bytes:ParseFromString(data.member)

    local member = TowerBackroomTroopsMemberClass()
    member:updateInfo(bytes)
    table.insert(TowerBackroomData.TroopsDetailInfo.Members, member)

    TowerBackroomData.TroopsDetailInfo.ProtectEndTime = data.protect_end_time
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true
    TowerBackroomData.InviteTroopsInfo.ShouldRefresh = true

    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_OTHER_JOIN_JOIN_TEAM, S2COtherJoinJoinTeamProto)

-- 加入队伍失败
local function S2CFailJoinTeamProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_JOIN_TEAM, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_JOIN_TEAM, S2CFailJoinTeamProto)

-- 队伍信息更新
-- team_detail: bytes // 队伍详细信息, shared_proto.SecretTeamDetailProto
local function S2CRequestTeamDetailProto(data)
    local bytes = shared_pb.SecretTeamDetailProto()
    bytes:ParseFromString(data.team_detail)

    TowerBackroomData.TroopsDetailInfo:updateInfo(bytes)
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true
    TowerBackroomData.InviteTroopsInfo.ShouldRefresh = true

    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_REQUEST_TEAM_DETAIL, S2CRequestTeamDetailProto)

-- 队伍信息更新失败
local function S2CFailRequestTeamDetailProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_DETAIL, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_DETAIL, S2CFailRequestTeamDetailProto)

-- 自身离开队伍
local function S2CSelfLeaveTeamProto(data)
    TowerBackroomData.TroopsDetailInfo.TeamId = -1
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true
    TowerBackroomData.InviteTroopsInfo.ShouldRefresh = true

    -- 离开队伍
    Event.dispatch(Event.TOWER_BACKROOM_LEAVE_TROOPS_SUCCEED)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_LEAVE_TEAM, S2CSelfLeaveTeamProto)

-- 其他人离开队伍
-- id: int // 离开的人的id
-- new_team_leader_id: string // 新的队长id，跟此前队长id相同表示队长没变
local function S2COtherLeaveLeaveTeamProto(data)
    TowerBackroomData.TroopsDetailInfo.LeaderId = data.new_team_leader_id
    for i = 1, #TowerBackroomData.TroopsDetailInfo.Members do
        if TowerBackroomData.TroopsDetailInfo.Members[i].Id == data.id then
            table.remove(TowerBackroomData.TroopsDetailInfo.Members, i)
            break
        end
    end
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true
    TowerBackroomData.InviteTroopsInfo.ShouldRefresh = true

    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_OTHER_LEAVE_LEAVE_TEAM, S2COtherLeaveLeaveTeamProto)

-- 离开队伍失败
local function S2CFailLeaveTeamProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_LEAVE_TEAM, code)
    -- 离开队伍
    Event.dispatch(Event.TOWER_BACKROOM_LEAVE_TROOPS_SUCCEED)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_LEAVE_TEAM, S2CFailLeaveTeamProto)

-- 剔出他人
-- id: int // 离开的人的id
local function S2CKickMemberProto(data)
    for i = 1, #TowerBackroomData.TroopsDetailInfo.Members do
        if TowerBackroomData.TroopsDetailInfo.Members[i].Id == data.id then
            table.remove(TowerBackroomData.TroopsDetailInfo.Members, i)
            break
        end
    end
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true
    TowerBackroomData.InviteTroopsInfo.ShouldRefresh = true

    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_KICK_MEMBER, S2CKickMemberProto)

-- 自己被踢出
local function S2CSelfBeenKickKickMemberProto(data)
    TowerBackroomData.TroopsDetailInfo.TeamId = -1
    TowerBackroomData.FloorTroopsInfo[TowerBackroomData.TroopsDetailInfo.FloorId].ShouldRefresh = true
    TowerBackroomData.InviteTroopsInfo.ShouldRefresh = true

    UIManager.showTip( { content = Localization.BackroomTroopKickedOut, result = false })
    -- 离开队伍
    Event.dispatch(Event.TOWER_BACKROOM_LEAVE_TROOPS_SUCCEED)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_YOU_BEEN_KICKED_KICK_MEMBER, S2CSelfBeenKickKickMemberProto)

-- 他人剔出他人
-- id: int // 离开的人的id
local function S2COtherBeenKickKickMemberProto(data)
    S2CKickMemberProto(data)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_OTHER_BEEN_KICK_KICK_MEMBER, S2COtherBeenKickKickMemberProto)

-- 成员移动
-- id: int // 离开的人的id
-- up: boolean // true(上移)/false(下移)
local function S2CBroadcsatMoveMemberProto(data)
    local index = 0
    for i = 1, #TowerBackroomData.TroopsDetailInfo.Members do
        if TowerBackroomData.TroopsDetailInfo.Members[i].Id == data.id then
            index = i
            break
        end
    end
    local curTroop = TowerBackroomData.TroopsDetailInfo.Members[index]
    if data.up then
        TowerBackroomData.TroopsDetailInfo.Members[index] = TowerBackroomData.TroopsDetailInfo.Members[index - 1]
        TowerBackroomData.TroopsDetailInfo.Members[index - 1] = curTroop
    else
        TowerBackroomData.TroopsDetailInfo.Members[index] = TowerBackroomData.TroopsDetailInfo.Members[index + 1]
        TowerBackroomData.TroopsDetailInfo.Members[index + 1] = curTroop
    end

    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_BROADCSAT_MOVE_MEMBER, S2CBroadcsatMoveMemberProto)

-- 成员移动失败
local function S2CFailMoveMemberProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_MOVE_MEMBER, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_MOVE_MEMBER, S2CFailMoveMemberProto)

-- 修改挑战模式
-- mode: int // 模式类型
local function S2CChangeModeProto(data)
    for i = 1, #TowerBackroomData.TroopsDetailInfo.Members do
        if TowerBackroomData.TroopsDetailInfo.Members[i].Id == DataTrunk.PlayerInfo.MonarchsData.Id then
            TowerBackroomData.TroopsDetailInfo.Members[i].Mode = data.mode
            break
        end
    end
    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_CHANGE_MODE, S2CChangeModeProto)

-- 别人修改了挑战模式
-- mode: int // 模式类型
-- id: string // 谁修改了自己的模式
local function S2COtherChangedChangeModeProto(data)
    for i = 1, #TowerBackroomData.TroopsDetailInfo.Members do
        if TowerBackroomData.TroopsDetailInfo.Members[i].Id == data.id then
            TowerBackroomData.TroopsDetailInfo.Members[i].Mode = data.mode
            break
        end
    end
    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_OTHER_CHANGED_CHANGE_MODE, S2COtherChangedChangeModeProto)

-- 挑战模式失败
local function S2CFailChangedChangeModeProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_CHANGE_MODE, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_CHANGE_MODE, S2CFailChangedChangeModeProto)

-- 新的协助次数
-- new_times: int // 新的协助次数
local function S2CHelpTimesChangeProto(data)
    TowerBackroomData.HelpTimes = BackroomCommonConfig.Config.MaxHelpTimes - data.new_times
    -- 基础信息更新
    Event.dispatch(Event.TOWER_BACKROOM_BASE_INFO_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_HELP_TIMES_CHANGE, S2CHelpTimesChangeProto)

-- 下次挑战次数恢复时间变更
-- start_recover_time: int // 新的开始恢复的unix时间
local function S2CTimesChangeProto(data)
    TowerBackroomData.StartRecoverTime = data.start_recover_time
    TowerBackroomData:startChallengeRecoverTimer()
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_TIMES_CHANGE, S2CTimesChangeProto)

-- 邀请他人成功
local function S2CInviteProto(data)
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, { Id = data.id, Result = TowerBackroomData.InviteResultType.Invited })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_INVITE, S2CInviteProto)

-- 邀请他人失败未找到目标
local function S2CFailTargetNotFoundInviteProto(data)
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, { Id = data.id, Result = TowerBackroomData.InviteResultType.Invited })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_TARGET_NOT_FOUND_INVITE, S2CFailTargetNotFoundInviteProto)

-- 邀请他人失败目标玩家不在本盟
local function S2CFailTargetNotInMyGuildInviteProto(data)
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, { Id = data.id, Result = TowerBackroomData.InviteResultType.Invited })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_TARGET_NOT_IN_MY_GUILD_INVITE, S2CFailTargetNotInMyGuildInviteProto)

-- 邀请他人失败目标未开启密室
local function S2CFailTargetNotOpenInviteProto(data)
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, { Id = data.id, Result = TowerBackroomData.InviteResultType.NotOpen })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_TARGET_NOT_OPEN_INVITE, S2CFailTargetNotOpenInviteProto)

-- 邀请他人失败目标不在线
local function S2CFailTargetNotOnlineInviteProto(data)
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, { Id = data.id, Result = TowerBackroomData.InviteResultType.Invited })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_TARGET_NOT_ONLINE_INVITE, S2CFailTargetNotOnlineInviteProto)

-- 邀请他人失败目标已在队伍中
local function S2CFailTargetInYourTeamInviteProto(data)
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, { Id = data.id, Result = TowerBackroomData.InviteResultType.Invited })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_TARGET_IN_YOUR_TEAM_INVITE, S2CFailTargetInYourTeamInviteProto)

-- 邀请他人失败目标没有次数了
local function S2CFailTargetNoTimesInviteProto(data)
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, { Id = data.id, Result = TowerBackroomData.InviteResultType.NotNum })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_TARGET_NO_TIMES_INVITE, S2CFailTargetNoTimesInviteProto)

-- 邀请他人失败
local function S2CFailInviteProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_INVITE, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_INVITE, S2CFailInviteProto)

-- 邀请数量
-- count: int // 邀请的数量，客户端根据邀请数量自己决定是否显示图标
local function S2CReceiveInviteProto(data)
    TowerBackroomData.InviteTroopsInfo.TroopsCount = data.count
    -- 邀请次数更新
    Event.dispatch(Event.TOWER_BACKROOM_INVITE_COUNT)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_RECEIVE_INVITE, S2CReceiveInviteProto)

-- 接收到邀请
-- invite_list: bytes // 邀请列表, []shared_proto.SecretTeamShowProto
local function S2CRequestInviteListProto(data)
    TowerBackroomData.InviteTroopsInfo:clear()

    TowerBackroomData.InviteTroopsInfo.Floor = -1
    TowerBackroomData.InviteTroopsInfo.Troops = { }
    -- 队伍
    for k, v in ipairs(data.invite_list) do
        local bytes = shared_pb.SecretTeamShowProto()
        bytes:ParseFromString(v)

        local troop = TowerBackroomTroopsBriefClass()
        troop:updateInfo(bytes)

        table.insert(TowerBackroomData.InviteTroopsInfo.Troops, troop)
    end
    -- 队伍个数
    TowerBackroomData.InviteTroopsInfo.TroopsCount = #TowerBackroomData.InviteTroopsInfo.Troops
    -- 开始计时
    TowerBackroomData.InviteTroopsInfo.RefreshTimer:start()

    -- 邀请的队伍信息刷新
    Event.dispatch(Event.TOWER_BACKROOM_TROOPS_REFRESH)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_REQUEST_INVITE_LIST, S2CRequestInviteListProto)

-- 开始挑战
-- result: bytes // 结果 shared_proto.SecretChallengeResultProto
local function S2CBroadcastStartChallengeProto(data)
    -- 解析
    local bytes = shared_pb.SecretChallengeResultProto()
    bytes:ParseFromString(data.result)

    -- 战斗回放
    TowerBackroomData.BackroomReplay:clear()
    -- 结果信息
    TowerBackroomData.BackroomReplay.Result.OtherResultInfo = TowerBackroomBattleResultClass()
    TowerBackroomData.BackroomReplay.Result.OtherResultInfo:updateInfo(bytes)

    -- 退出队伍
    TowerBackroomData.TroopsDetailInfo.TeamId = -1

    -- 挑战回复
    Event.dispatch(Event.TOWER_BACKROOM_BATTLE_REPLAY_ACK)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_BROADCAST_START_CHALLENGE, S2CBroadcastStartChallengeProto)

-- 挑战失败
local function S2CFailBroadcastStartChallengeProto(code)
    UIManager.showNetworkErrorTip(secret_tower_decoder.ModuleID, secret_tower_decoder.S2C_FAIL_START_CHALLENGE, code)
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_START_CHALLENGE, S2CFailBroadcastStartChallengeProto)

-- 挑战失败，没有充足挑战次数
-- id: string // 玩家id
-- name: string // 玩家名字
-- guild_flag: string // 玩家帮旗
local function S2CFailWithMemberTimesNotEnoughStartChallengeProto(data)
    UIManager.showTip( { content = Localization.BackroomChallengeResult_1, result = false })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_WITH_MEMBER_TIMES_NOT_ENOUGH_START_CHALLENGE, S2CFailWithMemberTimesNotEnoughStartChallengeProto)

-- 挑战失败，没有充足协助次数
-- id: string // 玩家id
-- name: string // 玩家名字
-- guild_flag: string // 玩家帮旗
local function S2CFailWithMemberHelpTimesNotEnoughStartChallengeProto(data)
    UIManager.showTip( { content = Localization.BackroomChallengeResult_2, result = false })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_WITH_MEMBER_HELP_TIMES_NOT_ENOUGH_START_CHALLENGE, S2CFailWithMemberHelpTimesNotEnoughStartChallengeProto)

-- 挑战失败，没有联盟的
-- id: string // 玩家id
-- name: string // 玩家名字
-- guild_flag: string // 玩家帮旗
local function S2CFailWithMemberNoGuildStartChallengeProto(data)
    UIManager.showTip( { content = Localization.BackroomChallengeResult_3, result = false })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_WITH_MEMBER_NO_GUILD_START_CHALLENGE, S2CFailWithMemberNoGuildStartChallengeProto)

-- 挑战失败，不是该联盟的
-- id: string // 玩家id
-- name: string // 玩家名字
-- guild_flag: string // 玩家帮旗
local function S2CFailWithMemberNotMyGuildStartChallengeProto(data)
    UIManager.showTip( { content = Localization.BackroomChallengeResult_4, result = false })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_WITH_MEMBER_NOT_MY_GUILD_START_CHALLENGE, S2CFailWithMemberNotMyGuildStartChallengeProto)

-- 挑战失败，开的是协助模式，但是没有联盟
-- id: string // 玩家id
-- name: string // 玩家名字
-- guild_flag: string // 玩家帮旗
local function S2CFailWithMemberIsHelpButNoGuildStartChallengeProto(data)
    UIManager.showTip( { content = Localization.BackroomChallengeResult_5, result = false })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_WITH_MEMBER_IS_HELP_BUT_NO_GUILD_START_CHALLENGE, S2CFailWithMemberIsHelpButNoGuildStartChallengeProto)

-- 挑战失败，开的是协助模式，但是没有盟友
-- id: string // 玩家id
-- name: string // 玩家名字
-- guild_flag: string // 玩家帮旗
local function S2CFailWithMemberIsHelpButNoGuildMemberStartChallengeProto(data)
    UIManager.showTip( { content = Localization.BackroomChallengeResult_6, result = false })
end
secret_tower_decoder.RegisterAction(secret_tower_decoder.S2C_FAIL_WITH_MEMBER_IS_HELP_BUT_NO_GUILD_MEMBER_START_CHALLENGE, S2CFailWithMemberIsHelpButNoGuildMemberStartChallengeProto)

return TowerBackroomData