local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "SoulDetails")
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.GetSoulBtn = self.UI:GetChild("Button_Acquire")
    self.FettersBtn = self.UI:GetChild("Button_Connection")

    -- 图像
    local soulCom = self.UI:GetChild("Component_SoulIcon")
    -- 品质控制器
    self.QualityController = soulCom:GetChild("Quality_C")
    self.SoulICon = soulCom:GetChild("Loader_Icon")
    self.SoulNameText = self.UI:GetChild("TextField_SoulName")
    self.SoulDescText = self.UI:GetChild("TextField_Background")
end

return _V 