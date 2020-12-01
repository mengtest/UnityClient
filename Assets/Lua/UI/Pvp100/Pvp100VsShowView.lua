local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Pvp100/Pvp100Battle", "Pvp100Battle", "Pvp100VsShow")

    self.AttackerName = self.UI:GetChild("Text_AttackerName")
    self.DefenderName = self.UI:GetChild("Text_DefenderName")
    self.AttackerHead = self.UI:GetChild("Loader_AttackIcon")
    self.DefenderHead = self.UI:GetChild("Loader_DefenderIcon")
end

return _V