local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/WarSituation/WarSituation", "WarSituation", "WarSituationMain")

    -- controller
    self.State_C = self.UI:GetController("Page_C")

    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.LianMengTab = self.UI:GetChild("btn_tablianmeng")
    self.List = self.UI:GetChild("list_junxingliebiao").asList
    self.List.defaultItem = UIConfig.WarSituation.TitleItem
    self.List:SetVirtual()
end

return _V