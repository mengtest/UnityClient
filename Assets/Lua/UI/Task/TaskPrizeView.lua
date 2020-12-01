local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Task/Task", "Task", "TaskRewardsMain")

    self.PrizeList = self.UI:GetChild("list_jiangli")
    self.Effect = self.UI:GetTransition("Effect_T")
end

return _V