local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "ReincarnationUpgradeMain")
    -- 底图
    self.Background = self.UI:GetChild("Graph_Base")

    -- 半身像
    local captainCom = self.UI:GetChild("Component_Icon")
    self.Icon = captainCom:GetChild("icon")
    self.Name = captainCom:GetChild("title")
    self.Quality = captainCom:GetChild("list_quality"):GetController("Quality_C")
    self.RaceCom = captainCom:GetChild("com_zhiye")
    self.Level = captainCom:GetChild("txt_chengzhang")
    -- 转生前数据
    self.BfGrowUpLimitNum = self.UI:GetChild("TextField_Number7")
    self.BfPropertyNum = self.UI:GetChild("TextField_Number")
    self.BfCommandNum = self.UI:GetChild("TextField_Number2")
    self.BfGrowUpNum = self.UI:GetChild("TextField_Number3")
    -- 转生后数据
    self.AfGrowUpLimitNum = self.UI:GetChild("TextField_Number8")
    self.AfPropertyNum = self.UI:GetChild("TextField_Number4")
    self.AfCommandNum = self.UI:GetChild("TextField_Number5")
    self.AfGrowUpNum = self.UI:GetChild("TextField_Number6")
    -- 几转
    self.RebirthTimesCom = self.UI:GetChild("Label_State")

end
return _V 