local _C = UIManager.Controller(UIManager.ControllerName.GeneralDetails, UIManager.ViewName.GeneralDetails)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 武将数据
local captainsData = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains
-- 道具数据
local itemsData = DataTrunk.PlayerInfo.ItemsData
-- 当前武将下标
local currIndex = -1
-- 当前武将实例化信息
local currGeneralData = nil
-- 武将Id列表
local myData = { }
-- 当前武将Id
local currGeneralId = -1
-- 绿色强化符
local greenBill = { }
-- 蓝色强化符
local blueBill = { }
-- 紫色强化符
local purpleBill = { }
-- 橙色强化符
local orangeBill = { }
-- 绿色强化符物品Id
local greenBillId = 20001
-- 蓝色强化符物品Id
local blueBillId = 20002
-- 紫色强化符物品Id
local purpleBillId = 20003
-- 橙色强化符物品Id
local orangeBillId = 20004
-- 超过30级不能解雇
local levelLimit = 30

local function OnClose()
    _C:close()
end

-- 卸下将魂
local function ReleaseSoulSucc(data)

end

-- 更新星星等级
local function UpdateStarLv(starList, maxLv, curLv)
    -- 强化等级
    starList:RemoveChildrenToPool()
    local half = 0
    local max = math.ceil(maxLv * 0.5)
    local full = math.floor(curLv * 0.5)
    if full < curLv * 0.5 then half = 1 end
    -- 添加星星
    for id = 1, full, 1 do
        starList:AddChild(starList:AddItemFromPool(UIConfig.Item.StarFullUrl))
    end
    if half == 1 then
        starList:AddChild(starList:AddItemFromPool(UIConfig.Item.StarHalfUrl))
    end
    for id = 1, max - half - full do
        starList:AddChild(starList:AddItemFromPool(UIConfig.Item.StarEmptyUrl))
    end
end

-- 处理装备信息
local function UpdateEquipInfo(ui, data, equipType, heroId)
    -- 0 有装备 1 有装备可穿 2 没装备空的
    local state_C = ui:GetController("State_C")

    if data == nil then
        if itemsData:checkEquipExists(equipType) then
            -- 有装备可穿
            state_C.selectedIndex = 1
            ui:GetChild("Text_BodyPart").text = Localization["EquipType" .. equipType]
        else
            -- 没装备
            state_C.selectedIndex = 2
            ui:GetChild("Text_BodyPart_None").text = Localization["EquipType" .. equipType]
        end
    else
        state_C.selectedIndex = 0
        -- 等级
        ui.title = data.Level
        -- 图标
        ui.icon = data.Config.Icon
        -- 品质
        ui:GetChild("Loader_Quality").url = UIConfig.Item.EquipQuality[data.Config.Quality.Level]
        -- 星星
        UpdateStarLv(ui:GetChild("List_EquipStar"), data.RefinedLevel, data.Config.Quality.RefinedLevelLimit)
    end

    local info = { CaptainId = heroId, PartType = equipType }

    ui.onClick:Set( function()
        UIManager.openController(UIManager.ControllerName.CaptainEquipMain, info)
    end )
end

-- 初始化强化符按钮的数据和状态
local function UpdataExpItemInfo(data)
    -- 使用个数
    data.Btn:GetChild("TextField_LeftNumber").text = 0
    -- 当前个数
    local currExpLabel = data.Btn:GetChild("TextField_MaxAmount")

    if data.Data == nil then
        currExpLabel.text = 0
        data.Btn.touchable = false
        data.Btn.grayed = true
    else
        currExpLabel.text = data.Data.Amount
        data.Btn.touchable = true
        data.Btn.grayed = false
    end

    data.Amount_C.selectedIndex = 0
end

-- 是否满足强化条件(数量)
local function CheckIntensifyBtn()
    if greenBill.CountInUse == 0 and blueBill.CountInUse == 0 and purpleBill.CountInUse == 0 and orangeBill.CountInUse == 0 then
        view.GrowthPanel_StrenghthenBtn.touchable = false
        view.GrowthPanel_StrenghthenBtn.grayed = true
    else
        view.GrowthPanel_StrenghthenBtn.touchable = true
        view.GrowthPanel_StrenghthenBtn.grayed = false
    end
end

local function UpdatePreProgress()
    view.GrowthPanel_ProgressBarAfter.value = view.GrowthPanel_ProgressBarNow.value
    + greenBill.Exp * greenBill.CountInUse
    + blueBill.Exp * blueBill.CountInUse
    + purpleBill.Exp * purpleBill.CountInUse
    + orangeBill.Exp * orangeBill.CountInUse
end

-- 加一个
local function AddFunction(data)
    local label = data.Btn:GetChild("TextField_LeftNumber")

    data.Btn:GetChild("Button_Plus").onClick:Set( function()
        if data.CountInUse ~= data.Data.Amount then
            data.CountInUse = data.CountInUse + 1
            label.text = data.CountInUse

            CheckIntensifyBtn()

            if data.CountInUse > 0 then
                data.Amount_C.selectedIndex = 1
            else
                data.Amount_C.selectedIndex = 0
            end

            UpdatePreProgress()
        end
    end )
end

-- 减一个
local function SubFunction(data)
    local label = data.Btn:GetChild("TextField_LeftNumber")

    data.Btn:GetChild("Button_Delete").onClick:Set( function()
        if data.CountInUse ~= 0 then
            data.CountInUse = data.CountInUse - 1
            label.text = data.CountInUse

            CheckIntensifyBtn()

            if data.CountInUse > 0 then
                data.Amount_C.selectedIndex = 1
            else
                data.Amount_C.selectedIndex = 0
            end

            UpdatePreProgress()
        end
    end )
end

-- 清空所有设置
local function BillClear(data)
    data.CountInUse = 0
    data.Btn:GetChild("TextField_LeftNumber").text = "0"
    data.Amount_C.selectedIndex = 0
end

-- 计算经验值
local function AutoPutIn(data)
    if data.Data == nil then
        return
    end

    local addBtn = data.Btn:GetChild("Button_Plus")

    for i = data.CountInUse, data.Data.Amount do
        if view.GrowthPanel_ProgressBarAfter.value >= view.GrowthPanel_ProgressBarAfter.max then
            break
        else
            addBtn.onClick:Call()
        end
    end

    data.Btn:GetTransition("Putin_T"):Play()
end

-- 更新一个面板的数据
local function UpdateCurrPanelInfo()
    if currGeneralData == nil then
        OnClose()
        return
    end

    -- 成长配置数据
    local abilityConfig = CaptainAbilityConfig:getConfigById(currGeneralData.Ability)
    -- 转生配置
    local generalRebirthConfig = CaptainRebirthConfig:getConfigByLevel(currGeneralData.RebirthLevel)
    -- 成长上限配置数据
    local abilityLimitConfig = CaptainAbilityConfig:getConfigById(generalRebirthConfig.AbilityLimit)
    -- 当前质量等级
    local generalQualityNum = abilityConfig.Quality - 1

    -- 是否显示解雇按钮
    if currGeneralData.Level >= levelLimit then
        view.FireBtn.visible = false
    else
        view.FireBtn.visible = true
    end

    -- 判断是否有将魂附身
    if currGeneralData.AttachedCaptainSoulId ~= 0 then
        -- 控制器，有将魂
        view.SoulController.selectedIndex = 1

        -- ********************界面中间，详情区域，将魂信息********************
        local soulInfo = CaptainSoulConfig:getConfigById(currGeneralData.AttachedCaptainSoulId)
        local soulQualityNum = soulInfo.Quality - 1
        -- 品质
        view.SoulPanel_Quality.selectedIndex = soulQualityNum
        -- 将魂名字
        view.SoulPanel_Name.text = soulInfo.Name
        -- 影响的士气
        view.MoraleText.text = "+" .. soulInfo.AddMorale
        -- 卸下按钮
        view.SoulRemoveBtn.onClick:Set(
        function()
            -- 卸下将魂
            NetworkManager.C2SAttachSoulProto(currGeneralData.Id, false, soulInfo.Id)
        end )

        -- ********************左侧，将魂panel********************
        --  -- 将魂名字
        --  view.NormalPanel_GeneralSoul:GetChild("TextField_SoulName").text = soulInfo.Name
        --  -- 大头像(将魂图片)
        --  view.NormalPanel_GeneralSoul:GetChild("Loader_GeneralIcon").url = soulInfo.Icon
        --  -- 品质
        --  view.NormalPanel_GeneralSoul:GetController("Stete_C").selectedIndex = soulQualityNum
        --  view.NormalPanel_GeneralSoul:GetChild("Component_Square"):GetController("Quality_C").selectedIndex = -- soulQualityNum
        --  -- Todo，等下一个规范化版本，需要将武将名字和成长抽出来，放入武将面板中，将魂中不需要这俩字段
        --  -- 武将名字
        --  view.NormalPanel_GeneralSoul:GetChild("TextField_GeneralName").text = currGeneralData.Name
        --  -- 武将当前成长值
        --  local textField = view.NormalPanel_GeneralSoul:GetChild("TextField_Growth")
        --  textField.text = string.format(Localization.GrowUp, currGeneralData.Ability)
        --  -- 当前成长值品质(文本颜色)
        --  textField.color = UIConfig.QualityColor[abilityConfig.Quality - 1]
    else
        -- 控制器，没有将魂
        view.SoulController.selectedIndex = 0
        -- 品质
        view.NormalPanel_GeneralQuality_C.selectedIndex = generalQualityNum
        -- 头像
        view.NormalPanel_GeneralIcon.icon = currGeneralData.BigHead
        -- 武将名字
        view.NormalPanel_GeneralName.text = currGeneralData.Name
        -- 成长
        view.NormalPanel_GeneralGrouth.text = string.format(Localization.GrowUp, currGeneralData.Ability)
        -- 成长颜色
        view.NormalPanel_GeneralGrouth.color = UIConfig.QualityColor[generalQualityNum + 1]
        -- 成长上限
        -- view.NormalPanel_GeneralNormal:GetChild("text_chengzhangshangxian").text = string.format(Localization.GrowUpLimit, generalRebirthConfig.AbilityLimit)
        -- view.NormalPanel_GeneralNormal:GetChild("text_chengzhangshangxian").color = UIConfig.QualityColor[abilityLimitConfig.Quality]
        -- 将魂附身按钮
        view.NormalPanel_SoulPossessionBtn.onClick:Set(
        function()
            UIManager.openController(UIManager.ControllerName.GeneralSoulMain, currGeneralData)
        end )
    end

    -- ********************界面中间，详情区域********************
    -- 武将类型文字描述
    view.DetailsPanel_Type.title = Localization["CaptainRaceType" .. currGeneralData.Race]
    -- 兵种
    view.DetailsPanel_Job.icon = UIConfig.Race[currGeneralData.Race]
    -- 评分(战斗力)
    view.DetailsPanel_Judgement.title = currGeneralData.FullSoldierFightAmount
    -- 等级
    view.DetailsPanel_Level.text = currGeneralData.Level

    -- 满级判断
    if CaptainLevelConfig.Config[currGeneralData.Level] == nil then
        view.DetailsPanel_EXPBar.value = 0
        view.DetailsPanel_EXPBar.max = 0
        view.DetailsPanel_EXPBar:GetChild("title").text = Localization.MaxLevel
    else
        -- 经验值当前值
        view.DetailsPanel_EXPBar.value = currGeneralData.Exp
        -- 经验值最大值
        view.DetailsPanel_EXPBar.max = CaptainLevelConfig.Config[currGeneralData.Level]
    end

    -- 统率值(最大带兵数)
    view.DetailsPanel_DOM.text = currGeneralData.MaxSoldier
    -- 攻
    view.DetailsPanel_ATT.text = currGeneralData.TotalStat.Attack
    -- 防
    view.DetailsPanel_DEF.text = currGeneralData.TotalStat.Defense
    -- 体
    view.DetailsPanel_CON.text = currGeneralData.TotalStat.Strength
    -- 敏
    view.DetailsPanel_DEX.text = currGeneralData.TotalStat.Dexterity

    ------------------- 装备 -------------------
    -- 武器(ui命名有问题,请无视)
    UpdateEquipInfo(view.DetailsPanel_EqumentList:GetChildAt(0), currGeneralData.Equips[EquipType.WU_QI], EquipType.WU_QI, currGeneralData.Id)
    -- 头盔
    UpdateEquipInfo(view.DetailsPanel_EqumentList:GetChildAt(1), currGeneralData.Equips[EquipType.TOU_KUI], EquipType.TOU_KUI, currGeneralData.Id)
    -- 铠甲
    UpdateEquipInfo(view.DetailsPanel_EqumentList:GetChildAt(2), currGeneralData.Equips[EquipType.KAI_JIA], EquipType.KAI_JIA, currGeneralData.Id)
    -- 护腿
    UpdateEquipInfo(view.DetailsPanel_EqumentList:GetChildAt(3), currGeneralData.Equips[EquipType.HU_TUI], EquipType.HU_TUI, currGeneralData.Id)
    -- 护符
    UpdateEquipInfo(view.DetailsPanel_EqumentList:GetChildAt(4), currGeneralData.Equips[EquipType.SHI_PIN], EquipType.SHI_PIN, currGeneralData.Id)


    -- ***************************** 成长面板 *****************************
    -- 当前成长值
    view.GrowthPanel_GrowNow.title = string.format(Localization.GrowUp, currGeneralData.Ability)
    -- 当前成长值品质(颜色)
    view.GrowthPanel_GrowNow.titleColor = UIConfig.QualityColor[generalQualityNum + 1]
    -- 当前成长值描述
    view.GrowthPanel_InstructionNow.text = string.format(Localization.IntensifyDesc, currGeneralData.Ability * 20 * currGeneralData.Level)
    -- 强化按钮
    view.GrowthPanel_StrenghthenBtn.touchable = false
    view.GrowthPanel_StrenghthenBtn.grayed = true
    -- 满级判断
    if CaptainAbilityConfig.Config[currGeneralData.Ability + 1] == nil then
        view.GrowthPanel_StateController.selectedIndex = 1
        view.GrowthPanel_ProgressBarNow.value = 0
        view.GrowthPanel_ProgressBarNow.max = 0
        view.GrowthPanel_FastStrenghthenBtn.touchable = false
        view.GrowthPanel_FastStrenghthenBtn.grayed = true
        view.GrowthPanel.touchable = false
    else
        view.GrowthPanel_StateController.selectedIndex = 0
        view.GrowthPanel_FastStrenghthenBtn.touchable = true
        view.GrowthPanel_FastStrenghthenBtn.grayed = false
        view.GrowthPanel.touchable = true

        -- 下一级成长值
        local nextLev = currGeneralData.Ability + 1
        local nextConfig = CaptainAbilityConfig.Config[nextLev]
        view.GrowthPanel_GrowAfter.title = string.format(Localization.GrowUp, nextLev)
        -- 下一级成长值品质(颜色)
        view.GrowthPanel_GrowAfter.titleColor = UIConfig.QualityColor[nextConfig.Quality]
        -- 下一级成长值描述
        view.GrowthPanel_InstructionAfter.text = string.format(Localization.IntensifyDesc, nextLev * 20 * currGeneralData.Level)
        -- Tips
        if abilityConfig.Quality ~= nextConfig.Quality then
            view.GrowthPanel_Tips.visible = true
            view.GrowthPanel_Tips.title = Localization["Quality" ..(nextConfig.Quality - 1)]
        else
            view.GrowthPanel_Tips.visible = false
        end
    end
    -- 成长值经验当前值
    view.GrowthPanel_ProgressBarNow.value = currGeneralData.AbilityExp
    -- 成长值经验最大值
    view.GrowthPanel_ProgressBarNow.max = abilityConfig.UpgradeExp
    -- 成长值经验预览当前值
    view.GrowthPanel_ProgressBarAfter.value = view.GrowthPanel_ProgressBarNow.value
    -- 成长值经验预览最大值
    view.GrowthPanel_ProgressBarAfter.max = view.GrowthPanel_ProgressBarNow.max

    -- ***************************** 技能面板 *****************************
    local raceInfo = RaceDataConfig:getConfigByRace(currGeneralData.Race)
    local restraintSkillInfo = SkillDataConfig:getConfigById(raceInfo.RestraintSkillId)
    -- 技能名字和图标
    view.SkillPanel_SkillInfo.title = restraintSkillInfo.Name
    view.SkillPanel_SkillInfo.icon = restraintSkillInfo.Icon
    local restraintRace = nil
    for k, v in ipairs(raceInfo.RestraintRace) do
        if k == 1 then
            restraintRace = Localization["SoliderRaceType" .. v]
        else
            restraintRace = restraintRace .. "," .. Localization["SoliderRaceType" .. v]
        end
    end
    -- 技能作用对象描述
    view.SkillPanel_SkillEffect.text = string.format(Localization.RestraintRace, restraintRace)
    -- 技能效果描述
    view.SkillPanel_SkillDesc.text = restraintSkillInfo.Desc
    -- **************************** 强化符 ********************************

    -- 绿色强化符{Btn:按钮,Exp:经验值,Data:数据,CountInUse:使用数量,Amount_C:数量控制器}
    greenBill.Btn = view.GrowthPanel_StrenghthenBtn1
    greenBill.Exp = ItemsConfig.Config[greenBillId].Effect.Exp
    greenBill.Data = itemsData.Default[greenBillId]
    greenBill.CountInUse = 0
    greenBill.Amount_C = greenBill.Btn:GetController("State_C")

    -- 蓝色强化符{Btn:按钮,Exp:经验值,Data:数据,CountInUse:使用数量,Amount_C:数量控制器}
    blueBill.Btn = view.GrowthPanel_StrenghthenBtn2
    blueBill.Exp = ItemsConfig.Config[blueBillId].Effect.Exp
    blueBill.Data = itemsData.Default[blueBillId]
    blueBill.CountInUse = 0
    blueBill.Amount_C = blueBill.Btn:GetController("State_C")

    -- 紫色强化符{Btn:按钮,Exp:经验值,Data:数据,CountInUse:使用数量,Amount_C:数量控制器}
    purpleBill.Btn = view.GrowthPanel_StrenghthenBtn3
    purpleBill.Exp = ItemsConfig.Config[purpleBillId].Effect.Exp
    purpleBill.Data = itemsData.Default[purpleBillId]
    purpleBill.CountInUse = 0
    purpleBill.Amount_C = purpleBill.Btn:GetController("State_C")

    -- 橙色强化符{Btn:按钮,Exp:经验值,Data:数据,CountInUse:使用数量,Amount_C:数量控制器}
    orangeBill.Btn = view.GrowthPanel_StrenghthenBtn4
    orangeBill.Exp = ItemsConfig.Config[orangeBillId].Effect.Exp
    orangeBill.Data = itemsData.Default[orangeBillId]
    orangeBill.CountInUse = 0
    orangeBill.Amount_C = orangeBill.Btn:GetController("State_C")

    -- 经验值提示信息
    view.GrowthPanel_StrenghthenExp1.text = string.format(Localization.Exp_1, greenBill.Exp)
    view.GrowthPanel_StrenghthenExp2.text = string.format(Localization.Exp_1, blueBill.Exp)
    view.GrowthPanel_StrenghthenExp3.text = string.format(Localization.Exp_1, purpleBill.Exp)
    view.GrowthPanel_StrenghthenExp4.text = string.format(Localization.Exp_1, orangeBill.Exp)

    -- 强化符按钮信息初始化
    UpdataExpItemInfo(greenBill)
    UpdataExpItemInfo(blueBill)
    UpdataExpItemInfo(purpleBill)
    UpdataExpItemInfo(orangeBill)

    -- 加按钮的监听注册
    AddFunction(greenBill)
    AddFunction(blueBill)
    AddFunction(purpleBill)
    AddFunction(orangeBill)

    -- 减按钮的监听注册
    SubFunction(greenBill)
    SubFunction(blueBill)
    SubFunction(purpleBill)
    SubFunction(orangeBill)

    -- 四种强化符都没有,按钮置灰
    if itemsData.Default[greenBillId] == nil and itemsData.Default[blueBillId] == nil and itemsData.Default[purpleBillId] == nil and itemsData.Default[orangeBillId] == nil then
        view.GrowthPanel_FastStrenghthenBtn.touchable = false
        view.GrowthPanel_FastStrenghthenBtn.grayed = true
    else
        -- 一键放入按钮(自动放入一级经验,从小到大开始放)
        view.GrowthPanel_FastStrenghthenBtn.onClick:Set( function()
            -- 先放入最呆的,没到满级继续放
            if view.GrowthPanel_ProgressBarAfter.value < view.GrowthPanel_ProgressBarAfter.max then
                AutoPutIn(greenBill)
            end

            if view.GrowthPanel_ProgressBarAfter.value < view.GrowthPanel_ProgressBarAfter.max then
                AutoPutIn(blueBill)
            end

            if view.GrowthPanel_ProgressBarAfter.value < view.GrowthPanel_ProgressBarAfter.max then
                AutoPutIn(purpleBill)
            end

            if view.GrowthPanel_ProgressBarAfter.value < view.GrowthPanel_ProgressBarAfter.max then
                AutoPutIn(orangeBill)
            end

            if greenBill.CountInUse ~= 0 or blueBill.CountInUse ~= 0 or purpleBill.CountInUse ~= 0 or orangeBill.CountInUse ~= 0 then
                view.GrowthPanel_StrenghthenBtn.touchable = true
                view.GrowthPanel_StrenghthenBtn.grayed = false
            end

            CheckIntensifyBtn()
        end )

        -- 强化按钮逻辑
        view.GrowthPanel_StrenghthenBtn.onClick:Set( function()
            -- 强化符id[]
            local billId = { }
            -- 强化符数量[]
            local billCount = { }

            if greenBill.CountInUse ~= 0 then
                table.insert(billId, greenBillId)
                table.insert(billCount, greenBill.CountInUse)
            end

            if blueBill.CountInUse ~= 0 then
                table.insert(billId, blueBillId)
                table.insert(billCount, blueBill.CountInUse)
            end

            if purpleBill.CountInUse ~= 0 then
                table.insert(billId, purpleBillId)
                table.insert(billCount, purpleBill.CountInUse)
            end

            if orangeBill.CountInUse ~= 0 then
                table.insert(billId, orangeBillId)
                table.insert(billCount, orangeBill.CountInUse)
            end

            NetworkManager.NewC2sCaptainRefinedMsg(currGeneralData.Id, billId, billCount)
        end )
    end
    -- 转生提示
    if currGeneralData.Level == CaptainRebirthConfig:getConfigByLevel(currGeneralData.RebirthLevel).LevelLimit then
        view.DetailsPanel_TransmigrationBtn.visible = true
        view.HintController.selectedIndex = 0
        -- 转生
        view.DetailsPanel_TransmigrationBtn.onClick:Set(
        function()
            UIManager.openController(UIManager.ControllerName.GeneralRebirthPre)
        end )
    else
        view.DetailsPanel_TransmigrationBtn.visible = false
        view.HintController.selectedIndex = 1
    end

    -- **************************** 左右箭头 ********************************
    -- 如果已经到底，禁止点击
    if currIndex == 0 then
        view.NormalPanel_TurnLeftBtn.grayed = true
        view.NormalPanel_TurnLeftBtn.touchable = false
    else
        view.NormalPanel_TurnLeftBtn.grayed = false
        view.NormalPanel_TurnLeftBtn.touchable = true
    end

    -- 如果已经到底，禁止点击
    if currIndex == #myData - 1 then
        view.NormalPanel_TurnRightBtn.grayed = true
        view.NormalPanel_TurnRightBtn.touchable = false
    else
        view.NormalPanel_TurnRightBtn.grayed = false
        view.NormalPanel_TurnRightBtn.touchable = true
    end
end

-- 更新武将信息
local function UpdateInfo()
    if not _C.IsOpen then
        return
    end

    -- 没有武将关闭界面
    if Utils.GetTableLength(captainsData) == 0 then
        OnClose()
        return
    end

    -- 拷贝现有的武将Id
    myData = { }
    for k, v in pairs(captainsData) do
        table.insert(myData, k)
    end

    -- 当前武将Id
    currGeneralId = myData[currIndex + 1]
    -- 武将实例化数据
    currGeneralData = captainsData[currGeneralId]
    UpdateCurrPanelInfo()
end

-- 强化成功
-- captain: int // 武将id
-- exp: int // 更新后的强化经验
local function IntensifySuccess(generalId)
    if not _C.IsOpen then
        return
    end

    -- 当前武将Id
    currGeneralId = generalId
    -- 武将实例化数据
    currGeneralData = captainsData[currGeneralId]

    -- 更新当前面板数据
    UpdateCurrPanelInfo()
end

-- 强化后武将升级
-- captain: int // 武将id
-- exp: int // 更新后的强化经验
-- ability: int // 更新后的能力值
-- name: string // 更新后的武将名字
-- generalId:武将Id
local function IntensifyUpgrade(generalId)
    if not _C.IsOpen then
        return
    end

    -- 当前武将Id
    currGeneralId = generalId
    -- 武将实例化数据
    currGeneralData = captainsData[currGeneralId]

    -- 升级特效
    view.GrowthPanel_ProgressEffect:Play()
    -- 属性提升特效
    view.GrowthPanel_StatusEffect:Play()
    -- 更新当前面板数据
    UpdateCurrPanelInfo()
end

-- 武将数据更新
local function UpdateStatus(generalId)
    if not _C.IsOpen then
        return
    end

    -- 当前武将Id
    currGeneralId = generalId
    -- 武将实例化数据
    currGeneralData = captainsData[currGeneralId]

    UpdateCurrPanelInfo()
end

-- 上一个武将
local function SwitchLeft()
    if currIndex == 0 then
        return
    end

    currIndex = currIndex - 1
    currGeneralId = myData[currIndex + 1]
    -- 武将实例化数据
    currGeneralData = captainsData[currGeneralId]
    -- 更新当前面板数据
    UpdateCurrPanelInfo()
end

-- 下一个武将
local function SwitchRight()
    if currIndex == #myData - 1 then
        return
    end

    currIndex = currIndex + 1
    currGeneralId = myData[currIndex + 1]
    -- 武将实例化数据
    currGeneralData = captainsData[currGeneralId]
    -- 更新当前面板数据
    UpdateCurrPanelInfo()
end

-- 重命名
local function OnRename()
    UIManager.openController(UIManager.ControllerName.GeneralRename, currGeneralId)
end

-- 改名成功
local function OnRenameSucc(generalId, name)
    if not _C.IsOpen then
        return
    end

    currGeneralId = generalId
    -- 武将实例化数据
    currGeneralData = captainsData[currGeneralId]
    -- 更新当前面板数据
    UpdateCurrPanelInfo()
end

-- 解雇
local function OnFire()
    local popupData = { }

    -- 计算强化符
    for k, v in pairs(CaptainAbilityConfig.Config[currGeneralData.Ability].SellPrice.Goods) do
        if v.Amount > 0 then
            table.insert(popupData, { icon = ItemsConfig.Config[v.Id].Icon, count = v.Amount })
        end
    end

    -- 计算装备
    for k, v in pairs(currGeneralData.Equips) do
        table.insert(popupData, { icon = v.Config.Icon, count = 1 })
    end

    -- 标题 + 物品列表 + 取消 + 确认
    local data = {
        UIManager.PopupStyle.TitleListYesNo,
        title = Localization.FireGeneral,
        listData = popupData,
        btnTitle = { Localization.Cancel, Localization.Confirm },
        btnFunc = function() NetworkManager.C2SFireCaptainProto(currGeneralData.Id) end
    }

    UIManager.openController(UIManager.ControllerName.Popup, data)
end

function _C:onCreat()
    view = _C.View
    -- 返回
    view.BackBtn.onClick:Set(OnClose)
    -- 上一个按钮
    view.NormalPanel_TurnLeftBtn.onClick:Set(SwitchLeft)
    -- 下一个按钮
    view.NormalPanel_TurnRightBtn.onClick:Set(SwitchRight)
    -- 改名按钮
    view.RenameBtn.onClick:Set(OnRename)
    -- 解雇按钮
    view.FireBtn.onClick:Set(OnFire)

    Event.addListener(Event.GENERAL_UPDATE, UpdateInfo)
    Event.addListener(Event.ITEM_EXP_UPDATE, UpdateList)
    Event.addListener(Event.GENERAL_INTENSIFY_SUCCESS, IntensifySuccess)
    Event.addListener(Event.GENERAL_INTENSIFY_UPGRADE, IntensifyUpgrade)
    Event.addListener(Event.GENERAL_STATUS_UPDATE, UpdateStatus)
    Event.addListener(Event.CAPTAIN_ATTACH_SOUL_SUCCESS, ReleaseSoulSucc)
    Event.addListener(Event.GENERAL_RENAME_SUCCESS, OnRenameSucc)
end

-- generalId:武将id
function _C:onOpen(index)
    if index < 0 then
        return
    end

    currIndex = index

    UpdateInfo()
end

function _C:onShow()
    UpdateInfo()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    Event.removeListener(Event.GENERAL_UPDATE, UpdateInfo)
    Event.removeListener(Event.ITEM_EXP_UPDATE, UpdateList)
    Event.removeListener(Event.GENERAL_INTENSIFY_SUCCESS, IntensifySuccess)
    Event.removeListener(Event.GENERAL_INTENSIFY_UPGRADE, IntensifyUpgrade)
    Event.removeListener(Event.GENERAL_STATUS_UPDATE, UpdateStatus)
    Event.removeListener(Event.CAPTAIN_ATTACH_SOUL_SUCCESS, ReleaseSoulSucc)
    Event.removeListener(Event.GENERAL_RENAME_SUCCESS, OnRenameSucc)
end