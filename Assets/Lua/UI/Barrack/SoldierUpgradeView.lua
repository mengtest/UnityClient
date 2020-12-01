local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Barrack/Barrack", "Barrack", "UpgradeMain")

    -- controller
    self.Level_C = self.UI:GetController("Level_C")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- top right
    self.RelationBtn = self.UI:GetChild("Button_Relations")

    -- left
    self.ConditionList = self.UI:GetChild("Component_Condition"):GetChild("List_Condition")

    -- right(步弓骑车器)
    self.BuBing = self.UI:GetChild("Component_Bu")
    self.BuBingInfo = self.BuBing:GetChild("Label_SoldierType")
    self.GongBing = self.UI:GetChild("Component_Gong")
    self.GongBingInfo = self.GongBing:GetChild("Label_SoldierType")
    self.QiBing = self.UI:GetChild("Component_Qi")
    self.QiBingInfo = self.QiBing:GetChild("Label_SoldierType")
    self.CheBing = self.UI:GetChild("Component_Che")
    self.CheBingInfo = self.CheBing:GetChild("Label_SoldierType")
    self.XieBing = self.UI:GetChild("Component_Xie")
    self.XieBingInfo = self.XieBing:GetChild("Label_SoldierType")

    -- bottom right
    self.CurLev = self.UI:GetChild("Label_CurrLevel")
    self.NextLev = self.UI:GetChild("Label_NextLevel")
    self.CurrDesc = self.UI:GetChild("Text_CurrDesc")
    self.NextDesc = self.UI:GetChild("Text_NextDesc")
    self.UpgradeBtn = self.UI:GetChild("Button_Upgrade")
end

return _V