-- *********************************************************************
-- 商店信息
-- *********************************************************************

-- 商店实例化信息
local ShopData = { }

-- 清空数据
function ShopData:clear()

end

-- 根据一个PrizeClass去寻觅一个物品(我的内心是抗拒的)
-- data:PrizeClass()
function ShopData:GetItemInfoByPrizeData(data)
    if data == nil then
        return
    end

    local item = ItemShowInfo()

    -- 货币类型
    if data.Gold > 0 then
        return item:updateInfo(CurrencyType.Gold, data.Gold, ItemClassifyType.Currency)
    elseif data.Food > 0 then
        return item:updateInfo(CurrencyType.Food, data.Food, ItemClassifyType.Currency)
    elseif data.Wood > 0 then
        return item:updateInfo(CurrencyType.Wood, data.Wood, ItemClassifyType.Currency)
    elseif data.Stone > 0 then
        return item:updateInfo(CurrencyType.Stone, data.Stone, ItemClassifyType.Currency)
    elseif data.MonarchsExp > 0 then
        return item:updateInfo(CurrencyType.MonarchsExp, data.MonarchsExp, ItemClassifyType.Currency)
    elseif data.CaptainExp > 0 then
        return item:updateInfo(CurrencyType.CaptainExp, data.CaptainExp, ItemClassifyType.Currency)
    end

    for k, v in pairs(data.Goods) do
        if v.Amount > 0 then
            return v
        end
    end

    for k, v in pairs(data.Equips) do
        if v.Amount > 0 then
            return v
        end
    end

    for k, v in pairs(data.CaptainSoul) do
        if v.Amount > 0 then
            return v
        end
    end

    for k, v in pairs(data.Gem) do
        if v.Amount > 0 then
            return v
        end
    end
end

-- 联盟商店
-- *****************************************************************************************
-- *****************************************************************************************
-- *****************************************************************************************
-- 更新每日限购数据
-- HeroShopProto 存放着每日限购的物品
--    repeated int32 daily_shop_goods = 1 [packed = false]; // 每日购买物品id
--    repeated int32 daily_buy_times = 2 [packed = false]; // 每日已购买次数次数，用于限购使用
--
-- 收到每日重置消息时候misc.S2C_RESET_DAILY，需要将这里面的数据清空
-- moduleId = 20, msgId = 64
-- id: int // 购买物品id
-- count: int // 已买次数
local function S2CUpdateDailyShopGoodsProto(data)
    if data == nil then
        return
    end

    local propData = DataTrunk.PlayerInfo.MonarchsData.DailyPropInfo

    if propData == nil then
        return
    end

    propData[data.id] = data.count
    Event.dispatch(Event.SHOP_ON_UPDATE_DAILY_SHOP_GOODS)
end
shop_decoder.RegisterAction(shop_decoder.S2C_UPDATE_DAILY_SHOP_GOODS, S2CUpdateDailyShopGoodsProto)

--------------------------------------------------------------------------
-- 购买物品成功
-- ShopProto 存放着每个商店的数据，目前只有帮派商店，以后会慢慢增加
--    int32 type = 1; // 商店类型, 1表示帮派商店
--    repeated ShopGoodsProto goods = 2; // 商品
--
-- 购买成功，如果是限购物品，服务器会主动推送更新每日限购数据消息 update_daily_shop_goods
-- id: int // 商品id，对应ShopGoodsProto.id
-- count: int // 购买个数
local function S2CBuyGoodsProto(data)
    UIManager.showTip( { content = Localization.BuySuccess, result = true })
    Event.dispatch(Event.SHOP_ON_UPDATE_DAILY_SHOP_GOODS)
end
shop_decoder.RegisterAction(shop_decoder.S2C_BUY_GOODS, S2CBuyGoodsProto)

-- 购买失败
local function S2CFailBuyGoodsProto(code)
    UIManager.showNetworkErrorTip(shop_decoder.ModuleID, shop_decoder.S2C_FAIL_BUY_GOODS, code)
end
shop_decoder.RegisterAction(shop_decoder.S2C_FAIL_BUY_GOODS, S2CFailBuyGoodsProto)

return ShopData