local _C = UIManager.Controller(UIManager.ControllerName.ItemTips, UIManager.ViewName.ItemTips)
_C.IsPopupBox = true

local view = nil
-- 道具信息(ItemShowInfo类操作)
local itemInfo = nil

-- 返回
local function btnBack()
    _C:close()
end

-- 更新道具信息
local function updateItemInfo()
    -- icon
    view.Icon.url = itemInfo.Config.Icon
    view.Name.text = itemInfo.Config.Name
    view.Desc.text = itemInfo.Config.Desc
    -- 个数
    view.Amount.text = 0
    if itemInfo.ClassifyType == ItemClassifyType.Currency then
        -- 通货
        view.Amount.text = DataTrunk.PlayerInfo.InternalAffairsData.CurrencyCurrInfo[itemInfo.Id]
        view.Quality.url = UIConfig.Item.DefaultQuality[itemInfo.Config.Quality]
    elseif itemInfo.ClassifyType == ItemClassifyType.Default then
        -- 堆叠道具
        if nil ~= DataTrunk.PlayerInfo.ItemsData.Default[itemInfo.Id] then
            view.Amount.text = DataTrunk.PlayerInfo.ItemsData.Default[itemInfo.Id].Amount
        end
        view.Quality.url = UIConfig.Item.DefaultQuality[itemInfo.Config.Quality]
    elseif itemInfo.ClassifyType == ItemClassifyType.Equip then
        -- 装备
        if nil ~= DataTrunk.PlayerInfo.ItemsData.Equips[itemInfo.Id] then
            view.Amount.text = DataTrunk.PlayerInfo.ItemsData.Equips[itemInfo.Id].Amount
        end
        view.Quality.url = UIConfig.Item.EquipQuality[itemInfo.Config.Quality.Level]
    end
end

function _C:onCreat()
    view = _C.View
end
function _C:onOpen(data)
    if nil == data then
        _C:close()
        return
    end

    itemInfo = data
    updateItemInfo()

    -- 添加监听
    Event.addListener(Event.STAGE_ON_TOUCH_END, btnBack)
end
function _C:onClose()
    -- 移除监听
    Event.removeListener(Event.STAGE_ON_TOUCH_END, btnBack)
end
