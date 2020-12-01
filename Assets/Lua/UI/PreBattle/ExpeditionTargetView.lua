local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/PreBattle/PreBattle", "PreBattle", "ExpeditionTargetMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
	self.BtnHostile = self.UI:GetChild("btn_difang")
    self.BtnAllies  = self.UI:GetChild("btn_wofang")
	self.BtnConflict = self.UI:GetChild("btn_chongtu")
	
	self.HostileNum = self.BtnHostile:GetChild("title")
	self.AlliesNum = self.BtnAllies:GetChild("title")
	self.ConflictNum = self.BtnConflict:GetChild("title")
	
	self.HostileList = self.UI:GetChild("list_diduishili").asList
	self.AlliesList = self.UI:GetChild("list_wofangshili").asList
	self.ConflictList = self.UI:GetChild("list_chongtushili").asList
	
    self.HostileList:SetVirtual()
    self.AlliesList:SetVirtual()
    self.ConflictList:SetVirtual()
end

return _V