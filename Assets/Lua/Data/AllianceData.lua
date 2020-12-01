-- *********************************************************************
-- 联盟信息
-- *********************************************************************

-- 联盟实例化信息
local AllianceData = { }
-- 联盟列表
AllianceData.AllianceList = { }
-- 联盟的实例化数据(GuildClass())
AllianceData.MyAlliance = nil
-- 成员列表(GuildMemberClass[])
AllianceData.MemberList = { }
-- 我的联盟数据(GuildMemberClass())
AllianceData.MyData = nil
-- 在线成员数据
AllianceData.OnlineMemberData = { }
-- 当前版本
AllianceData.Version = 0
-- 联盟雕像
AllianceData.StatueLocation = 0

-- 清除信息
function AllianceData:clear()
    self.AllianceList = { }
    self.MyAlliance = nil
end

-- 更新所有联盟信息
function AllianceData:updateAllAllianceInfo(data)
    if data == nil then
        return
    end

    if AllianceData.AllianceList == nil then
        AllianceData.AllianceList = { }
    end

    if AllianceData.AllianceList[data.id] == nil then
        AllianceData.AllianceList[data.id] = GuildClass()
    end

    AllianceData.AllianceList[data.id]:updateInfo(data)
end

-- 更新我的联盟信息
function AllianceData:updateMyAllianceInfo(data)
    if data == nil then
        return
    end

    if self.MyAlliance == nil then
        self.MyAlliance = GuildClass()
    end

    self.MyAlliance:updateInfo(data)
    -- 成员列表(把首领放进去)
    self.MemberList = { }
    table.insert(self.MemberList, self.MyAlliance.Leader)

    for k, v in pairs(self.MyAlliance.Members) do
        table.insert(self.MemberList, v)
    end

    -- 在线成员
    self.OnlineMemberData = { }

    for k, v in pairs(self.MemberList) do
        if v.Hero.LastOfflineTime <= 0 then
            table.insert(self.OnlineMemberData, v)
        end
    end

    -- 我的数据
    for k, v in pairs(self.MemberList) do
        if v.Hero.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
            self.MyData = v
        end
    end
end

-- 离开联盟
function AllianceData:leave()
    self.MyAlliance = nil
end

-- 通知联盟其他人，有玩家离开了联盟
function AllianceData:otherLeave(data)
    if data == nil or self.MyAlliance == nil then
        return
    end

    self.MyAlliance:leaveGuildForOther(data)
end

-- 踢出联盟, 联盟中所有管理员都会收到消息，用于更新成员列表（包括被踢的那个人）
function AllianceData:kickOther(data)
    if data == nil or self.MyAlliance == nil then
        return
    end

    self.MyAlliance:kickOther(data)
end
-- *********************************************************************
-- 功能相关
-- *********************************************************************
-- 根据玩家Id获取他的系统职称
-- id:君主id
function AllianceData:GetSystemTitle(id)
    if id == nil then
        return
    end

    local title = { }

    for k, v in pairs(self.MyAlliance.ClassTitle.SystemClassTitleMemberId) do
        if id == v then
            table.insert(title, self.MyAlliance.ClassTitle.SystemClassTitleId[k])
            ---- 系统职称只能有一个,所以可以break
            -- break
            -- 现在一个人可以有多个系统职称
        end
    end

    return title
end

-- 根据玩家Id获取他的自定义职称
-- id:君主id
function AllianceData:GetCustomTitle(id)
    if id == nil then
        return
    end

    local title = { }

    for k, v in pairs(self.MyAlliance.ClassTitle.CustomClassTitleMemberId) do
        for i, j in pairs(v.V) do
            if id == j then
                table.insert(title, self.MyAlliance.ClassTitle.CustomClassTitleName[k])
                -- 一种自定义职称只能有一个
                break
            end
        end
    end

    return title
end

-- 根据Id获取他的数据(HeroBasicSnapshotClass())
-- id:string
function AllianceData:GetMemberDataById(id)
    if id == nil then
        return
    end

    for k, v in pairs(self.MemberList) do
        if id == v.Hero.Id then
            return v
        end
    end

    return nil
end

-- 根据Id获取他的职位
function AllianceData:GetMemberPostById(id)
    if id == nil then
        return
    end

    -- v:GuildMemberClass()
    for k, v in pairs(self.MemberList) do
        if id == v.Hero.Id then
            return v.ClassLevel
        end
    end

    return nil
end

-- *********************************************************************
-- 联盟相关协议
-- *********************************************************************

-- 更新所有联盟的信息
local function UpdateAllGuildInfo(data)
    if data == nil then
        return
    end

    -- 本次获取到的所有联盟Id
    local allianceIdList = nil

    for k, v in ipairs(data) do
        local allianceInfo = shared_pb.GuildProto()
        allianceInfo:ParseFromString(v)

        if allianceInfo ~= nil then
            if allianceIdList == nil then
                allianceIdList = { }
            end
            table.insert(allianceIdList, allianceInfo.id)

            -- 更新到所有联盟信息列表中
            AllianceData:updateAllAllianceInfo(allianceInfo)
        end
    end

    return allianceIdList
end

-- 更新我的联盟的信息
local function UpdateMyGuildInfo(data)
    if data == nil then
        return
    end

    local allianceInfo = shared_pb.GuildProto()
    allianceInfo:ParseFromString(data)

    if allianceInfo ~= nil then
        -- 更新我的联盟信息
        AllianceData:updateMyAllianceInfo(allianceInfo)
    end
end

-- 获取联盟列表
-- moduleId = 9, msgId = 2
-- guilds: bytes[] // shared_proto.GuildProto
local function S2CListGuildProto(data)
    if data == nil or data.guilds == nil then
        return
    end

    local allianceIdList = UpdateAllGuildInfo(data.guilds)

    -- 发送消息
    Event.dispatch(Event.ON_UPDATE_GUILD_LIST, allianceIdList)
end
guild_decoder.RegisterAction(guild_decoder.S2C_LIST_GUILD, S2CListGuildProto)

-- 获取联盟列表失败
-- moduleId = 9, msgId = 3
local function S2CFailListGuildProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_LIST_GUILD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_LIST_GUILD, S2CFailListGuildProto)

-- *********************************************************************
-- 搜索联盟
-- moduleId = 9, msgId = 5
-- proto: bytes[] // shared_proto.GuildProto
local function S2CSearchGuildProto(data)
    if data == nil or data.proto == nil then
        return
    end

    local allianceIdList = UpdateAllGuildInfo(data.proto)

    -- 发送消息
    Event.dispatch(Event.ON_UPDATE_GUILD_LIST, allianceIdList)
end
guild_decoder.RegisterAction(guild_decoder.S2C_SEARCH_GUILD, S2CSearchGuildProto)

-- 搜索联盟失败
-- moduleId = 9, msgId = 6
local function S2CFailSearchGuildProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_SEARCH_GUILD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_SEARCH_GUILD, S2CFailSearchGuildProto)

-- *********************************************************************
-- 创建联盟
-- moduleId = 9, msgId = 8
-- proto: bytes // shared_proto.GuildProto
local function S2CCreateGuildProto(data)
    if data == nil or data.proto == nil then
        return
    end

    UpdateMyGuildInfo(data.proto)

    -- 更新君主信息
    if AllianceData.MyAlliance ~= nil then
        DataTrunk.PlayerInfo.MonarchsData:updateGuildInfo(AllianceData.MyAlliance.Id, AllianceData.MyAlliance.Name, AllianceData.MyAlliance.FlagName)
    end

    Event.dispatch(Event.ON_CREATE_GUILD)
end
guild_decoder.RegisterAction(guild_decoder.S2C_CREATE_GUILD, S2CCreateGuildProto)

-- 创建联盟失败
-- moduleId = 9, msgId = 9
local function S2CFailCreateGuildProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_CREATE_GUILD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_CREATE_GUILD, S2CFailCreateGuildProto)

-- *********************************************************************
-- 请求自己的联盟数据（已加入联盟）
-- 玩家打开联盟面板时候，请求这条数据，获取联盟详细数据
-- 此消息会根据情况返回2条消息，
-- 1、如果服务器的版本跟客户端不一致，则返回本条消息的s2c消息，客户端更新version以及刷新联盟面板数据
-- 2、如果服务器的版本号跟客户端的一致，则返回 self_guild_same_version的s2c消息
-- 客户端的联盟面板一致持续打开的情况下(关掉就不要请求了)，每5秒请求一次帮派自己的数据，刷新帮派面板展示
-- moduleId = 9, msgId = 11
-- varsion: int // 最新的联盟数据版本号，每次拿到后，客户端存着这个值，下次请求时，带上这个值
-- proto: bytes // shared_proto.GuildProto
local function S2CSelfGuildProto(data)
    if data == nil then
        return
    end

    AllianceData.Version = data.varsion
    UpdateMyGuildInfo(data.proto)

    Event.dispatch(Event.REQ_MY_GUILD_DATA_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_SELF_GUILD, S2CSelfGuildProto)

-- 请求自己的联盟数据（已加入联盟）失败
-- moduleId = 9, msgId = 12
local function S2CFailSelfGuildProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_SELF_GUILD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_SELF_GUILD, S2CFailSelfGuildProto)

-- *********************************************************************
-- 退出联盟
-- moduleId = 9, msgId = 14
local function S2CLeaveGuildProto()
    AllianceData:leave()

    -- 更新君主信息
    DataTrunk.PlayerInfo.MonarchsData:updateGuildInfo(0, "", "")

    Event.dispatch(Event.ON_LEAVE_GUILD)
end
guild_decoder.RegisterAction(guild_decoder.S2C_LEAVE_GUILD, S2CLeaveGuildProto)

-- 退出联盟失败
-- moduleId = 9, msgId = 15
local function S2CFailLeaveGuildProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_LEAVE_GUILD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_LEAVE_GUILD, S2CFailLeaveGuildProto)

-- *********************************************************************
-- 通知联盟其他人，有玩家离开了联盟
-- moduleId = 9, msgId = 16
-- id: string // 离开联盟的玩家id
-- name: string // 离开联盟的玩家名字
local function S2CLeaveGuildForOtherProto(data)
    if data == nil or data.id == nil or data.name == nil then
        return
    end

    AllianceData:otherLeave(data)

    -- 飘字提示
    UIManager.showTip( { content = string.format(Localization.AllianceOtherLeave, data.name), result = false })

    Event.dispatch(Event.ON_OTHER_LEAVE_GUILD)
end
guild_decoder.RegisterAction(guild_decoder.S2C_LEAVE_GUILD_FOR_OTHER, S2CLeaveGuildForOtherProto)

-- *********************************************************************
-- 踢出联盟（组织上的大哥干的事情）
-- GuildProto
--   int32 kick_member_count = 32; // 踢人数，限制每日最多踢几个
-- config.GuildConfig.DailyMaxKickCount = 1; // 每日最多可以踢多少人，联盟满员时候不受这个限制
-- GuildClassLevelProto.kick_lower_member = true 表示允许踢人（低阶级盟友）
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
-- moduleId = 9, msgId = 18
-- id: string // 目标id
local function S2CKickOtherProto(data)
    if data == nil or data.id == nil then
        return
    end

    AllianceData:kickOther(data.id)
    -- 飘字提示
    UIManager.showTip( { content = string.format(Localization.AllianceOtherBeKicked, data.name), result = false })
    Event.dispatch(Event.ON_KICK_OTHER)
end
guild_decoder.RegisterAction(guild_decoder.S2C_KICK_OTHER, S2CKickOtherProto)

-- 踢出联盟失败
-- moduleId = 9, msgId = 19
local function S2CFailKickOtherProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_KICK_OTHER, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_KICK_OTHER, S2CFailKickOtherProto)

-- *********************************************************************
-- 修改联盟宣言（组织上的老头干的事情）
-- 联盟中所有人都会收到s2c消息，用于更新联盟宣言
-- moduleId = 9, msgId = 21
-- text: string // 联盟宣言
local function S2CUpdateTextProto(data)
    if data == nil or data.text == nil then
        return
    end

    -- 修改宣言成功
    UIManager.showTip( { content = Localization.AllianceUpdateText, result = true })
    AllianceData.MyAlliance:updateInfo(data)
    Event.dispatch(Event.ON_UPDATE_GUILD_TEXT)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_TEXT, S2CUpdateTextProto)

-- 修改联盟宣言失败
-- moduleId = 9, msgId = 22
local function S2CFailUpdateTextProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_TEXT, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_TEXT, S2CFailUpdateTextProto)

-- *********************************************************************
-- 修改联盟阶级称谓
-- 未设置时候，读取这里面的值 GuildClassLevelProto.name
-- moduleId = 9, msgId = 24
-- name: string[] // 联盟阶级称谓
local function S2CUpdateClassNamesProto(data)
    Event.dispatch(Event.ON_UPDATE_CLASS_NAME)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_CLASS_NAMES, S2CUpdateClassNamesProto)

-- 修改联盟阶级称谓失败
-- moduleId = 9, msgId = 25
local function S2CFailUpdateClassNamesProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_CLASS_NAMES, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_CLASS_NAMES, S2CFailUpdateClassNamesProto)

-- *********************************************************************
-- 修改组织联盟旗帜(就是旗号的底图)
-- moduleId = 9, msgId = 27
-- flag_type: int // 旗帜类型，从0开始
local function S2CUpdateFlagTypeProto(data)
    -- 这玩意儿没什么用
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_FLAG_TYPE, S2CUpdateFlagTypeProto)

-- 修改组织联盟旗帜失败
-- moduleId = 9, msgId = 28
local function S2CFailUpdateFlagTypeProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_FLAG_TYPE, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_FLAG_TYPE, S2CFailUpdateFlagTypeProto)

-- *********************************************************************
-- 修改成员职位成功
-- moduleId = 9, msgId = 30
-- id: string // 目标id
-- class_level: int // 新的阶级
local function S2CUpdateMemberClassLevelProto(data)
    UIManager.showTip( { content = Localization.AllianceModifyTitleSuccess, result = true })
    Event.dispatch(Event.ON_CHANGE_MEMBER_POST_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_MEMBER_CLASS_LEVEL, S2CUpdateMemberClassLevelProto)

-- 修改成员阶级失败
-- moduleId = 9, msgId = 31
local function S2CFailUpdateMemberClassLevelProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_MEMBER_CLASS_LEVEL, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_MEMBER_CLASS_LEVEL, S2CFailUpdateMemberClassLevelProto)

-- *********************************************************************
-- 加入联盟分2部分，玩家申请加入联盟，以及被邀请加入联盟
-- v01版本这2个都不做，只做一个简单的，点击加入就进入联盟
-- 下面先把简单的部分搞上了

-- 加入联盟（v01版本做的，不需要审核，一点就加入）
-- moduleId = 9, msgId = 33
-- id: int // 帮派id
-- name: string // 帮派名字
-- flag_name: string // 帮派旗号
local function S2CJoinGuildV01Proto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_JOIN_GUILD_V01, S2CJoinGuildV01Proto)

-- 加入联盟失败
-- moduleId = 9, msgId = 34
local function S2CFailJoinGuildV01Proto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_JOIN_GUILD_V01, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_JOIN_GUILD_V01, S2CFailJoinGuildV01Proto)

-- *********************************************************************
-- 有新的盟友加入联盟（联盟中所有人收到）
-- moduleId = 9, msgId = 35
-- id: string // 玩家id
-- name: string // 玩家名字
local function S2CAddGuildMemberProto(data)
    if data == nil or data.id == nil then
        return
    end

    -- 飘字提示
    UIManager.showTip( { content = string.format(Localization.AllianceOtherJoined, data.name), result = true })
    if AllianceData.MyAlliance ~= nil then
        AllianceData.MyAlliance:newMember(data)
    end
    Event.dispatch(Event.ON_NEW_MEMBER_JOIN)
end
guild_decoder.RegisterAction(guild_decoder.S2C_ADD_GUILD_MEMBER, S2CAddGuildMemberProto)

-- *********************************************************************
-- 玩家已经加入联盟，做加入联盟的处理，比如主ui上面显示联盟信息等等
-- 先把自己所有的申请加入删除，邀请加入申请删除（v01不做的部分，但是要记得处理这部分数据）
-- 此时打开联盟面板，当中第一次请求联盟数据，请求自己的联盟数据
-- moduleId = 9, msgId = 36
-- id: int // 已加入联盟id
-- name: string // 联盟名字
-- flag_name: string // 联盟旗号
local function S2CUserJoinedProto(data)
    if data == nil or data.id == nil then
        return
    end

    -- 更新君主信息
    DataTrunk.PlayerInfo.MonarchsData:updateGuildInfo(data.id, data.name, data.flag_name)

    -- 飘字提示
    UIManager.showTip( { content = string.format(Localization.AllianceJoined, data.name), result = true })
    -- 请求联盟数据
    NetworkManager.C2SGetSelfGuildProto(DataTrunk.PlayerInfo.AllianceData.Version)
    Event.dispatch(Event.ON_JOINED_GUILD)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_JOINED, S2CUserJoinedProto)

-- *********************************************************************
-- 申请加入联盟 --------------
-- （玩家消息）玩家申请加入联盟（申请加入哪个联盟）
-- HeroProto.joinGuildIds 表示当前已申请的联盟id 列表
-- config.GuildCofnig.user_max_join_request_count = 26; // 用户最大申请加入联盟数量（默认5条）
-- 申请加入的联盟如果是允许自动加入，则会收到user_joined，不会收到s2c消息
-- 申请成功(收到s2c消息)，将这个联盟id加入到已申请联盟id 列表
-- moduleId = 9, msgId = 41
-- id: int // 申请联盟id，将这个id加入到申请id列表
local function S2CUserRequestJoinProto(data)
    if data == nil or data.id == nil then
        return
    end

    -- 飘字提示:申请成功
    UIManager.showTip( { content = Localization.AllianceApplicationSuccess, result = true })

    Event.dispatch(Event.ON_APPLY_TO_JOIN_ALLIANCE_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_REQUEST_JOIN, S2CUserRequestJoinProto)

-- 申请加入联盟失败
-- moduleId = 9, msgId = 42
local function S2CFailUserRequestJoinProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_USER_REQUEST_JOIN, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_USER_REQUEST_JOIN, S2CFailUserRequestJoinProto)

-- *********************************************************************
-- 玩家取消申请加入帮派
-- 取消成功，将这个联盟id从已申请联盟id 列表中移除
-- moduleId = 9, msgId = 44
-- id: int // 取消加入帮派id
local function S2CUserCancelJoinRequestProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_CANCEL_JOIN_REQUEST, S2CUserCancelJoinRequestProto)

-- 玩家取消申请加入帮派失败
-- moduleId = 9, msgId = 45
local function S2CFailUserCancelJoinRequestProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_USER_CANCEL_JOIN_REQUEST, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_USER_CANCEL_JOIN_REQUEST, S2CFailUserCancelJoinRequestProto)

-- *********************************************************************
-- 玩家回复邀请加入帮派
-- （玩家加入帮派，通过加入帮派消息处理user_join_guild，这里的消息只处理邀请列表）
-- moduleId = 9, msgId = 49
-- id: int // 邀请的帮派id
-- agree: bool // true表示同意加入帮派
local function S2CUserReplyInvateRequestProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_REPLY_INVATE_REQUEST, S2CUserReplyInvateRequestProto)

-- 玩家回复邀请加入帮派失败
-- moduleId = 9, msgId = 50
local function S2CFailUserReplyInvateRequestProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_USER_REPLY_INVATE_REQUEST, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_USER_REPLY_INVATE_REQUEST, S2CFailUserReplyInvateRequestProto)

-- *********************************************************************
-- （联盟消息）审批加入联盟申请
-- GuildProto中可以获取到申请加入联盟的列表
-- GuildJoinRequestProto join_request = 27; // 申请加入/邀请加入的玩家信息
-- 审批加入联盟(有允许同意申请入盟权限的操作)
-- moduleId = 9, msgId = 56
-- id: string // 玩家id
-- agree: bool // true表示同意加入联盟，否则表示拒绝加入
local function S2CGuildReplyJoinRequestProto(data)
    if data == nil then
        return
    end

    -- 手动移除
    for k, v in pairs(DataTrunk.PlayerInfo.AllianceData.MyAlliance.RequestJoinHero) do
        if v.Id == data.id then
            table.remove(DataTrunk.PlayerInfo.AllianceData.MyAlliance.RequestJoinHero, k)
            break
        end
    end

    Event.dispatch(Event.ALLIANCE_REPLY_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_GUILD_REPLY_JOIN_REQUEST, S2CGuildReplyJoinRequestProto)

-- 审批加入联盟失败
-- moduleId = 9, msgId = 57
local function S2CFailGuildReplyJoinRequestProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_GUILD_REPLY_JOIN_REQUEST, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_GUILD_REPLY_JOIN_REQUEST, S2CFailGuildReplyJoinRequestProto)

-- *********************************************************************
-- 组织上的老头干的事情
-- 修改内部公告
-- moduleId = 9, msgId = 66
-- text: string // 联盟内部公告
local function S2CUpdateinternalText(data)
    if data == nil or data.text == nil then
        return
    end

    -- 更新公告成功
    UIManager.showTip( { content = Localization.AllianceUpdateNotice, result = true })

    local myData = { }
    myData.internal_text = data.text

    AllianceData.MyAlliance:updateInfo(myData)

    Event.dispatch(Event.ON_UPDATE_GUILD_NOTICE)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_INTERNAL_TEXT, S2CUpdateinternalText)

-- 修改内部公告失败
-- moduleId = 9, msgId = 67
local function S2CFailUpdateinternalText(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_INTERNAL_TEXT, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_INTERNAL_TEXT, S2CFailUpdateinternalText)

-- *********************************************************************
-- 修改入盟条件
-- moduleId = 9, msgId = 69
-- reject_auto_join: bool // false表示达到条件直接入盟，true表示需要申请才能加入
-- required_hero_level: int // 君主等级
-- required_jun_xian_level: int // 百战军衔等级
local function S2CUpdateJoinConditionProto(data)
    UIManager.showTip( { content = Localization.AllianceModifyJoinConditionSuccess, result = true })
    Event.dispatch(Event.ALLIANCE_MODIFY_JOIN_CONDITION_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_JOIN_CONDITION, S2CUpdateJoinConditionProto)

-- 修改入盟条件失败
-- moduleId = 9, msgId = 70
local function S2CFailUpdateJoinConditionProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_JOIN_CONDITION, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_JOIN_CONDITION, S2CFailUpdateJoinConditionProto)

-- *********************************************************************
-- 联盟改名改旗号
-- 联盟改名消耗：config.MiscConfig.ChangeGuildNameCost
-- 联盟改名成功后，会统一推送消息（根据这个消息来修改联盟数据），update_guild_name_broadcast
-- moduleId = 9, msgId = 72
local function S2CUpdateGuildNameProto()
    UIManager.showTip( { content = Localization.AllianceModifyNameOrFlagSuccess, result = true })
    Event.dispatch(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_GUILD_NAME, S2CUpdateGuildNameProto)

-- 联盟改名改旗号失败
-- moduleId = 9, msgId = 73
local function S2CFailUpdateGuildNameProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_GUILD_NAME, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_GUILD_NAME, S2CFailUpdateGuildNameProto)

-- *********************************************************************
-- 联盟改名广播
-- 所有收到这条消息的人，将自己的联盟名字和旗号改掉
-- 包括但不限于以下为主，君主面板，主界面，等等
-- moduleId = 9, msgId = 74
-- id: int // 联盟id
-- name: string // 联盟名字
-- flag_name: string // 联盟旗号
local function S2CUpdateGuildNameBroadCastProto(data)
    Event.dispatch(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_GUILD_NAME_BROADCAST, S2CUpdateGuildNameBroadCastProto)

-- *********************************************************************
-- 修改联盟标签
-- 联盟标签字符个数限制（1个汉字算1个字符，2个英文算1个字符）：config.MiscConfig.GuildLabelLimitChar
-- 联盟标签个数上限：config.MiscConfig.GuildLabelLimitCount
-- 职位 GuildClassLevelData.UpdateLabel = true表示有权限修改联盟标签
-- moduleId = 9, msgId = 76
-- label: string[] // 标签
local function S2CUpdateGuildLabelProto(data)
    if data == nil then
        return
    end

    -- 更新标签成功
    UIManager.showTip( { content = Localization.AllianceUpdateLabel, result = true })

    if data.label ~= nil then
        AllianceData.MyAlliance.Labels = { }

        for k, v in ipairs(data.label) do
            table.insert(AllianceData.MyAlliance.Labels, v)
        end
    end

    Event.dispatch(Event.ON_UPDATE_GUILD_Label)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_GUILD_LABEL, S2CUpdateGuildLabelProto)

-- 修改联盟标签失败
-- moduleId = 9, msgId = 77
local function S2CFailUpdateGuildLabelProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_GUILD_LABEL, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_GUILD_LABEL, S2CFailUpdateGuildLabelProto)

-- *********************************************************************
-- 盟主取消禅让倒计时
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
-- moduleId = 9, msgId = 81
local function S2CCancelChangeLeader(data)
    UIManager.showTip( { content = Localization.AllianceCancelDemiseSuccess, result = true })
    Event.dispatch(Event.ALLIANCE_CANCEL_DEMISE_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_CANCEL_CHANGE_LEADER, S2CCancelChangeLeader)

-- 盟主取消禅让倒计时失败
-- moduleId = 9, msgId = 82
local function S2CFailCancelChangeLeader(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_CANCEL_CHANGE_LEADER, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_CANCEL_CHANGE_LEADER, S2CFailCancelChangeLeader)

-- *********************************************************************
-- 联盟捐献
-- 获取联盟捐献数据，GuildDonateProto，里面包含每个位置每次捐献的数据
-- 登陆时，从HeroProto中获取英雄自己的捐献次数
--     repeated int32 guild_donate_times = 33 [packed = false]; // 联盟已捐献次数
-- 根据已捐献次数来显示捐献项目的内容，如已捐献次数=0，那么显示捐献1次的数据
-- 当收到每日重置消息，misc.S2C_DAILY_RESET 时，将联盟已捐献次数设置为0，刷新面板
-- moduleId = 9, msgId = 84
-- sequence: int
-- times: int // 已捐献次数，显示times+1的数据出来
-- building_amount: int // 更新帮派建设值
-- contribution_amount: int // 更新自己的帮派贡献值
-- contribution_total_amount: int // 更新自己的总帮派贡献值
-- contribution_amount7: int // 更新自己的7日帮派贡献值
-- donation_amount: int // 更新自己的帮派捐献值
-- donation_total_amount: int // 更新自己的总帮派捐献值
-- donation_amount7: int // 更新自己的7日帮派捐献值
-- donation_total_yuanbao: int // 更新自己的总帮派捐献元宝
local function S2CDonateProto(data)
    if data == nil then
        return
    end

    DataTrunk.PlayerInfo.MonarchsData.GuildDonateTimes[data.sequence] = data.times
    AllianceData.MyAlliance:updateInfo(data)
    AllianceData.MyData:updateInfo(data)

    UIManager.showTip( { content = Localization.DonateSuccess, result = true })
    Event.dispatch(Event.ALLIANCE_DONATE_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_DONATE, S2CDonateProto)

-- 联盟捐献失败
-- moduleId = 9, msgId = 85
local function S2CFailDonateProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_DONATE, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_DONATE, S2CFailDonateProto)

-- *********************************************************************
-- 更新自己的联盟贡献币
-- 登陆时，从HeroProto中获取当前贡献币
--     int32 contribution_coin = 32; // 联盟贡献币
-- 收到消息时候，更新联盟贡献币
-- moduleId = 9, msgId = 86
-- coin: int // 更新后的贡献币
local function S2CUpdateContributionCoinProto(data)
    if data == nil or data.coin == nil then
        return
    end

    DataTrunk.PlayerInfo.MonarchsData.ContributionCoin = data.coin
    Event.dispatch(Event.ALLIANCE_ON_UPDATE_CONTRIBUTION_COIN)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_CONTRIBUTION_COIN, S2CUpdateContributionCoinProto)

-- *********************************************************************
-- 联盟数据一致返回消息
-- 收到此消息，说明目前服务器的联盟数据跟客户端的一致，客户端不需要更新
-- moduleId = 9, msgId = 87
local function S2CSelfGuildSameVersionProto()
    Event.dispatch(Event.ALLIANCE_SAME_VERSION)
end
guild_decoder.RegisterAction(guild_decoder.S2C_SELF_GUILD_SAME_VERSION, S2CSelfGuildSameVersionProto)

-- *********************************************************************
-- 联盟数据变化
-- 客户端收到此消息，如果当前正在打开联盟面板，则立即请求一次自己帮派数据，获取最新的联盟数据
-- 如果当前没有打开联盟面板，忽略此消息
-- moduleId = 9, msgId = 88
local function S2CSelfGuildChangedProto()
    NetworkManager.C2SGetSelfGuildProto(AllianceData.Version)
end
guild_decoder.RegisterAction(guild_decoder.S2C_SELF_GUILD_CHANGED, S2CSelfGuildChangedProto)

-- *********************************************************************
-- 你被T出帮派了
-- moduleId = 9, msgId = 89
local function S2CSelfBeenKicked()
    AllianceData:leave()

    -- 更新君主信息
    DataTrunk.PlayerInfo.MonarchsData:updateGuildInfo(0, "", "")

    -- 飘字提示
    UIManager.showTip( { content = Localization.AllianceBeKicked, result = false })
    Event.dispatch(Event.ON_LEAVE_GUILD)
end
guild_decoder.RegisterAction(guild_decoder.S2C_SELF_BEEN_KICKED, S2CSelfBeenKicked)

-- *********************************************************************
-- 升级联盟成功
-- 职位 GuildClassLevelData.UpgradeLevel = true表示有权限修改联盟标签
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
-- moduleId = 9, msgId = 91
local function S2CUpgradeLevelProto()
    Event.dispatch(Event.ALLIANCE_UPGRADE_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPGRADE_LEVEL, S2CUpgradeLevelProto)

-- 帮派升级失败
-- moduleId = 9, msgId = 92
local function S2CFailUpgradeLevelProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPGRADE_LEVEL, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPGRADE_LEVEL, S2CFailUpgradeLevelProto)

-- *********************************************************************
-- 帮派升级加速
-- 升级加速数据（包含每一级每次加速次数对应的数据）：GuildLevelCdrProto
-- GuildProto
--    int32 upgrade_end_time = 42; // 升级结束时间（0表示当前没有在升级），unix时间戳，秒
--    int32 cdr_times = 43; // 联盟升级已加速次数
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
-- moduleId = 9, msgId = 94
local function S2CReduceUpgradeLevelCDProto()
    Event.dispatch(Event.ALLIANCE_UPGRADE_SPEEDUP_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_REDUCE_UPGRADE_LEVEL_CD, S2CReduceUpgradeLevelCDProto)

-- 帮派升级加速失败
-- moduleId = 9, msgId = 95
local function S2CFailReduceUpgradeLevelCDProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_REDUCE_UPGRADE_LEVEL_CD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_REDUCE_UPGRADE_LEVEL_CD, S2CFailReduceUpgradeLevelCDProto)

-- *********************************************************************
-- 发起弹劾盟主
-- GuildImpeachProto.impeach_end_time = 26; // 0表示当前没有弹劾，否则表示当前正在弹劾盟主
--
-- 职位 GuildClassLevelData
--     bool impeach_npc_leader = 15; // true表示允许弹劾NPC盟主
--     int32 vote_score = 20; // 弹劾NPC盟主，这个职位的票数
--
-- ConfigProto.GuildConfigProto
--     int32 impeach_required_member_count = 22; // 需要联盟内存在多少玩家数量才能弹劾
--     int32 impeach_leader_offline_duration = 23; // 玩家盟主多长时间不在线可以弹劾，单位秒
--     int32 impeach_npc_leader_hour = 24; // 弹劾npc盟主小时数，如23
--     int32 impeach_npc_leader_minute = 25; // 弹劾npc盟主分钟数，如40 表示每天23点40分之前可以发起NPC弹劾
--
-- 服务器会主动推送帮派更新消息，根据消息刷新帮派面板
-- moduleId = 9, msgId = 97
local function S2CImpeachLeaderProto()
    UIManager.showTip( { content = Localization.AllianceImpeachSuccess, result = true })
    Event.dispatch(Event.ALLIANCE_IMPEACH_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_IMPEACH_LEADER, S2CImpeachLeaderProto)

-- 发起弹劾盟主失败
-- moduleId = 9, msgId = 98
local function S2CFailImpeachLeaderProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_IMPEACH_LEADER, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_IMPEACH_LEADER, S2CFailImpeachLeaderProto)

-- *********************************************************************
-- 弹劾盟主投票
-- 投票后会推送帮派更新消息，根据消息刷新帮派面板
-- moduleId = 9, msgId = 100
local function S2CImpeachLeaderVoteProto()
    Event.dispatch(Event.ALLIANCE_VOTE_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_IMPEACH_LEADER_VOTE, S2CImpeachLeaderVoteProto)

-- 弹劾盟主投票失败
-- moduleId = 9, msgId = 101
local function S2CFailImpeachLeaderVoteProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_IMPEACH_LEADER_VOTE, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_IMPEACH_LEADER_VOTE, S2CFailImpeachLeaderVoteProto)

-- *********************************************************************
-- （玩家消息）获取帮派列表（通过id查询帮派列表）
-- 以下功能使用这个消息，查询帮派列表数据
-- 玩家获取自己的申请加入帮派列表
-- 玩家获取自己的被邀请加入帮派列表
-- 每次最多请求id数 config.GuildConfig.guild_num_per_page = 14; // 每页多少个帮派数
-- moduleId = 9, msgId = 103
-- bytes[] // shared_proto.GuildProto
local function S2CListGuildByIdsProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_LIST_GUILD_BY_IDS, S2CListGuildByIdsProto)

-- 获取帮派列表失败
-- moduleId = 9, msgId = 104
local function S2CFailListGuildByIdsProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_LIST_GUILD_BY_IDS, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_LIST_GUILD_BY_IDS, S2CFailListGuildByIdsProto)

-- *********************************************************************
-- 邀请加入联盟 --------------------
-- （联盟消息）邀请加入联盟
-- GuildProto中可以获取到邀请加入联盟的列表
--     GuildJoinRequestProto join_request = 27; // 申请加入/邀请加入
-- 审批加入联盟(有允许同意申请入盟权限的操作)
-- GuildClassLevelData
--    bool invate_other = 4; // true表示允许邀请他人入盟
-- 邀请成功，服务会主动推送帮派数据变更消息
-- moduleId = 9, msgId = 110
-- id: string // 邀请的玩家id
local function S2CGuildInvateOtherProto(data)

end
guild_decoder.RegisterAction(guild_decoder.S2C_GUILD_INVATE_OTHER, S2CGuildInvateOtherJoinProto)

-- 邀请加入联盟失败
-- moduleId = 9, msgId = 111
local function S2CFailGuildInvateOtherProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_GUILD_INVATE_OTHER, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_GUILD_INVATE_OTHER, S2CFailGuildInvateOtherProto)

-- *********************************************************************
-- （联盟消息）取消邀请加入联盟
-- GuildProto中可以获取到邀请加入联盟的列表
--     GuildJoinRequestProto join_request = 27; // 申请加入/邀请加入
-- 审批加入联盟(有允许同意申请入盟权限的操作)
-- GuildClassLevelData
--    bool invate_other = 4; // true表示允许邀请他人入盟
-- 将邀请加入玩家删掉
-- moduleId = 9, msgId = 113
-- id: string // 取消邀请的玩家id
local function S2CGuildCancelInvateOtherProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_GUILD_CANCEL_INVATE_OTHER, S2CGuildCancelInvateOtherProto)

-- 取消邀请加入联盟失败
-- moduleId = 9, msgId = 114
local function S2CFailGuildCancelInvateOtherProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_GUILD_CANCEL_INVATE_OTHER, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_GUILD_CANCEL_INVATE_OTHER, S2CFailGuildCancelInvateOtherProto)

-- *********************************************************************
-- 移除自己的申请联盟id
-- 1、联盟拒绝你加入
-- 2、申请过期
-- moduleId = 9, msgId = 118
-- id: string // 申请联盟id
local function S2CUserRemoveJoinRequestProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_REMOVE_JOIN_REQUEST, S2CUserRemoveJoinRequestProto)

-- *********************************************************************
-- 移除自己的申请联盟id
-- 清空自己的联盟申请列表
-- 1、加入新帮派
-- 2、当上盟主
-- moduleId = 9, msgId = 119
-- id: string // 申请联盟id
local function S2CUserClearJoinRequestProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_CLEAR_JOIN_REQUEST, S2CUserClearJoinRequestProto)

-- *********************************************************************
-- （玩家消息）添加邀请联盟id
-- moduleId = 9, msgId = 120
-- id: string // 邀请联盟id
local function S2CUserAddBeenInvateGuildProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_ADD_BEEN_INVATE_GUILD, S2CUserAddBeenInvateGuildProto)

-- *********************************************************************
-- （玩家消息）移除自己的被邀请联盟id
-- 1、联盟取消邀请
-- 2、邀请过期
-- moduleId = 9, msgId = 121
-- id: string // 邀请联盟id
local function S2CUserRemoveBeenInvateGuildProto(data)
end
guild_decoder.RegisterAction(guild_decoder.S2C_USER_REMOVE_BEEN_INVATE_GUILD, S2CUserRemoveBeenInvateGuildProto)

-- *********************************************************************
-- 更新职称
-- moduleId = 9, msgId = 123
local function S2CUpdateClassTitleProto()
    UIManager.showTip( { content = Localization.AllianceMemberTitleModifySuccess, result = true })
    Event.dispatch(Event.ALLIANCE_ON_UPDATE_MEMBER_TITLE_SUCCESS)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_CLASS_TITLE, S2CUpdateClassTitleProto)

-- 更新职称失败
-- moduleId = 9, msgId = 124
local function S2CFailUpdateClassTitleProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_CLASS_TITLE, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_CLASS_TITLE, S2CFailUpdateClassTitleProto)
-- *********************************************************************
-- 更新友盟
-- moduleId = 9, msgId = 126
-- text: string // 联盟友盟
local function S2CUpdateFriendGuildProto(data)
    if data == nil or data.text == nil then
        return
    end

    AllianceData.MyAlliance.FriendGuildText = data.text
    UIManager.showTip( { content = Localization.AllianceUpdateAlly, result = true })
    Event.dispatch(Event.ALLIANCE_ON_UPDATE_ALLY)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_FRIEND_GUILD, S2CUpdateFriendGuildProto)

-- 更新友盟失败
-- moduleId = 9, msgId = 127
local function S2CFailUpdateFriendGuildProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_FRIEND_GUILD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_FRIEND_GUILD, S2CFailUpdateFriendGuildProto)
-- *********************************************************************
-- 更新敌盟
-- moduleId = 9, msgId = 129
-- text: string // 联盟敌盟
local function S2CUpdateEnemyGuildProto(data)
    if data == nil or data.text == nil then
        return
    end

    AllianceData.MyAlliance.EnemyGuildText = data.text
    UIManager.showTip( { content = Localization.AllianceUpdateEnemy, result = true })
    Event.dispatch(Event.ALLIANCE_ON_UPDATE_ENEMY)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_ENEMY_GUILD, S2CUpdateEnemyGuildProto)

-- 更新敌盟失败
-- moduleId = 9, msgId = 130
local function S2CFailUpdateEnemyGuildProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_ENEMY_GUILD, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_ENEMY_GUILD, S2CFailUpdateEnemyGuildProto)

-- *********************************************************************
-- 修改声望目标成功
-- moduleId = 9, msgId = 132
-- target: int // 配置 DefaultCountryProto中的id
local function S2CUpdateGuildPrestigeProto(data)
    if data == nil or data.target == nil then
        return
    end

    AllianceData.MyAlliance.PrestigeTarget = data.target
    UIManager.showTip( { content = Localization.AllianceUpdatePrestigeTarget, result = true })
    Event.dispatch(Event.ON_UPDATE_GUILD_TARGET)
end
guild_decoder.RegisterAction(guild_decoder.S2C_UPDATE_GUILD_PRESTIGE, S2CUpdateGuildPrestigeProto)

-- 修改声望目标失败
-- moduleId = 9, msgId = 133
local function S2CFailUpdateGuildPrestigeProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_UPDATE_GUILD_PRESTIGE, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_UPDATE_GUILD_PRESTIGE, S2CFailUpdateGuildPrestigeProto)

-- 放置联盟雕像
local function S2CPlaceGuildStatue()
    UIManager.showTip( { result = true, content = Localization.AllianceStatueSetSuccess })
end
guild_decoder.RegisterAction(guild_decoder.S2C_PLACE_GUILD_STATUE, S2CPlaceGuildStatue)

-- 设置联盟雕像失败
-- no_guild: 没有联盟
-- not_leader: 不是盟主
-- has_placed: 有放置了，请先取回
-- map_not_found: 地图没找到
-- x_invalid: x非法
-- y_invalid: y非法
-- server_error: 服务器忙，请稍后再试
local function S2CGuildStatuePlaceFailProto(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_PLACE_GUILD_STATUE, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_PLACE_GUILD_STATUE, S2CGuildStatuePlaceFailProto)

-- 联盟雕像信息
-- realm_id: int32; // 地图id
-- realm_x: int32; // x
-- realm_y: int32; // y
local function S2CGuildStatueProto(data)
    if data == nil then
        return
    end
    AllianceData.StatueLocation = data.realm_id
    Event.dispatch(Event.ALLIANCE_STATUE_UPDATE)
end
guild_decoder.RegisterAction(guild_decoder.S2C_GUILD_STATUE, S2CGuildStatueProto)

-- 收回雕像
local function S2CTakeBackGuildStatue()
    if AllianceData.StatueLocation ~= 0 then
        AllianceData.StatueLocation = 0
    end
    Event.dispatch(Event.ALLIANCE_STATUE_UPDATE)
    UIManager.showTip( { result = true, content = Localization.AllianceStatueHasReturned })
end
guild_decoder.RegisterAction(guild_decoder.S2C_TAKE_BACK_GUILD_STATUE, S2CTakeBackGuildStatue)

-- 收回雕像广播
local function SCBroadcastTakeBackGuildStatue()
    if AllianceData.StatueLocation ~= 0 then
        AllianceData.StatueLocation = 0
    end
    if AllianceData.MyAlliance.Leader ~= AllianceData.MyData then
        UIManager.showTip( { result = true, content = Localization.AllianceStatueReturnSuccess })
    end
end
guild_decoder.RegisterAction(guild_decoder.S2C_BROADCAST_TAKE_BACK_GUILD_STATUE, SCBroadcastTakeBackGuildStatue)

-- 收回雕像失败
-- no_guild: 没有联盟
-- not_leader: 不是盟主
-- not_place: 没有放置
-- server_error: 服务器忙，请稍后再试
local function S2CFailTakeBackGuildStatue(code)
    UIManager.showNetworkErrorTip(guild_decoder.ModuleID, guild_decoder.S2C_FAIL_TAKE_BACK_GUILD_STATUE, code)
end
guild_decoder.RegisterAction(guild_decoder.S2C_FAIL_TAKE_BACK_GUILD_STATUE, S2CFailTakeBackGuildStatue)

return AllianceData