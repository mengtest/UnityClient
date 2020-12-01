local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "SoulAquire")
    self.BackBtn= self.UI:GetChild("Gra_Main")
end

return _V 