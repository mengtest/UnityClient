local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Tools/Tools", "Tools", "ToolsMain")

    -- 关闭按钮
    self.BtnClose = self.UI:GetChild("Button_Close")
    -- 选择关卡列表
    self.ListLevels = self.UI:GetChild("List_Levels")
end

return _V