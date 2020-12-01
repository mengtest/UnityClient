local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "ChangeAllianceName")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    
    self.CloseBtn = window:GetChild("Component_BG"):GetChild("Button_Close")
    self.Name = window:GetChild("Text_Name")
    self.Input = window:GetChild("Input_Content")
    self.YuanBao = window:GetChild("Text_YuanBao")
    self.ConfirmBtn = window:GetChild("Button_Confirm")

end

return _V