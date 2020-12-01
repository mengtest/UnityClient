local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/MonarchOrMainCityUpgrade/MonarchOrMainCityUpgrade", "MonarchOrMainCityUpgrade", "MonarchOrMainCityUpgradeMain")
    
    -- Controller
    -- 0 主城,1 君主
    self.Type_C = self.UI:GetController("Type_C")

    -- Transition
    self.Effect_T = self.UI:GetTransition("Effect_T")
end

return _V