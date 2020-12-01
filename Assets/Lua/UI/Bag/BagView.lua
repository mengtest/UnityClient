local _V = UIManager.View()

function _V:getTempList()
    self.BagTempList = self.UI:GetChild("Componment_BagHandle"):GetChild("List_Bag"):GetChildAt(3):GetChild("List_Item").asList
    self.BagTempList.defaultItem = UIConfig.Item.EquipItemUrl
    self.BagTempList:SetVirtual()
end
function _V:stopEffect()
    if self.EffectId == 1 then
        self.EffectId = 0
        self.BagEffect:PlayReverse()
    end
end
function _V:initStat()
    self.EffectId = 0
    self.BagEffect:Stop()
    self.BagInitStat.selectedIndex = 1
    self.BagInitStat.selectedIndex = 0
end
function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Bag/Bag", "Bag", "BagMain")

    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BagEffect = self.UI:GetTransition("selected_T")
    self.BagInitStat = self.UI:GetController("State_C")

    -- 背包操作
    local bagHandle = self.UI:GetChild("Componment_BagHandle")
    -- 背包状态
    self.BagStat = bagHandle:GetController("Tab_C")
    self.BagTempStat = bagHandle:GetController("Type_C")
    -- 背包列表
    local bagList = bagHandle:GetChild("List_Bag")
    -- 背包列表个数
    bagList.numItems = 4
    self.BagList = bagList.asList
    self.BagList.scrollPane.decelerationRate = 20
    self.BagList.scrollItemToViewOnClick = false
    self.BagDefaultList = bagList:GetChildAt(0):GetChild("List_Item").asList
    self.BagEquipList = bagList:GetChildAt(1):GetChild("List_Item").asList
    self.BagGemList = bagList:GetChildAt(2):GetChild("List_Item").asList
    self.BagDefaultList.defaultItem = UIConfig.Item.DefaultItemUrl
    self.BagEquipList.defaultItem = UIConfig.Item.EquipItemUrl
    self.BagGemList.defaultItem = UIConfig.Item.DefaultItemUrl
    self.BagDefaultList:SetVirtual()
    self.BagEquipList:SetVirtual()
    self.BagGemList:SetVirtual()
    -- 装备按钮
    self.BtnDefault = bagHandle:GetChild("Button_Default")
    self.BtnEquip = bagHandle:GetChild("Button_Equip")
    self.BtnGemBag = bagHandle:GetChild("Button_Gen")
    self.BtnTempBag = bagHandle:GetChild("Button_Temp")
    -- 装备道具个数
    self.BagEquipCount = self.BtnEquip:GetChild("title")
    self.BagGenCount = self.BtnGemBag:GetChild("title")

    -- 底部使用面板
    local itemUse = self.UI:GetChild("Component_ControllPad")
    self.ItemUseStat = itemUse:GetController("State_C")
    -- 道具滑条
    self.ItemUseAmount = itemUse:GetChild("Component_ProgressBar1")
    self.ItemUseBtnAdd = itemUse:GetChild("Button_Plus")
    self.ItemUseBtnSubtract = itemUse:GetChild("Button_Minus")
    -- 道具信息
    local itemLocal = itemUse:GetChild("Component_ItemIcon")
    self.ItemName = itemUse:GetChild("TextField_ItemName")
    self.ItemUseDesc = itemUse:GetChild("TextField_Description")
    self.ItemIcon = itemLocal:GetChild("icon")
    self.ItemQuality = itemLocal:GetChild("quality")
    itemLocal:GetController("Count_C").selectedIndex = 0
    itemLocal:GetController("State_C").selectedIndex = 1
    -- 临时背包
    self.BagTempDieTime = bagHandle:GetChild("Label_LeftTime"):GetChild("title")
    self.ItemUseDieTime = itemUse:GetChild("TextField_ItemDieTime")
    -- 使用
    self.BtnItemUse = itemUse:GetChild("Button_Use")

    self.EffectId = 0
end

return _V