-- 时间线事件
local LineEvent = Class("LineEvent")
-- 延时
LineEvent.delay = 0
-- 结束
LineEvent.isOver = false
-- 目标
LineEvent.host = nil
-- 参数
LineEvent.args = { }
-- 回调
LineEvent.callBack = nil
-- 构造函数
function LineEvent:init(delay, args, callBack, host)
    self.delay = delay
    self.host = host
    self.args = args
    self.callBack = callBack
    self.isOver = false
end
-- 重置
function LineEvent:reset()
    self.isOver = false
end
-- 计时
function LineEvent:ticker(p)
    if self.isOver then
        return
    end
    if self.delay > p then
        return
    end
    if nil ~= self.callBack then
        self.callBack(self.host, self.args)
    end
    self.isOver = true
end


-- 时间线
local TimeLine = Class("TimeLine")
-- 速率
TimeLine.speedRate = 1
-- 开始
TimeLine.isStart = false
-- 暂停
TimeLine.isPause = false
-- 计时
TimeLine.ticker = 0
-- 线上事件
TimeLine.events = { }

-- 构造函数
function TimeLine:init(speedRate)
    self.speedRate = speedRate
end
-- 添加事件
function TimeLine:addEvent(delay, args, callBack, host)
    local event = LineEvent(delay, args, callBack, host)
    table.insert(self.events, event)
end
-- 速率
function TimeLine:setSpeedRate(speedRate)
    self.speedRate = speedRate
end
-- 更新
function TimeLine:update()
    if not self.isStart or self.isPause then
        return
    end
    self.ticker = self.ticker + TimerManager.deltaTime * self.speedRate
    for k, v in pairs(self.events) do
        v:ticker(self.ticker)
    end
end
-- 重置
function TimeLine:reset()
    self.isStart = false
    self.isPause = false
    self.ticker = 0
    for k, v in pairs(self.events) do
        v:reset()
    end
end
-- 开始
function TimeLine:start()
    self:reset()
    self.isStart = true
end
-- 暂停
function TimeLine:pause()
    self.isPause = true
end
-- 恢复
function TimeLine:resume()
    self.isPause = false
end

return {
    TimeLine = TimeLine,
    LineEvent = LineEvent,
}

