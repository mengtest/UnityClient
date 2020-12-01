local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Library/Library", "Library", "Component_PropTips",false)

    self.Amount = self.UI:GetChild("shu_yongyou")
	self.Desc = self.UI:GetChild("wenbenneirong")
	self.Name = self.UI:GetChild("title")
	local item = self.UI:GetChild("icon")
	self.Icon = item:GetChild("icon")
	self.Quality = item:GetChild("quality")
	item:GetController("State_C").selectedIndex = 1        
end

return _V