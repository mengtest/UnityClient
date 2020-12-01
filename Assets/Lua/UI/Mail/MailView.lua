local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Mail/Mail", "Mail", "MailMain")

    -- controller
    -- 0:全部 1:战报 2:系统 3:收藏
    self.Tab_C = self.UI:GetController("Tab_C")
    -- 0:无邮件 1:有邮件
    self.State_C = self.UI:GetController("State_C")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    local panel = self.UI:GetChild("Component_MailList")
    self.UnreadToggle = panel:GetChild("Button_UnreadToggle")
    self.AccessoryToggle = panel:GetChild("Button_HasPrizeToggle")
    self.MainList = panel:GetChild("List_Main")
    self.MainList:SetVirtual()
end

return _V