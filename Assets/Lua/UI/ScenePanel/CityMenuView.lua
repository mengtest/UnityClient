local _V = UIManager.View()

function _V:LoadView()
    self.UI = require("UI.MainCity.MainCityView").UI
    self.OutsideMenu = self.UI:GetChild("Component_OutsideMenu")
    -- controller
    -- selectedIndex = 0 1个按钮
    -- selectedIndex = 1 2个按钮
    -- selectedIndex = 2 3个按钮
    self.Type_C = self.OutsideMenu:GetController("Type_C")

    self.Btn1 = self.OutsideMenu:GetChild("Button_01")
    self.Btn1Ctrl = self.Btn1:GetController("State_C")
    self.Btn2 = self.OutsideMenu:GetChild("Button_02")
    self.Btn2Ctrl = self.Btn2:GetController("State_C")
    self.Btn3 = self.OutsideMenu:GetChild("Button_03")
    self.Btn3Ctrl = self.Btn3:GetController("State_C")
    self.Btn4 = self.OutsideMenu:GetChild("Button_04")
    self.Btn4Ctrl = self.Btn4:GetController("State_C")
    self.Btn5 = self.OutsideMenu:GetChild("Button_05")
    self.Btn5Ctrl = self.Btn5:GetController("State_C")
    self.Name = self.OutsideMenu:GetChild("Text_Name")
    self.Coordinate = self.OutsideMenu:GetChild("Label_Coords")

    self.Visible_C = self.UI:GetController("OutsideMenu_C")
end

return _V