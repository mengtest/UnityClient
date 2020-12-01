local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "CheckVoteMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    self.MainList = window:GetChild("List_Main")
    self.MainList:SetVirtual()
end

return _V