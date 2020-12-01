local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/PracticeHall/PracticeHall", "PracticeHall", "UpgradeMenuMain")

    self.BackBtn = self.UI:GetChild("Component_BG")

    -- center
    self.UpgradeList = self.UI:GetChild("Component_Main"):GetChild("List_Upgrade")
end

return _V