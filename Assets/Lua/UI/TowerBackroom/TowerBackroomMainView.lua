local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/TowerBackroom/Backroom", "Backroom", "BackroomMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnCreatTroop = self.UI:GetChild("Button_CreateTeam")
    self.RoomNumStat = self.UI:GetController("NumState_C")
    self.FloorTroopStat = self.UI:GetController("State_C")
    self.TroopCreatStat = self.UI:GetController("Create_C")

    self.FloorCountList = self.UI:GetChild("List_Floor").asList
    self.FloorCountList:SetVirtual()
    self.FloorTroopsList = self.UI:GetChild("List_Troops").asList
    self.FloorTroopsList:SetVirtual()

    self.HelpNum = self.UI:GetChild("TextField_HelpTimes")
    self.RoomNum = self.UI:GetChild("TextField_RoomNumber")
    self.RecoverTime = self.UI:GetChild("TextField_Time")
end

return _V