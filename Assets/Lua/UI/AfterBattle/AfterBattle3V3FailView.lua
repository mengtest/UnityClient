local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/TowerBackroom/Backroom", "Backroom", "FailMain")

    -- 按钮
    self.BtnReplay = self.UI:GetChild("Button_Replay")
    self.BtnBack = self.UI:GetChild("Button_Back")

    self.BattleLeftChalletNum = self.UI:GetChild("TextField_LeftChallengeNumber")
    self.BattleLeftHelpNum = self.UI:GetChild("TextField_LeftHelpNumber")
    self.DefenderDieNum = self.UI:GetChild("TextField_DieNumber")
    self.DefenderAliveNum = self.UI:GetChild("TextField_RemainNumber")

    -- 君主列表
    self.PlayerList = self.UI:GetChild("List_PlayerAward").asList
    self.PlayerList:SetVirtual()
end

return _V