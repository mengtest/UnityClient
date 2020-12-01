local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ClimbingTower/ClimbingTower", "ClimbingTower", "GainMain")

    self.BtnBack = self.UI:GetChild("Button_Background")

    local award = self.UI:GetChild("Component_Gain")
    self.Floors = award:GetChild("TextField_Floor")
    self.BtnDrawAward = award:GetChild("Button_Acquire")
    self.DrawStat = award:GetController("State_C")
    self.EnterEffect = award:GetTransition("enter_T")
    self.AwardItemList = award:GetChild("List_Item")
    self.AwardItemList:SetVirtual()
end

return _V