local _V = UIManager.View()

-- 获取君主UI信息
local function getPlayerUI(item)
    local info = { }
    local head = item:GetChild("Component_GeneralIcon")
    head:GetController("ctrl_dengji").selectedIndex = 0
    item:GetController("Type_C").selectedIndex = 1
    info.Head = head:GetChild("loader_wujiang")
    info.QualityStat = head:GetController("ctrl_pinzhi")
    info.Name = item:GetChild("TextField_LordIcon")
    info.FightAmount = item:GetChild("TextField_Fight")
    info.ResultStat = item:GetController("State_C")
    info.Root = item
    return info
end

function _V:LoadView()
    -- 添加战斗Ui
    UIPackage.AddPackage("UI/Battle/Battle")

    self.UI, self.PKG = UIManager.creatView("UI/TowerBackroom/Backroom", "Backroom", "BattlefieldMain")

    self.HeaderStat = self.UI:GetController("State_C")
    -- 攻击方信息
    self.Attacker = { }
    self.Attacker[1] = getPlayerUI(self.UI:GetChild("Component_Attack1"))
    self.Attacker[2] = getPlayerUI(self.UI:GetChild("Component_Attack2"))
    self.Attacker[3] = getPlayerUI(self.UI:GetChild("Component_Attack3"))
    self.AttackerInfo = self.UI:GetChild("Label_AttackInfo")
    self.BtnAllAttacker = self.UI:GetChild("Button_AttackAll")

    -- 防守方信息
    self.Defender = { }
    self.Defender[1] = getPlayerUI(self.UI:GetChild("Component_Defender1"))
    self.Defender[2] = getPlayerUI(self.UI:GetChild("Component_Defender2"))
    self.Defender[3] = getPlayerUI(self.UI:GetChild("Component_Defender3"))
    self.DefenderInfo = self.UI:GetChild("Label_DefendInfo")
    self.BtnAllDefender = self.UI:GetChild("Button_DefenderAll")

    -- 进度
    self.ProBarPlayer = self.UI:GetChild("ProgressBar_Player")

    -- 跳过
    self.BtnSkip = self.UI:GetChild("Button_Skip")
    self.BtnBattleLog = self.UI:GetChild("Button_BattleLog")
end

return _V