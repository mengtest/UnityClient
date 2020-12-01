local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "UpgradeSpeedupMain")

    self.BG = self.UI:GetChild("Component_BG")
    local window = self.UI:GetChild("Component_Main")
    self.CloseBtn = window:GetChild("Label_Window"):GetChild("Button_Close")
    self.State_C = window:GetController("State_C")
    self.SpeedupTimesText = window:GetChild("Text_SpeedupTimes")
    self.CostText = window:GetChild("Text_Cost")
    self.TimeText = window:GetChild("Text_Time")
    self.ConfirmBtn = window:GetChild("Button_Confirm")
end

return _V