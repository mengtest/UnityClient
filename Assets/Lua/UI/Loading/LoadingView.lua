local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Login/Login", "Login", "LoadingMain")

    self.ProgressBar = self.UI:GetChild("ProgressBar_Loading")
end

return _V