local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Pvp100/Pvp100Battle", "Pvp100Battle", "Pvp100RankSalary")

    self.BtnBack = self.UI:GetChild("Button_Close")
    self.BtnBack_2 = self.UI:GetChild("Button_Back")

    self.ListRankSalary = self.UI:GetChild("List_RankLevelReward").asList
end

return _V