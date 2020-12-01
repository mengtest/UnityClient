-----------------------------------------------------
-------------------定义controller--------------------
-----------------------------------------------------

local Controller = Class()
-- 是否置顶
Controller.IsStick = false
-- 是否打开
Controller.IsOpen = false
-- 是否显示
Controller.IsShow = false
-- 是否弹框
Controller.IsPopupBox = false
-- 是否在交互
Controller.IsInteractive = false
-- ctrl名称
Controller.ControllerName = nil
-- view名称
Controller.ViewName = nil
-- view引用
Controller.View = nil
-- 计时器
Controller.TimerCd = nil
-- 子ctrl
Controller.SubCtrl = { }

function Controller:init(ctrlName, viewName)
    self.ControllerName = ctrlName
    self.ViewName = viewName
    UIManager.registerController(self)
end
-- 广播消息--
function Controller:sendNtfMsg(ntfType, ...)
    UIManager.sendNtfMessage(ntfType, ...)
end
-- 创建界面--
function Controller:creat()
    if self.View ~= nil and self.View.UI ~= nil then
        return
    end
    if self.ViewName ~= nil then
        self.View =(require(self.ViewName))
        self.View:LoadView()
    end
    self:onCreat()

    -- 子ctrl创建
    for k, v in pairs(self.SubCtrl) do
        v:creat()
    end

    -- 创建计时器
    local aliveTime = UIDisposeConfig[self.ControllerName] or 0
    if nil == self.TimerCd and aliveTime ~= -1 then
        self.TimerCd = TimerManager.newTimer(aliveTime, false, true, nil, nil, function(t) t:destroy(false) end, self)
    end
end
-- 打开界面--
function Controller:open(data)
    self.IsOpen = true

    self:onOpen(data)
    -- 子ctrl打开
    for k, v in pairs(self.SubCtrl) do
        v:open(data)
    end

    UIManager.pushingStack(self)

    if nil ~= self.TimerCd then
        self.TimerCd:pause()
    end
end
-- 关闭界面--
function Controller:close()
    UIManager.popingStack(self)

    -- 子ctrl关闭
    for k, v in pairs(self.SubCtrl) do
        v:close()
    end
    self:onClose()

    self.IsOpen = false

    if nil ~= self.TimerCd then
        self.TimerCd:start()
    end
end
-- 显示界面--
function Controller:show()
    self.IsShow = true

    if self.View ~= nil and not self.View:isDispose() then
        self.View:show()
        self:onShow()
    end

    -- 子ctrl显示
    for k, v in pairs(self.SubCtrl) do
        v:show()
    end
end
-- 通知界面是否可交互--
function Controller:interactive(isok)
    self.IsInteractive = isok

    -- 子ctrl交互
    for k, v in pairs(self.SubCtrl) do
        v:interactive(isok)
    end
    if self.View ~= nil and not self.View:isDispose() then
        self.View:interactive(isok)
        self:onInteractive(isok)
    end
end
-- 隐藏界面--
function Controller:hide()
    self.IsShow = false

    -- 子ctrl隐藏
    for k, v in pairs(self.SubCtrl) do
        v:hide()
    end

    if self.View ~= nil and not self.View:isDispose() then
        self.View:hide()
        self:onHide()
    end
end
-- 销毁界面--
function Controller:destroy(enforces)
    -- 移除自己
    if self.IsOpen then
        UIManager.popingStack(self)
    end
    -- 子ctrl销毁
    for k, v in pairs(self.SubCtrl) do
        v:destroy(enforces)
    end
    -- 销毁
    if self.View ~= nil then
        self:onDestroy()
        self.View:destroy()
    end
    -- 析构计时器
    if nil ~= self.TimerCd then
        TimerManager.disposeTimer(self.TimerCd)
    end

    self.IsOpen = false
    self.IsShow = false
    self.TimerCd = nil
    self.View = nil
end
-- 通知界面设置渲染顺序--
function Controller:sortingOrder(order)
    -- 子ctrl渲染顺序
    for k, v in pairs(self.SubCtrl) do
        v:sortingOrder(order)
    end
    if self.View ~= nil and not self.View:isDispose() then
        self.View:sortingOrder(order)
    end
end
-- 广播消息--
function Controller:ntfHandle(ntfType, ...)
    -- 子ctrl广播
    for k, v in pairs(self.SubCtrl) do
        v:ntfHandle(ntfType, ...)
    end
    self:onNtfHandle(ntfType, ...)
end
-- 更新--
function Controller:update()
    -- 子ctrl更新
    for k, v in pairs(self.SubCtrl) do
        v:update()
    end
    self:onUpdate()
end

--------当xx方法处理，子类重写----------
function Controller:onNtfHandle(ntfType, ...)
end
function Controller:onCreat()
end
function Controller:onOpen(data)
end
function Controller:onClose()
end
function Controller:onShow()
end
function Controller:onInteractive(isOk)
end
function Controller:onHide()
end
function Controller:onUpdate()
end
function Controller:onDestroy()
end

return Controller

