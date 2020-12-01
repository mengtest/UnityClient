local _C = UIManager.SubController(UIManager.ControllerName.AllianceShopController, nil)

local view = nil
-- 联盟数据
local allianceData = DataTrunk.PlayerInfo.AllianceData
-- 商店数据
local shopData = DataTrunk.PlayerInfo.ShopData
-- 君主数据
local monarchData = DataTrunk.PlayerInfo.MonarchsData
-- 商店类型(1为联盟商店)
local shopType = 1
-- 当前道具数据
local currItemData = nil
-- 当前道具数量
local currPropAmount = 0
-- 一组有几个item
local countInGroup = 3

-- 计算组内有几个item
-- index:第几组(从0开始)
local function CalculateCount(index)
    if index == nil or type(index) ~= "number" then
        return
    end

    -- 这一组最后一个的索引
    local lastIndex =(index + 1) * 3

    if ShopConfig.Config[shopType].Goods[lastIndex] ~= nil then
        return 3
    elseif ShopConfig.Config[shopType].Goods[lastIndex - 1] ~= nil then
        return 2
    end

    return 1
end

-- 更新购买状态
local function UpdateBuyState()
    -- 花费贡献
    local cost = tonumber(view.CostText.text)
    -- 拥有贡献
    local total = monarchData.ContributionCoin

    -- 判断花费
    if cost > total then
        view.BuyBtn.touchable = false
        view.BuyBtn.grayed = true
        view.Cost_C.selectedIndex = 1
    else
        view.BuyBtn.touchable = true
        view.BuyBtn.grayed = false
        view.Cost_C.selectedIndex = 0
    end

    -- 如果购买数量为0
    if currPropAmount == 0 then
        view.BuyBtn.touchable = false
        view.BuyBtn.grayed = true
    end
end

-- 重置选中项目
local function PropListOnClickItem(context)
    for i = 0, view.PropList.numItems - 1 do
        while true do
            local item = view.PropList:GetChildAt(i)

            if item == context.data then
                break
            end

            item:GetChild("List_ShopProItem"):SelectNone()
            break
        end
    end
end

-- 点击商店物品item
local function PropItemOnClick(context)
    -- 物品数据(ShopGoodsClass())
    local data = context.data.data
    -- 保存数据
    currItemData = data
    -- 显示详情界面
    view.Prop_C.selectedIndex = 1

    -- 0:可购买(不限数量) 1不可购买(售罄/未解锁)
    if context.data:GetController("State_C").selectedIndex == 0 or context.data:GetChild("Text_LimitAmount").text ~= "" then
        view.State_C.selectedIndex = 0
    else
        view.State_C.selectedIndex = 1
    end

    -- 设置道具的文字介绍
    view.PropDesc.text = shopData:GetItemInfoByPrizeData(data.ExchangeData.Prize).Config.Desc
    -- 购买道具数量还原
    currPropAmount = 1
    view.PropAmountInput.text = currPropAmount
    -- 当前道具消耗贡献
    view.CostText.text = data.ExchangeData.Cost.GuildContributionCoin
    UpdateBuyState()
end

local function UpdatePropList()
    -- 清空
    view.PropList:RemoveChildrenToPool()
    -- 设置点击事件
    view.PropList.onClickItem:Clear()
    view.PropList.onClickItem:Add(PropListOnClickItem)

    -- 创建
    for i = 0, math.ceil(Utils.GetTableLength(ShopConfig.Config[shopType].Goods) / countInGroup) -1 do
        local obj = view.PropList:AddItemFromPool(view.PropList.defaultItem)
        -- 物品小列表
        local itemList = obj:GetChild("List_ShopProItem")
        -- 清空
        itemList:RemoveChildrenToPool()

        -- 计算数量之后增加item
        for j = 1, CalculateCount(i) do
            local item = itemList:AddItemFromPool(itemList.defaultItem)
            -- ShopGoodsClass()
            local data = ShopConfig.Config[shopType].Goods[i * countInGroup + j]
            -- 保存数据
            item.data = data
            -- 道具的UI展示信息(ItemShowInfo)
            local uiData = shopData:GetItemInfoByPrizeData(data.ExchangeData.Prize)

            if data == nil or uiData == nil then
                return
            end

            -- 0:正常 1.限购 2.售罄 3.未解锁
            local state_C = item:GetController("State_C")
            -- 这里先把文本置空,留到下面用
            item:GetChild("Text_LimitAmount").text = ""

            -- 判断是否需要解锁前置条件
            -- UnLockCondition(UnlockConditionClass)
            -- 君主等级\主城等级\联盟等级
            if data.UnLockCondition.RequireHeroLevel > monarchData.Level then
                state_C.selectedIndex = 3
                item:GetChild("Text_UnlockCondition").text = string.format(Localization.RequireHeroLevelToUnlock, data.UnLockCondition.RequireHeroLevel)
            elseif data.UnLockCondition.RequireBaseLevel > monarchData.BaseLevel then
                state_C.selectedIndex = 3
                item:GetChild("Text_UnlockCondition").text = string.format(Localization.RequireBaseLevelToUnlock, data.UnLockCondition.RequireBaseLevel)
            elseif data.UnLockCondition.RequireGuildLevel > allianceData.MyAlliance.Level then
                state_C.selectedIndex = 3
                item:GetChild("Text_UnlockCondition").text = string.format(Localization.RequireGuildLevelToUnlock, data.UnLockCondition.RequireGuildLevel)
            else
                -- 判断是不是限购
                if data.CountLimit == 0 then
                    state_C.selectedIndex = 0
                else
                    -- 可购买次数
                    local currTimes = data.CountLimit

                    -- 计算一下当前的可购买次数去显示在限购数量上
                    if monarchData.DailyPropInfo[data.Id] ~= nil then
                        currTimes = currTimes - monarchData.DailyPropInfo[data.Id]
                    end

                    -- 根据次数判断是否售罄
                    if currTimes == 0 then
                        state_C.selectedIndex = 2
                    else
                        state_C.selectedIndex = 1
                        -- 可购买次数
                        item:GetChild("Text_LimitAmount").text = currTimes
                    end
                end
            end

            -- 道具名字
            item:GetChild("Text_Name").text = uiData.Config.Name
            -- 道具icon
            item:GetChild("Loader_Icon").url = uiData.Config.Icon
            -- 道具消耗贡献(目前只消耗贡献)
            item:GetChild("Text_Cost").text = data.ExchangeData.Cost.GuildContributionCoin
        end

        itemList.onClickItem:Clear()
        itemList.onClickItem:Add(PropItemOnClick)
    end
end

-- 更新数据
local function UpdateData()
    if not _C.IsOpen then
        return
    end

    -- 更新商品列表
    UpdatePropList()
    -- 清空选择
    view.PropList:SelectNone()
    -- 控制器还原
    view.Prop_C.selectedIndex = 0
    -- 拥有贡献币
    view.TotalContributionText.text = monarchData.ContributionCoin
end

-- 点击减按钮
local function SubBtnOnClick()
    if currItemData == nil then
        return
    end

    if currPropAmount <= 0 then
        view.PropAmountInput.text = "0"
        return
    end

    currPropAmount = currPropAmount - 1
    view.PropAmountInput.text = currPropAmount
    view.CostText.text = currPropAmount * currItemData.ExchangeData.Cost.GuildContributionCoin
    UpdateBuyState()
end

-- 点击加按钮
local function AddBtnOnClick()
    if currItemData == nil then
        return
    end

    -- 消耗贡献
    local currCost = currItemData.ExchangeData.Cost.GuildContributionCoin
    -- 可购买次数
    local currTimes = currItemData.CountLimit

    if currTimes ~= nil and currTimes ~= 0 and(currPropAmount + 1) > currTimes then
        return
    end

    currPropAmount = currPropAmount + 1
    view.PropAmountInput.text = currPropAmount
    view.CostText.text = currPropAmount * currCost
    UpdateBuyState()
end

-- 输入框失焦回调
local function InputOnFocusOut()
    if currItemData == nil then
        return
    end

    -- 如果没输入东西,默认数量为0
    if view.PropAmountInput.text == "" then
        view.PropAmountInput.text = 0
    end

    -- 消耗贡献
    local currCost = currItemData.ExchangeData.Cost.GuildContributionCoin
    -- 用户输入的数量
    local countByUser = tonumber(view.PropAmountInput.text)
    -- 可购买次数
    local currTimes = currItemData.CountLimit

    -- 判断用户输入的数量是否大于可购买数量
    if countByUser ~= nil and countByUser > currTimes and currTimes ~= 0 then
        view.PropAmountInput.text = currTimes
    end

    -- 保存
    currPropAmount = tonumber(view.PropAmountInput.text)
    -- 计算
    view.CostText.text = currCost * currPropAmount
    UpdateBuyState()
end

-- 点击购买按钮
local function BuyBtnOnClick()
    if currItemData == nil then
        return
    end

    NetworkManager.C2SBuyGoodsProto(currItemData.Id, currPropAmount)
end

function _C.RefreshUI()
    UpdateData()
end

function _C:onCreat()
    view = _C.view.ShopPage

    view.SubBtn.onTouchBegin:Set(SubBtnOnClick)
    local subGesture = LongPressGesture(view.SubBtn)
    subGesture.interval = UIConfig.LongPressInterval
    subGesture.trigger = UIConfig.LongPressTrigger
    subGesture.onAction:Set(SubBtnOnClick)
    view.AddBtn.onTouchBegin:Set(AddBtnOnClick)
    local addGesture = LongPressGesture(view.AddBtn)
    addGesture.interval = UIConfig.LongPressInterval
    addGesture.trigger = UIConfig.LongPressTrigger
    addGesture.onAction:Set(AddBtnOnClick)
    view.PropAmountInput.onFocusOut:Set(InputOnFocusOut)
    view.BuyBtn.onClick:Set(BuyBtnOnClick)

    Event.addListener(Event.SHOP_ON_BUY_ALLIANCE_PROP_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_DONATE_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_ON_UPDATE_CONTRIBUTION_COIN, UpdateData)
    Event.addListener(Event.SHOP_ON_UPDATE_DAILY_SHOP_GOODS, UpdateData)
end

function _C:onDestroy()
    Event.removeListener(Event.SHOP_ON_BUY_ALLIANCE_PROP_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_DONATE_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_ON_UPDATE_CONTRIBUTION_COIN, UpdateData)
    Event.removeListener(Event.SHOP_ON_UPDATE_DAILY_SHOP_GOODS, UpdateData)
end

return _C