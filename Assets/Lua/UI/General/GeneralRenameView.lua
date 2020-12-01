local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/General/General", "General", "RenameMain")

    -- 名字输入框
    self.InputNewName = self.UI:GetChild("Input_Name")
    -- 改名按钮
    self.BtnRename = self.UI:GetChild("Button_Change")
    -- 花费
    self.Price = self.UI:GetChild("Component_Price")
    -- 关闭按钮
    self.BtnClose = self.UI:GetChild("Component_Base"):GetChild("Button_Close")

end

return _V