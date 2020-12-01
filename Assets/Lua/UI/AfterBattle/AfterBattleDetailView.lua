local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/AfterBattle/AfterBattle", "AfterBattle", "DetailsMain")
    -- 按钮
    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    -- 武将列表
    self.GeneralList = self.UI:GetChild("List_Details"):GetChildAt(0)
    self.AttackerGeneralList = self.GeneralList:GetChild("List_MyTroop")
    self.DefenderGeneralList = self.GeneralList:GetChild("List_EnemyTroop")
end

return _V