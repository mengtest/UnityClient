local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/BuildersSpeedup/BuildersSpeedup", "BuildersSpeedup", "BuildersSpeedupMain")
    
    self.Effect_T = self.UI:GetTransition("Effect_T")
    self.BackBtn = self.UI:GetChild("Component_BG")
    local window = self.UI:GetChild("Component_WindowMain")
    -- 时间
    self.Time = window:GetChild("Text_CD")
    self.CdBar = window:GetChild("ProgressBar_Time")
    self.State_C = self.CdBar:GetController("State_C")

    --  加速道具按钮
    self.PropsList = 
    {
        window:GetChild("Button_SpeedUpProp01"),
        window:GetChild("Button_SpeedUpProp02"),
        window:GetChild("Button_SpeedUpProp03"),
        window:GetChild("Button_SpeedUpProp04"),
    }

    self.YuanBaoBtn = window:GetChild("Button_YuanBao")
end

return _V