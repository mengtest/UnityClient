local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Login/Login", "Login", "Shan")
    -- logo效果
    self.Effect = self.UI:GetTransition("logodongxiao")
end

return _V