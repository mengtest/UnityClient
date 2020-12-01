local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Smithy/Smithy", "Smithy", "SmithyMain")
    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    -- 列表
    self.EquipList = self.UI:GetChild("List_Smelting").asList
    self.EquipList:SetVirtual()

    -- 底部使用面板
    local itemUse = self.UI:GetChild("Component_Smelting")
    self.EquipDesc = itemUse:GetChild("Text_Description")
    self.BtnSmelt = itemUse:GetChild("Button_Smelting")
    self.BtnRebuild = itemUse:GetChild("Button_Reforging")
    self.BtnWhite = itemUse:GetChild("Button_White")
    self.BtnGreen = itemUse:GetChild("Button_Green")
    self.BtnBlue = itemUse:GetChild("Button_Blue")
    self.BtnPurple = itemUse:GetChild("Button_Purple")
    self.BtnOrange = itemUse:GetChild("Button_Orange")
    self.BtnRed = itemUse:GetChild("Button_Red")
end

return _V