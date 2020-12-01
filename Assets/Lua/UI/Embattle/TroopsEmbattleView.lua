local _V = UIManager.View()

local function getInfo(generalSlot, slotId)
    local saveTable = { }
    generalSlot.draggable = true
    saveTable.Root = generalSlot
    saveTable.Head = generalSlot:GetChild("loader_head")
    saveTable.Name = generalSlot:GetChild("txt_name")
    saveTable.Level = generalSlot:GetChild("txt_level")
    saveTable.SoliderBar = generalSlot:GetChild("progressBar_soliderNum")
    saveTable.SlotStat = generalSlot:GetController("stat_C")
    saveTable.OutSideTip = generalSlot:GetChild("com_tips"):GetController("stat_C")
    saveTable.SoliderType = generalSlot:GetChild("lab_zhiye"):GetChild("icon")

    return saveTable
end

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/PreBattle/PreBattle", "PreBattle", "TroopsEmbattleMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnAddSolider = self.UI:GetChild("btn_addSoliders")
    self.BtnAddSoliderTroop1 = self.UI:GetChild("btn_addSoliders")
    self.BtnAddSoliderTroop2 = self.UI:GetChild("btn_addSoliders")
    self.BtnAddSoliderTroop3 = self.UI:GetChild("btn_addSoliders")

    -- 共15个槽位，此处约定
    self.Captains = { }
    for i = 1, 15 do
        self.Captains[i] = getInfo(self.UI:GetChild("com_captainSlot" .. i))
    end
    -- 部队信息
    self.Troops = { }
    for i = 1, 3 do
        self.Troops[i] = {}
        self.Troops[i].Fight = self.UI:GetChild("txt_fight_troop"..i)
        self.Troops[i].BtnAddSolider = self.UI:GetChild("btn_addSolider_troop"..i)
        self.Troops[i].ExpeditionStat = self.UI:GetController("troop"..i.."Stat_C")
    end
end

return _V