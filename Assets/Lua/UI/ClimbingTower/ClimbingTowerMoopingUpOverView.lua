local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ClimbingTower/ClimbingTower", "ClimbingTower", "MopUpCompleteMain")

    self.BtnBack = self.UI:GetChild("Button_Background")
    self.EffectVictory_1 = self.UI:GetTransition("Victory_T")

    local result = self.UI:GetChild("Component_Gain")
    self.EffectVictory_2 = result:GetTransition("Victory_T")	
    self.CaptainList = result:GetChild("List_Details").asList	
    self.ItemList = result:GetChild("List_Acquire").asList
	
    self.ItemList:SetVirtual()
end

return _V