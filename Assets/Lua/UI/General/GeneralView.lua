local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "GeneralMain")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.GeneralDes = self.UI:GetChild("TextField_Amount")
    self.Tips = self.UI:GetChild("TextField_Design")

    -- center
    self.GeneralList = self.UI:GetChild("List_General")
    self.GeneralList:SetVirtual()
end

return _V