local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Pvp100/Pvp100Battle", "Pvp100Battle", "Pvp100RankLevel")

    self.BtnBack = self.UI:GetChild("Button_Back")

    self.Loader_Rank_Icon = self.UI:GetChild("Loader_Rank_Icon")
end

return _V