local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Academy/Academy", "Academy", "AcademyMain")
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.MainList = self.UI:GetChild("List_Technology")
end

return _V