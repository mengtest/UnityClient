local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Barrack/Barrack", "Barrack", "BarrackMain")
    -- controller
    -- 0:新兵 1:伤兵
    self.Type_C = self.UI:GetController("Type_C")

    -- transition
    self.Update_T = self.UI:GetTransition("Add_T") 
    self.Train_T = self.UI:GetTransition("Train_T") 
    self.Treat_T = self.UI:GetTransition("Treat_T") 
    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- top right
    self.SoldierLev = self.UI:GetChild("Text_SoldierLevel")
    self.SoldierAmount = self.UI:GetChild("Text_SoldierAmount")
    self.SoldierTips = self.UI:GetChild("Label_SoldierTips")
    self.UpgradeBtn = self.UI:GetChild("Button_Upgrade")

    -- left
    self.ConditionPanel = self.UI:GetChild("List_ConditionPanel")
    self.ConditionTitle = self.ConditionPanel:GetChild("Text_Title")
    self.ConditionTitle.text = Localization.NewSoldierCondition
    self.ConditionList = self.ConditionPanel:GetChild("List_Condition")

    -- right
    self.NewSoldierAmount = self.UI:GetChild("Text_NewSoldierAmount")
    self.NewSoldierTips = self.UI:GetChild("Label_NewSoldierTips")
    self.TrainBtn = self.UI:GetChild("Button_Train")
    self.TrainSlider = self.UI:GetChild("Slider_Train")
    self.TrainAmount = self.UI:GetChild("Text_TrainAmount")
    self.TrainSubBtn = self.UI:GetChild("Button_TrainSub")
    self.TrainAddBtn = self.UI:GetChild("Button_TrainAdd")

    -- bottom right
    self.WoundedSoldierAmount = self.UI:GetChild("Text_WoundedSoldierAmount")
    self.WoundedSoldierTips = self.UI:GetChild("Label_WoundedSoldierTips")
    self.TreatBtn = self.UI:GetChild("Button_Treat")
    self.TreatSlider = self.UI:GetChild("Slider_Treat")
    self.TreatAmount = self.UI:GetChild("Text_TreatAmount")
    self.TreatSubBtn = self.UI:GetChild("Button_TreatSub")
    self.TreatAddBtn = self.UI:GetChild("Button_TreatAdd")
end

return _V