local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Bazaar/Bazaar", "Bazaar", "BazaarMain")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- 0:元宝 1:贡献(联盟)
    self.Tab_C = self.UI:GetController("Tab_C")
    self.MoneyText = self.UI:GetChild("Text_TotalMoney")
    self.HaveNoAllianceBtn = self.UI:GetChild("Button_HaveNoAlliance")

    local ShopPage = self.UI:GetChild("Component_Shop")
    self.Prop_C = ShopPage:GetController("Prop_C")
    -- 0:元宝 1:贡献(联盟)
    self.Type_C = ShopPage:GetController("Type_C")
    self.State_C = ShopPage:GetController("State_C")
    self.Cost_C = ShopPage:GetController("Cost_C")
    self.PropList = ShopPage:GetChild("List_Prop")
    self.PropDesc = ShopPage:GetChild("Text_PropDesc")
    self.SubBtn = ShopPage:GetChild("Button_Sub")
    self.PropAmountInput = ShopPage:GetChild("Text_PropAmount")
    self.AddBtn = ShopPage:GetChild("Button_Add")
    self.CostText = ShopPage:GetChild("Text_Cost")
    self.BuyBtn = ShopPage:GetChild("Button_Buy")
end

return _V