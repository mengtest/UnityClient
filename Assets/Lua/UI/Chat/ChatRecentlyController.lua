local _C = UIManager.SubController(UIManager.ControllerName.ChatRecently, nil)
_C.view = nil
_C.Contents = nil

-- 聊天列表
local chatList = nil
-- 社交实例化数据
local chatInsInfo = DataTrunk.PlayerInfo.ChatData

-- item点击
local function onItemClick(item)
    local id = tonumber(item.data.name) + 1
    local itemInfo = chatList[id]

    -- 标记为已读
    item.data:GetController("Type_C").selectedIndex = 1
    -- 进入详情面板
    _C.Contents:onChannelClick(itemInfo.Channel, nil)
end

-- item渲染
local function onItemRender(index, obj)
    obj.name = tostring(index)
    local itemInfo = chatList[index + 1]

    -- 所在频道和头像
    if itemInfo.Channel == ChatChannelType.World then
        obj:GetChild("TextField_Title").text = Localization.ChatPannelWorld
        obj:GetChild("loader_touxiang").url = UIConfig.ChatWorldHead
    elseif itemInfo.Channel == ChatChannelType.Guild then
        obj:GetChild("TextField_Title").text = Localization.ChatPannelGuild
        obj:GetChild("loader_touxiang").url = UIConfig.ChatGuideHead_1
    elseif itemInfo.Channel == ChatChannelType.Private then
        obj:GetChild("TextField_Title").text = Localization.ChatPannelFirend
        obj:GetChild("loader_touxiang").url = UIConfig.ChatWorldHead
    elseif itemInfo.Channel == ChatChannelType.Opposite then
        obj:GetChild("TextField_Title").text = Localization.ChatPannelOpposite
        obj:GetChild("loader_touxiang").url = UIConfig.ChatWorldHead
    end
    -- 无消息	
    local unReadNum = chatInsInfo:getMarkReadNum(itemInfo.Channel)
    if unReadNum > 0 then
        obj:GetChild("Label_MessageCount").title = unReadNum
        obj:GetController("Type_C").selectedIndex = 0
    else
        obj:GetController("Type_C").selectedIndex = 1
    end
    -- 消息内容
    if nil ~= itemInfo.ChannelMsgListInfo[1] then
        if itemInfo.ChannelMsgListInfo[1].GuildFlagName == "" then
            obj:GetChild("TextField_Details").text = string.format("%s：%s", itemInfo.ChannelMsgListInfo[1].Name, itemInfo.ChannelMsgListInfo[1].Content)
        else
            obj:GetChild("TextField_Details").text = string.format("[%s]%s：%s", itemInfo.ChannelMsgListInfo[1].GuildFlagName, itemInfo.ChannelMsgListInfo[1].Name, itemInfo.ChannelMsgListInfo[1].Content)
        end
    else
        obj:GetChild("TextField_Details").text = ""
    end
end

-- 当获取到新消息
local function onGetNewMsg(channel)
    if not _C.IsOpen then
        return
    end
    local numItems = _C.view.ChatRecentlyList.numItems
    for i = 0, numItems - 1, 1 do
        local item = _C.view.ChatRecentlyList:GetChildAt(i)
        local id = tonumber(item.name)
        -- 判断频道一致
        if chatList[id + 1].Channel == channel then
            onItemRender(id, item)
        end
    end
end

-- 获取聊天列表信息
local function getChannelListInfo()
    chatList = { }
    -- 世界频道
    table.insert(chatList, { Channel = ChatChannelType.World, ChannelMsgListInfo = chatInsInfo.WorldInfo })
    -- 有联盟时
    if DataTrunk.PlayerInfo.MonarchsData.GuildId ~= 0 and DataTrunk.PlayerInfo.MonarchsData.GuildId ~= nil then
        table.insert(chatList, { Channel = ChatChannelType.Guild, ChannelMsgListInfo = chatInsInfo.GuildInfo })
    end

    _C.view.ChatRecentlyList.numItems = #chatList
    _C.view.ChatRecentlyList:GetChildAt(0).onClick:Call()
end

function _C:onCreat()
    _C.view.ChatRecentlyList.itemRenderer = onItemRender
    _C.view.ChatRecentlyList.onClickItem:Add(onItemClick)

    Event.addListener(Event.CHAT_MSG_SUCCEED, onGetNewMsg)
    Event.addListener(Event.CHAT_MSG_HANDLER_OVER, onGetNewMsg)
end
function _C:onOpen(data)
    getChannelListInfo()
end
function _C:onDestroy()
    _C.view.ChatRecentlyList.itemRenderer = nil
    _C.view.ChatRecentlyList.onClickItem:Clear()

    Event.removeListener(Event.CHAT_MSG_SUCCEED, onGetNewMsg)
    Event.removeListener(Event.CHAT_MSG_HANDLER_OVER, onGetNewMsg)
end

return _C