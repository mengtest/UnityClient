local TimerManager = { }

local Timer = require "Timer.Timer"
local DelayToDo = require "Timer.DelayToDo"

-- 当前帧时间
local theCurrRealtime = 0
-- 上一帧时间
local theLastRealtime = CS.UnityEngine.Time.realtimeSinceStartup
-- 计时器池--
local TimeNormalCenter = setmetatable( { }, { __mode = 'k' })
local TimeIgnoreCenter = setmetatable( { }, { __mode = 'k' })

-- 当前时间（以服务器下发的时间为准）
TimerManager.currentTime = os.time()
TimerManager.deltaTime = 0
TimerManager.ignoreDeltaTime = 0
TimerManager.fixedDeltaTime = CS.UnityEngine.Time.fixedDeltaTime
-- 与服务器的Ping值
TimerManager.ping = 0

-- 正常计时--
local function timeNormalUpdate()
    if TimeNormalCenter == nil then
        return
    end
    for k, v in pairs(TimeNormalCenter) do
        if v ~= nil then
            v:update(TimerManager.fixedDeltaTime)
        end
    end
end

-- 忽略timeScaler计时--
local function timeIgnoreUpdate(f)
    if TimeIgnoreCenter == nil then
        return
    end
    for k, v in pairs(TimeIgnoreCenter) do
        if v ~= nil then
            v:update(f)
        end
    end
end

-- 添加计时器--
local function addTimer(t, isIgnoreTimeScale)
    if isIgnoreTimeScale then
        TimeIgnoreCenter[t.InstanceId] = t
    else
        TimeNormalCenter[t.InstanceId] = t
    end
end

-- 更新服务器时间
local function updateServerTime(serverTime, ping)
    TimerManager.currentTime = serverTime
    TimerManager.ping = ping
end
Event.addListener(Event.UPDATE_SERVER_TIME, updateServerTime)

-- 移除计时器--
local function removeTimer(id, isIgnoreTimeScale)
    if isIgnoreTimeScale then
        TimeIgnoreCenter[id] = nil
    else
        TimeNormalCenter[id] = nil
    end
end
-- 初始化--
function TimerManager.initialize()
end

-- 更新
function TimerManager.update()
    -- 忽略timeScaler
    theCurrRealtime = CS.UnityEngine.Time.realtimeSinceStartup
    TimerManager.ignoreDeltaTime = theCurrRealtime - theLastRealtime
    theLastRealtime = theCurrRealtime
    timeIgnoreUpdate(TimerManager.ignoreDeltaTime)

    TimerManager.deltaTime = CS.UnityEngine.Time.deltaTime
    -- 等服务器通知时间后，这里要算的是服务器时间
    TimerManager.currentTime = TimerManager.currentTime + TimerManager.deltaTime
end

-- 固定更新
function TimerManager.fixedUpdate()
    timeNormalUpdate()
end

-- 实例化新计时器--
-- <param name="maxCd" type="numble">时间</param>
-- <param name="isAutoReset" type="boolen">自动重置，如为True,则结束计时时，会自动重置并重新启动计时</param>
-- <param name="isIgnoreTimeScale" type="boolean">是否忽略timescaler</param>
-- <param name="funcStart" type="function">传入计时开始回调</param>
-- <param name="funcUpdate" type="function">传入计时进行回调</param>
-- <param name="funcComplete" type="function">传入计时结束回调</param>
-- <param name="funcHost" type="table">传入回调宿主，self</param>
-- <param name="isAscend" type="bool">是否为正序计时，默认为倒计时</param>
-- <returns> Timer </returns>
function TimerManager.newTimer(maxCd, isAutoReset, isIgnoreTimeScale, funcStart, funcUpdate, funcComplete, funcHost, isAscend)
    local t = Timer(maxCd, isAutoReset, isIgnoreTimeScale, funcStart, funcUpdate, funcComplete, funcHost, isAscend)
    addTimer(t, isIgnoreTimeScale)
    return t
end
-- 延时执行--
-- <param name="maxCd" type="numble">时间</param>
-- <param name="speedRate" type="numble">计时速率</param>
-- <param name="func" type="function">传入回调方法</param>
-- <param name="params" type="function">传入回调参数</param>
-- <param name="funcHost" type="table">传入回调宿主</param>
-- <returns> Timer </returns>
function TimerManager.waitTodo(maxCd, speedRate, func, params, funcHost)
    local t = DelayToDo()
    t:start(maxCd, speedRate, func, params, funcHost)
    return t.Timer
end
--- 析构指定计时器---
-- <param name="timer" type="timer">计时器实例化</param>
function TimerManager.disposeTimer(timer)
    if timer ~= nil then
        removeTimer(timer.InstanceId, timer.IsIgnoreTimeScale)
    end
    timer = nil
end
--- 获取今日零时时间---
function TimerManager.getTodayZeroTime()
    local tab = os.date("*t", TimerManager.currentTime)
    return os.time( {
        year = tab.year,
        month = tab.month,
        day = tab.day,
        hour = 0,
        min = 0,
        sec = 0
    } )
end

return TimerManager

