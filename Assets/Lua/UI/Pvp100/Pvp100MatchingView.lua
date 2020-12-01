local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Pvp100/Pvp100Battle", "Pvp100Battle", "Pvp100Matching")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    self.BtnEmbattle = self.UI:GetChild("Button_Embattle")
    self.AttackTroopSlot = self.UI:GetChild("Component_MyTeam")
    self.RankIcon = self.UI:GetChild("Component_MiltaryRanking"):GetChild("Loader_MiltaryRank")

    -- 军衔名次
    local rankPanel = self.UI:GetChild("Componment_SelfRanking")
    self.SelfRank = {
        Stat = rankPanel:GetController("State_C"),
        Type = rankPanel:GetController("Type_C"),
        Name = rankPanel:GetChild("Text_PlayerName"),
        Ranking = rankPanel:GetChild("Text_Ranking"),
        Point = rankPanel:GetChild("Text_Points"),
        LevelupDesc = self.UI:GetChild("Text_RankDesc"),
    }

    self.ListRankStat = self.UI:GetController("State_C")
    self.ListRankTitle = self.UI:GetChild("Text_RankLevel")
    self.ListRank = self.UI:GetChild("List_Ranking").asList
    self.ListRank:SetVirtual()

    self.RankLevelupDesc = self.UI:GetChild("Text_RankDesc")
    self.WinPoint = self.UI:GetChild("Text_WinPoint")
    self.FailPoint = self.UI:GetChild("Text_LosePoint")

    self.BtnStart = self.UI:GetChild("Buttonn_Start")
end

return _V