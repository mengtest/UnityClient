local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Library/Library", "Library", "Component_Chat",false)
	self.BtnChat = self.UI:GetChild("Button_Chat")   
	self.Content = self.BtnChat:GetChild("title")    
end

return _V