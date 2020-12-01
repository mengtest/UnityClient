local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Tools/Tools", "Tools", "MapEditorMain")

    -- controller
    self.State_C = self.UI:GetController("State_C")

    -- ���ܰ�ť��ѡ��ؿ�
    self.BtnSelectLevel = self.UI:GetChild("Button_SelectLevel")
    self.BtnSave = self.UI:GetChild("Button_Save")

    -- �رհ�ť
    self.BtnClose = self.UI:GetChild("Button_Close")
    -- �ؿ��б�
    self.ListLevels = self.UI:GetChild("List_SelectLevel")

    -- �ر�˵�����
    self.PageGroundMenu = self.UI:GetChild("Page_GroundMenu")
    self.BtnPGMLeft = self.PageGroundMenu:GetChild("Button_Left")
    self.BtnPGMTop = self.PageGroundMenu:GetChild("Button_Top")
    self.BtnPGMRight = self.PageGroundMenu:GetChild("Button_Right")
    self.BtnPGMBottom = self.PageGroundMenu:GetChild("Button_Bottom")
end

return _V