local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ScenePanel/ScenePanel", "ScenePanel", "ResourceMenuMain", false)

    -- controller
    -- selectedIndex = 0 3个按钮
    -- selectedIndex = 1 4个按钮
    self.Type_C = self.UI:GetController("Type_C")

    self.TopBtn = self.UI:GetChild("Button_Top")
    self.TopBtnCtrl = self.TopBtn:GetController("State_C")
    self.BottomBtn = self.UI:GetChild("Button_Bottom")
    self.BottomBtnCtrl = self.BottomBtn:GetController("State_C")
    self.LeftBtn = self.UI:GetChild("Button_Left")
    self.LeftBtnCtrl = self.LeftBtn:GetController("State_C")
    self.RightBtn = self.UI:GetChild("Button_Right")
    self.RightBtnCtrl = self.RightBtn:GetController("State_C")
end

return _V