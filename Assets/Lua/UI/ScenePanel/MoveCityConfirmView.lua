local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ScenePanel/ScenePanel", "ScenePanel", "MoveCityMenuMain", false)


    self.CancelBtn = self.UI:GetChild("btn_quxiao")
    self.MoveBtn = self.UI:GetChild("btn_qiancheng")
    self.CostNum = self.UI:GetChild("txt_xiaohao")
end

return _V