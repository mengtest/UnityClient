local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/PracticeHall/PracticeHall", "PracticeHall", "UpgradeMain")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- center
    self.UpgradeList = self.UI:GetChild("List_Stage")
    self.UpgradeList:SetVirtual()
end

return _V