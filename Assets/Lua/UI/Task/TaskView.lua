local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Task/Task", "Task", "TaskMain")

    -- top left
    self.BackBtn =  self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    self.MainTask = self.UI:GetChild("Component_MainTask")

    self.BranchTaskList = self.UI:GetChild("List_BranchTask")
    self.BranchTaskList:SetVirtual()
end

return _V