local UIView = UIManager.View()

function UIView:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Lords/Lords", "Lords", "WhiteFlag")
    self.Bg = self.UI:GetChild("graph_bg")
    self.AllianceName = self.UI:GetChild("text_lianmeng")
    self.LordName = self.UI:GetChild("txt_mingcheng")
    self.AppearTime = self.UI:GetChild("txt_kaishishijian")
    self.DisappearTime = self.UI:GetChild("txt_xiaoshishijian")
    self.LookBtn = self.UI:GetChild("btn_chakan")
end

return UIView