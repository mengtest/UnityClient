local _V = UIManager.View()

function _V:LoadView()
    _V.EquipItems = { }
    self.UI, self.PKG = UIManager.creatView("UI/Smithy/Smithy", "Smithy", "ForgeMain")
    self.EquipInfo_C = self.UI:GetController("State_C") 
    self.BtnReturn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnEquipment = self.UI:GetChild("Button_Equipment")
    self.BtnMelt = self.UI:GetChild("Button_Smelting")
    self.BtnForgeOneKey = self.UI:GetChild("Button_QuickForge")
    local BtnForgeItem = self.UI:GetChild("Button_Forge")
    self.BtnForge = BtnForgeItem:GetChild("Button_Forge")
    self.ForgeRemain = BtnForgeItem:GetChild("Text_RemainTimes")
    self.ForgeCD = self.BtnForge:GetChild("Text_Time")
    self.BtnForgeItem_C = BtnForgeItem:GetController("State_C")
    self.BtnForgeGray_C = self.BtnForge:GetController("State_C")
    self.ForgeCdVisible_C = self.BtnForge:GetController("Time_C")
    local compEquipment = self.UI:GetChild("Component_EquipmentMenu")
    table.insert(_V.EquipItems, compEquipment:GetChild("Button_EquipmentIcon1"))
    table.insert(_V.EquipItems, compEquipment:GetChild("Button_EquipmentIcon2"))
    table.insert(_V.EquipItems, compEquipment:GetChild("Button_EquipmentIcon3"))
    table.insert(_V.EquipItems, compEquipment:GetChild("Button_EquipmentIcon4"))
    table.insert(_V.EquipItems, compEquipment:GetChild("Button_EquipmentIcon5"))
    table.insert(_V.EquipItems, compEquipment:GetChild("Button_EquipmentIcon6"))
    table.insert(_V.EquipItems, compEquipment:GetChild("Button_EquipmentIcon7"))
    local compEquipInfo = self.UI:GetChild("Component_EquipmentInfo")
    self.EquipName = compEquipInfo:GetChild("Text_EquipmentName")
    self.EquipAttribute = compEquipInfo:GetChild("Text_Attribute")
    self.EquipHave = compEquipInfo:GetChild("Text_Amount")
end

return _V 