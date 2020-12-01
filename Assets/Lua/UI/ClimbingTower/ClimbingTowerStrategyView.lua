local _V = UIManager.View()

-- 获取回放Item
local function getReplayItemInfo(item)
    local info = { }
    info.Stat = item:GetController("State_C")
    info.Head = item:GetChild("Component_Head"):GetChild("loader_wujiang")
    info.Name = item:GetChild("TextField_Name")
    info.FightAmount = item:GetChild("TextField_FightAmount")
    info.GuildFlagName = item:GetChild("TextField_Flag")
    info.Time = item:GetChild("TextField_Time")
    info.BtnRepaly = item:GetChild("Button_Replay")
    local race = item:GetChild("List_Race")
    info.Race = { }
    info.Race[1] = race:GetChild("loader_icon1")
    info.Race[2] = race:GetChild("loader_icon2")
    info.Race[3] = race:GetChild("loader_icon3")
    info.Race[4] = race:GetChild("loader_icon4")
    info.Race[5] = race:GetChild("loader_icon5")
    return info
end

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/ClimbingTower/ClimbingTower", "ClimbingTower", "FloorStrategyMain")

    self.BtnBack = self.UI:GetChild("Button_Background")
    self.BtnNext = self.UI:GetChild("Button_RightArrow")
    self.BtnBef = self.UI:GetChild("Button_LeftArrow")

    self.FloorDesc = self.UI:GetChild("TextField_Floor")

    self.FloorReplay = { }
    self.FloorReplay[1] = getReplayItemInfo(self.UI:GetChild("Component_Player1"))
    self.FloorReplay[2] = getReplayItemInfo(self.UI:GetChild("Component_Player2"))
    self.FloorReplay[3] = getReplayItemInfo(self.UI:GetChild("Component_Player3"))
    self.FloorReplay[4] = getReplayItemInfo(self.UI:GetChild("Component_Player4"))

    self.FloorNbReplay = getReplayItemInfo(self.UI:GetChild("Component_Player5"))
end

return _V