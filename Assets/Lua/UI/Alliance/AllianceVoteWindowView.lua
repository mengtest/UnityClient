local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Alliance/Alliance", "Alliance", "VoteMain")

    self.BG = self.UI:GetChild("Component_BG")

    local window = self.UI:GetChild("Component_Main")
    self.CloseBtn = window:GetChild("Label_Window"):GetChild("Button_Close")
    self.TimeText = window:GetChild("Text_Time")
    self.VoteDetailsBtn = window:GetChild("Button_VoteDetails")
    self.CandidateList = window:GetChild("List_Candidate")
    self.CandidateList:SetVirtual()
end

return _V