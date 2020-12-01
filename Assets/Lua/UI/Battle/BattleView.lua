local BattleView = UIManager.View()

function BattleView:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Battle/Battle", "Battle", "BattleMain")

    -- 攻击方信息
    self.AttackerCountry = self.UI:GetChild("Loader_AttackerCountry");
    self.AttackerHead = self.UI:GetChild("Label_AttackerHead");
    self.AttackerName = self.UI:GetChild("Label_AttackerName");
    self.AttackerFightAmount = self.UI:GetChild("Label_AttackerFight");
    self.AttackerBuffList = self.UI:GetChild("List_AttackerBuff");
    self.AttackerHead:GetController("Level_C").selectedIndex = 1

	-- 攻击方兵力滑条
    self.AttackerGenerals = self.UI:GetChild("List_AttackerCaptain");
    self.AttackerSoliderBar = self.UI:GetChild("ProgressBar_Attacker");
	
    -- 防守方信息
    self.DefenderCountry = self.UI:GetChild("Loader_DefenderCountry");
    self.DefenderHead = self.UI:GetChild("Label_DefenderHead");
    self.DefenderName = self.UI:GetChild("Label_DefenderName");
    self.DefenderFightAmount = self.UI:GetChild("Label_DefenderFight");
    self.DefenderBuffList = self.UI:GetChild("List_DefenderBuff");
    self.DefenderHead:GetController("Level_C").selectedIndex = 1
  
    -- 防御方兵力滑条
    self.DefenderGenerals = self.UI:GetChild("List_DefenderCaptain");
    self.DefenderSoliderBar = self.UI:GetChild("ProgressBar_Defender");

    -- 按钮
    self.SpeedUpBtn = self.UI:GetChild("Button_SpeedUp");
    self.SkipBtn = self.UI:GetChild("Button_Skip");

    -- 战斗进展信息
    self.BtnBattleProgress = self.UI:GetChild("Button_battleProgress");
end

return BattleView