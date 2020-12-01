-- 提示
local Tips = { }

-- 消息管理
local Msgs = { }
-- 消息池
Msgs.Pool = { }
-- 获取消息
function Msgs.getFromPool()
    if #Msgs.Pool > 0 then
        local msg = Msgs.Pool[1]
        table.remove(Msgs.Pool, 1)

        return msg
    end
    return nil
end
-- 进入消息池
function Msgs.enterToPool(msg)
    table.insert(Msgs.Pool, msg)
end

-- view管理
local TipsView = { }
-- view池
TipsView.Pool = { }
-- 使用中
TipsView.InUse = { }
-- 获取view
function TipsView.getFromPool()
    local view = nil
    if #TipsView.Pool > 0 then
        view = TipsView.Pool[1]
        table.remove(TipsView.Pool, 1)
        table.insert(TipsView.InUse, view)
    else
        view = { }

        local text = UIManager.creatView("UI/Tips/Tips", "Tips", "TipsMain")
        local child = text:GetChild("Component_Main")
        text.sortingOrder = 999
        text.touchable = false;
        view.Root = text
        view.Effect = text:GetTransition("Effect_T")
        view.Stat = child:GetController("State_C")
        view.Content = child:GetChild("Text_Content")

        table.insert(TipsView.InUse, view)
    end
    return view
end
-- 返回池view
function TipsView.backToPool(view)
    view.Root.visible = false
    table.insert(TipsView.Pool, view)
    table.remove(TipsView.InUse, view)
end

-- 计时器
local timer = nil
-- 正在计时
local isPlaying = false
-- 计时结束
local function timerStart()
    isPlaying = true
end
-- 计时结束
local function timerComplete()
    isPlaying = false

    local msg = Msgs.getFromPool()
    if nil ~= msg then
        Tips.show(msg)
    end
end

-- 正在弹出的一条内容
local lastContent = nil

-- 显示
-- msg.result 表示显示类型，true为成功，false为警示
-- msg.content 表示显示文本内容
-- msg = { content = "" , result = true }
function Tips.show(msg)
    if nil == timer then
        timer = TimerManager.newTimer(0.5, false, false, timerStart, nil, timerComplete)
    end
    if not isPlaying then
        lastContent = msg

        timer:reset()
        timer:start()

        local view = TipsView.getFromPool()
        view.Root.visible = true
        view.Content.text = msg.content
        if nil == msg.result or msg.result then
            view.Stat.selectedIndex = 0
        else
            view.Stat.selectedIndex = 1
        end
        view.Effect:Play( function() TipsView.backToPool(view) end)
    else
        -- 和正在弹出内容相同则return
        if nil ~= lastContent and lastContent.content == msg.content and lastContent.result == msg.result then
            return
        else
            Msgs.enterToPool(msg)
        end
    end
end
-- 清除
function Tips.clear()
    for k, v in pairs(TipsView.InUse) do
        v.Effect:Stop()
    end
    TipsView.Pool = { }
    TipsView.InUse = { }
    Msgs.Pool = { }
end
-- 销毁
function Tips.destroy()
    for k, v in pairs(TipsView.InUse) do
        v.Root:Dispose()
    end
    for k, v in pairs(TipsView.Pool) do
        v.Root:Dispose()
    end
    TipsView.Pool = { }
    TipsView.InUse = { }
    Msgs.Pool = { }
end
return Tips

