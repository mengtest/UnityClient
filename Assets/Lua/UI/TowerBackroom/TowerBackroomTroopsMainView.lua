local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/TowerBackroom/Backroom", "Backroom", "TroopsMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnStart = self.UI:GetChild("Button_Start")
    self.BtnLeave = self.UI:GetChild("Button_Leave")
    self.BtnInvite = self.UI:GetChild("Button_Invite")
    self.BtnShout  = self.UI:GetChild("Button_Shout")

    self.TroopsModeStat = self.UI:GetController("Type_C")
    self.BtnTroopsMode = self.UI:GetChild("Button_Mode")

    self.RoomNum = self.UI:GetChild("TextField_RoomNumber")
    self.RoomName = self.UI:GetChild("TextField_RoomName")
    self.TroopsMinNum = self.UI:GetChild("TextField_MinTroopsNumber")

    local attackerTroops = self.UI:GetChild("Component_AttackerTroops")
    attackerTroops:GetController("troops_C").selectedIndex = 0
    self.AttackerTroopsList = attackerTroops:GetChild("List_Troops").asList
    self.AttackerTroopsList:SetVirtual()

    local defenderTroops = self.UI:GetChild("Component_DefenderTroops")
    defenderTroops:GetController("troops_C").selectedIndex = 1
    self.DefenderTroopsList = defenderTroops:GetChild("List_Troops").asList
    self.DefenderTroopsList:SetVirtual()

    self.ItemAwardList = self.UI:GetChild("List_Rewards").asList
    self.ItemAwardList:SetVirtual()

    local superPrize = self.UI:GetChild("Component_Prize")
    superPrize:GetController("Count_C").selectedIndex = 1
    superPrize:GetController("State_C").selectedIndex = 1
    superPrize:GetController("CornerMark_C").selectedIndex = 2
    self.SuperPrize = {}
    self.SuperPrize.Root = superPrize
    self.SuperPrize.Icon = superPrize:GetChild("icon")
    self.SuperPrize.Quality = superPrize:GetChild("quality")
    self.SuperPrize.Num = superPrize:GetChild("title")

    local guildContribution = self.UI:GetChild("Component_GuildContribution")
    guildContribution:GetController("Count_C").selectedIndex = 1
    guildContribution:GetController("State_C").selectedIndex = 1
    guildContribution:GetController("CornerMark_C").selectedIndex = 2
    self.GuildContribution = {}
    self.GuildContribution.Root = guildContribution
    self.GuildContribution.Icon = guildContribution:GetChild("icon")
    self.GuildContribution.Quality = guildContribution:GetChild("quality")
    self.GuildContribution.Num = guildContribution:GetChild("title")
end

return _V