-----------------------------------------------------
-------------------定义SubController-----------------
-----------------------------------------------------
local SubController = require "UI.core.Controller":extend()
-- 不允许被销毁（默认都是可以被销毁的）
SubController.IsCannotDestroy = false
-- 界面引用
SubController.view = nil
-- 初始化
function SubController:init(ctrlName, viewName)
    self.ControllerName = ctrlName
    self.ViewName = viewName
end
-- 重建界面--
function SubController:reCreat()
    if self.ViewName ~= nil and nil == self.view and nil == self.View then
        self:creat()
        self:open()
    end
end
-- 打开界面--
function SubController:open(data)
    self.IsOpen = true

    -- 子ctrl打开
    for k, v in pairs(self.SubCtrl) do
        v:open(data)
    end
    self:onOpen(data)
end
-- 关闭界面--
function SubController:close()
    self.IsOpen = false

    -- 子ctrl关闭
    for k, v in pairs(self.SubCtrl) do
        v:close()
    end
    self:onClose()
end
-- 显示界面--
function SubController:show()
    -- 如果被销毁则重新创建
    self:reCreat()

    self.IsShow = true
    if self.View ~= nil and not self.View:isDispose() then
        self.View:show()
        self:onShow()
    elseif nil ~= self.view then
        self:onShow()
    end

    -- 子ctrl显示
    for k, v in pairs(self.SubCtrl) do
        v:show()
    end
end
-- 隐藏界面--
function SubController:hide()
    self.IsShow = false

    -- 子ctrl隐藏
    for k, v in pairs(self.SubCtrl) do
        v:hide()
    end

    if self.View ~= nil and not self.View:isDispose() then
        self.View:hide()
    elseif nil ~= self.view then
        self:onHide()
    end
end
-- 销毁界面--
function SubController:destroy(enforces)
    -- 子ctrl销毁
    for k, v in pairs(self.SubCtrl) do
        v:destroy(enforces)
    end

    -- 是否强制销毁，如果有不允许销毁的subCtrl则return,比如一些共用的ctrl(聊天缩略框等)
    if (enforces == nil or not enforces) and self.IsCannotDestroy then
        -- 如果未显示
        if not self.IsShow then
            self:setParent(GRoot.inst)
            self:hide()
        end
        return
    end

    self:onDestroy()
    if self.View ~= nil then
        self.View:destroy()
    end

    self.IsOpen = false
    self.View = nil
end
-- 设置父对象
function SubController:setParent(parent)
    if nil == parent or nil == self.View or nil == self.View.UI or nil == self.View.UI.displayObject or self.View.UI.displayObject.isDisposed then
        return
    end
    self.View.UI.visible = true
    --    self.View.UI.touchable = true

    parent:AddChild(self.View.UI)
    self.View.UI.position = CS.UnityEngine.Vector3.zero
end
return SubController

