local _V = UIManager.View()

-- 获取部件道具信息
local function getItemInfo(part)
    local partInfo = { }
    partInfo.Root = part
    partInfo.Stat = part:GetController("zhuangbei")
    partInfo.Part = part:GetChild("wenzi_bwkong")
    partInfo.Icon = part:GetChild("icon")
    partInfo.Lv = part:GetChild("title")
    partInfo.Quality = part:GetChild("quality")
    partInfo.RefineLv = part:GetChild("xingliebiao").asList

    return partInfo
end
-- 获取部件道具宝石信息
local function getGemItemInfo(gemItem)
    local partInfo = { }
    partInfo.Stat = gemItem:GetController("Stage_C")
    partInfo.Item = getItemInfo(gemItem:GetChild("Button_Prop"))

    local gem1 = gemItem:GetChild("Component_GemBody_Hole1")
    local gem2 = gemItem:GetChild("Component_GemBody_Hole2")
    local gem3 = gemItem:GetChild("Component_GemBody_Hole3")
    partInfo.Gem = {
        [1] = { Stat = gem1:getController("Stage_C"), Icon = gem1:GetChild("Loader_Gem") },
        [2] = { Stat = gem2:getController("Stage_C"), Icon = gem2:GetChild("Loader_Gem") },
        [3] = { Stat = gem3:getController("Stage_C"), Icon = gem3:GetChild("Loader_Gem") },
    }

    return partInfo
end
-- 获取宝石槽位信息
local function getGemSlotInfo(gemItem)
    local partInfo = { }
    partInfo.Stat = gemItem:GetController("Stage_C")
    partInfo.Icon = gemItem:GetChild("Loader_Gem")
    partInfo.OpenCondition = gemItem:GetChild("Text_Condition")

    return partInfo
end
-- 更新星星等级
function _V:updateStarLv(starList, maxLv, curLv, size)
    -- 强化等级
    starList:RemoveChildrenToPool()
    local half = 0
    local max = math.ceil(maxLv * 0.5)
    local full = math.floor(curLv * 0.5)
    if full < curLv * 0.5 then half = 1 end
    -- 添加星星
    for id = 1, full, 1 do
        local item = starList:AddItemFromPool(UIConfig.Item.StarFullUrl)
        item.viewWidth = size
        item.viewHeight = size
        starList:AddChild(item)
    end
    if half == 1 then
        local item = starList:AddItemFromPool(UIConfig.Item.StarHalfUrl)
        item.viewWidth = size
        item.viewHeight = size
        starList:AddChild(item)
    end
    for id = 1, max - half - full do
        local item = starList:AddItemFromPool(UIConfig.Item.StarEmptyUrl)
        item.viewWidth = size
        item.viewHeight = size
        starList:AddChild(item)
    end
end
-- 更新列表装备信息
function _V:updateListEquipInfo(item, info)
    if info == nil then
        item:GetController("zhuangbei").selectedIndex = 2
        item:GetChild("wenzi_bwkong").text = ""
    else
        item:GetController("zhuangbei").selectedIndex = 0
        item:GetChild("icon").url = info.Config.Icon
        item:GetChild("title").text = tostring(info.Level)
        item:GetChild("quality").url = UIConfig.Item.EquipQuality[info.Config.Quality.Level]

        -- 强化等级
        _V:updateStarLv(item:GetChild("xingliebiao").asList, info.Config.Quality.RefinedLevelLimit, info.RefinedLevel, UIConfig.Item.StarSmallSize)
    end
end
-- 更新部件装备信息
function _V:updatePartEquipInfo(equip, info, equipTypeDesc)
    if info == nil then
        equip.Stat.selectedIndex = 2
        equip.Part.text = equipTypeDesc
        return
    else
        equip.Stat.selectedIndex = 0
    end

    equip.Icon.url = info.Config.Icon
    equip.Lv.text = tostring(info.Level)
    equip.Quality.url = UIConfig.Item.EquipQuality[info.Config.Quality.Level]

    -- 强化等级
    _V:updateStarLv(equip.RefineLv, info.Config.Quality.RefinedLevelLimit, info.RefinedLevel, UIConfig.Item.StarSmallSize)
end
-- 更新武将信息
function _V:updateGeneralInfo(captain, info)
    -- 头像
    local head = captain:GetChild("con_wujiangtouxiang")
    head:GetChild("wujiangtouxiang").url = info.Head
    head:GetController("pinzhi").selectedIndex = info.Quality - 1

    -- 等级
    captain:GetChild("txt_wujiangmingzi").text = info.Name
    captain:GetChild("txt_dengji").text = string.format(Localization.Level_1, info.Level)

    -- 装备
    equipSet = function(equip, equipType)
        if nil ~= info.Equips[equipType] then
            equip:GetController("icon").selectedIndex = 0
            equip:GetChild("icon").url = info.Equips[equipType].Config.Icon
            equip:GetChild("pinzhi").url = UIConfig.Item.EquipQuality[info.Equips[equipType].Config.Quality.Level]
        else
            equip:GetController("icon").selectedIndex = 2
        end
    end
    local equipList = captain:GetChild("list_icon")
    -- 武器
    equipSet(equipList:GetChildAt(0), EquipType.WU_QI)
    -- 头盔
    equipSet(equipList:GetChildAt(1), EquipType.TOU_KUI)
    -- 铠甲
    equipSet(equipList:GetChildAt(2), EquipType.KAI_JIA)
    -- 护腿
    equipSet(equipList:GetChildAt(3), EquipType.HU_TUI)
    -- 饰品
    equipSet(equipList:GetChildAt(4), EquipType.SHI_PIN)

    -- 武將类型
    local captainType = captain:GetChild("lab_zhiye")
    captainType.icon = UIConfig.Race[info.Race]
    captainType.title = tostring(DataTrunk.PlayerInfo.MilitaryAffairsData.SoldierLevel)

    -- 武將精炼
    -- ToDo
end

function _V:LoadView()
    self.UI, self.PKG = UIManager.creatView("UI/Armor/Armor", "Armor", "ArmorMain")

    -- 武将装备
    self.BtnBack = self.UI:GetChild("Label_BackTitle"):GetChild("Button_Back")
    self.BtnEquip = self.UI:GetChild("Button_EquipmentDetails")
    self.BtnUpdate = self.UI:GetChild("Button_EquipmentLevel")
    self.BtnRefine = self.UI:GetChild("Button_EquipmentStrengthen")
    self.BtnGem = self.UI:GetChild("Button_Gem")

    self.EquipPanelStat = self.UI:GetController("Tab_C")

    -- 武将列表
    self.CaptainList = self.UI:GetChild("List_General").asList
    self.CaptainList:SetVirtual()

    -- 索引0 - 5 约定，
    -- 0:全部
    -- 1:武器
    -- 2:铠甲
    -- 3:护腿
    -- 4:饰品
    -- 5:头盔

    -- 武将部件
    self.CaptainPart = { }
    self.CaptainPart[1] = getItemInfo(self.UI:GetChild("Component_Armor"))
    self.CaptainPart[2] = getItemInfo(self.UI:GetChild("Component_Bard"))
    self.CaptainPart[3] = getItemInfo(self.UI:GetChild("Component_Leg"))
    self.CaptainPart[4] = getItemInfo(self.UI:GetChild("Component_Accessory"))
    self.CaptainPart[5] = getItemInfo(self.UI:GetChild("Component_Helmet"))
    self.BtnTaoZ_1 = self.UI:GetChild("Button_TaoZhuang")
    self.EquipTaoZLvList = self.BtnTaoZ_1:GetChild("List_Stars")
    self.GeneralMorale = self.BtnTaoZ_1:GetChild("Text_Morale")

    -- 装备列表按钮
    self.BtnEquipList = { }
    self.BtnEquipList[0] = self.UI:GetChild("Button_All")
    self.BtnEquipList[1] = self.UI:GetChild("Button_ArmorPage")
    self.BtnEquipList[2] = self.UI:GetChild("Button_BardPage")
    self.BtnEquipList[3] = self.UI:GetChild("Button_LegPage")
    self.BtnEquipList[4] = self.UI:GetChild("Button_AccessoryPage")
    self.BtnEquipList[5] = self.UI:GetChild("Button_HelmetPage")

    self.EquipPartStat = self.UI:GetController("Type_C")
    self.EquipSlideBar = self.UI:GetChild("ProgressBar_Equipment")
    self.EquipSlideBar:RemoveEventListeners()

    -- 装备列表
    self.EquipList = self.UI:GetChild("List_Equipment")
    self.ListEquip = { }
    self.ListEquip[0] = self.EquipList:GetChildAt(0):GetChild("List_Equipment")
    self.ListEquip[1] = self.EquipList:GetChildAt(1):GetChild("List_Main").asList
    self.ListEquip[2] = self.EquipList:GetChildAt(2):GetChild("List_Main").asList
    self.ListEquip[3] = self.EquipList:GetChildAt(3):GetChild("List_Main").asList
    self.ListEquip[4] = self.EquipList:GetChildAt(4):GetChild("List_Main").asList
    self.ListEquip[5] = self.EquipList:GetChildAt(5):GetChild("List_Main").asList
    self.ListEquip[0]:SetVirtual()
    self.ListEquip[1]:SetVirtual()
    self.ListEquip[2]:SetVirtual()
    self.ListEquip[3]:SetVirtual()
    self.ListEquip[4]:SetVirtual()
    self.ListEquip[5]:SetVirtual()

    -- 装备替换
    local replace = self.UI:GetChild("Component_ReplaceEquipment")
    self.SelectedEquipName = replace:GetChild("Text_EquipmentName")
    self.SelectedEquipDesc = replace:GetChild("Text_Current")
    self.ReplaceEquipDesc = replace:GetChild("Text_Change")
    self.ReplaceEquipName = replace:GetChild("Text_EquipmentName2")
    self.BtnReplace = replace:GetChild("Button_Replace")

    -- 装备升级强化
    local equipSrength = self.UI:GetChild("Component_UpgradeEquipment")
    self.StrengthDescList = equipSrength:GetChild("List_Description")
    self.EquipStrengthStat = equipSrength:GetController("Type_C")
    self.EquipStrengthSelectStat = equipSrength:GetController("Tab_C")
    self.EquipEmptyStat = equipSrength:GetController("State_C")
    self.EffectEquipStrength = equipSrength:GetTransition("Strength_T")
    self.BtnTaoZ_2 = equipSrength:GetChild("Button_Set")

    -- 装备加强
    self.EquipStength = { }
    self.EquipStength[1] = getItemInfo(equipSrength:GetChild("Button_Armor"))
    self.EquipStength[2] = getItemInfo(equipSrength:GetChild("Button_Bard"))
    self.EquipStength[3] = getItemInfo(equipSrength:GetChild("Button_Leg"))
    self.EquipStength[4] = getItemInfo(equipSrength:GetChild("Button_Accessory"))
    self.EquipStength[5] = getItemInfo(equipSrength:GetChild("Button_Helmet"))

    self.EquipStengthName = equipSrength:GetChild("Text_EquipmentName")
    local costItem = equipSrength:GetChild("Component_Cost")
    costItem:GetController("State_C").selectedIndex = 1
    costItem:GetController("Count_C").selectedIndex = 1
    self.EquipStengthCostIcon = costItem:GetChild("icon")
    self.EquipStengthCostCount = costItem:GetChild("title")

    -- 装备升级
    self.BtnEquipUpgardeOnce = equipSrength:GetChild("Button_LevelUp")
    self.BtnEquipUpgardeTen = equipSrength:GetChild("Button_LevelUp10")
    self.BtnEquipAllUpgardeOnce = equipSrength:GetChild("Button_LevelUpAll")

    self.EquipStengthLv = equipSrength:GetChild("Text_LevelNumber")

    -- 装备强化
    self.BtnEquipRefine = equipSrength:GetChild("Button_Strengthen")

    self.EquipStengthPropertyPercentAdd = equipSrength:GetChild("Text_Status")
    self.EquipStengthRefineLvList = equipSrength:GetChild("List_Star").asList
    self.EquipStengthTaoZLvList = equipSrength:GetChild("List_Stars").asList

--    -- 宝石面板镶嵌
--    self.BtnRemoveGems = self.UI:GetChild("Button_Remove")
--    self.BtnDecotate = self.UI:GetChild("Button_Decorate")

--    self.PropertyGemLab = self.UI:GetChild("Text_Attribute1")

--    -- 部件宝石列表
--    self.CaptainPartGems = {
--        [EquipType.WU_QI] = getGemItemInfo(self.UI:GetChild("Button_GemBody1")),
--        [EquipType.TOU_KUI] = getGemItemInfo(self.UI:GetChild("Button_GemBody2")),
--        [EquipType.KAI_JIA] = getGemItemInfo(self.UI:GetChild("Button_GemBody3")),
--        [EquipType.SHI_PIN] = getGemItemInfo(self.UI:GetChild("Button_GemBody4")),
--        [EquipType.HU_TUI] = getGemItemInfo(self.UI:GetChild("Button_GemBody5")),
--    }
--    -- 大槽位
--    self.BigSlotList = {
--        [1] = getGemSlotInfo(self.UI:GetChild("Component_ArmorHole1")),
--        [2] = getGemSlotInfo(self.UI:GetChild("Component_ArmorHole2")),
--        [3] = getGemSlotInfo(self.UI:GetChild("Component_ArmorHole3")),
--    }
end

return _V