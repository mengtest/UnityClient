local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Pvp100/Pvp100Battle", "Pvp100Battle", "Pvp100NewRecord")

    self.BtnBack = self.UI:GetChild("Component_Main"):GetChild("Button_Close")
    self.BtnBack_2 = self.UI:GetChild("Button_Back")

    self.ListAward = self.UI:GetChild("List_Rewards")
    self.BtnCollect = self.UI:GetChild("Button_Acquire")
end

return _V