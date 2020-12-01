local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Chat/Chat", "Chat", "ChatMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    -- 聊天大类列表
    local chatList = self.UI:GetChild("list_fenzu")
    self.ChatList = chatList.asList
    self.ChatRecentlyList = chatList:GetChildAt(0):GetChild("List_GroupList")
    self.ChatRecentlyList:SetVirtual()

    -- 内容框信息
    local contents = self.UI:GetChild("com_liaotianneirong")
    self.ContentsChatStat = contents:GetController("Type_C")
    self.ContentsInput = contents:GetChild("TextField_Imput")
    self.ContentsSend = contents:GetChild("Button_Send")
    self.ContentsGroupChatList = contents:GetChild("List_GroupChat")
    self.ContentsPrivateChatList = contents:GetChild("List_PrivateChat")       

    -- 内容框item
    self.ChatLeftUI = UIPackage.GetItemURL("Chat", "Component_OthersItem");
    self.ChatRightUI = UIPackage.GetItemURL("Chat", "Component_SelfItem");
    self.ChatTimeUI = UIPackage.GetItemURL("Chat", "Component_Time");

    self.ContentsGroupChatList.defaultItem = self.ChatLeftUI;
    self.ContentsPrivateChatList.defaultItem = self.ChatLeftUI;
    self.ContentsGroupChatList:SetVirtual()
    self.ContentsPrivateChatList:SetVirtual()
end

return _V