local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Armor/Armor", "Armor", "GemBag")
    -- 按钮
    self.BackBtn = self.UI:GetChild("Button_GemDecoration"):GetChild("Button_Back")
    self.GemComposeBackBtn = self.UI:GetChild("Button_GemAssemble"):GetChild("Button_Back")
    --------------------宝石镶嵌界面-------------------------------
    self.DecoRateBtn = self.UI:GetChild("Button_Decorate")
    -- 背包列表
    self.GemBagList = self.UI:GetChild("List_GemBag")
    -- 详情
    self.GemBigObj = self.UI:GetChild("Button_GemIcon")
    self.GemNameLab = self.UI:GetChild("Text_GemName")
    self.GemLevelLab = self.UI:GetChild("Text_Level")
    self.GemPorpertyLab = self.UI:GetChild("Component_Attribute1"):GetChild("Text_Attribute")
    self.GemPorpertyNum = self.UI:GetChild("Component_Attribute1"):GetChild("Text_Number2")

    -------------------宝石合成界面--------------------------------
    self.ComposeList = self.UI:GetChild("List_GemComposeBag")
    local com = self.UI:GetChild("Component_GemComponent")
    self.ComposeCostList = com:GetChild("List_GemChart")
    self.ComposeBtn = com:GetChild("Button_Assemble")
    self.GetGemBtn = com:GetChild("Button_Get")
    self.ReplaceGemBtn = com:GetChild("Button_Replace")
    self.GemHelpBtn = com:GetChild("Button_Help")
    self.ComposeGemIcom = com:GetChild("Loader_Gem")
    self.ComposeGemName = com:GetChild("Text_GemName2")
    self.ComposeCurLevel = com:GetChild("Text_Level1")
    self.ComposeCurPorpertyLab = com:GetChild("Component_Attribute1"):GetChild("Text_Attribute")
    self.ComposeCurPorpertyNum = com:GetChild("Component_Attribute1"):GetChild("Text_Number2")
    self.ComposeNexLevel = com:GetChild("Text_NextLevel2")
    self.ComposeNexPorpertyLab = com:GetChild("Component_Attribute2"):GetChild("Text_Attribute")
    self.ComposeNexPorpertyNum = com:GetChild("Component_Attribute2"):GetChild("Text_Number2")
    self.ComPoseProgressBar = self.UI:GetChild("ProgressBar_Experience2")
end

return _V 