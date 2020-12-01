local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Academy/Academy", "Academy", "UpgradeTechnologyMain")

    -- controller
    self.Level_C = self.UI:GetController("Level_C")
    self.Speedup_C = self.UI:GetController("Speedup_C")

    -- transition
    self.Upgrade_T = self.UI:GetTransition("Upgrade_T")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- center
    local conditionPanel =self.UI:GetChild("Component_Condition")
    self.ConditionTitle = conditionPanel:GetChild("Text_Title")
    self.ConditionList = conditionPanel:GetChild("List_Condition")
    self.Title = self.UI:GetChild("Label_Technology")
    self.Icon = self.UI:GetChild("Loader_TechIcon")
    self.Lev = self.UI:GetChild("Text_Level")
    self.CurLev = self.UI:GetChild("Text_CurrLevel")
    self.NextLev = self.UI:GetChild("Text_NextLevel")
    self.CurDesc = self.UI:GetChild("Text_CurrDesc")
    self.NextDesc = self.UI:GetChild("Text_NextDesc")
    self.SpeedUp = self.UI:GetChild("Text_SpeedUp")
    self.UpgradeBtn = self.UI:GetChild("Button_Research")
    self.UpgradeCD = self.UpgradeBtn:GetChild("Text_Time")
    self.UpgradeCD.text = ""
end

return _V