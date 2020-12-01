local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Tools/Tools", "Tools", "MapEditorMain")

    -- controller
    self.State_C = self.UI:GetController("State_C")

    -- 功能按钮，选择关卡
    self.BtnSelectLevel = self.UI:GetChild("Button_SelectLevel")
    self.BtnSave = self.UI:GetChild("Button_Save")

    -- 关闭按钮
    self.BtnClose = self.UI:GetChild("Button_Close")
    -- 关卡列表
    self.ListLevels = self.UI:GetChild("List_SelectLevel")

    -- 地表菜单界面
    self.PageGroundMenu = self.UI:GetChild("Page_GroundMenu")
    self.BtnPGMLeft = self.PageGroundMenu:GetChild("Button_Left")
    self.BtnPGMTop = self.PageGroundMenu:GetChild("Button_Top")
    self.BtnPGMRight = self.PageGroundMenu:GetChild("Button_Right")
    self.BtnPGMBottom = self.PageGroundMenu:GetChild("Button_Bottom")
end

return _V