local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Armor/Armor", "Armor", "GemHelp")
    self.BackBtn= self.UI:GetChild("Component_GrapgBG")
    self.GemList = self.UI:GetChild("List_GemHelp")
end

return _V 