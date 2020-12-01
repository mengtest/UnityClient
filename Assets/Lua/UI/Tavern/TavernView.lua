local _V = UIManager.View()

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Tavern/Tavern", "Tavern", "TavernMain")

    -- 0 宴请前 1 宴请后
    self.State_C = self.UI:GetController("State_C")

    -- top left
    self.BackBtn = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")

    -- top right
    self.RelationBtn = self.UI:GetChild("Button_HuKe")
    -- particle
    local baguaEffect = self.UI:GetChild("Component_Gossip")
    baguaEffect.rotationX = 220
    baguaEffect.rotationY = 15

    -- bottom left
    self.GeneralBtn = self.UI:GetChild("Button_General")
    self.IntensifyBtn = self.UI:GetChild("Button_Intensify")

    -- center
    self.CardList = {
        self.UI:GetChild("Button_Card01"),
        self.UI:GetChild("Button_Card02"),
        self.UI:GetChild("Button_Card03"),
        self.UI:GetChild("Button_Card04"),
        self.UI:GetChild("Button_Card05"),
        self.UI:GetChild("Button_Card06"),
    }

    -- bottom
    self.GreenBill = self.UI:GetChild("Label_GreenBill")
    self.BlueBill = self.UI:GetChild("Label_BlueBill")
    self.PurpleBill = self.UI:GetChild("Label_PurpleBill")
    self.OrangeBill = self.UI:GetChild("Label_OrangeBill")

    -- bottom right
    self.FeteBtn = self.UI:GetChild("Button_Fete")
    self.FeteCD = self.FeteBtn:GetChild("Text_Time")
    self.FeteCD.text = ""
    self.ConvertBtn = self.UI:GetChild("Button_Convert")
    self.Tips = self.UI:GetChild("Label_Tips")
    self.TheRestTimes = self.UI:GetChild("Text_RestTimes")
end

return _V