local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "ModifyMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    self.TargetComboBox = window:GetChild("Label_Target"):GetChild("ComboBox")
    self.AllyLabel = window:GetChild("Label_Ally")
    self.AllyInput = self.AllyLabel:GetChild("Input_Content")
    self.EnemyLabel = window:GetChild("Label_Enemy")
    self.EnemyInput = self.EnemyLabel:GetChild("Input_Content")
    self.ManifestoLabel = window:GetChild("Label_Manifesto")
    self.ManifestoInput = self.ManifestoLabel:GetChild("Input_Content")
    self.NoticeLabel = window:GetChild("Label_Notice")
    self.NoticeInput = self.NoticeLabel:GetChild("Input_Content")
    self.ChangeBtn = window:GetChild("Button_Change")
    self.SaveBtn = window:GetChild("Button_Save")
    -- 0 更换 1 保存 2 无权限
    self.Label_C = window:GetController("Label_C")
    self.LabelList = window:GetChild("List_Label")
    self.ConditionPanel = window:GetChild("Component_Condition")
    self.MonarchLevelInput = self.ConditionPanel:GetChild("Label_MonarchLevel"):GetChild("Input_Num")
    self.RankingInput = self.ConditionPanel:GetChild("Label_Ranking"):GetChild("Input_Num")
    self.FloorInput = self.ConditionPanel:GetChild("Label_Floor"):GetChild("Input_Num")
    self.MilitaryRankComboBox = self.ConditionPanel:GetChild("Label_MilitaryRank"):GetChild("ComboBox")
    self.AutoJoinBtn = self.ConditionPanel:GetChild("Button_CheckBox")
    self.ConfirmBtn = window:GetChild("Button_Confirm")
    self.CancelBtn = window:GetChild("Button_Cancel")
end

return _V