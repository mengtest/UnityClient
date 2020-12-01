local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "ReincarnationMain")
    -- 列表
    self.GeneralList = self.UI:GetChild("list_wujiang").asList
    self.GeneralList:SetVirtual()
    -- 转生前
    self.BeforeRebirth = self.UI:GetChild("com_kapai")
    self.BeforeLevel = self.BeforeRebirth:GetChild("txt_gji")
    self.BeforeHead = self.BeforeRebirth:GetChild("loader_wujiang")
    self.BeforeQuality = self.BeforeRebirth:GetController("pinzhi")
    self.BfGrowLab = self.UI:GetChild("txt_chengzhang1")
    self.BfGrowNum = self.UI:GetChild("txt_shuzi5")
    self.BfGrowMaxLab = self.UI:GetChild("txt_chengzhangsahngxian")
    self.BfGrowMaxNum = self.UI:GetChild("txt_shuzi6")
    -- 转生后
    self.AfterRebirth = self.UI:GetChild("com_kapai2")
    self.AfterLevel = self.AfterRebirth:GetChild("txt_gji")
    self.AfterHead = self.AfterRebirth:GetChild("loader_wujiang")
    self.AfterQuality = self.AfterRebirth:GetController("pinzhi")
    self.RebirthTimes = self.UI:GetChild("lab_shubiaoqian")
    self.AfGrowLab = self.UI:GetChild("txt_chengzhang2")
    self.AfGrowNum = self.UI:GetChild("txt_shuzi7")
    self.AfGrowMaxLab = self.UI:GetChild("txt_chengzhangsahngxian2")
    self.AfGrowMaxNum = self.UI:GetChild("txt_shuzi8")
    self.AddPropertyLab = self.UI:GetChild("txt_shuxing")
    self.AddPropertyNum = self.UI:GetChild("txt_shuzi")
    self.AddCommandLab = self.UI:GetChild("txt_shuxing2")
    self.AddCommandNum = self.UI:GetChild("txt_shuzi2")
    self.AddGrowUpLab = self.UI:GetChild("txt_chengzhang")
    self.AddGrowUpNum = self.UI:GetChild("txt_shuzi4")
    -- 转生条件
    self.LevelLimitLab = self.UI:GetChild("txt_wujiang")   
    self.LevelLabel = self.UI:GetChild("txt_dengji")
    self.LevelNum = self.UI:GetChild("txt_baifengbi")
    self.LevelProgressBar = self.UI:GetChild("progressBar_dengji")
    -- 道具
    self.ItemBtnList = { }
    self.ExpList = { }
    local itemListCom = self.UI:GetChild("btn_icon")
    self.ItemBtnList[1] = itemListCom:GetChild("btn_icon")
    self.ExpList[1] = itemListCom:GetChild("txt_shuzi1")
    self.ItemBtnList[2] = itemListCom:GetChild("btn_icon2")
    self.ExpList[2] = itemListCom:GetChild("txt_shuzi2")
    self.ItemBtnList[3] = itemListCom:GetChild("btn_icon3")
    self.ExpList[3] = itemListCom:GetChild("txt_shuzi3")
    self.ItemBtnList[4] = itemListCom:GetChild("btn_icon4")
    self.ExpList[4] = itemListCom:GetChild("txt_shuzi4")
    self.ItemBtnList[5] = itemListCom:GetChild("btn_icon5")
    self.ExpList[5] = itemListCom:GetChild("txt_shuzi5")
    -- 按钮
    self.BackBtn = self.UI:GetChild("btn_fanhui")
    self.RebirthBtn = self.UI:GetChild("btn_zhuansheng")
end

return _V 