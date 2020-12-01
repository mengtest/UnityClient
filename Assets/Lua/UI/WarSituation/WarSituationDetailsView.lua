local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/WarSituation/WarSituation", "WarSituation", "WarSituationDetailsMain")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.List = self.UI:GetChild("list_xiangxiliebiao")
    self.SubListMain = self.List:GetChildAt(0)
    self.SubListAddi = self.List:GetChildAt(1):GetChild("list_junqingliebiao")
    self.SubListAddi.defaultItem = UIConfig.WarSituation.TitleItem
    self.SubListAddi:SetVirtual()

    -- controller
    self.Target_C = self.SubListMain:GetController("mubiao")
    self.Color_C = self.SubListMain:GetController("yanse")
    self.Count_C = self.SubListMain:GetController("renshu")
    self.Action_C = self.SubListMain:GetController("qiangziyuan")
    self.Button_C = self.SubListMain:GetController("annuikongzhi")
end

return _V