-----------------------------------------------------
-------------------定义View--------------------------
-----------------------------------------------------

local View = Class()
View.UI = nil
View.PKG = nil
    
function View.init()
end

function View:LoadView()

end

function View:interactive(isok)
    self.UI.touchable = isok;
end

function View:sortingOrder(order)
    self.UI.sortingOrder = order;
end

function View:show()
    self.UI.visible = true;
end

function View:hide()
    self.UI.visible = false;
end

function View:destroy()
    if nil ~= self.UI then
        -- 析构界面
        self.UI:Dispose()
        -- 移除包
        UIManager.disposeView(self.PKG)
    end
    self.UI = nil
end

-- 是否已析构
function View:isDispose()
    if nil == self.UI or nil == self.UI.displayObject or self.UI.displayObject.isDisposed then
        return true
    else
        return false
    end
end

return View