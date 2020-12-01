local _V = UIManager.View()

local function getInfo(generalSlot, slotId)
    local saveTable = { }
    generalSlot.draggable = true
    saveTable.Root = generalSlot
    saveTable.SlotStat = generalSlot:GetController("stat_C")
    saveTable.OutSideTip = generalSlot:GetChild("Label_Tips"):GetController("stat_C")
    saveTable.Level = generalSlot:GetChild("Text_Level")
    saveTable.Name = generalSlot:GetChild("Text_Name")
    saveTable.SoliderBar = generalSlot:GetChild("ProgressBar_soliderNum")
    saveTable.Head = generalSlot:GetChild("Loader_GeneralIcon")
    saveTable.SoliderType = generalSlot:GetChild("Label_SoldierType"):GetChild("icon")

    return saveTable
end

function _V:LoadView()
    -- 不需要适应
    self.UI, self.PKG = UIManager.creatView("UI/PreBattle/PreBattle", "PreBattle", "TroopsSelectMain", false)

    self.BtnTroop_1 = self.UI:GetChild("btn_zhenxing1")
    self.BtnTroop_2 = self.UI:GetChild("btn_zhenxing2")
    self.BtnTroop_3 = self.UI:GetChild("btn_zhenxing3")

    self.FightAmount = self.UI:GetChild("txt_zhanli")
    self.ExpeditionStat = self.UI:GetController("troopStat_C")

    self.Captains = { }
    for i = 1, 5 do
        self.Captains[i] = getInfo(self.UI:GetChild("com_wujiangwei" ..(i - 1)))
    end
end

return _V