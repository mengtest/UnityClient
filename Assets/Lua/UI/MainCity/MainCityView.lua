local MainCityView = UIManager.View()

function MainCityView:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/MainCity/MainCity", "MainCity", "MainCityMain")
    UIPackage.AddPackage("UI/ScenePanel/ScenePanel")
    -- controller
    -- 0:城内 1:世界
    self.State_C = self.UI:GetController("State_C")

    -- top left
    self.PlayerIcon = self.UI:GetChild("Label_LordIcon")
    self.ExpBar = self.UI:GetChild("ProgressBar_Experience")
    self.PlayerName = self.UI:GetChild("Text_Name")
    self.YuanBaoCount = self.UI:GetChild("Label_Money")
    self.DefensivePower = self.UI:GetChild("Label_Power")
    self.AllianceName = self.UI:GetChild("Label_Alliance")
    self.BuilderList = self.UI:GetChild("List_Workers")
    self.NavBtn = self.UI:GetChild("Button_Navigation")
    self.NavArrow = self.NavBtn:GetChild("icon")
    self.InfluenceBtn = self.UI:GetChild("Button_Influence")

    -- top right
    local cityInfoPanel = self.UI:GetChild("Component_CityInfo")
    self.ProsperityBar = cityInfoPanel:GetChild("ProgressBar_Prosperity")
    self.ProsperityHighestBar = cityInfoPanel:GetChild("ProgressBar_ProsperityHighest")
    self.Gold = cityInfoPanel:GetChild("Label_Gold")
    self.Wood = cityInfoPanel:GetChild("Label_Wood")
    self.Food = cityInfoPanel:GetChild("Label_Food")
    self.Stone = cityInfoPanel:GetChild("Label_Stone")
    -- self.VipLevel = cityInfoPanel:GetChild("shu_guizu")
    self.CityBtn = cityInfoPanel:GetChild("Button_City")
    self.CityUpgradeEffect = self.CityBtn:GetChild("MovieClip_Effect")

    -- bottom left
    self.WarList = self.UI:GetChild("List_War")
    self.TaskBtn = self.UI:GetChild("Button_Task")
    self.CurrentTaskBtn = self.UI:GetChild("Button_CurrentTask")
    self.TaskCompletedEffect = self.UI:GetChild("Button_TaskCompletedEffect")

    -- bottom right
    self.LordBtn = self.UI:GetChild("Button_Lord")
    self.GeneralBtn = self.UI:GetChild("Button_General")
    self.EquipBtn = self.UI:GetChild("Button_Equipment")
    self.AllianceBtn = self.UI:GetChild("Button_Alliance")
    self.WarSituationBtn = self.UI:GetChild("Button_WarSituation")
    self.BattleBtn = self.UI:GetChild("Button_Battle")
    self.BagBtn = self.UI:GetChild("Button_Bag")
    self.MailBtn = self.UI:GetChild("Button_Mail")
    self.RankingBtn = self.UI:GetChild("Button_Ranking")
    self.SwitchBtn = self.UI:GetChild("Button_Outside")

    -- GM
    local Menu = self.UI:GetChild("Component_GMMain"):GetChild("Component_GM")
    self.TabList = Menu:GetChild("List_Main")
    self.TabList:SetVirtual()
    self.MenuList = Menu:GetChild("List_Title")
    self.MenuList.defaultItem = "ui://hszc9xee8ptb5x"
    self.MenuList:SetVirtual()
    self.ButtonItem = "ui://hszc9xee8ptb5x"
    self.InputItem = "ui://hszc9xee8ptb5y"

    -- Invade
    self.InvadeItem = self.UI:GetChild("Component_Conquer")
    self.EventCount = self.InvadeItem:GetChild("toggle_shouqi"):GetChild("title")
    self.MilitaryList = self.InvadeItem:GetChild("com_diban"):GetChild("list_zuobiao")

    -- 入侵行营面板打开和关闭
    self.ToggleCtr = self.InvadeItem:GetController("State_C")
    -- 入侵个数的显示和隐藏
    self.VisibleCtr = self.InvadeItem:GetChild("toggle_shouqi"):GetController("Visible_C")
    -- 入侵行营点击按钮的显示和隐藏
    self.ButtonExpandCtl = self.InvadeItem:GetController("Type_C")

    -- DebugTool
    local DebugToolComponent = self.UI:GetChild("Component_DebugToolMain")
    -- 主界面上的DebugButton
    self.DebugToolBtn = DebugToolComponent:GetChild("Button_DebugTool")
    -- 状态控制器
    self.DTStateController = DebugToolComponent:GetController("State_C")
    -- 回退
    self.DTBackBtn = DebugToolComponent:GetChild("Label_BackTitle")
    -- 选项
    self.DTSelectionList = DebugToolComponent:GetChild("List_DebugSelection")
    -- 当前加载的camera参数文件名称
    self.DTCurrentLoadedCPFileLabel = DebugToolComponent:GetChild("Label_CurrentFile")
    -- camera参数
    self.DTCameraParameterList = DebugToolComponent:GetChild("List_CameraParameters")
    -- camera默认的存档按钮（其实是读取了MainCityCamera的默认参数）
    self.DTCameraDefaultSaveFileBtn = DebugToolComponent:GetChild("Button_DefaultSaveFile")
    -- camera存档List
    self.DTCameraSaveFileList = DebugToolComponent:GetChild("List_SaveFile")

    -- ChangeArea
    local changeAreaComponent = self.UI:GetChild("Component_AreaSwitch")
    self.changeAreaButtonWorld = changeAreaComponent:GetChild("Button_World")
    self.changeAreaLeftArrow = changeAreaComponent:GetChild("Button_LeftArrow")
    self.changeAreaRightArrow = changeAreaComponent:GetChild("Button_RightArrow")
    self.changeAreaSwichBtn = changeAreaComponent:GetChild("Button_Switch")
    self.changeAreaCurrent = changeAreaComponent:GetChild("Text_Region")
    self.changeAreaList = changeAreaComponent:GetChild("List_Area")
    self.changeAreaSwitch_C = changeAreaComponent:GetController("Qiehuan_C")
    -- 紧急事件列表
    self.EmergencyList = self.UI:GetChild("list_emergency_tips")
    self.EmergencyList.visible = false
end

return MainCityView