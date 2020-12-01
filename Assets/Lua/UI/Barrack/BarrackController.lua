local _C = UIManager.Controller(UIManager.ControllerName.Barrack, UIManager.ViewName.Barrack)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 军政实例化信息
local militaryData = nil
-- 货币信息
local currencyData = nil
-- 玩家信息
local playerdata = nil
-- 新兵计时器
local newSoldierTimer = nil

local function BackBtnOnClick()
    _C:close()
end

-- 升阶按钮:进入升阶界面
local function UpgradeBtnOnClick()
    UIManager.openController(UIManager.ControllerName.SoldierUpgrade)
end

-- 获取配置显示消耗列表
local function GetConfigAndShowUI(table, btn, num)
    for k, v in pairs(table) do
        while true do
            if type(v) ~= "number" or v == 0 then
                break
            end

            -- 滑动条为0时按钮置灰
            if num == 0 then
                btn.grayed = true
                btn.touchable = false
                return
            else
                btn.grayed = false
                btn.touchable = true
            end

            local item = view.ConditionList:AddItemFromPool(UIConfig.ConditionType.Resourse)
            item_C = item:GetController("State_C")
            -- 图标
            item:GetChild("Loader_Res").url = UIConfig.CurrencyType[k]
            -- 当前值
            local currValue = 0

            -- 如果是元宝,可能是我多虑了,先写着以防万一,如果不是4种货币/元宝会出错
            if k == "YuanBao" then
                currValue = playerdata.Money
            else
                currValue = currencyData[CurrencyType[k]]
            end

            -- 当前货币值
            item:GetChild("Text_Total").text = currValue
            -- 消耗值
            item:GetChild("Text_Need").text = v * num

            if currValue < v * num then
                item_C.selectedIndex = 1
                item:GetChild("Button_Add").onClick:Set( function() print("怕是要干一些增加货币的事情了") end)
                -- 按钮置灰,关闭交互
                btn.grayed = true
                btn.touchable = false
            else
                item_C.selectedIndex = 0
            end

            break
        end
    end
end

-- 更新消耗列表
local function UpdateConditionInfo()
    view.ConditionList:RemoveChildrenToPool()

    if view.Type_C.selectedIndex == 0 then
        -- 招募(训练)
        GetConfigAndShowUI(SoldierConfig.Config[militaryData.SoldierLevel].RecruitCost, view.TrainBtn, math.floor(view.TrainSlider.value))
    else
        -- 治疗
        GetConfigAndShowUI(SoldierConfig.Config[militaryData.SoldierLevel].WoundedCost, view.TreatBtn, math.floor(view.TreatSlider.value))
    end
end

-- 训练士兵滑动条
local function TrainProgressOnChanged()
    view.Type_C.selectedIndex = 0
    UpdateConditionInfo()
    view.TrainAmount.text = string.format(Localization.TrainAmount, view.TrainSlider.value)

    if view.TrainSlider.value == 0 then
        view.TrainAmount.text = false
    else
        view.TrainAmount.visible = true
    end
end

-- 治疗士兵滑动条
local function TreatProgressOnChanged()
    view.Type_C.selectedIndex = 1
    UpdateConditionInfo()
    view.TreatAmount.text = string.format(Localization.TreatAmount, view.TreatSlider.value)

    if view.TreatSlider.value == 0 then
        view.TreatAmount.visible = false
    else
        view.TreatAmount.visible = true
    end
end

-- 训练"-"按钮
local function TrainSubBtnOnClick()
    if view.TrainSlider.value == 0 then
        return
    end

    view.TrainSlider.value = view.TrainSlider.value - 1
    TrainProgressOnChanged()
end

-- 训练"+"按钮
local function TrainAddBtnOnClick()
    if view.TrainSlider.value == view.TrainSlider.max or view.TrainSlider.value >= math.floor(militaryData.NewSoldier) then
        return
    end

    view.TrainSlider.value = view.TrainSlider.value + 1
    TrainProgressOnChanged()
end

-- 训练按钮
local function TrainBtnOnClick()
    print("view.TrainSlider.value!!!", view.TrainSlider.value)
    NetworkManager.C2SRecruitSoldierProto(view.TrainSlider.value)
end

-- 治疗"-"按钮
local function TreatSubBtnOnClick()
    if view.TreatSlider.value == 0 then
        return
    end

    view.TreatSlider.value = view.TreatSlider.value - 1
    TreatProgressOnChanged()
end

-- 治疗"+"按钮
local function TreatAddBtnOnClick()
    if view.TreatSlider.value == view.TreatSlider.max or view.TreatSlider.value >= math.floor(militaryData.WoundedSoldier) then
        return
    end

    view.TreatSlider.value = view.TreatSlider.value + 1
    TreatProgressOnChanged()
end

-- 治疗按钮
local function TreatBtnOnClick()
    NetworkManager.C2SHealWoundedSoldierProto(view.TreatSlider.value)
end

-- 刷新训练滑动条
local function RefreshTrainSlider()
    if math.floor(militaryData.NewSoldier) <= 0 then
        view.TrainSlider.touchable = false
        view.TrainSubBtn.touchable = false
        view.TrainAddBtn.touchable = false
        view.TrainSlider.grayed = true
        view.TrainSubBtn.grayed = true
        view.TrainAddBtn.grayed = true
    else
        view.TrainSlider.touchable = true
        view.TrainSubBtn.touchable = true
        view.TrainAddBtn.touchable = true
        view.TrainSlider.grayed = false
        view.TrainSubBtn.grayed = false
        view.TrainAddBtn.grayed = false
    end
end

local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    -- 士兵详情
    view.SoldierLev.text = militaryData.SoldierLevel
    view.SoldierAmount.text = militaryData.FreeSoldier .. "/" .. militaryData.SoldierCapacity

    if militaryData.SoldierCapacity ~= 0 and militaryData.FreeSoldier == militaryData.SoldierCapacity then
        view.SoldierTips.icon = UIConfig.RedTipsBg
        view.SoldierTips.title = Localization.SoldiersAreFull
        view.SoldierTips.visible = true
    else
        view.SoldierTips.visible = false
    end

    -- 新兵详情
    view.NewSoldierAmount.text = math.floor(militaryData.NewSoldier) .. "/" .. militaryData.SoldierCapacity

    -- 新兵提示
    if militaryData.NewSoldierCapacity ~= 0 and militaryData.NewSoldier == militaryData.NewSoldierCapacity then
        view.NewSoldierTips.icon = UIConfig.RedTipsBg
        view.NewSoldierTips.title = Localization.NewSoldiersAreFull
    else
        view.NewSoldierTips.icon = UIConfig.GreenTipsBg
        view.NewSoldierTips.title = string.format(Localization.AddDes, militaryData.NewSoldierOutput)

        -- 新兵计时器
        local function TimerComplete()
            view.NewSoldierAmount.text = math.floor(militaryData.NewSoldier) .. "/" .. militaryData.SoldierCapacity
            view.TrainSlider.max = math.floor(militaryData.NewSoldier)
            RefreshTrainSlider()
        end

        if newSoldierTimer == nil then
            newSoldierTimer = TimerManager.newTimer(1, true, true, nil, nil, TimerComplete)
        end

        newSoldierTimer:start()
    end

    -- 伤兵详情
    view.WoundedSoldierAmount.text = militaryData.WoundedSoldier .. "/" .. militaryData.WoundedSoldierCapacity

    if militaryData.WoundedSoldierCapacity ~= 0 and militaryData.WoundedSoldier == militaryData.WoundedSoldierCapacity then
        view.WoundedSoldierTips.icon = UIConfig.RedTipsBg
        view.WoundedSoldierTips.title = Localization.WoundedSoldiersAreFull
        view.WoundedSoldierTips.visible = true
    else
        view.WoundedSoldierTips.visible = false
    end

    -- 数量为0处理
    if militaryData.WoundedSoldier == 0 then
        view.TreatSlider.value = 0
        view.TreatSlider.max = 1
        view.TreatSlider.touchable = false
        view.TreatSubBtn.touchable = false
        view.TreatAddBtn.touchable = false
        view.TreatSlider.grayed = true
        view.TreatSubBtn.grayed = true
        view.TreatAddBtn.grayed = true
    else
        view.TreatSlider.touchable = true
        view.TreatSlider.max = militaryData.WoundedSoldier
        view.TreatSubBtn.touchable = true
        view.TreatAddBtn.touchable = true
        view.TreatSlider.grayed = false
        view.TreatSubBtn.grayed = false
        view.TreatAddBtn.grayed = false
    end
end

-- 训练(招募)成功
local function RecruitSoldierSuccess()
    if not _C.IsOpen then
        return
    end

    UIManager.showTip( { content = Localization.RecruitSuccess, result = true })
    view.TrainSlider.value = 0
    view.TrainSlider.max = militaryData.NewSoldier
    view.TrainAmount.text = false
    UpdateConditionInfo()
    RefreshUI()
    view.Train_T:Play()
    view.Update_T:Play()
end

-- 治疗成功
local function HealSoldierSuccess()
    if not _C.IsOpen then
        return
    end

    UIManager.showTip( { content = Localization.HealSuccess, result = true })
    view.TreatSlider.value = 0
    view.TreatSlider.max = militaryData.WoundedSoldier
    view.TreatAmount.visible = false
    UpdateConditionInfo()
    RefreshUI()
    view.Treat_T:Play()
    view.Update_T:Play()
end

-- 切换页签 0 新兵 1 伤兵
local function StateOnChange()
    if view.Type_C.selectedIndex == 0 then
        -- 新兵
        view.ConditionTitle.text = Localization.NewSoldierCondition
        view.TreatSlider.value = 0
        view.TreatBtn.grayed = true
        view.TreatBtn.touchable = false
        view.TreatAmount.visible = false
        -- 获取最大可招募士兵数量
        NetworkManager.C2SGetMaxRecruitSoldier()
    else
        -- 伤兵
        view.ConditionTitle.text = Localization.WoundedSoldierCondition
        view.TrainSlider.value = 0
        view.TrainBtn.grayed = true
        view.TrainBtn.touchable = false
        view.TrainAmount.visible = false
        -- 获取最大可治疗伤兵数
        NetworkManager.C2SGetMaxHealSoldier()
    end

    view.ConditionList:RemoveChildrenToPool()
end

-- 获取最大可招募士兵数量成功
local function GetMaxRecruitSoldierSuccess(count)
    if not _C.IsOpen then
        return
    end

    view.TrainSlider.value = count
    TrainProgressOnChanged()
end

-- 获取最大可治疗伤兵数成功
local function GetMaxHealSoldierSuccess(count)
    if not _C.IsOpen then
        return
    end

    view.TreatSlider.value = count
    TreatProgressOnChanged()
end

function _C:onCreat()
    view = _C.View

    -- top left
    view.BackBtn.onClick:Set(BackBtnOnClick)

    -- top right
    view.UpgradeBtn.onClick:Set(UpgradeBtnOnClick)

    -- left
    view.ConditionList:RemoveChildrenToPool()

    -- right
    view.TrainBtn.onClick:Set(TrainBtnOnClick)
    view.TrainBtn.grayed = true
    view.TrainBtn.touchable = false
    view.TrainSlider.value = 0
    -- 获取最大可招募士兵数量
    NetworkManager.C2SGetMaxRecruitSoldier()
    view.TrainAmount.visible = false
    view.TrainSlider.onChanged:Set(TrainProgressOnChanged)
    view.TrainSubBtn.onTouchBegin:Set(TrainSubBtnOnClick)
    local trainSubGesture = LongPressGesture(view.TrainSubBtn)
    trainSubGesture.interval = UIConfig.LongPressInterval
    trainSubGesture.trigger = UIConfig.LongPressTrigger
    trainSubGesture.onAction:Set(TrainSubBtnOnClick)
    view.TrainAddBtn.onTouchBegin:Set(TrainAddBtnOnClick)
    local trainAddGesture = LongPressGesture(view.TrainAddBtn)
    trainAddGesture.interval = UIConfig.LongPressInterval
    trainAddGesture.trigger = UIConfig.LongPressTrigger
    trainAddGesture.onAction:Set(TrainAddBtnOnClick)

    -- bottom right
    view.TreatBtn.onClick:Set(TreatBtnOnClick)
    view.TreatBtn.grayed = true
    view.TreatBtn.touchable = false
    view.TreatSlider.value = 0
    view.TreatAmount.visible = false
    view.TreatSlider.onChanged:Set(TreatProgressOnChanged)
    view.TreatSubBtn.onTouchBegin:Set(TreatSubBtnOnClick)
    local treatSubGesture = LongPressGesture(view.TreatSubBtn)
    treatSubGesture.interval = UIConfig.LongPressInterval
    treatSubGesture.trigger = UIConfig.LongPressTrigger
    treatSubGesture.onAction:Set(TreatSubBtnOnClick)
    view.TreatAddBtn.onTouchBegin:Set(TreatAddBtnOnClick)
    local treatAddGesture = LongPressGesture(view.TreatAddBtn)
    treatAddGesture.interval = UIConfig.LongPressInterval
    treatAddGesture.trigger = UIConfig.LongPressTrigger
    treatAddGesture.onAction:Set(TreatAddBtnOnClick)

    view.Type_C.onChanged:Set(StateOnChange)

    Event.addListener(Event.SOLDIER_INFO_UPDATE, RefreshUI)
    Event.addListener(Event.CURRENCY_CURRENT_UPDATE, RefreshUI)
    Event.addListener(Event.BARRACK_RECRUIT_SOLDIER_SUCCESS, RecruitSoldierSuccess)
    Event.addListener(Event.BARRACK_HEAL_SOLDIER_SUCCESS, HealSoldierSuccess)
    Event.addListener(Event.BARRACK_GET_MAX_Recruit_SOLDIER_SUCCESS, GetMaxRecruitSoldierSuccess)
    Event.addListener(Event.BARRACK_GET_MAX_HEAL_SOLDIER_SUCCESS, GetMaxHealSoldierSuccess)
end

function _C:onOpen()
    militaryData = DataTrunk.PlayerInfo.MilitaryAffairsData
    currencyData = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo
    playerdata = DataTrunk.PlayerInfo.MonarchsData
    RefreshUI()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    TimerManager.disposeTimer(newSoldierTimer)
    newSoldierTimer = nil
    view.Type_C.onChanged:Clear()

    Event.removeListener(Event.SOLDIER_INFO_UPDATE, RefreshUI)
    Event.removeListener(Event.CURRENCY_CURRENT_UPDATE, RefreshUI)
    Event.removeListener(Event.BARRACK_RECRUIT_SOLDIER_SUCCESS, RecruitSoldierSuccess)
    Event.removeListener(Event.BARRACK_HEAL_SOLDIER_SUCCESS, HealSoldierSuccess)
    Event.removeListener(Event.BARRACK_GET_MAX_Recruit_SOLDIER_SUCCESS, GetMaxRecruitSoldierSuccess)
    Event.removeListener(Event.BARRACK_GET_MAX_HEAL_SOLDIER_SUCCESS, GetMaxHealSoldierSuccess)
end