local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Tools/Tools", "Tools", "ToolsMain")

    -- �رհ�ť
    self.BtnClose = self.UI:GetChild("Button_Close")
    -- ѡ��ؿ��б�
    self.ListLevels = self.UI:GetChild("List_Levels")
end

return _V