local View = UIManager.View()

function View:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ScenePanel/ScenePanel", "ScenePanel", "PlunderMain")
    self.Bg = self.UI:GetChild("gra_heisebg")
    self.List = self.UI:GetChild("list_lueduoliebiao")
end

return View