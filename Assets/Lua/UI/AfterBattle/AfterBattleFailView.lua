local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/AfterBattle/AfterBattle", "AfterBattle", "FailMain")

    -- pvp面板信息
    self.PanelPVP = self.UI:GetChild("Group_PvP")
    self.PVPFood = self.UI:GetChild("Label_Resource1")
    self.PVPFood.icon = UIConfig.CurrencyType.Food
    self.PVPWood = self.UI:GetChild("Label_Resource2")
    self.PVPWood.icon = UIConfig.CurrencyType.Wood
    self.PVPGold = self.UI:GetChild("Label_Resource3")
    self.PVPGold.icon = UIConfig.CurrencyType.Gold
    self.PVPStone = self.UI:GetChild("Label_Resource4")
    self.PVPStone.icon = UIConfig.CurrencyType.Stone
    self.PVPResource = self.UI:GetChild("TextField_Volume")

    -- pve面板信息
    self.PanelPVE = self.UI:GetChild("Group_PvE")

    -- 效果
    self.EffectFail = self.UI:GetTransition("Fail_T")
    self.EffectPVP = self.UI:GetTransition("PVP_T")
    self.EffectPVE = self.UI:GetTransition("PVE_T")

    -- 按钮
    self.BtnDetial = self.UI:GetChild("Button_Details")
    self.BtnReplay = self.UI:GetChild("Buttton_Replay")
    self.BtnProgress = self.UI:GetChild("Button_battleProgress")
    self.BtnBack = self.UI:GetChild("Button_Continue")
end

return _V