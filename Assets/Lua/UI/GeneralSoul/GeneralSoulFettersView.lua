local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "SoulConnnection")
    self.BackBtn = self.UI:GetChild("Btn_Back")

    self.FettersList = self.UI:GetChild("List_ConnectionSet")
    self.FettersList:SetVirtual()
end

return _V 