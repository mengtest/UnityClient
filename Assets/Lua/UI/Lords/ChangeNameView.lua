local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Lords/Lords", "Lords", "RenameMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    self.InputName = window:GetChild("Input_Name")
    self.CostText = window:GetChild("Text_Cost")
    self.ChangeBtn = window:GetChild("Button_Change")
    self.CDTimer = self.ChangeBtn:GetChild("Text_Time")
    self.CDTimer.text = ""
end

return _V