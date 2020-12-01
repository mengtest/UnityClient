local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "ChangeSalaryWindowMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    self.Name = window:GetChild("Text_Name")
    self.SalaryInput = window:GetChild("Text_Input")
    self.SubBtn = window:GetChild("Button_SUB")
    self.AddBtn = window:GetChild("Button_ADD")
    self.ConfirmBtn = window:GetChild("Button_Confirm")
    self.CancelBtn = window:GetChild("Button_Cancel")
end

return _V