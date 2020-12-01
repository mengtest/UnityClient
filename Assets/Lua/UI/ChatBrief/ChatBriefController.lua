local _C = UIManager.SubController(UIManager.ControllerName.ChatBrief, UIManager.ViewName.ChatBrief)
-- 不允许被销毁
_C.IsCannotDestroy = true

local view
-- 输入的文本
local inputMsg = ""
-- 颜色长度 
local colorLen = 24
-- 最大字符长度
local msgMaxLen = 36 + colorLen
-- 社交实例化数据
local chatInsInfo = DataTrunk.PlayerInfo.ChatData

-- 检测发送消息长度
local function check2RetrunMsgLen(msg, len)
    -- 最大字数限制
    if Utils.stringLen_2(msg) > len then
        msg = Utils.stringSub(msg, 1, len)

        return msg .. "..."
    end

    return msg
end
-- 打开聊天系统
local function btnChatMain()
    UIManager.openController(UIManager.ControllerName.ChatMain)
end
-- 更新聊天内容
local function updateChatInfo()
    inputMsg = ""
    local name
    for k, v in pairs(chatInsInfo.NearestInfo) do
        -- 别人
        if v.YouOrMe == 0 then
            name = string.format("[color=#ffe485]%s[/color]", v.Name)
        else
            name = string.format("[color=#fb91ff]%s[/color]", v.Name)
        end
        inputMsg = inputMsg .. check2RetrunMsgLen(name .. ":" .. v.Content, msgMaxLen) .. "\n"
    end
    view.Content.text = inputMsg
end
-- 更新聊天内容
local function receiveNewMsg(chatInfo)
    table.insert(chatInsInfo.NearestInfo, 1, chatInfo)
    chatInsInfo.NearestInfo[chatInsInfo.MaxNearestChatNum + 1] = nil

    updateChatInfo()
end

function _C:onCreat()
    view = _C.View
    view.BtnChat.onClick:Set(btnChatMain)

    Event.addListener(Event.CHAT_BRIEF_UPDATE, receiveNewMsg)

    view.Content.text = inputMsg
end
function _C:onOpen()
    updateChatInfo()
end
function _C:onDestroy()
    if nil == view or nil == view.UI then
        return
    end
    view.BtnChat.onClick:Clear()

    Event.removeListener(Event.CHAT_BRIEF_UPDATE, receiveNewMsg)
end

return _C

