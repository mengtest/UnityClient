local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Upgrade/Upgrade", "Upgrade", "UpgradeMain")

    -- controller
    self.LevelMax_C = self.UI:GetController("Level_C")
    self.Speedup_C = self.UI:GetController("Speedup_C")

    -- tansition
    self.Effect_T = self.UI:GetTransition("Effect_T")

    -- top left
    self.TitleLabel = self.UI:GetChild("Label_BackTitle")
    self.BackBtn = self.TitleLabel:GetChild("Button_Back")

    -- left
    local conditionPanel = self.UI:GetChild("Component_Condition")
    self.ConditionTitle = conditionPanel:GetChild("Text_Title")
    self.ConditionList = conditionPanel:GetChild("List_Condition")

    -- bottom right
    self.CurrLevel = self.UI:GetChild("Text_CurrLevel")
    self.NextLevel = self.UI:GetChild("Text_NextLevel")
    self.CurrDes = self.UI:GetChild("Text_CurrDes")
    self.NextDes = self.UI:GetChild("Text_NextDes")
    self.Speedup = self.UI:GetChild("Text_Speedup")
    self.UpgradeBtn = self.UI:GetChild("Button_Upgrade")
    self.CD = self.UpgradeBtn:GetChild("Text_Time")
    self.CD.text = ""
end

return _V