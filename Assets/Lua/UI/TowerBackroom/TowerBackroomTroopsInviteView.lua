local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/TowerBackroom/Backroom", "Backroom", "InvitationMain")

    self.BtnBack = self.UI:GetChild("Button_Background")
    self.BtnFriend = self.UI:GetChild("Button_Friends")
    self.BtnGuild = self.UI:GetChild("Button_Guild")
    self.GroupStat = self.UI:GetController("State_C")

    self.FriendList = self.UI:GetChild("List_Friends")
    self.FriendList:SetVirtual()
end

return _V