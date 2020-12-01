local UIView = UIManager.View()

function UIView:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Ranking/Ranking", "Ranking", "Main")
    self.ButtonReturn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    local mainUI = self.UI:GetChild("Component_Content")
    self.AllianceRanking = mainUI:GetChild("Component_LeagueRanking"):GetChild("List_LeagueRanking")
    self.AllianceRanking:SetVirtual()

    self.SecretTowerRanking = mainUI:GetChild("Component_ClimbingRanking"):GetChild("List_ClimbingRanking")
    self.SecretTowerRanking:SetVirtual()

    self.HundredsWarRanking = mainUI:GetChild("Component_ThousandRanking"):GetChild("List_MainChart")
    self.HundredsWarRanking:SetVirtual()

    self.HundredsWarLevel = mainUI:GetChild("List_BottomButtons")
    self.HundredsWarLevelCtr = mainUI:GetController("MilitaryRank_C")

    self.CountryRanking = mainUI:GetChild("Component_CountryRanking"):GetChild("List_CountryRanking")
    self.CountryRanking:SetVirtual()

    self.SearchInput = mainUI:GetChild("Text_Search")

    self.ButtonSerachOrCancel = mainUI:GetChild("Button_Search")

    self.ButtonSelfOrTop = mainUI:GetChild("Button_FirstPlace")

    self.MyHundredRank = mainUI:GetChild("Text_Tips")

    self.HundredRefreshTime = mainUI:GetChild("Text_RefreshTime")

    self.TabCtr = mainUI:GetController("Tab_C")

    self.SearchCtr = mainUI:GetController("SearchOrCancel_C")

    self.BackTopCtr = mainUI:GetController("SelfOrTop_C")

end

return UIView