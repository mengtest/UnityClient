local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/PracticeHall/PracticeHall", "PracticeHall", "PracticeHallMain")

    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- 修炼馆
    local practicePanel = self.UI:GetChild("Component_Practice")
    self.GeneralList = practicePanel:GetChild("List_General")
    self.GeneralList:SetVirtual()
    self.StageList = practicePanel:GetChild("List_Practice")
    self.StageList:SetVirtual()
    self.PracticeBtn = practicePanel:GetChild("Button_Practice")
    self.UpgradeBtn = practicePanel:GetChild("Button_Upgrade")
    self.GetBtn = practicePanel:GetChild("Button_Get")
end

return _V