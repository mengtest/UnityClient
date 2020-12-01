local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "IllustratedHandbookMain")
    -- 按钮
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.FettersBtn = self.UI:GetChild("Button_Connection")

    -- 列表
    self.SoulList = self.UI:GetChild("List_HandBook")
    self.SoulList:SetVirtual()
end

return _V 