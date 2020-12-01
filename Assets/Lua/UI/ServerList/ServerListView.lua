local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Login/Login", "Login", "ServerListMain")

    self.ServerList = self.UI:GetChild("List_Servers").asList
    self.ServerDetailList = self.UI:GetChild("List_ServerList").asList 

    self.ServerList:SetVirtual()
    self.ServerDetailList:SetVirtual()

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
end

return _V