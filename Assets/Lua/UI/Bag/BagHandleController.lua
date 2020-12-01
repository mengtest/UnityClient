local _C = UIManager.SubController(UIManager.ControllerName.BagHandle, nil)
_C.view = nil

local itemClick = { ctrl = nil, bagType = nil, item = nil, insInfo = nil }
-- 道具使用个数上限
local itemUseCountLimit = 0

-- 道具使用回复
local function itemUseAck(insId)
    if not _C.IsOpen then
        return
    end

    -- 刷新
    if nil == itemClick.insInfo or itemClick.insInfo.Amount <= 0 then
        _C.view:stopEffect()
        itemClick.ctrl:refreshVirtualList()
    else
        itemClick.ctrl:updateItemInfo(itemClick.item, itemClick.insInfo)

        -- 更新使用
        _C.view.ItemUseAmount.max = itemClick.insInfo.Amount
        _C.view.ItemUseAmount.value = 1
    end
end

-- item使用
local function btnItemUse()
    if itemClick.bagType == 0 then
        if itemClick.insInfo.Config.Type == ItemType.Resource or itemClick.insInfo.Config.Type == ItemType.Accelerate then
            -- 道具使用同步数据
            local count = math.floor(_C.view.ItemUseAmount.value + 0.5)
            if count > 0 then
                NetworkManager.NewC2sUseGoodsMsg(itemClick.insInfo.InsId, count)
            else
                if itemUseCountLimit > 0 then
                    -- ui提示
                    UIManager.showTip( { content = Localization.BagResourceItemUseFail, result = false })
                else
                    -- ui提示
                    UIManager.showTip( { content = Localization.BagSelectedItemEmpty, result = false })
                end
            end
        elseif itemClick.insInfo.Config.Type == ItemType.BaseMove then
            UIManager.showTip( { content = "前往迁城界面", result = false })
        end
    elseif itemClick.bagType == 1 then
        UIManager.openController(UIManager.ControllerName.CaptainEquipMain)
    elseif itemClick.bagType == 2 then
        UIManager.openController(UIManager.ControllerName.CaptainEquipMain)
    elseif itemClick.bagType == 3 then
        UIManager.openController(UIManager.ControllerName.Smithy)
    end
end
-- item使用上限
local function resourceItemUseLimit()
    -- 道具效果
    local goldAdd = itemClick.insInfo.Config.Effect.Gold
    local foodAdd = itemClick.insInfo.Config.Effect.Food
    local woodAdd = itemClick.insInfo.Config.Effect.Wood
    local stoneAdd = itemClick.insInfo.Config.Effect.Stone

    -- 当前资源
    local curGold = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo[CurrencyType.Gold]
    local curFood = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo[CurrencyType.Food]
    local curWood = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo[CurrencyType.Wood]
    local curStone = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo[CurrencyType.Stone]

    -- 资源上限
    local goldLimit = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyLimitInfo[CurrencyType.Gold]
    local foodLimit = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyLimitInfo[CurrencyType.Food]
    local woodLimit = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyLimitInfo[CurrencyType.Wood]
    local stoneLimit = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyLimitInfo[CurrencyType.Stone]

    itemUseCountLimit = 0
    -- 二分法判断可使用道具最大个数
    local left, right, mid = 0, itemClick.insInfo.Amount, 0
    local gold, food, wood, stone
    while (left <= right) do
        mid = math.floor((left + right) / 2)

        gold = curGold + goldAdd * mid
        food = curFood + foodAdd * mid
        wood = curWood + woodAdd * mid
        stone = curStone + stoneAdd * mid

        if food >= foodLimit or wood >= woodLimit or stone >= stoneLimit or gold >= goldLimit then
            if food - foodAdd < foodLimit and wood - woodAdd < woodLimit and stone - stoneAdd < stoneLimit and gold - goldAdd < goldLimit then
                -- 允许使用的最大道具个数
                itemUseCountLimit = mid - 1
                return
            else
                right = mid - 1
            end
        else
            left = mid + 1
        end
    end
end
-- item点击(bagType： 0标识默认，1表示装备，2表示宝石，3表示临时)
function _C:onItemClick(ctrl, item, insInfo, bagType)
    itemClick.ctrl = ctrl
    itemClick.item = item
    itemClick.insInfo = insInfo
    itemClick.bagType = bagType
    -- 弹出底部面板
    if _C.view.EffectId ~= 1 and nil ~= insInfo then
        _C.view.EffectId = 1
        _C.view.BagEffect:Play()
    end

    -- 为空判断
    if nil ~= insInfo then
        -- 使用状态
        local btnHandleStat = function(bool)
            _C.view.BtnItemUse.grayed = not bool
            _C.view.BtnItemUse.touchable = bool
        end
        -- 更新道具
        local updateItemInfo = function(name, desc, iconRul, qualityUrl)
            _C.view.ItemName.text = name
            _C.view.ItemUseDesc.text = desc
            _C.view.ItemIcon.url = iconRul
            _C.view.ItemQuality.url = qualityUrl
        end

        -- 堆叠道具
        if bagType == 0 then
            updateItemInfo(insInfo.Config.Name, insInfo.Config.Desc, insInfo.Config.Icon, UIConfig.Item.DefaultQuality[insInfo.Config.Quality])
            -- 资源类道具
            if insInfo.Config.Type == ItemType.Resource then
                resourceItemUseLimit()
                _C.view.ItemUseAmount.max = insInfo.Amount
                if itemUseCountLimit > 0 then
                    btnHandleStat(true)
                    _C.view.ItemUseAmount.value = 1
                else
                    btnHandleStat(false)
                    _C.view.ItemUseAmount.value = 0
                end

                _C.view.BtnItemUse.title = Localization.ItemUseDefault
                _C.view.ItemUseStat.selectedIndex = 2
                return
            end
            -- 普通迁城道具
            if insInfo.Config.Type == ItemType.BaseMove then
                _C.view.BtnItemUse.title = Localization.ItemUseBaseMove
                _C.view.ItemUseStat.selectedIndex = 3
                btnHandleStat(true)
                return
            end
            -- 高级迁城或加速道具
            if insInfo.Config.Type == ItemType.AdvancedMove or insInfo.Config.Type == ItemType.Accelerate then
                _C.view.ItemUseStat.selectedIndex = 4
                return
            end
            -- 其他道具
            _C.view.ItemUseStat.selectedIndex = 4

            return
        end
        -- 装备
        if bagType == 1 then
            updateItemInfo(insInfo.Config.Name, insInfo.Config.Desc, insInfo.Config.Icon, UIConfig.Item.EquipQuality[insInfo.Config.Quality.Level])
            _C.view.BtnItemUse.title = Localization.ItemUseEquip
            _C.view.ItemUseStat.selectedIndex = 3
            btnHandleStat(true)
            return
        end
        -- 宝石
        if bagType == 2 then
            updateItemInfo(insInfo.Config.Name, insInfo.Config.Desc, insInfo.Config.Icon, UIConfig.Item.DefaultQuality[insInfo.Config.Quality])
            _C.view.BtnItemUse.title = Localization.ItemUseInlay
            _C.view.ItemUseStat.selectedIndex = 3
            btnHandleStat(true)
            return
        end
        -- 临时装备
        if bagType == 3 then
            updateItemInfo(insInfo.Config.Name, insInfo.Config.Desc, insInfo.Config.Icon, UIConfig.Item.EquipQuality[insInfo.Config.Quality.Level])
            _C.view.BtnItemUse.title = Localization.ItemUseMelting
            _C.view.ItemUseStat.selectedIndex = 1
            btnHandleStat(true)
            return
        end
    end
end
-- 道具使用滑动
local function scrollEndItemUsa()
    if _C.view.ItemUseAmount.value > itemUseCountLimit then
        _C.view.ItemUseAmount.value = itemUseCountLimit
        print("将超出仓库上限！！！")
    end
end
-- 道具使用增加
local function btnItemUsaAdd()
    _C.view.ItemUseAmount.value = _C.view.ItemUseAmount.value + 1
    -- 判断上限
    scrollEndItemUsa()
end
-- 道具使用减少
local function btnItemUsaSubtract()
    local value = _C.view.ItemUseAmount.value - 1
    if value < 0 then
        value = 0
    end
    _C.view.ItemUseAmount.value = value
end
function _C:onCreat()
    _C.view.BtnItemUse.onClick:Set(btnItemUse)
    _C.view.ItemUseAmount.onGripTouchEnd:Set(scrollEndItemUsa)
    _C.view.ItemUseBtnAdd.onClick:Set(btnItemUsaAdd)
    _C.view.ItemUseBtnSubtract.onClick:Set(btnItemUsaSubtract)

    Event.addListener(Event.ITEM_USE_SUCCEED, itemUseAck)
end
function _C:onDestroy()
    _C.view.BtnItemUse.onClick:Clear()
    _C.view.ItemUseAmount.onGripTouchEnd:Clear()
    _C.view.ItemUseBtnAdd.onClick:Clear()
    _C.view.ItemUseBtnSubtract.onClick:Clear()

    Event.removeListener(Event.ITEM_USE_SUCCEED, itemUseAck)
end
return _C
