local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Login/Login", "Login", "LoginMain")

    -- 帐号
    self.AcountId = self.UI:GetChild("Text_Account")
    self.Password = self.UI:GetChild("Text_Password")
    -- 版本
    self.Version = self.UI:GetChild("Text_Version")
    -- 按钮
    self.BtnStart = self.UI:GetChild("Button_Start")
    self.BtnLogin = self.UI:GetChild("Button_Login")
    self.BtnRegister = self.UI:GetChild("Button_Create")
    self.BtnNotice = self.UI:GetChild("Button_Notice")
    -- 记住账户
    self.BtnRemember = self.UI:GetChild("Button_Keep")
    self.RememberStat = self.BtnRemember:GetController("button")
    -- 切服
    self.BtnSwitchServer = self.UI:GetChild("Button_ChangeServer")
    self.BtnSwitchAccount = self.UI:GetChild("Button_Switch")
    -- 服务器
    self.ServerName = self.BtnSwitchServer:GetChild("TextFiled_ServerName")
    self.ServerStat = self.BtnSwitchServer:GetController("State_C")
    -- 登录状态
    self.LoginStat = self.UI:GetController("State_C")
    self.EffectBg = self.UI:GetChild("Graph_Effect").asGraph

    -- 工具按钮
    self.BtnTools = self.UI:GetChild("Button_Tools")

    -- 调试模式下才打开
    if MiscConfig.DebugMode then
        self.BtnTools.visible = true
    else
        self.BtnTools.visible = false
    end
end

return _V