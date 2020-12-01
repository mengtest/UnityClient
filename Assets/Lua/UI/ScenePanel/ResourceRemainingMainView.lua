local View = UIManager.View()

function View:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ScenePanel/ScenePanel", "ScenePanel", "RemainingResourcesMain")
    self.Resources = 
    {
        self.UI:GetChild("com_cailiao1"),
        self.UI:GetChild("com_cailiao2"),
        self.UI:GetChild("com_cailiao3"),
        self.UI:GetChild("com_cailiao4"),
    }

    self.MilitaryCount = self.UI:GetChild("text_budui")
    self.MilitaryList = self.UI:GetChild("List_budui")
end