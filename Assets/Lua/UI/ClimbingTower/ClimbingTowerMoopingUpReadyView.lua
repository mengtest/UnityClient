local _V = UIManager.View()

function _V:LoadView()
	self.UI, self.PKG = UIManager.creatView("UI/ClimbingTower/ClimbingTower", "ClimbingTower", "MopUpStartMain")

    self.BtnBack = self.UI:GetChild("Button_Background")        
	self.BtnTroopEmbattle = self.UI:GetChild("Button_Change")	
	self.TroopSlot = self.UI:GetChild("Component_MySlot")
	
	local moopingUp = self.UI:GetChild("Component_Start")	
    self.MoopingUpDesc = moopingUp:GetChild("TextField_Description")
    self.BtnStart = moopingUp:GetChild("Button_Start")	
 
    self.MoopingUpCount = moopingUp:GetChild("TextField_RemainTimes")
    self.ResetTime = moopingUp:GetChild("TextField_Reset")
    self.MoopingUpFloorMax = moopingUp:GetChild("TextField_RecordFloor")
end

return _V