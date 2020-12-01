local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Battle/Battle", "Battle", "InformationMain")

    -- 返回
    self.BtnBack = self.UI:GetChild("Button_Back")

    local LogPanel = self.UI:GetChild("Component_Info")
    self.BattleLogList = LogPanel:GetChild("List_BattleDetails").asList
    self.BattleLogList:SetVirtual()

    self.BtnBack_2 = LogPanel:GetChild("Component_Details"):GetChild("Button_Close")
end

return _V