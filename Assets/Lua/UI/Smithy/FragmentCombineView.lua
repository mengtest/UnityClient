local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Smithy/Smithy", "Smithy", "SuitCompoundMain")
    self.BtnReturn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnEquip = self.UI:GetChild("Button_Function")
    self.ListTab = self.UI:GetChild("List_TabButtons")
    self.ListTab:SetVirtual()
    self.ListFragment = self.UI:GetChild("List_Suits")
    self.ListFragment:SetVirtual()
    self.FragmentCount = self.UI:GetChild("Text_PieceAmount")
end

return _V