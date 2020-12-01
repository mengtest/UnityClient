local UIController = UIManager.Controller(UIManager.ControllerName.FlaggingInfo, UIManager.ViewName.FlaggingInfo)

function UIController:onCreat()
    self.View.Bg.onClick:Set(self.OnViewClick)
    self.View.LookBtn.onClick:Set(self.OnLookBtnClick)
end

function UIController:onOpen()

end

function UIController.OnViewClick()
    UIController:close()
end

function UIController.OnLookBtnClick()

end

function UIController:onDestroy()
    self.View.LookBtn.onClick:Clear()
    self.View.Bg.onClick:Clear()
end

return UIController