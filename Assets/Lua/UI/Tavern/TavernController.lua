local _C = UIManager.Controller(UIManager.ControllerName.Tavern, UIManager.ViewName.Tavern)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
local feteTimer = nil
-- 宴请武将数据
local militaryData = DataTrunk.PlayerInfo.MilitaryAffairsData
-- 寻访武将时间间隔 int
local D = MilitaryCommonConfig.Config.SeekDuration
-- 最多寻访次数 int
local C = MilitaryCommonConfig.Config.SeekMaxTimes
-- 物品数据
local itemData = DataTrunk.PlayerInfo.ItemsData
-- 武将数据
local captainsData = militaryData.Captains
-- 记录卡牌状态 // true 正面 false 反面
local previousState = {
    false,
    false,
    false,
    false,
    false,
    false,
}
-- 绿色强化符物品Id
local greenBillId = 20001
-- 蓝色强化符物品Id
local blueBillId = 20002
-- 紫色强化符物品Id
local purpleBillId = 20003
-- 橙色强化符物品Id
local orangeBillId = 20004

-- 返回按钮
local function BackBtnOnClick()
    _C:close()
end

-- 跳转到武将背包界面
local function GeneralBtnOnClick()
    UIManager.openController(UIManager.ControllerName.General)
end

-- 跳转到武将详情界面
local function IntensifyBtnOnClick()
    if #captainsData == 0 then
        UIManager.showTip( { content = Localization.NoneOfGeneral, result = false })
    else
        UIManager.openController(UIManager.ControllerName.GeneralDetails, 0)
    end
end

-- 宴请按钮
local function FeteBtnOnClick()
    NetworkManager.C2SSeekCaptainProto()
end

-- 点击兑换按钮(根据配表计算强化符数量,打开二次确认面板)
local function ConvertBtnOnClick()
    local billConfig =
    {
        [greenBillId] = 0,
        [blueBillId] = 0,
        [purpleBillId] = 0,
        [orangeBillId] = 0,
    }

    for k, v in pairs(militaryData.SeekedCaptainList) do
        if v == nil then
            break
        end

        for i, j in pairs(CaptainAbilityConfig.Config[v.Ability].SellPrice.Goods) do
            if billConfig[i] ~= nil then
                billConfig[i] = billConfig[i] + j.Amount
            end
        end
    end

    local billData = {
        { icon = ItemsConfig.Config[greenBillId].Icon, count = billConfig[greenBillId] },
        { icon = ItemsConfig.Config[blueBillId].Icon, count = billConfig[blueBillId] },
        { icon = ItemsConfig.Config[purpleBillId].Icon, count = billConfig[purpleBillId] },
        { icon = ItemsConfig.Config[orangeBillId].Icon, count = billConfig[orangeBillId] },
    }

    -- 标题 + 物品列表 + 取消 + 确认
    data = {
        UIManager.PopupStyle.TitleListYesNo,
        title = Localization.TavernConvert,
        listData = billData,
        btnTitle = { Localization.Cancel, Localization.Confirm },
        btnFunc = function() NetworkManager.C2SSellSeekCaptainProto(0) end
    }

    UIManager.openController(UIManager.ControllerName.Popup, data)
end

local function FeteTimerStart()
    view.FeteBtn.touchable = false
    view.FeteBtn.grayed = true
end 

local function FeteTimerUpdate(t, p)
    view.FeteCD.text = Utils.secondConversion(math.ceil(p))
end 

local function FeteTimerComplete()
    view.FeteCD.text = ""
    view.FeteBtn.touchable = true
    view.FeteBtn.grayed = false
end 

-- 更新强化符数量
local function UpdateIntensiveBill()
    local itemInfo = itemData.Default[greenBillId]

    if itemInfo == nil then
        view.GreenBill.title = "0"
    else
        view.GreenBill.title = itemInfo.Amount
    end

    itemInfo = itemData.Default[blueBillId]

    if itemInfo == nil then
        view.BlueBill.title = "0"
    else
        view.BlueBill.title = itemInfo.Amount
    end

    itemInfo = itemData.Default[purpleBillId]

    if itemInfo == nil then
        view.PurpleBill.title = "0"
    else
        view.PurpleBill.title = itemInfo.Amount
    end

    itemInfo = itemData.Default[orangeBillId]

    if itemInfo == nil then
        view.OrangeBill.title = "0"
    else
        view.OrangeBill.title = itemInfo.Amount
    end
end

-- 刷新界面
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    -- 寻访英雄的时间
    local T = DataTrunk.PlayerInfo.MilitaryAffairsData.CaptainGenTime
    -- 当前宴请次数
    local currTimes = math.ceil(C -((math.max(T - TimerManager.currentTime, 0) + D - 1) / D))
    view.TheRestTimes.text = currTimes

    -- 最大宴请次数
    if currTimes == C then
        view.Tips.icon = UIConfig.RedTipsBg
        view.Tips.title = Localization.TavernFull
    else
        view.Tips.icon = UIConfig.GreenTipsBg
        view.Tips.title = Localization.TavernTips
    end

    -- 宴请次数为0时,打开计时器.(秒数为临时测试数据)
    local second =((T - TimerManager.currentTime) % D + D) % D
    if currTimes == 0 then
        feteTimer = TimerManager.newTimer(second, false, true, FeteTimerStart, FeteTimerUpdate, FeteTimerComplete)
        feteTimer:start()
    end

    if Utils.GetTableLength(militaryData.SeekedCaptainList) == 0 then
        view.State_C.selectedIndex = 0
    else
        view.State_C.selectedIndex = 1

        for k, v in pairs(militaryData.SeekedCaptainList) do
            if v == nil then
                break
            end

            -- v.Index 很关键
            local card = view.CardList[v.Index]

            local cardInfo = card:GetChild("Component_GeneralCard"):GetChild("Component_General")
            -- 成长值
            -- cardInfo:GetChild("Text_Ability").text = Localization.GrowthValue .. v.Ability
            -- 名字
            cardInfo:GetChild("Text_Name").text = v.Name
            -- 头像
            cardInfo:GetChild("Label_GeneralIcon").icon = v.BigHead
            -- 职业
            cardInfo:GetChild("Label_SoldierType").icon = UIConfig.Race[v.Race]
            -- 品质
            cardInfo:GetController("Quality_C").selectedIndex = v.Quality - 1

            if not previousState[v.Index] then
                card:GetTransition("Turn_T"):Play()
            end

            card.onClick:Set(
            function()
                NetworkManager.C2SRecruitCaptainProto(v.Index)
            end )

            previousState[v.Index] = true
        end
    end
end

-- 招募成功
-- data // id 索引, 从1开始的
local function RecruitGeneralSuccess(id)
    if not _C.IsOpen then
        return
    end

    previousState[id] = false
    local card = view.CardList[id]
    card:GetTransition("Fete_T"):Play()
    card.onClick:Clear()
    -- 检查当前招募数量
    if Utils.GetTableLength(militaryData.SeekedCaptainList) == 0 then
        view.State_C.selectedIndex = 0
    else
        view.State_C.selectedIndex = 1
    end
end

-- 兑换成功
local function ConvertSuccess()
    if not _C.IsOpen then
        return
    end

    -- 更新强化符
    UpdateIntensiveBill()
    -- 控制器状态还原
    view.State_C.selectedIndex = 0
    -- 播放动效
    for k, v in pairs(previousState) do
        if v == true then
            previousState[k] = false
            local card = view.CardList[k]
            card:GetTransition("Convert_T"):Play()
            card.onClick:Clear()
        end
    end
end

function _C:onCreat()
    view = _C.View

    -- top left
    view.BackBtn.onClick:Set(BackBtnOnClick)

    -- top right
    view.RelationBtn.onClick:Set( function()
        UIManager.openController(UIManager.ControllerName.MutualRestraint)
    end )

    -- bottom left
    view.GeneralBtn.onClick:Set(GeneralBtnOnClick)
    view.IntensifyBtn.onClick:Set(IntensifyBtnOnClick)

    -- bottom right
    view.FeteBtn.onClick:Set(FeteBtnOnClick)
    view.ConvertBtn.onClick:Set(ConvertBtnOnClick)

    Event.addListener(Event.SEEK_CAPTAIN_UPDATE, RefreshUI)
    Event.addListener(Event.RECRUIT_CAPTAIN_SUCCESS, RecruitGeneralSuccess)
    Event.addListener(Event.SELL_SEEK_CAPTAIN_SUCCESS, ConvertSuccess)
end

function _C:onOpen()
    UpdateIntensiveBill()
    RefreshUI()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)      
    end
end

function _C:onDestroy()
    TimerManager.disposeTimer(feteTimer)
    feteTimer = nil
    Event.removeListener(Event.SEEK_CAPTAIN_UPDATE, RefreshUI)
    Event.removeListener(Event.RECRUIT_CAPTAIN_SUCCESS, RecruitGeneralSuccess)
    Event.removeListener(Event.SELL_SEEK_CAPTAIN_SUCCESS, ConvertSuccess)
end
