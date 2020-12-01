local View = UIManager.View()

function View:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/FieldHeadquarters/FieldHeadquarters", "FieldHeadquarters", "HeadquartersMain")
    self.CloseButton = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    local leftTopPanel = self.UI:GetChild("Component_Soldier")
    self.MyTroopsList = leftTopPanel:GetChild("List_Race")
    self.Power = leftTopPanel:GetChild("TextField_Sword")
    self.Troop = leftTopPanel:GetChild("TextField_Troops")
    self.AddMilitary = leftTopPanel:GetChild("Button_Add")
    self.AddWarrior = leftTopPanel:GetChild("Button_Defend")
    self.LTStateCtr = leftTopPanel:GetController("State_C")

    local leftBottmPanel = self.UI:GetChild("Component_Time")
    self.FlourishProgressBar = leftBottmPanel:GetChild("ProgressBar_Progress")
    self.RecoveryButton = leftBottmPanel:GetChild("Button_Recover")
    self.FlourishTips = leftBottmPanel:GetChild("Label_Instructions")
    self.CampsiteFragment = leftBottmPanel:GetChild("TextField_Fragment")
    self.LBStateCtr = leftBottmPanel:GetController("State_C")
    self.LBSwitchCtl = leftBottmPanel:GetController("Type_C")
    self.CampsiteMoveTimer = leftBottmPanel:GetChild("TextField_Time")
    self.CampsiteMoveButton = leftBottmPanel:GetChild("Button_Leave")

    self.FriendList = self.UI:GetChild("Component_Alliance"):GetChild("List_Alliance")

end

return View