local _C = UIManager.Controller(UIManager.ControllerName.Warehouse, UIManager.ViewName.Warehouse)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
local protectedValue = nil

local function BackBtnOnClick()
    UIManager.openController(UIManager.ControllerName.MainCity)
end

local function UpdateResBar(bar, value, max)
    bar.value.text = value
    bar.max.text = max

    if value < protectedValue then
        bar.proBar.value = value
    else
        bar.proBar.value = protectedValue
    end

    bar.proBar.max = max
    bar.curBar.value = value
    bar.curBar.max = max
    bar.exBar.value, view.FoodBar.exBar.max = max, max

    if value ~= nil and max ~= nil then
        bar.exBar.visible =(value > max)
    end

    if value >= max then
        view.Tips.visible = true
    end
end

-- 更新仓库数据（等级）
local function UpdateWarehouseData()
    local data = DataTrunk.PlayerInfo.InternalAffairsData.BuildingsInfo

    for k, v in pairs(data) do
        if v.BuildingType == BuildingType.Warehouse then
            view.WarehouseLev.text = v.Level
        end
    end
end

local function UpdateCurrenyData()
    if not _C.IsOpen then
        return
    end

    local currData = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo
    local limitData = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyLimitInfo
    protectedValue = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyProtectedInfo
    view.ProtectedAmount.text = protectedValue
    view.Tips.visible = false
    -- food
    UpdateResBar(view.FoodBar, currData[CurrencyType.Food], limitData[CurrencyType.Food])
    -- coin
    UpdateResBar(view.CoinBar, currData[CurrencyType.Gold], limitData[CurrencyType.Gold])
    -- wood
    UpdateResBar(view.WoodBar, currData[CurrencyType.Wood], limitData[CurrencyType.Wood])
    -- stone
    UpdateResBar(view.StoneBar, currData[CurrencyType.Stone], limitData[CurrencyType.Stone])
end

function _C:onCreat()
    view = _C.View
    -- top left
    view.BackBtn.onClick:Set(BackBtnOnClick)

    Event.addListener(Event.CURRENCY_CURRENT_UPDATE, UpdateCurrenyData)
    Event.addListener(Event.CURRENCY_LIMIT_AND_PROTECTED_UPDATE, UpdateCurrenyData)
end

function _C:onOpen(data)
    UpdateWarehouseData()
    UpdateCurrenyData()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)      
    end
end

function _C:onDestroy()
    Event.removeListener(Event.CURRENCY_CURRENT_UPDATE, UpdateCurrenyData)
    Event.removeListener(Event.CURRENCY_LIMIT_AND_PROTECTED_UPDATE, UpdateCurrenyData)
end