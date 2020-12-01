local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/TowerBackroom/Backroom", "Backroom", "BattlelogMain")

    -- 返回
    self.BtnBack = self.UI:GetChild("Button_Background")

    self.BattleLogList = self.UI:GetChild("List_Log").asList
    self.BattleLogList:SetVirtual()
end

return _V