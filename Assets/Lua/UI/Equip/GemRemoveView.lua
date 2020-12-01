local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Armor/Armor", "Armor", "GemSynthesis")
    self.BackBtn = self.UI:GetChild("Component_BG")
    local windowMain = self.UI:GetChild("Component_Main")
    self.Level_C = windowMain:GetController("Level_C")
    self.RemoveBtn = windowMain:GetChild("Button_Remove")
    self.ComposeBtn = windowMain:GetChild("Button_Assemble")
    self.ComGem = windowMain:GetChild("Component_GemIcon")
    self.GemNameLab = windowMain:GetChild("Text_GemName")
    self.curLevelLab = windowMain:GetChild("Text_CurrentLevel")
    self.curGemPorpertyLab = windowMain:GetChild("Component_Atrribute1"):GetChild("Text_Attribute")
    self.curGemPorpertyNum = windowMain:GetChild("Component_Atrribute1"):GetChild("Text_Number2")
    self.nexLevelLab = windowMain:GetChild("Text_CurrentLevel1")
    self.nexGemPorpertyLab = windowMain:GetChild("Component_Atrribute2"):GetChild("Text_Attribute")
    self.nexGemPorpertyNum = windowMain:GetChild("Component_Atrribute2"):GetChild("Text_Number2")
end

return _V 