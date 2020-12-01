local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Login/Login", "Login", "CreateRoleMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    self.BtnCreat = self.UI:GetChild("Button_Create")
    self.BtnSelecteMale = self.UI:GetChild("Button_Male")
    self.BtnSelecteFemale = self.UI:GetChild("Button_Female")

    self.SexStat = self.UI:GetController("State_C")
    self.EffectMale = self.UI:GetTransition("MaleOnSelected_T")
    self.EffectFemale = self.UI:GetTransition("FemaleOnSelected_T")

    self.PlayerName = self.UI:GetChild("TextField_Name")
end

return _V