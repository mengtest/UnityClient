local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "ApplicationWindowMain")

    self.BG = self.UI:GetChild("Component_BG")
    local window = self.UI:GetChild("Component_Main")

    self.CloseBtn = window:GetChild("Label_PopupWindow"):GetChild("Button_Close")
    self.MainList = window:GetChild("List_Application")
    self.MainList:SetVirtual()
end

return _V