local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "ChangePostWindowMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    
    self.CloseBtn = window:GetChild("Label_PopupWindow"):GetChild("Button_Close")
    self.NameText = window:GetChild("Text_Name")
    self.PostList = window:GetChild("List_Post")
    self.ConfirmBtn = window:GetChild("Button_Confirm")

end

return _V