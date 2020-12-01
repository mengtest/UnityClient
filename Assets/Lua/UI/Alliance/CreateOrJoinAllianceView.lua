local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "CreateOrJoinAllianceMain")

    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.CreateBtn = self.UI:GetChild("Button_Create")
    self.SearchBtn = self.UI:GetChild("Button_Search")
    self.LeftArrowBtn = self.UI:GetChild("Button_LeftArrow")
    self.RightArrowBtn = self.UI:GetChild("Button_RightArrow")
    self.SearchLabel = self.UI:GetChild("Input_SearchContent")
    self.LevelLabel = self.UI:GetChild("Text_Level")
    self.MainList = self.UI:GetChild("List_Alliance")
end

return _V