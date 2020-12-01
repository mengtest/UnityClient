local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "AllianceMain")

    -- controller
    self.Page_C = self.UI:GetController("Page_C")

    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    -- 主页
    local HomePage = self.UI:GetChild("Component_Homepage")
    self.HomePage = { }
    -- 0 进度条 1 升级按钮 2 可加速 3 不可加速
    self.HomePage.Level_C = HomePage:GetController("Level_C")
    self.HomePage.LevelProgressBar = HomePage:GetChild("ProgressBar_Level")
    self.HomePage.UpgradeBtn = HomePage:GetChild("Button_Upgrade")
    self.HomePage.UpgradeTime = HomePage:GetChild("Text_UpgradeTime")
    self.HomePage.SpeedupBtn = HomePage:GetChild("Button_Speedup")
    -- 0 弹劾 1 投票 2 查看 3 禅让 4 无
    self.HomePage.Leader_C = HomePage:GetController("Leader_C")
    self.HomePage.ImpeachBtn = HomePage:GetChild("Button_Accuse")
    self.HomePage.VoteBtn = HomePage:GetChild("Button_Vote")
    self.HomePage.DemiseBtn = HomePage:GetChild("Button_Demise")
    self.HomePage.AllianceName = HomePage:GetChild("Text_AllianceName")
    self.HomePage.LeaderName = HomePage:GetChild("Text_LeaderName")
    self.HomePage.AllianceLevel = HomePage:GetChild("Text_AllianceLevel")
    self.HomePage.MemberCount = HomePage:GetChild("Text_Member")
    self.HomePage.Ranking = HomePage:GetChild("Text_Ranking")
    self.HomePage.ConstructionValue = HomePage:GetChild("Text_ConstructionValue")
    self.HomePage.Silver = HomePage:GetChild("Text_Silver")
    self.HomePage.AllianceNameBtn = HomePage:GetChild("Button_AllianceName")
    -- 0 已放置 1 未放置 2 没雕像
    self.HomePage.Statue_C = HomePage:GetController("Statue_C")
    self.HomePage.PlaceBtn = HomePage:GetChild("Button_Place")
    self.HomePage.Statue = HomePage:GetChild("Text_Statue")
    -- 0 有国家 1 没国家
    self.HomePage.Country_C = HomePage:GetController("Country_C")
    self.HomePage.Country = HomePage:GetChild("Label_Country")
    self.HomePage.Flag = HomePage:GetChild("Label_Flag")
    -- 0 有标签 1 没标签
    self.HomePage.Tag_C = HomePage:GetController("Tag_C")
    self.HomePage.TagList = HomePage:GetChild("List_Tag")
    -- 0 有诏书 1 没诏书
    self.HomePage.Edict_C = HomePage:GetController("Edict_C")
    self.HomePage.EdictBtn = HomePage:GetChild("Button_Edict")
    self.HomePage.EdictTime = HomePage:GetChild("Text_EdictTime")
    self.HomePage.EdictTitle = HomePage:GetChild("Text_EdictTitle")
    self.HomePage.WarSituationBtn = HomePage:GetChild("Button_WarSituation")
    self.HomePage.WarSituationList = HomePage:GetChild("List_WarSituation")
    self.HomePage.WarSituationList:SetVirtual()
    -- 0 有联盟目标 1 无联盟目标
    self.HomePage.Target_C = HomePage:GetController("Target_C")
    self.HomePage.TargetDesc = HomePage:GetChild("Text_TargetDesc")
    self.HomePage.EditBtn = HomePage:GetChild("Button_Edit")
    self.HomePage.DetailsList= HomePage:GetChild("List_Details")

    -- 捐献页
    local ContributionPage = self.UI:GetChild("Component_Contribution")
    self.ContributionPage = { }
    self.ContributionPage.ConstructionValue = ContributionPage:GetChild("Text_ConstructionValue")
    self.ContributionPage.ContributionValue = ContributionPage:GetChild("Text_ContributionValue")
    self.ContributionPage.Label_1 = ContributionPage:GetChild("Label_1")
    self.ContributionPage.Label_2 = ContributionPage:GetChild("Label_2")
    self.ContributionPage.Label_4 = ContributionPage:GetChild("Label_4")
    self.ContributionPage.Label_5 = ContributionPage:GetChild("Label_5")
    self.ContributionPage.TitleText = ContributionPage:GetChild("Text_Title")
    self.ContributionPage.DonationText = ContributionPage:GetChild("Text_Donation")
    self.ContributionPage.DescText = ContributionPage:GetChild("Text_Desc")
    self.ContributionPage.DonateBtn = ContributionPage:GetChild("Button_Donate")
    --self.ContributionPage.DonateBtnList = ContributionPage:GetChild("List_Buttons")
    --self.ContributionPage.DonateDescList = ContributionPage:GetChild("List_Desc")
    self.ContributionPage.ContributionList = ContributionPage:GetChild("List_Contribution")
    self.ContributionPage.ContributionList:SetVirtual()
    self.ContributionPage.ResourceToggle = ContributionPage:GetChild("Toggle_Resource")
    self.ContributionPage.YuanBaoToggle = ContributionPage:GetChild("Toggle_YuanBao")
    self.ContributionPage.HodiernalContributionToggle = ContributionPage:GetChild("Toggle_HodiernalContribution")
    self.ContributionPage.SevenDaysContributionToggle = ContributionPage:GetChild("Toggle_SevenDaysContribution")
    self.ContributionPage.TotalContributionToggle = ContributionPage:GetChild("Toggle_TotalContribution")
    self.ContributionPage.DonateRankingList = ContributionPage:GetChild("List_DonateRanking")
    self.ContributionPage.DonateRankingList:SetVirtual()

    -- 管理页
    local ManagePage = self.UI:GetChild("Component_Manage")
    self.ManagePage = { }
    -- 联盟管理页签
    local ManagePanel = ManagePage:GetChild("Component_ManagePage")
    -- 盟主 副盟主 其他人
    self.ManagePage.Post_C = ManagePanel:GetController("Post_C")
    self.ManagePage.ApplicationBtn = ManagePanel:GetChild("Button_Application")
    self.ManagePage.ChangePostBtn = ManagePanel:GetChild("Button_ChangePost")
    self.ManagePage.ChangeTitleBtn = ManagePanel:GetChild("Button_ChangeTitle")
    self.ManagePage.KickoutBtn = ManagePanel:GetChild("Button_Kickout")
    self.ManagePage.ChangeSalaryBtn = ManagePanel:GetChild("Button_ChangeSalary")
    self.ManagePage.DemiseBtn = ManagePanel:GetChild("Button_Demise")
    self.ManagePage.DissolveBtn = ManagePanel:GetChild("Button_Dissolve")
    self.ManagePage.QuitBtn = ManagePanel:GetChild("Button_Quit")
    self.ManagePage.MemberList = ManagePanel:GetChild("List_Member")
    self.ManagePage.MemberList:SetVirtual()
    -- 大事记页签
    self.ManagePage.NoteList = ManagePage:GetChild("List_Note")
    -- self.ManagePage.NoteList:SetVirtual()

    -- 商店页
    local ShopPage = self.UI:GetChild("Component_Shop")
    self.ShopPage = { }
    self.ShopPage.Prop_C = ShopPage:GetController("Prop_C")
    self.ShopPage.State_C = ShopPage:GetController("State_C")
    self.ShopPage.Cost_C = ShopPage:GetController("Cost_C")
    self.ShopPage.PropList = ShopPage:GetChild("List_Prop")
    self.ShopPage.PropDesc = ShopPage:GetChild("Text_PropDesc")
    self.ShopPage.SubBtn = ShopPage:GetChild("Button_Sub")
    self.ShopPage.PropAmountInput = ShopPage:GetChild("Text_PropAmount")
    self.ShopPage.AddBtn = ShopPage:GetChild("Button_Add")
    self.ShopPage.CostText = ShopPage:GetChild("Text_Cost")
    self.ShopPage.TotalContributionText = ShopPage:GetChild("Text_TotalContribution")
    self.ShopPage.BuyBtn = ShopPage:GetChild("Button_Buy")

    -- 银两页
    local SilverPage = self.UI:GetChild("Component_Silver")
    self.SilverPage = { }
    self.SilverPage.Post_C = SilverPage:GetController("Post_C")
    self.SilverPage.IncomeDetailsList = SilverPage:GetChild("List_IncomeDetails")
    self.SilverPage.IncomeDetailsList:SetVirtual()
    self.SilverPage.PayList = SilverPage:GetChild("List_Pay")
    self.SilverPage.PayList:SetVirtual()
    self.SilverPage.IncomeList = SilverPage:GetChild("List_Income")
    self.SilverPage.IncomeList:SetVirtual()
    self.SilverPage.TotalMoney = SilverPage:GetChild("Text_TotalMoney")
    self.SilverPage.TotalSalary = SilverPage:GetChild("Text_TotalSalary")
    self.SilverPage.SalaryBtn = SilverPage:GetChild("Button_Salary")
    self.SilverPage.GiveToAllianceBtn = SilverPage:GetChild("Button_GiveToAlliance")
    self.SilverPage.GiveToPlayerBtn = SilverPage:GetChild("Button_GiveToPlayer")
end

return _V