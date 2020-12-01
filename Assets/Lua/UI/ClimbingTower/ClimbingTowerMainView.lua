local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ClimbingTower/ClimbingTower", "ClimbingTower", "ClimbingTowerMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnStrategy = self.UI:GetChild("Button_Strategy")
    self.BtnBox = self.UI:GetChild("Button_Box")
    self.BtnChallenge = self.UI:GetChild("Button_Challenge")
    self.BtnMoopingUp = self.UI:GetChild("Button_MopUp")
    
    self.EffectChallenge = self.UI:GetTransition("Challenge_T")

    self.TowerStat = self.UI:GetController("State_C")  
    self.AwardBoxId = self.BtnBox:GetChild("TextField_BoxFloor")

    local floorInfo = self.UI:GetChild("Component_FloorInfo")
    self.TowerFloorCur = floorInfo:GetChild("txt_curFloor")
    self.TowerFloorMax = floorInfo:GetChild("txt_max")
    self.ResetTime = floorInfo:GetChild("txt_reset")
    self.ChallengeTimeStat = floorInfo:GetController("State_C")    

    self.AwardItemList = self.UI:GetChild("List_Acquire").asList
    self.AwardItemList.defaultItem = UIConfig.Item.DefaultItemUrl
    self.AwardItemDesc = self.UI:GetChild("TextField_FloorAward")

    self.BottomUI = UIPackage.GetItemURL("ClimbingTower", "Button_DownFloor")
    self.TopUI = UIPackage.GetItemURL("ClimbingTower", "Button_UpFloor")
    self.LeftUI = UIPackage.GetItemURL("ClimbingTower", "Button_LeftFloor")
    self.RightUI = UIPackage.GetItemURL("ClimbingTower", "Button_RightFloor")

    self.TowerFloorList = self.UI:GetChild("List_Mission").asList
    self.TowerFloorList.defaultItem = self.LeftUI;
    self.TowerFloorList:SetVirtual()
end

return _V