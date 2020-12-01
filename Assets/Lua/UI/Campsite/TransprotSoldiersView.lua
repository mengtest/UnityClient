local View = UIManager.View()

function View:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/FieldHeadquarters/FieldHeadquarters", "FieldHeadquarters", "DispatchMain")
    self.TranportButton = self.UI:GetChild("Button_YunSong")
    self.TranportTimer = self.UI:GetChild("TextField_ShiJian")
    self.CancelButton = self.UI:GetChild("Button_Cancel")
    self.SpeedUpButton = self.UI:GetChild("Button_SpeedUp")

    self.SoldiersIcon = self.UI:GetChild("Image_shibingtouxiang")
    self.DecreaseButton = self.UI:GetChild("Button_jian")
    self.IncreaseButton = self.UI:GetChild("Button_jia")
    self.ProgressBar = self.UI:GetChild("ProgressBar_jindutiao3")

    self.ComeFromLeftText = self.UI:GetChild("TextFild_shibin")
    self.ComeFromRightText = self.UI:GetChild("TextField_junyingshibing")
    self.SoldiersNumberLeft = self.UI:GetChild("ProgressBar_jindutiao_left")
    self.SoldiersNumberRight = self.UI:GetChild("ProgressBar_jindutiao_right")

    self.SwitchButton = self.UI:GetChild("btn_qiehuan")

    self.BottomBtnCtr = self.UI:GetController("BottomBtn_C")
    self.TopItemCtr = self.UI:GetController("TopItem_C")

    self.Bg = self.UI:GetChild("Graph_Beijing")
end

return View