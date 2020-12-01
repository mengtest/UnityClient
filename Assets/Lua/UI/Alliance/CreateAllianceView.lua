local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "CreateWindowMain")
    self.BG = self.UI:GetChild("Component_BG")
    local window = self.UI:GetChild("Component_MainWindow")
    self.NameLabel = window:GetChild("Input_AllianceName")
    self.FlagNameLabel = window:GetChild("Input_FlagName")
    self.CreateBtn = window:GetChild("Button_Confirm")
    self.CloseBtn = window:GetChild("Label_Window"):GetChild("Button_Close")
end

return _V