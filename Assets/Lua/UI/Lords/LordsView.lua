local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Lords/Lords", "Lords", "LordsMain")

    -- controller
    -- 0 is main player
    -- 1 is others
    self.IsMainPlayer_C = self.UI:GetController("IsMainPlayer_C")
    self.Flag_C = self.UI:GetController("Flag_C")
    self.State_C = self.UI:GetController("State_C")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- center
    self.Picture = self.UI:GetChild("Loader_LargeIcon")
    self.Icon = self.UI:GetChild("Loader_SmallIcon")
    self.Name = self.UI:GetChild("Text_Name")
    
    self.Tips = self.UI:GetChild("Label_Tips")
    self.Tips_T = self.Tips:GetTransition("Effect_T")

    self.FormerNameBtn = self.UI:GetChild("Button_FormerName")
    -- 0:联盟 1:没有联盟
    self.Alliance_C = self.UI:GetController("Alliance_C")
    self.AllianceBtn = self.UI:GetChild("Button_Alliance")
    self.Alliance = self.UI:GetChild("Text_Alliance")
    self.Power = self.UI:GetChild("Text_FightAmount")
    self.Coords = self.UI:GetChild("Label_Coords")
    self.LordLevel = self.UI:GetChild("Text_LordLevel")
    self.LordExpBar = self.UI:GetChild("ProgressBar_LordExp")
    self.CityLevel = self.UI:GetChild("Text_CityLevel")
    self.CityExpBar = self.UI:GetChild("ProgressBar_CityExp")
    self.RenameBtn = self.UI:GetChild("Button_Rename")
    self.SettingsBtn = self.UI:GetChild("Button_Settings")
    self.ChatBtn = self.UI:GetChild("Button_Chat")
    self.MuteBtn = self.UI:GetChild("Button_Mute")
    self.FriendBtn = self.UI:GetChild("Button_Friend")
    self.IllustrationBtn = self.UI:GetChild("btn_handbook")

    self.WhiteFlag = self.UI:GetChild("Button_WhiteFlag")

    -- WhiteFlag
    local WhiteFlagUI = self.UI:GetChild("WhiteFlag")
    self.FlagAllianceName = WhiteFlagUI:GetChild("Text_GuildName")
    self.FlagPlayerName = WhiteFlagUI:GetChild("Text_FlagName")
    self.FlagDataTime = WhiteFlagUI:GetChild("Text_StartTime")
    self.FlagExpire = WhiteFlagUI:GetChild("Text_EndTime")
    self.ViewHisAlliance = WhiteFlagUI:GetChild("Button_View")
    self.WhiteFlagUIBg = WhiteFlagUI:GetChild("Graph_Background")
    self.WhiteFlag_C = self.UI:GetController("WhiteFlag_C")
end

return _V