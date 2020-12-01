local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "GeneralDetailsMain")

    -- 返回按钮
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    local base = self.UI:GetChild("Component_General")

    -- Tab页控制器
    self.TabController = base:GetController("Tab_C")
    -- 是否显示将魂控制器
    self.SoulController = base:GetController("Type_C")
    -- 转生提示控制器
    self.HintController = base:GetController("State_C")

    -- 主面板
    -- 改名按钮
    self.RenameBtn = base:GetChild("Button_Rename")
    -- 解雇按钮
    self.FireBtn = base:GetChild("Button_Fire")

    -- 将魂面板
    local soulPanel = base:GetChild("Component_GeneralSoul")
    -- 将魂品质
    self.SoulPanel_Quality = soulPanel:GetController("Quality_C")
    -- 将魂名字
    self.SoulPanel_Name = soulPanel:GetChild("Text_SoulName")
    local soulDesc = base:GetChild("Component_SoulDesc")
    -- 士气
    self.MoraleText = soulDesc:GetChild("Text_Number")
    -- 卸下按钮
    self.SoulRemoveBtn = soulDesc:GetChild("Button_Remove")

    -- 普通头像面板
    local normalPanel = base:GetChild("Component_GeneralNormal")
    -- 品质
    self.NormalPanel_GeneralQuality_C = normalPanel:GetController("Quality_C")
    -- 头像
    self.NormalPanel_GeneralIcon = normalPanel:GetChild("Label_GeneralIcon")
    -- 名字
    self.NormalPanel_GeneralName = normalPanel:GetChild("Text_Name")
    -- 成长
    self.NormalPanel_GeneralGrouth = normalPanel:GetChild("Text_Develop")
    -- 将魂附身按钮
    self.NormalPanel_SoulPossessionBtn = normalPanel:GetChild("Button_Soul")
    -- 左箭头
    self.NormalPanel_TurnLeftBtn = base:GetChild("Button_Left")
    -- 右箭头
    self.NormalPanel_TurnRightBtn = base:GetChild("Button_Right")

    -- 细节面板
    -- 转生按钮
    self.DetailsPanel_TransmigrationBtn = base:GetChild("Button_Transmigration")
    -- 将魂描述
    self.DetailsPanel_SoulDesc = base:GetChild("Component_SoulDesc")
    -- 等级
    self.DetailsPanel_Level = base:GetChild("Text_Level")
    -- 经验条
    self.DetailsPanel_EXPBar = base:GetChild("ProgressBar_EXP")
    -- 兵种类型文字
    self.DetailsPanel_Type = base:GetChild("Label_GeneralBase")
    -- 职业图标
    self.DetailsPanel_Job = base:GetChild("Label_GeneralType")
    -- 评分
    self.DetailsPanel_Judgement = base:GetChild("Label_Judgement")
    -- 统帅值
    self.DetailsPanel_DOM = base:GetChild("TextField_DOM")
    -- 攻击力值
    self.DetailsPanel_ATT = base:GetChild("TextField_ATT")
    -- 防御力值
    self.DetailsPanel_DEF = base:GetChild("TextField_DEF")
    -- 体力值
    self.DetailsPanel_CON = base:GetChild("TextField_CON")
    -- 敏捷值
    self.DetailsPanel_DEX = base:GetChild("TextField_DEX")
    -- 装备列表
    self.DetailsPanel_EqumentList = base:GetChild("List_Equipment")

    -- 成长面板
    self.GrowthPanel = base:GetChild("Component_Growth")
    -- 是否满级状态控制器
    self.GrowthPanel_StateController = self.GrowthPanel:GetController("State_C")
    -- 经验条动效
    self.GrowthPanel_ProgressEffect = self.GrowthPanel:GetTransition("ProgressBar_T")
    -- 属性动效
    self.GrowthPanel_StatusEffect = self.GrowthPanel:GetTransition("Status_T")
    -- 当前经验条
    self.GrowthPanel_ProgressBarNow = self.GrowthPanel:GetChild("ProgressBar_ProgressBar2")
    -- 预览经验条
    self.GrowthPanel_ProgressBarAfter = self.GrowthPanel:GetChild("ProgressBar_ProgressBar1")
    -- 强化按钮
    self.GrowthPanel_StrengthenBtn = self.GrowthPanel:GetChild("Button_Strengthen")
    -- 当前成长值
    self.GrowthPanel_GrowNow = self.GrowthPanel:GetChild("Label_GrowNow")
    -- 强化后成长值
    self.GrowthPanel_GrowAfter = self.GrowthPanel:GetChild("Label_GrowAfter")
    -- 当前成长值带来的总属性
    self.GrowthPanel_InstructionNow = self.GrowthPanel:GetChild("TextField_InstructionNow")
    -- 强化后成长值带来的总属性
    self.GrowthPanel_InstructionAfter = self.GrowthPanel:GetChild("TextField_InstructionAfter")
    -- 强化后成长值提示
    self.GrowthPanel_Tips = self.GrowthPanel:GetChild("Label_Tips")
    -- 强化符按钮1
    self.GrowthPanel_StrenghthenBtn1 = self.GrowthPanel:GetChild("Button_Strenghthen1")
    -- 强化符按钮2
    self.GrowthPanel_StrenghthenBtn2 = self.GrowthPanel:GetChild("Button_Strenghthen2")
    -- 强化符按钮3
    self.GrowthPanel_StrenghthenBtn3 = self.GrowthPanel:GetChild("Button_Strenghthen3")
    -- 强化符按钮4
    self.GrowthPanel_StrenghthenBtn4 = self.GrowthPanel:GetChild("Button_Strenghthen4")
    -- 强化符经验值1
    self.GrowthPanel_StrenghthenExp1 = self.GrowthPanel:GetChild("TextField_Experience")
    -- 强化符经验值2
    self.GrowthPanel_StrenghthenExp2 = self.GrowthPanel:GetChild("TextField_Experience2")
    -- 强化符经验值3
    self.GrowthPanel_StrenghthenExp3 = self.GrowthPanel:GetChild("TextField_Experience3")
    -- 强化符经验值4
    self.GrowthPanel_StrenghthenExp4 = self.GrowthPanel:GetChild("TextField_Experience4")
    -- 一键强化按钮
    self.GrowthPanel_FastStrenghthenBtn = self.GrowthPanel:GetChild("Button_Quick")
    -- 强化按钮
    self.GrowthPanel_StrenghthenBtn = self.GrowthPanel:GetChild("Button_Strengthen")

    -- 技能面板
    -- 技能信息：图标和名称
    self.SkillPanel_SkillInfo = base:GetChild("Label_SkillInfo")
    -- 技能作用对象描述
    self.SkillPanel_SkillEffect = base:GetChild("TextField_SkillEffect")
    -- 技能效果描述
    self.SkillPanel_SkillDesc = base:GetChild("TextField_Instruction")

end

return _V