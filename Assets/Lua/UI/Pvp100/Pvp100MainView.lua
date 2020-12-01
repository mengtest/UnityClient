local _V = UIManager.View()

local function getRankTitle(item)
    local part = { }
    part.Title = item:GetChild("Txt_Rank_Building")
    part.Stat = item:GetController("State_C")

    return part
end

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Pvp100/Pvp100Battle", "Pvp100Battle", "Pvp100Main")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    self.BtnRanking = self.UI:GetChild("Button_Ranking")
    self.BtnRecord = self.UI:GetChild("Button_Record")
    self.BtnSalary = self.UI:GetChild("Button_Salary")
    self.RankPrizeStat = self.UI:GetController("Stage_C")

    -- 军衔进度
    local rankPanel = self.UI:GetChild("Component_ExpperienceBar")
    self.RankPointBar = rankPanel:GetChild("ProgressBar_Experience")
    self.RankPointCur = rankPanel:GetChild("Text_CurrentPoints")
    self.RankPointMax = rankPanel:GetChild("Text_NextPoints")
    self.RankPointMax_2 = rankPanel:GetChild("Text_Experience")
    self.BtnRankPrize = rankPanel:GetChild("Button_RankPrize")

    -- 基础信息
    local basePanel = self.UI:GetChild("Component_RankingDetails")
    self.RankIcon = basePanel:GetChild("Component_MiltaryRanking"):GetChild("Loader_MiltaryRank")
    self.WinPoint = basePanel:GetChild("Text_WinPoint")
    self.FailPoint = basePanel:GetChild("Text_LosePoint")
    self.NextTimeRecoverCd = basePanel:GetChild("Text_Times")
    self.TodayRankPoint = basePanel:GetChild("Text_Points")
    self.TodayLeftTime = basePanel:GetChild("Text_RemainNumber")
    self.BtnChallenge = basePanel:GetChild("Button_Challenge")

    -- 军衔名称
    local rankTitlePanel = self.UI:GetChild("Component_Buildings")
    self.RankTitle = {
        [1] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding01")),
        [2] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding02")),
        [3] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding03")),
        [4] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding04")),
        [5] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding05")),
        [6] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding06")),
        [7] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding07")),
        [8] = getRankTitle(rankTitlePanel:GetChild("Btn_Buiding08")),
    }
end

return _V