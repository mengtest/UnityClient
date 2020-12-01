local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "DemiseDetailsWindowMain")

    self.BG = self.UI:GetChild("Component_BG")
    local window = self.UI:GetChild("Component_Main")
    -- 0:其他人 1:盟主
    self.Type_C = window:GetController("Type_C")
    self.CloseBtn = window:GetChild("Label_Window"):GetChild("Button_Close")
    self.ContentText = window:GetChild("Text_Content")
    self.CancelBtn = window:GetChild("Button_Cancel")
    self.ConfirmBtn = window:GetChild("Button_Confirm")
end

return _V