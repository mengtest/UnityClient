local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/TowerBackroom/Backroom", "Backroom", "ArmyInfoMain")

    -- 返回
    self.BtnBack = self.UI:GetChild("Button_Background")

    self.TroopsList = self.UI:GetChild("List_Troops").asList
    self.TroopsList:SetVirtual()
end

return _V