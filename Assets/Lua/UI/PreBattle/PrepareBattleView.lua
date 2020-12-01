local _V = UIManager.View()

local function getInfo(generalSlot)
    local saveTable = { }
    saveTable.SlotStat = generalSlot:GetController("stat_C")
    saveTable.Level = generalSlot:GetChild("txt_level")
    saveTable.Name = generalSlot:GetChild("txt_name")
    saveTable.SoliderBar = generalSlot:GetChild("progressBar_SoliderNum")
    saveTable.Head = generalSlot:GetChild("loader_head")
    saveTable.SoliderType = generalSlot:GetChild("lab_zhiYe"):GetChild("icon")

    return saveTable
end

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/PreBattle/PreBattle", "PreBattle", "PreBattleMain")

    -- 按钮
    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnEmbattle = self.UI:GetChild("btn_embattle")
    self.BtnAddSolider = self.UI:GetChild("btn_addSolider")
    self.BtnExpedition = self.UI:GetChild("btn_battle")
    self.BtnIsGuild = self.UI:GetChild("btn_guild")

    -- 基础
    -- 显示状态（0缺省，1pvp只显示君主，2pve只显示军队，3pvp显示君主和和切换按钮，4pvp显示军队和切换按钮，5pve只显示军队，6pve只显示君主，7pve显示君主和和切换按钮，8pve显示军队和切换按钮，9pve重楼密室）
    self.ShowStat = self.UI:GetController("Type_C")
    self.AttackTroopSlot = self.UI:GetChild("com_wofangcaowei")

    -- award
    local award = self.UI:GetChild("com_award")
    self.AwardListStat = award:GetController("State_C")
    self.AwardList = award:GetChild("list_award").asList
    self.AwardList:SetVirtual()

    -- 目标信息
    local choseTarget = self.UI:GetChild("com_targetInfo")
    self.TargetName = choseTarget:GetChild("txt_mengyoumingzi")
    self.TargetPos = choseTarget:GetChild("txt_pos")
    self.TargetTime = choseTarget:GetChild("txt_time")
    self.BtnChoseTarget = choseTarget:GetChild("btn_chose")

    -- 敌方信息
    self.DefenderFinghtAmount = self.UI:GetChild("txt_defenderFight")
    self.DefenderName_1 = self.UI:GetChild("txt_defenderName_1")
    self.BtnDefenderPanel = self.UI:GetChild("btn_defenderPanel")

    self.DefenderHead = self.UI:GetChild("loader_defenderHead")
    self.DefenderName = self.UI:GetChild("txt_defenderName")
    self.DefenderGuild = self.UI:GetChild("txt_defenderGuild")
    self.DefenderLevel = self.UI:GetChild("txt_defenderLevel")
    self.DefenderTowerFloor = self.UI:GetChild("txt_defenderTower")
    self.DefenderMainCityLevel = self.UI:GetChild("txt_defenderMainCityLv")
    self.DefenderRank = self.UI:GetChild("txt_defenderRank")

    -- 敌方军队
    local troopList = self.UI:GetChild("list_defenderTroop")
    self.DefenderSlot_1 = getInfo(troopList:GetChildAt(0))
    self.DefenderSlot_2 = getInfo(troopList:GetChildAt(1))
    self.DefenderSlot_3 = getInfo(troopList:GetChildAt(2))
    self.DefenderSlot_4 = getInfo(troopList:GetChildAt(3))
    self.DefenderSlot_5 = getInfo(troopList:GetChildAt(4))

    -- 重楼密室
    self.BackroomId = self.UI:GetChild("txt_backroomId")
    self.BackroomPlayerNum = self.UI:GetChild("txt_backroomPlayerNum")
    self.BackroomTroopsNum = self.UI:GetChild("txt_backroomTroopsNum")
    self.BackroomContinueWinNum = self.UI:GetChild("txt_backroomContinueWinNum")
end

return _V