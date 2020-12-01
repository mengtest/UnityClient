---------------------------------------------------------------
--- 社交信息----------------------------------------------------
---------------------------------------------------------------
local monarchsData = require "Data.MonarchsData"

-- 最大缓存个数
local MaxCacheChatNum = 100

-- 社交实例化信息--
local ChatData = { }
-- 最近的消息(只缓存两条)
ChatData.NearestInfo = { }
-- 联盟聊天
ChatData.GuildInfo = { }
-- 世界聊天
ChatData.WorldInfo = { }
-- 好友聊天（里面会按Id细分）
ChatData.FriendInfo = { }
-- 敌对聊天（里面会按Id细分）
ChatData.OppositeInfo = { }
-- 世界频道已发送条数
ChatData.SendMsgNumInWolrdChannel = 0
-- 最大缓存个数
ChatData.MaxCacheChatNum = 100
-- 最近聊天个数
ChatData.MaxNearestChatNum = 2
-- 清除--
function ChatData:clear()
    self.GuildInfo = { }
    self.WorldInfo = { }
    self.FriendInfo = { }
    self.OppositeInfo = { }
    self.NearestInfo = { }
end
-- 更新数据--
function ChatData:updateInfo()
end
-- 获取未读消息个数--
function ChatData:getMarkReadNum(channel)
    getNum = function(t)
        local num = 0
        for i = 1, #t, 1 do
            if t[i].MarkRead then
                return num
            end
            num = num + 1
        end

        return num
    end
    if channel == ChatChannelType.World then
        return getNum(ChatData.WorldInfo)
    elseif channel == ChatChannelType.Guild then
        return getNum(ChatData.GuildInfo)
    elseif channel == ChatChannelType.Friend then
        return getNum(ChatData.FriendInfo)
    elseif channel == ChatChannelType.Opposite then
        return getNum(ChatData.OppositeInfo)
    end
end

-- 获取自身聊天信息
local function getSelfChatInfo(channel)
    local chat = ChatInsInfo()

    chat.Id = monarchsData.Id
    chat.Name = monarchsData.Name
    chat.Head = monarchsData.Head
    chat.GuildFlagName = monarchsData.GuildFlagName
    chat.Timestamp = TimerManager.currentTime
    chat.Channel = channel
    chat.YouOrMe = 1
    chat.Content = ""

    return chat
end

-- 世界聊天自己--moduleId = 13, msgId = 2
local function S2CWorldChat(data)
    local chat = getSelfChatInfo(ChatChannelType.World)

    -- 世界频道发送消息条数
    ChatData.SendMsgNumInWolrdChannel = ChatData.SendMsgNumInWolrdChannel + 1

    -- 在首位插入
    table.insert(ChatData.WorldInfo, 1, chat)
    -- 移除超出缓存
    ChatData.WorldInfo[ChatData.MaxCacheChatNum] = nil

    Event.dispatch(Event.CHAT_MSG_SUCCEED, ChatChannelType.World)
end
chat_decoder.RegisterAction(chat_decoder.S2C_WORLD_CHAT, S2CWorldChat)

-- 世界聊天别人--moduleId = 13, msgId = 3
-- id: string // 君主id
-- name: string // 君主名字
-- head: string // 君主头像
-- guild_flag: string // 联盟旗号
-- text: string // 聊天内容
-- white_flag_guild_flag_name: string // 插白旗联盟旗号，空表示没有
local function S2CWorldOtherChatProto(data)
    local chat = ChatInsInfo()
    chat:updateInfo(data, ChatChannelType.World)
    -- 在首位插入
    table.insert(ChatData.WorldInfo, 1, chat)
    -- 移除超出缓存
    ChatData.WorldInfo[ChatData.MaxCacheChatNum] = nil

    Event.dispatch(Event.CHAT_MSG_SUCCEED, ChatChannelType.World)
    Event.dispatch(Event.CHAT_BRIEF_UPDATE, chat)
end
chat_decoder.RegisterAction(chat_decoder.S2C_WORLD_OTHER_CHAT, S2CWorldOtherChatProto)

-- 联盟聊天自己--moduleId = 13, msgId = 5
local function S2CGuildChat(data)
    local chat = getSelfChatInfo(ChatChannelType.Guild)

    -- 在首位插入
    table.insert(ChatData.GuildInfo, 1, chat)
    -- 移除超出缓存
    ChatData.GuildInfo[MaxCacheChatNum] = nil

    Event.dispatch(Event.CHAT_MSG_SUCCEED, ChatChannelType.Guild)
end
chat_decoder.RegisterAction(chat_decoder.S2C_GUILD_CHAT, S2CGuildChat)

-- 失败联盟聊天自己--moduleId = 13, msgId = 7
-- 13-7-1: 你当前没有联盟
local function S2CFailGuildChat(code)
    UIManager.showNetworkErrorTip(chat_decoder.ModuleID,chat_decoder.S2C_FAIL_GUILD_CHAT,code)
end
chat_decoder.RegisterAction(chat_decoder.S2C_FAIL_GUILD_CHAT, S2CFailGuildChat)

-- 联盟聊天别人--moduleId = 13, msgId = 6
-- id: string // 君主id
-- name: string // 君主名字
-- head: string // 君主头像
-- guild_flag: string // 联盟旗号
-- text: string // 聊天内容
-- white_flag_guild_flag_name: string  // 插白旗联盟旗号，空表示没有
local function S2CGuildOtherChatProto(data)
    local chat = ChatInsInfo()
    chat:updateInfo(data, ChatChannelType.Guild)

    -- 在首位插入
    table.insert(ChatData.GuildInfo, 1, chat)
    -- 移除超出缓存
    ChatData.GuildInfo[MaxCacheChatNum] = nil

    Event.dispatch(Event.CHAT_MSG_SUCCEED, ChatChannelType.Guild)
    Event.dispatch(Event.CHAT_BRIEF_UPDATE, chat)
end
chat_decoder.RegisterAction(chat_decoder.S2C_GUILD_OTHER_CHAT, S2CGuildOtherChatProto)

return ChatData