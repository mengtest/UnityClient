local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Mail/Mail", "Mail", "BattlelogMailMain")

    -- controller
    -- 0 双方 1 三方
    self.State_C = self.UI:GetController("State_C")

    self.Title = self.UI:GetChild("Text_Title")
    self.Content = self.UI:GetChild("Text_Content")
    self.Date = self.UI:GetChild("Text_Date")
    self.Time = self.UI:GetChild("Text_Time")
    self.CloseBtn = self.UI:GetChild("Button_Close")
    self.DeleteBtn = self.UI:GetChild("Button_Delete")
    self.CollectBtn = self.UI:GetChild("Button_Collect")
    self.ReplayBtn = self.UI:GetChild("Button_Replay")

    -- 我方
    self.Our = {}
    self.Our.Icon = self.UI:GetChild("Loader_Icon1")
    self.Our.Name = self.UI:GetChild("Text_NameLeft")
    self.Our.Coordinate = self.UI:GetChild("Label_Coords1")
    self.Our.SoilderBar = self.UI:GetChild("ProgressBar_Soldier1")
    self.Our.Title = self.UI:GetChild("Text_Reward")
    self.Our.List = self.UI:GetChild("List_Reward")

    -- 敌方
    self.Enemy = {}
    self.Enemy.Icon = self.UI:GetChild("Loader_Icon2")
    self.Enemy.Name = self.UI:GetChild("Text_NameRight")
    self.Enemy.Coordinate = self.UI:GetChild("Label_Coords2")
    self.Enemy.SoilderBar = self.UI:GetChild("ProgressBar_Soldier2")
    self.Enemy.Title = self.UI:GetChild("Text_Lost")
    self.Enemy.List = self.UI:GetChild("List_Lost")
end

return _V