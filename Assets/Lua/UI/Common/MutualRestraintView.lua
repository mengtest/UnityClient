local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Library/Library", "Library", "Component_MutualRestraint")

    self.CloseBtn = self.UI:GetChild("Component_BG")
end

return _V