local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "GiveToAllianceWindowMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    
    self.NameInput = window:GetChild("Input_Name")
    self.SilverInput = window:GetChild("Input_Silver")
    self.DescInput = window:GetChild("Input_Desc")
    self.ConfirmBtn = window:GetChild("Button_Confirm")
    self.CancelBtn = window:GetChild("Button_Cancel")
end

return _V