local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ScenePanel/ScenePanel", "ScenePanel", "InsideMenuMain", false)

    -- controller
    -- selectedIndex:0 1个按钮
    -- selectedIndex:1 2个按钮
    -- selectedIndex:2 3个按钮
    -- selectedIndex:3 4个按钮
    self.State_C = self.UI:GetController("Type_C")

    self.MenuBtn1 = self.UI:GetChild("Button_01")
    self.MenuBtn2 = self.UI:GetChild("Button_02")
    self.MenuBtn3 = self.UI:GetChild("Button_03")
    self.MenuBtn4 = self.UI:GetChild("Button_04")
end

return _V