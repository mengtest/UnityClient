local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Library/Library", "Library", "Component_Loading")

    self.Effect = self.UI:GetTransition("juhuazhuan")
end

return _V