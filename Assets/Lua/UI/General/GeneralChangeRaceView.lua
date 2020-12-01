local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "ChangeJobMain")
    -- 武将列表
    self.GeneralList = self.UI:GetChild("list_wujiang").asList
    self.GeneralList:SetVirtual()
    -- 兵种btn
    self.RaceBtnList = {}
    self.RaceBtnList[RaceType.Infantry] = self.UI:GetChild("btn_zhiyebu")
    self.RaceBtnList[RaceType.Cavalry] = self.UI:GetChild("btn_zhiyeqi")
    self.RaceBtnList[RaceType.Archer] = self.UI:GetChild("btn_zhiyegong")
    self.RaceBtnList[RaceType.Chariots] = self.UI:GetChild("btn_zhiyeche")
    self.RaceBtnList[RaceType.Catapult] = self.UI:GetChild("btn_zhiyeqi2")
    -- 返回
    self.BackBtn = self.UI:GetChild("btn_fanhui")
    -- 转职
    self.ChangeRaceBtn = self.UI:GetChild("btn_zhuanzi")
    -- 条件文本
    self.ConditionDescLab = self.UI:GetChild("txt_wenben") 
    self.ConditionLevelLab = self.UI:GetChild("txt_shuzi")
    self.ConditionTimeLab = self.UI:GetChild("txt_shijian")
    -- 选中武将
    self.SelectedGeneralCom = self.UI:GetChild("com_wujiangtouxiang")
    self.SelectedGeneralQualityControl = self.SelectedGeneralCom:GetController("Quality_C")
    self.GeneralHeadIcon = self.SelectedGeneralCom:GetChild("Loader_Icon")
    self.GeneralRaceIcon = self.SelectedGeneralCom:GetChild("Label_GeneralType"):GetChild("icon")
    self.GeneralLevelLab = self.SelectedGeneralCom:GetChild("Text_Level")

end
return _V 