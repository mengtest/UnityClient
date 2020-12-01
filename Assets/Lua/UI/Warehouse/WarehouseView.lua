local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Warehouse/Warehouse", "Warehouse", "WarehouseMain")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- left
    self.WarehouseLev = self.UI:GetChild("Text_Level")
    self.ProtectedAmount = self.UI:GetChild("Text_Protected")

    -- 进度条实例化
    local function InitBar(table, bar)
        table.value = bar:GetChild("Text_Value")
        table.max = bar:GetChild("Text_Max")
        table.proBar = bar:GetChild("ProgressBar_Protect")
        table.curBar = bar:GetChild("ProgressBar_Current")
        table.exBar = bar:GetChild("ProgressBar_Ex")
    end

    self.FoodBar = { }
    self.CoinBar = { }
    self.WoodBar = { }
    self.StoneBar = { }

    InitBar(self.FoodBar, self.UI:GetChild("Component_Food"))
    InitBar(self.CoinBar, self.UI:GetChild("Component_Coin"))
    InitBar(self.WoodBar, self.UI:GetChild("Component_Wood"))
    InitBar(self.StoneBar, self.UI:GetChild("Component_Stone"))

    -- bottom
    self.Tips = self.UI:GetChild("Component_Tips")
end

return _V