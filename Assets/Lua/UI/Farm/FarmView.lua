local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Farm/Farm", "Farm", "FarmMain")

    -- controller
    -- 0 有冲突 有闲置
    -- 1 有冲突 无闲置
    -- 2 无冲突 有闲置
    -- 3 无冲突 无闲置
    self.State_C = self.UI:GetController("State_C")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.MainCityLev = self.UI:GetChild("Text_CityLevel")
    self.GroundCount = self.UI:GetChild("Text_GroundCount")
    self.ConflictCount = self.UI:GetChild("Text_ConflictCount")
    self.UnusedCount = self.UI:GetChild("Text_UnusedCount")
    self.CheckBtn = self.UI:GetChild("Button_Check")

    local ButtonTypes = 
    {
        Gold = "GoldMine",
        Wood = "Sawmill",
        Food = "Cropland",
        Stone = "StonePit",
    }

    for k,v in pairs(ButtonTypes) do
        self[k] = {}
        self[k].btn = self.UI:GetChild("Button_"..v)
        self[k].conflict_c = self[k].btn:GetController("State_C")
        self[k].full_c = self[k].btn:GetController("Full_C")
        self[k].coverArea = self[k].btn:GetChild("Text_CoverArea")
        self[k].output = self[k].btn:GetChild("Text_Output")
        self[k].harvest = self[k].btn:GetChild("Text_Harvest")
        self[k].tips = self[k].btn:GetChild("Label_Tips")
        self[k].tips.visible = false
        self[k].coverAreaConflict = self[k].btn:GetChild("Label_CoverAreaTips")
        self[k].outputConflict = self[k].btn:GetChild("Label_OutputTips")
        self[k].harvestConflict = self[k].btn:GetChild("Label_HarvestTips")
    end
    
    self.ButtonList = 
    {
       [BuildingType.GoldMine] = self.Gold,
       [BuildingType.Cropland] = self.Food,
       [BuildingType.Sawmill] = self.Wood,
       [BuildingType.StonePit] = self.Stone,
    }
end

return _V