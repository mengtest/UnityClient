local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "ChangeTitleWindowMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")

    self.CloseBtn = window:GetChild("Label_PopupWindow"):GetChild("Button_Close")
    self.SystemTitleList = window:GetChild("List_SystemTitle")
    self.SystemMemberList = window:GetChild("List_SystemMember")
    self.CustomTitleList = window:GetChild("List_CustomTitle")
    self.CustomMemberList = window:GetChild("List_CustomMember")
    self.MemberList = window:GetChild("List_Member")
    self.MemberList:SetVirtual()
    self.ConfirmBtn = window:GetChild("Button_Confirm")
end

return _V