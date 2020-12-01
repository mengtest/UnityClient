local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Mail/Mail", "Mail", "SystemMailMain")

    -- controller
    self.State_C = self.UI:GetController("State_C")

    self.Title = self.UI:GetChild("Text_Title")
    self.Date = self.UI:GetChild("Text_Date")
    self.Time = self.UI:GetChild("Text_Time")
    self.CloseBtn = self.UI:GetChild("Button_Close")
    self.AwardList = self.UI:GetChild("List_Awards")
    self.GetBtn = self.UI:GetChild("Button_Get")
    self.Content = self.UI:GetChild("Text_Content")
    self.DeleteBtn = self.UI:GetChild("Button_Delete")
    self.CollectBtn = self.UI:GetChild("Button_Collect")
end

return _V