local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Armor/Armor", "Armor", "Component_Intensify",false)

    self.TaoZCurLv = self.UI:GetChild("Text_CurrentLevel")
	self.TaoZNextLv = self.UI:GetChild("Text_NextLevel")
	self.TaoZCurEquip = self.UI:GetChild("Text_CurrentState")
	self.TaoZNextEquip = self.UI:GetChild("Text_NextState")
	self.TaoZCurMorale = self.UI:GetChild("Text_CurrentMorale")
	self.TaoZNextMorale = self.UI:GetChild("Text_NextMorale")
	
    self.TaoZStat = self.UI:GetController("State_C")

	self.BtnBack = self.UI:GetChild("Button_Back")	
end

return _V