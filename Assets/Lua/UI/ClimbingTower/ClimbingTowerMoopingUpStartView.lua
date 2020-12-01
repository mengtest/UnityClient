local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ClimbingTower/ClimbingTower", "ClimbingTower", "MopUpMain")

    self.TiaoGuo = self.UI:GetChild("Button_Background")

    local result = self.UI:GetChild("Component_Skip")
    self.MoopingUpCount = result:GetChild("TextField_RemainTimes")
    self.ResetTime = result:GetChild("TextField_Reset")
    self.MoopingUpFloorMax = result:GetChild("TextField_Max")
    self.BtnSkip = result:GetChild("Button_Skip")

    local moopingUpResult = result:GetChild("Component_Award")
    self.MoopingupAwardList = moopingUpResult:GetChild("List_MopUp").asList
    self.MoopingupAwardList:SetVirtual()
end

return _V