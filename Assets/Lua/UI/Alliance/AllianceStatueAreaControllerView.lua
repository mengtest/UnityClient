local UIView = UIManager.View()

function UIView:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "Component_Area")
    self.StatueAreaBg = self.UI:GetChild("Component_GraphBG")
    self.StatueAreaList = self.UI:GetChild("List_Area")

end

return UIView