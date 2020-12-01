local _C = UIManager.SubController(UIManager.ControllerName.ChatContents, nil)
_C.view = nil

-- 消息时间间隔(5分钟)
local msgTimeInterval = 300
-- 消息发送间隔
local msgSendInterval = 10
-- 最大字数限制(字符)
local msgInputMaxLen = 100
-- 世界频道发送消息个数上限
local msgSentNumLimitInWorldChannel = 100

-- 消息列表
local msgList = { }
-- 消息类型
local msgType = { left = 1, right = 2, time = 3 }
-- 关系类型
local relationType = { friendly = 1, unfriendly = 2 }
-- 社交实例化数据
local chatInsInfo = DataTrunk.PlayerInfo.ChatData

-- 当前频道
local curChannel = nil
-- 当前频道处理的消息列表
local curHandleMsgInsList = nil
-- 当前输入内容
local curInputMsg = nil

-- 消息发送计时器
local sendTimer = nil
-- 发送消息冷却中
local sendCooling = false
-- 舞台点触结束
local stageTouchEnd = nil

-- 舞台点触结束
local function onStageTouchEnd()
    if nil ~= stageTouchEnd then
        stageTouchEnd()
    end
end

-- 添加时间间隔线
local function addTimeIntervalLine(frontMsg, backMsg)
    if nil == frontMsg or nil == backMsg then
        return
    end
    if frontMsg.Timestamp - backMsg.Timestamp < msgTimeInterval then
        return
    end

    local timeInfo = ChatInsInfo()
    -- 此处约定
    timeInfo.YouOrMe = 2
    timeInfo.Content = os.date("%X", frontMsg.Timestamp)

    table.insert(msgList, timeInfo)
end

-- 检查输入内容为空
local function checkMsgInputEmpty(contents)
    -- 为空判断
    if contents == "" then
        UIManager.showTip( { content = Localization.ChatMsgEmpty, result = false })
        return true
    end

    return false
end

-- 检查是否在冷却中
local function checkSendCooling()
    if sendCooling then
        UIManager.showTip( { content = Localization.ChatMsgFast, result = false })
        return true
    end
    sendTimer:reset()
    sendTimer:start()

    return false
end

-- 检测发送消息条数上限
local function checkMsgNumLimit()
    if curChannel == ChatChannelType.World and msgSentNumLimitInWorldChannel > 0 and chatInsInfo.SendMsgNumInWolrdChannel >= msgSentNumLimitInWorldChannel then
        UIManager.showTip( { content = Localization.ChatMsgLimit, result = false })
        return true
    end
    return false
end

-- 聊天内容请求
local function chatContentReq(contents)
    if curChannel == ChatChannelType.World then
        -- 世界聊天
        NetworkManager.C2SWorldChatProto(contents)
    elseif curChannel == ChatChannelType.Guild then
        -- 部落聊天
        NetworkManager.C2SGuildChatProto(contents)
    end
end

-- 复制消息内容
local function copyMsgContent(contents)
    _C.view.ContentsInput.text = contents
end

-- 重发消息内容
local function resendMsgContent(contents)
    if checkSendCooling() then
        return
    end
    -- 当前输入内容
    curInputMsg = contents
    -- 服务器同步消息
    chatContentReq(contents)
end

-- 检测发送消息长度
local function onMsgInputFocusOut()
    -- 最大字数限制
    local msg = _C.view.ContentsInput.text
    if Utils.stringLen_2(msg) > msgInputMaxLen then
        curInputMsg = Utils.stringSub(msg, 1, msgInputMaxLen)
        _C.view.ContentsInput.text = curInputMsg
    end
end

-- item渲染
local function onItemRender(index, obj)
    local msg = msgList[index + 1]

    -- 时间线
    if msg.YouOrMe == 2 then
        obj:GetChild("TextField_Time").text = msg.Content
        return
    end
    
    -- 已读
    msg.MarkRead = true
    -- 自己或别人
    obj:GetChild("Loader_LordIcon").url = msg.Head.SmallIcon
    if msg.GuildFlagName == "" then
        obj:GetChild("TextField_Name").text = msg.Name
    else
        obj:GetChild("TextField_Name").text = string.format("[%s]%s", msg.GuildFlagName, msg.Name)
    end
    -- 设置文本宽高
    local tf = obj:GetChild("TextField_Content")
    tf.width = tf.initWidth;
    tf.text = msg.Content;
    tf.width = tf.textWidth;

    -- 气泡按钮
    local btnBubble = obj:GetChild("Button_Pop")

    if msg.YouOrMe == 0 then
        -- 别人
        btnBubble.onClick:Set( function()
            -- 显示复制按钮
            obj:GetController("State_C").selectedIndex = 0
            -- 复制添加监听
            obj:GetChild("Button_Copy").onTouchBegin:Set( function()
                copyMsgContent(msg.Content)
                onStageTouchEnd()
            end )

            -- 触发之前监听
            onStageTouchEnd()
            -- 添加触屏监听
            stageTouchEnd = function()
                obj:GetController("State_C").selectedIndex = 1
                stageTouchEnd = nil
            end
        end )

        -- 敌对关系
        if curChannel == ChatChannelType.Oposite then
            obj:GetController("Relation_C").selectedIndex = 1
        else
            obj:GetController("Relation_C").selectedIndex = 0
        end

        obj:GetController("State_C").selectedIndex = 1
    elseif msg.YouOrMe == 1 then
        -- 自己
        btnBubble.onClick:Set( function()
            -- 显示重发按钮
            obj:GetController("State_C").selectedIndex = 1
            -- 重发添加监听
            obj:GetChild("Button_Send").onTouchBegin:Set( function()
                resendMsgContent(msg.Content)
                onStageTouchEnd()
            end )

            -- 触发之前监听
            onStageTouchEnd()
            -- 添加触屏监听
            stageTouchEnd = function(info)
                obj:GetController("State_C").selectedIndex = 2
                stageTouchEnd = nil
            end
        end )

        obj:GetController("State_C").selectedIndex = 2
    end
end
-- item供应者
local function onItemProvider(index)
    local msg = msgList[index + 1]

    if msg.YouOrMe == 0 then
        return _C.view.ChatLeftUI
    elseif msg.YouOrMe == 1 then
        return _C.view.ChatRightUI
    elseif msg.YouOrMe == 2 then
        return _C.view.ChatTimeUI
    end
end

-- 添加消息
local function addMessage(channel)
    if not _C.IsOpen then
        return
    end
    -- 判断是否为当前频道
    if channel ~= curChannel then
        return
    end
    local msgInfo = curHandleMsgInsList[1]

    -- 如果是自己
    if msgInfo.YouOrMe == 1 then
        msgInfo.Content = curInputMsg
        -- 更新简要聊天框消息
        Event.dispatch(Event.CHAT_BRIEF_UPDATE, msgInfo)
    end

    -- 加入时间间隔线
    addTimeIntervalLine(msgInfo, curHandleMsgInsList[2])
    -- 加入本条消息
    table.insert(msgList, msgInfo)

    -- 最多缓存个数
    if #msgList > chatInsInfo.MaxCacheChatNum then
        table.remove(msgList, 1)
    end

    _C.view.ContentsGroupChatList.numItems = #msgList
    -- 拖动至底部
    -- _C.view.ContentsGroupChatList.scrollPane:ScrollBottom();
    -- 滚动至底部
    _C.view.ContentsGroupChatList:ScrollToView(#msgList - 1, true)

    -- 消息处理完成	
    Event.dispatch(Event.CHAT_MSG_HANDLER_OVER, channel)
end

-- 发送消息
local function btnMsgSend()
    curInputMsg = _C.view.ContentsInput.text

    -- 服务器时间
    if curInputMsg == "/time on" then
        UIManager.showHelper(true)
        return
    elseif curInputMsg == "/time off" then
        UIManager.showHelper(false)
        return
    end

    -- 为空判断
    if checkMsgInputEmpty(curInputMsg) then
        return
    end

    -- 已发送消息条数
    if checkMsgNumLimit() then
        return
    end

    -- 发送间隔判断
    if checkSendCooling() then
        return
    end

    -- 敏感词替换
    curInputMsg = Utils.sensitiveWordReplace(curInputMsg)

    -- 服务器同步消息
    chatContentReq(curInputMsg)

    -- 输入信息置空
    _C.view.ContentsInput.text = ""

end

-- 获取聊天信息
local function getMsgListInfo(msgListInsInfo)
    curHandleMsgInsList = msgListInsInfo

    msgList = { }
    local id = 0
    for i = #msgListInsInfo, 1, -1 do
        id = id + 1

        msgList[id] = msgListInsInfo[i]
        addTimeIntervalLine(msgListInsInfo[i - 1], msgListInsInfo[i])
    end

    _C.view.ContentsGroupChatList.numItems = id
end
-- 计时开始
local function timerStart()
    sendCooling = true
end
-- 计时结束
local function timerComplete()
    sendCooling = false
end
function _C:onChannelClick(channel, info)
    curChannel = channel
    if curChannel == ChatChannelType.World then
        getMsgListInfo(chatInsInfo.WorldInfo)
    elseif curChannel == ChatChannelType.Guild then
        getMsgListInfo(chatInsInfo.GuildInfo)
    elseif curChannel == ChatChannelType.Friend then
        getMsgListInfo(chatInsInfo.FriendInfo)
    elseif curChannel == ChatChannelType.Opposite then
        getMsgListInfo(chatInsInfo.OppositeInfo)
    end
end
function _C:onCreat()
    _C.view.ContentsGroupChatList.itemRenderer = onItemRender
    _C.view.ContentsGroupChatList.itemProvider = onItemProvider
    _C.view.ContentsSend.onClick:Add(btnMsgSend)
    _C.view.ContentsInput.onFocusOut:Add(onMsgInputFocusOut)

    Event.addListener(Event.CHAT_MSG_SUCCEED, addMessage)

    sendTimer = TimerManager.newTimer(msgSendInterval, false, true, timerStart, nil, timerComplete)
end
function _C:onDestroy()
    _C.view.ContentsGroupChatList.itemRenderer = nil
    _C.view.ContentsGroupChatList.itemProvider = nil
    _C.view.ContentsSend.onClick:Clear()
    _C.view.ContentsInput.onFocusOut:Clear()

    Event.removeListener(Event.CHAT_MSG_SUCCEED, addMessage)

    TimerManager.disposeTimer(sendTimer)
    sendCooling = false
end
function _C:onShow()
    -- 添加监听
    Event.addListener(Event.STAGE_ON_TOUCH_END, onStageTouchEnd)
end
function _C:onHide()
    -- 移除监听
    Event.removeListener(Event.STAGE_ON_TOUCH_END, onStageTouchEnd)
end
return _C