local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "SoulOfHeroMain")
    -- 按钮
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    -- 列表
    self.CaptainSoulList = self.UI:GetChild("List_Soul")
    self.CaptainSoulList:SetVirtual()
end

return _V 