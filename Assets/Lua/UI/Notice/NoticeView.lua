local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Login/Login", "Login", "NoticeMain")

	self.Content = self.UI:GetChild("txt_neirong")
    self.BtnBack = self.UI:GetChild("btn_wozhidao")
end

return _V