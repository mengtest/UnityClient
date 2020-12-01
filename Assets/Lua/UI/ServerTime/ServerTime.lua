-- 服务器时间
local ServerTime = { }
local view = nil
local timer = nil
local standardTime = nil
local secondTime = nil
local ping = nil

local function TimerUpdate()
    standardTime.text = os.date("%c", TimerManager.currentTime)
    secondTime.text = math.ceil(TimerManager.currentTime)
    ping.text = "ping:" .. TimerManager.ping
end

function ServerTime.init()
    view = UIManager.creatView("UI/Library/Library", "Library", "Component_ServerTime")
    view.sortingOrder = 9999
    -- 标准时间 如:xxxx年x月x日xx：xx
    standardTime = view:GetChild("n1")
    -- 时间戳 (秒)
    secondTime = view:GetChild("n0")
    -- ping
    ping = view:GetChild("n2")

    timer = TimerManager.newTimer(Const.INFINITE, false, true, nil, TimerUpdate, nil)
    timer:start()
    view.visible = false
end

function ServerTime.show(state)
    if type(state) ~= "boolean" then
        return
    end

    view.visible = state
end

-- 删除
function ServerTime.destroy()
    if view ~= nil then
        view:Dispose()
    end
end

return ServerTime

