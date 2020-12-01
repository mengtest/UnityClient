local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Wall/Wall", "Wall", "WallDefenseMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnEmbattle = self.UI:GetChild("btn_embattle")

    local defense = self.UI:GetChild("com_defense")
    self.HomeDefenseTroop = defense:GetChild("txt_homeDefense_troop")
    self.TentDefenseTroop = defense:GetChild("txt_tentDefense_troop")
    self.HomeDefenseTroopTip = defense:GetChild("com_homeDefenseTip")
    self.TentDefenseTroopTip = defense:GetChild("com_tentDefenseTip")

    local troops = self.UI:GetChild("com_troops")
    self.HandleTroopStat = troops:GetController("troopHandle_C")

    self.Troops = { }
    for i = 1, 3 do
        self.Troops[i] = { }
        self.Troops[i].BtnGarrison = troops:GetChild("btn_garrison_troop" .. i)
        self.Troops[i].BtnRevocation = troops:GetChild("btn_revocation_troop" .. i)
        self.Troops[i].BtnAddSolider = troops:GetChild("btn_addSolider_troop" .. i)
        self.Troops[i].TroopBtnStat = troops:GetController("btnTroop" .. i .. "Stat_C")
        self.Troops[i].TroopGarrisonStat = troops:GetController("garrisonTroop" .. i .. "Stat_C")
        self.Troops[i].RaceList = troops:GetChild("list_race_troop" .. i)
        self.Troops[i].Solider = troops:GetChild("progressBar_solider_troop" .. i)
        self.Troops[i].Fight = troops:GetChild("txt_fight_troop" .. i)
    end

    local garrison = troops:GetChild("com_select")
    self.BtnGarrisonHome = garrison:GetChild("btn_garrisonHome")
    self.BtnGarrisonTent = garrison:GetChild("btn_garrisonTent")
    self.BtnHandleCancel = garrison:GetChild("btn_cancel")
    self.HandleStat = garrison:GetController("handleStat_C")
end

return _V