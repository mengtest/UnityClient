local militaryAffairsData = require "Data.MilitaryAffairsData"
local internalAffairsData = require "Data.InternalAffairsData"
---------------------------------------------------------------
--- 道具信息----------------------------------------------------
---------------------------------------------------------------

-- 道具实例化信息--
local ItemsData = { }
-- 缺省--
ItemsData.Default = { }
-- 装备--
ItemsData.Equips = { }
-- 宝石--
ItemsData.Gems = { }
-- 临时--
ItemsData.Temp = { }
-- 套装
ItemsData.SmithyCombineSuits = { }
-- 清除--
function ItemsData:clear()
    self.Default = { }
    self.Equips = { }
    self.Gems = { }
    self.Temp = { }
    self.SmithyCombineSuits = { }
end
-- 更新道具信息--
function ItemsData:updateInfo(data)
    -- 普通使用物品（堆叠起来那种），key是id，value是个数
    for k, v in ipairs(data.goods) do
        if GemDataConfig:getConfigById(v.key) == nil then
            print("拥有堆叠道具：", v.key)
            local item = ItemInsInfo()
            item:updateInfo(v)
            self.Default[item.InsId] = item
        else
            print("拥有宝石道具：", v.key)
            local item = GemInsInfo()
            item:updateInfo(v)
            self.Gems[item.InsId] = item
        end
    end
    -- 装备道具
    for k, v in ipairs(data.equipments) do
        print("拥有装备道具：", v.id)
        local item = EquipInsInfo()
        item:updateInfo(v)
        self.Equips[item.InsId] = item
    end
    -- 临时背包过期时间，key是装备id，value是过期删除时间
    for k, v in ipairs(data.temp_expired_time) do
        print("拥有临时装备道具：", v.key)
        local item = self.Equips[v.key]
        if nil ~= item then
            -- 从装备中移除
            self.Equips[v.key] = nil

            -- 加入临时背包
            item.Timer = TimerManager.waitTodo(v.value - TimerManager.currentTime, 1)
            self.Temp[item.InsId] = item
        end
    end
end    

-- 检查是否有该类型的装备
function ItemsData:checkEquipExists(equipType)
    for k, v in pairs(self.Equips) do
        if v.Config.Type == equipType then
            return true
        end
    end

    return false
end
-- 检查是否有该类型的道具
function ItemsData:checkItemExists(id, count)
    if self.Default[id] == nil then
        return false
    end
    if count == nil then
        count = 1
    end
    if self.Default[id].Amount >= count then
        return true
    else
        return false
    end
end
-- 共6个滚动panel, 0~6 分别标示 全部 武器 铠甲 护腿 饰品 头盔（与装备类型枚举id不一致，此处做同步）
function ItemsData:getPartEquipType(panelId)
    if panelId == 1 then
        return EquipType.WU_QI
    elseif panelId == 2 then
        return EquipType.KAI_JIA
    elseif panelId == 3 then
        return EquipType.HU_TUI
    elseif panelId == 4 then
        return EquipType.SHI_PIN
    elseif panelId == 5 then
        return EquipType.TOU_KUI
    end
    return 0
end
-- 共6个滚动panel, 0~6 分别标示 全部 武器 铠甲 护腿 饰品 头盔
function ItemsData:getPartEquipPanelId(equipType)
    if equipType == EquipType.WU_QI then
        return 1
    elseif equipType == EquipType.KAI_JIA then
        return 2
    elseif equipType == EquipType.HU_TUI then
        return 3
    elseif equipType == EquipType.SHI_PIN then
        return 4
    elseif equipType == EquipType.TOU_KUI then
        return 5
    end
    return 0
end

-- 更新铁匠铺合成套装
function ItemsData:updateCombineSuit(data)
    if data == nil or data.open_equip_combine == nil then
        return
    end
    for k, v in ipairs(data.open_equip_combine) do
        table.insert(self.SmithyCombineSuits, v)
    end
end

----------------------------------------------------------------
-- 道具相关协议
----------------------------------------------------------------

-- 更新可堆叠道具
local function updateItemDefultInfo(id, count)
    print("堆叠道具更新！！")

    local item = ItemsData.Default[id]
    -- 道具
    if item ~= nil then
        item.Amount = count
        if item.Amount <= 0 then
            ItemsData.Default[id] = nil
        end

        Event.dispatch(Event.ITEM_DEFAULT_UPDATE)
        return
    end
    -- 宝石
    item = ItemsData.Gems[id]
    if item ~= nil then
        item.Amount = count
        if item.Amount <= 0 then
            ItemsData.Gems[id] = nil
        end

        Event.dispatch(Event.ITEM_GEN_UPDATE)
        return
    end

    local itemConfig = ItemsConfig:getConfigById(id)
    if itemConfig ~= nil then
        -- 堆叠道具
        item = ItemInsInfo()
        item.InsId = id
        item.Amount = count
        item.Config = itemConfig
        ItemsData.Default[item.InsId] = item

        -- 更新经验道具
        if item.Config.Type == ItemType.EXP then
            Event.dispatch(Event.ITEM_EXP_UPDATE)
        end
        Event.dispatch(Event.ITEM_DEFAULT_UPDATE)
    else
        -- 宝石
        item = GemInsInfo()
        item.InsId = id
        item.Amount = count
        item.Config = GemDataConfig:getConfigById(id)
        ItemsData.Gems[item.InsId] = item

        Event.dispatch(Event.ITEM_GEN_UPDATE)
    end
end
-- 更新物品个数（可堆叠物品），当物品个数发生变化，收到此消息--moduleId = 11, msgId = 1
-- id: int // 物品id
-- count: int// 物品个数
local function S2CUpdateGoodsProto(data)
    if nil == data then
        return
    end
    updateItemDefultInfo(data.id, data.count)
end
depot_decoder.RegisterAction(depot_decoder.S2C_UPDATE_GOODS, S2CUpdateGoodsProto)

-- 更新多个物品个数（可堆叠物品），当物品个数发生变化，收到此消息--moduleId = 11, msgId = 5
-- id: int // 物品id
-- count: int// 物品个数
local function S2CUpdateMultiGoodsProto(data)
    if nil == data then
        return
    end
    for i = 1, #data.id, 1 do
        updateItemDefultInfo(data.id[i], data.count[i])
    end
end
depot_decoder.RegisterAction(depot_decoder.S2C_UPDATE_MULTI_GOODS, S2CUpdateMultiGoodsProto)

-- # 使用物品（对于可以直接使用的物品而言，如资源类物品）
-- # 这里会发送update_goods 消息更新物品个数，不需要根据使用消息来更新物品个数，做提示就好了--moduleId = 11, msgId = 3
-- id: int // 物品id
-- count: int// 物品个数
local function S2CUseGoodsProto(data)
    Event.dispatch(Event.ITEM_USE_SUCCEED, data.id)
end
depot_decoder.RegisterAction(depot_decoder.S2C_USE_GOODS, S2CUseGoodsProto)

-- # 使用物品失败--moduleId = 11, msgId = 4
-- 11-4-1: 无效的物品id
-- 11-4-2: 无效的物品个数
-- 11-4-3: 物品个数不足
-- 11-4-4: 服务器忙，请稍后再试
-- 11-4-5: 资源已满，无法使用道具增加资源
-- 11-4-6: 发送的物品不能直接使用
local function S2CFailUseGoodsProto(code)
    UIManager.showNetworkErrorTip(depot_decoder.ModuleID, depot_decoder.S2C_FAIL_USE_GOODS, code)
end
depot_decoder.RegisterAction(depot_decoder.S2C_FAIL_USE_GOODS, S2CFailUseGoodsProto)

-- 使用减cd道具--moduleId = 11, msgId = 7
-- id: int // 物品id
-- count: int// 使用物品个数(这个数字可能少于客户端发的使用个数，因为服务器判断不能使用这么多)
-- cdr_type: int//  减cd类型，0-建筑 1-科技
-- index: int// 索引
-- cooldown: int// 最新的cd时间，unix时间戳（秒）
local function S2CUseCdrGoodsProto(data)
    if data.cdr_type == 0 then
        print("使用建筑减CD道具成功")
        internalAffairsData.BuildersTimeoutInfo[data.index + 1] = data.cooldown
    elseif data.cdr_type == 1 then
        print("使用科技减CD道具成功")
        internalAffairsData.TechnicianTimeOutInfo[data.index + 1] = data.cooldown
    end

    -- Tips提示
    UIManager.showTip( { content = string.format(Localization.UseSpeedupPropSuccess, math.floor(ItemsConfig:getConfigById(data.id).Effect.Cdr / 60)), result = true })

    Event.dispatch(Event.ITEM_USE_SUCCEED, data.id)
    Event.dispatch(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS)
end
depot_decoder.RegisterAction(depot_decoder.S2C_USE_CDR_GOODS, S2CUseCdrGoodsProto)

-- 使用减cd道具失败--moduleId = 11, msgId = 8
-- 11-8-1: 无效的物品id
-- 11-8-2: 无效的物品个数
-- 11-8-3: 物品个数不足
-- 11-8-4: 发送的物品id不是减cd道具
-- 11-8-5: 服务器忙，请稍后再试
-- 11-8-6: 物品不是这个类型的减cd物品
-- 11-8-7: 当前不处于cd状态
-- 11-8-8: 无效的索引
local function S2CFailUseCdrGoodsProto(code)
    UIManager.showNetworkErrorTip(depot_decoder.ModuleID, depot_decoder.S2C_FAIL_USE_CDR_GOODS, code)
end
depot_decoder.RegisterAction(depot_decoder.S2C_FAIL_USE_CDR_GOODS, S2CFailUseCdrGoodsProto)

-- 合成成功
local function S2CGoodsCombineSucess(data)
    Event.dispatch(Event.SMITHY_COMBINE_SUIT_SUCCESS)
end
depot_decoder.RegisterAction(depot_decoder.S2C_GOODS_COMBINE, S2CGoodsCombineSucess)

-- 合成失败
-- goods_not_enough: 物品不够
-- combine_not_found: 合成没找到
-- combine_count_invalid: 合成数量非法
local function S2CGoodsCombineFail(data)
    UIManager.showNetworkErrorTip(depot_decoder.ModuleID, depot_decoder.S2C_FAIL_GOODS_COMBINE, data)
end
depot_decoder.RegisterAction(depot_decoder.S2C_FAIL_GOODS_COMBINE, S2CGoodsCombineFail)

-- 增加装备道具--moduleId = 12, msgId = 18
-- data: bytes // shared_proto.EquipmentProto
local function S2CAddEquipmentProto(data)
    local equip = shared_pb.EquipmentProto()
    equip:ParseFromString(data.data)

    local item = ItemsData.Equips[equip.id]
    if item == nil then
        item = EquipInsInfo()
    end
    item:updateInfo(equip)
    ItemsData.Equips[equip.id] = item

    Event.dispatch(Event.ITEM_EQUIP_UPDATE)

    print("增加装备道具！！！", equip.id)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_ADD_EQUIPMENT, S2CAddEquipmentProto)

-- 增加带过期的装备道具--moduleId = 12, msgId = 34
-- data: bytes // shared_proto.EquipmentProto
local function S2CAddEquipmentWithExpireTimeProto(data)
    local equip = shared_pb.EquipmentProto()
    equip:ParseFromString(data.data)

    local item = ItemsData.Temp[equip.id]
    if item == nil then
        item = EquipInsInfo()
    end
    item:updateInfo(equip)
    item.Timer = TimerManager.waitTodo(data.expire_time, 1)
    ItemsData.Temp[equip.id] = item

    Event.dispatch(Event.ITEM_TEMP_UPDATE)

    print("增加临时装备道具！！！", equip.id)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_ADD_EQUIPMENT_WITH_EXPIRE_TIME, S2CAddEquipmentWithExpireTimeProto)

-- 熔炼装备--moduleId = 12, msgId = 11
-- equipment_id :int  // 装备id
local function S2CSmeltEquipmentProto(data)
    for k, v in ipairs(data.equipment_id) do
        if ItemsData.Equips[v] ~= nil then
            ItemsData.Equips[v] = nil
        end
        if ItemsData.Temp[v] ~= nil then
            ItemsData.Temp[v] = nil
        end
    end
    Event.dispatch(Event.SMITHY_SMELT_SUCCEED)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_SMELT_EQUIPMENT, S2CSmeltEquipmentProto)

-- 熔炼装备失败--moduleId = 12, msgId = 12
-- 12-12-1: 无效的装备id
local function S2CFailSmeltEquipmentProto(code)
    UIManager.showNetworkErrorTip(equipment_decoder.ModuleID, equipment_decoder.S2C_FAIL_SMELT_EQUIPMENT, code)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_FAIL_SMELT_EQUIPMENT, S2CFailSmeltEquipmentProto)

-- 重铸装备--moduleId = 12, msgId = 14
-- equipment_id :int  // 装备id
local function S2CRebuildEquipmentProto(data)
    for k, v in ipairs(data.equipment_id) do
        if ItemsData.Equips[v] ~= nil then
            ItemsData.Equips[v].Level = 1
            ItemsData.Equips[v].RefinedLevel = 0
        end
        if ItemsData.Temp[v] ~= nil then
            ItemsData.Equips[v].Level = 1
            ItemsData.Equips[v].RefinedLevel = 0
        end
    end
    Event.dispatch(Event.SMITHY_SRBUILD_SUCCEED)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_REBUILD_EQUIPMENT, S2CRebuildEquipmentProto)

-- 重铸装备失败--moduleId = 12, msgId = 15
-- 12-15-1: 无效的装备id
-- 12-15-2: 装备没有升级和强化
local function S2CFailRebuildEquipmentProto(code)
    UIManager.showNetworkErrorTip(equipment_decoder.ModuleID, equipment_decoder.S2C_FAIL_REBUILD_EQUIPMENT, code)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_FAIL_REBUILD_EQUIPMENT, S2CFailRebuildEquipmentProto)

-- 换装备--moduleId = 12, msgId = 2
-- captain_id: int; // 武将id
-- up_id: int; // 穿的装备id（将这件装备给武将穿上），0表示没有穿装备
-- down_id: int; // 脱的装备id（将这件装备放回背包），0表示没有脱
local function S2CWearEquipmentProto(data)
    -- 脱掉的装备实例化Id
    local equipType = nil
    local captainIns = militaryAffairsData.Captains[data.captain_id]
    if 0 ~= data.down_id then
        local equipInCaptain = captainIns:getEquipById(data.down_id)
        equipType = equipInCaptain.Config.Type
        -- 放进背包
        ItemsData.Equips[data.down_id] = equipInCaptain
        captainIns.Equips[equipInCaptain.Config.Type] = nil
    end
    -- 穿上的装备实例化Id
    if 0 ~= data.up_id then
        local equipInBag = ItemsData.Equips[data.up_id]
        equipType = equipInBag.Config.Type
        captainIns.Equips[equipInBag.Config.Type] = equipInBag
        -- 从背包中移除
        ItemsData.Equips[data.up_id] = nil
    end
    -- 套装更改
    captainIns.EquipTaoZ = EquipTaozConfig:getConfigById(data.taoz)

    print("套装：", data.taoz, captainIns.EquipTaoZ)
    Event.dispatch(Event.EQUIP_REPLACE_SUCCEED, equipType)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_WEAR_EQUIPMENT, S2CWearEquipmentProto)

-- 换装备失败--moduleId = 12, msgId = 3
-- 12-3-1: 无效的武将id
-- 12-3-2: 无效的装备id
-- 12-3-3: 服务器忙，请稍后再试
-- 12-3-4: 武将出征中，不能更换装备
local function S2CFailWearEquipmentProto(code)
    UIManager.showNetworkErrorTip(equipment_decoder.ModuleID, equipment_decoder.S2C_FAIL_WEAR_EQUIPMENT, code)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_FAIL_WEAR_EQUIPMENT, S2CFailWearEquipmentProto)

-- 升级装备--moduleId = 12, msgId = 5
-- captain_id :int // 武将id
-- equipment_id :int  // 装备id
-- level :int  // 新等级
local function S2CUpgradeEquipmentProto(data)
    local equipInCaptain = militaryAffairsData.Captains[data.captain_id]:getEquipById(data.equipment_id)
    equipInCaptain.Level = data.level

    Event.dispatch(Event.EQUIP_UPGRADE_SUCCEED, equipInCaptain.Config.Type)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_UPGRADE_EQUIPMENT, S2CUpgradeEquipmentProto)

-- 升级装备失败--moduleId = 12, msgId = 6
-- 12-6-1: 无效的武将id
-- 12-6-2: 无效的装备id
-- 12-6-3: 已达当前最大等级
-- 12-6-4: 消耗不足
-- 12-6-5: 服务器忙，请稍后再试
-- 12-6-6: 武将出征中，不能操作
local function S2CFailUpgradeEquipmentProto(code)
    UIManager.showNetworkErrorTip(equipment_decoder.ModuleID, equipment_decoder.S2C_FAIL_UPGRADE_EQUIPMENT, code)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_FAIL_UPGRADE_EQUIPMENT, S2CFailUpgradeEquipmentProto)

-- 升级武将全部装备--moduleId = 12, msgId = 20
-- captain_id :int // 武将id
-- level :int[]  // 新等级, EquipType [2,0,2]，1 3位置上装备2级，2位置没有装备，4 5位置上装备没升级
local function S2CUpgradeEquipmentAllProto(data)
    local equipType = nil
    local captain = militaryAffairsData.Captains[data.captain_id]
    for i = 1, 5 do
        if data.level[i] ~= nil and data.level[i] ~= 0 then
            equipType = ItemsData:getPartEquipType(i)
            captain.Equips[equipType].Level = data.level[i]

            Event.dispatch(Event.EQUIP_UPGRADE_SUCCEED, equipType)
        end
    end
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_UPGRADE_EQUIPMENT_ALL, S2CUpgradeEquipmentAllProto)

-- 升级武将全部装备失败--moduleId = 12, msgId = 21
-- 12-21-1: 无效的武将id
-- 12-21-2: 没有可以升级的装备
-- 12-21-4: 消耗不足
-- 12-21-5: 武将出征中，不能操作
-- 12-21-6: 服务器忙，请稍后再试
local function S2CFailUpgradeEquipmentAllProto(code)
    UIManager.showNetworkErrorTip(equipment_decoder.ModuleID, equipment_decoder.S2C_FAIL_UPGRADE_EQUIPMENT_ALL, code)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_FAIL_UPGRADE_EQUIPMENT_ALL, S2CFailUpgradeEquipmentAllProto)

-- 强化装备--moduleId = 12, msgId = 8
-- captain_id : int // 武将id
-- equipment_id :int  // 装备id
-- level :int // 新强化等级
local function S2CRefinedEquipmentProto(data)
    local captainIns = militaryAffairsData.Captains[data.captain_id]
    local equipInCaptain = captainIns:getEquipById(data.equipment_id)
    equipInCaptain.RefinedLevel = data.level
    -- 套装更改
    captainIns.EquipTaoZ = EquipTaozConfig:getConfigById(data.taoz)

    Event.dispatch(Event.EQUIP_REFINE_SUCCEED, equipInCaptain.Config.Type)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_REFINED_EQUIPMENT, S2CRefinedEquipmentProto)

-- 强化装备失败--moduleId = 12, msgId = 9
-- 12-9-1: 无效的武将id
-- 12-9-2: 无效的装备id
-- 12-9-3: 已达当前最大等级
-- 12-9-4: 消耗不足
-- 12-9-5: 服务器忙，请稍后再试
-- 12-9-6: 武将出征中，不能操作
local function S2CFailRefinedEquipmentProto(code)
    UIManager.showNetworkErrorTip(equipment_decoder.ModuleID, equipment_decoder.S2C_FAIL_REFINED_EQUIPMENT, code)
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_FAIL_REFINED_EQUIPMENT, S2CFailRefinedEquipmentProto)

-- 更新武将装备信息--moduleId = 12, msgId = 25
-- bytes data // shared_proto.EquipmentProto
local function S2CUpdateEquipmentProto(data)
    -- 装备信息
    local equip = shared_pb.EquipmentProto()
    equip:ParseFromString(data.data)

    -- 更新
    local equipIns = ItemsData.Equips[equip.id]
    if equipIns ~= nil then
        -- 背包中
        equipIns:updateInfo(equip)
        -- 信息更新完成
        Event.dispatch(Event.EQUIP_INFO_UPDATE_COMPLETE, equipIns)
    else
        -- 武将身上
        Event.dispatch(Event.EQUIP_INFO_UPDATE, equip)
    end
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_UPDATE_EQUIPMENT, S2CUpdateEquipmentProto)

-- 更新武将装备信息--moduleId = 12, msgId = 26
-- repeated bytes data // shared_proto.EquipmentProto
local function S2CUpdateMultiEquipmentProto(data)
    -- 装备信息
    local equip
    for k, v in ipairs(data.data) do
        equip = shared_pb.EquipmentProto()
        equip:ParseFromString(v)

        -- 更新
        local equipIns = ItemsData.Equips[equip.id]
        if equipIns ~= nil then
            -- 背包中
            equipIns:updateInfo(equip)
        else
            -- 武将身上
            Event.dispatch(Event.EQUIP_INFO_UPDATE, equip)
        end
    end
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_UPDATE_MULTI_EQUIPMENT, S2CUpdateMultiEquipmentProto)

-- ************************************套装*******************************
-- 更新开放的套装信息
local function S2COpenEquipCombineProto(data)
    if ItemsData.SmithyCombineSuits ~= nil then
        table.insert(ItemsData.SmithyCombineSuits, data.id, data.id)
        Event.dispatch(Event.SMITHY_COMBINE_SUITS)
    end
end
equipment_decoder.RegisterAction(equipment_decoder.S2C_OPEN_EQUIP_COMBINE, S2COpenEquipCombineProto)

-- 镶嵌/卸下宝石
-- captain_id: int // 武将id
-- slot_idx: int // 卸下哪个槽位的宝石或者给哪个槽位加上宝石，即：GemSlotDataProto.slot_idx
-- up_id: int // 该槽位上面的新的宝石id：0表示卸下了，非0表示设置的新的宝石
local function S2CUseGemProto(data)
    -- 镶嵌宝石
    if data.up_id ~= nil and data.up_id ~= 0 then
        local gemItem = GemDataConfig:getConfigById(data.up_id)
        if gemItem ~= nil then
            DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[data.captain_id].Gems[data.slot_idx] = gemItem
        end
    end
    -- 卸下宝石
    if data.up_id ~= nil and data.up_id == 0 then
        DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[data.captain_id].Gems[data.slot_idx] = nil
    end
    Event.dispatch(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, data)
end
gem_decoder.RegisterAction(gem_decoder.S2C_USE_GEM, S2CUseGemProto)

-- 装卸宝石失败
local function S2CFailUseGemProto(data)
    UIManager.showNetworkErrorTip(gem_decoder.ModuleID, gem_decoder.S2C_FAIL_USE_GEM, data)
end
gem_decoder.RegisterAction(gem_decoder.S2C_FAIL_USE_GEM, S2CFailUseGemProto)

-- 一键镶嵌/卸下宝石
-- captain_id: int // 武将id
-- down_all: bool // 卸下所有(true)卸下所有不需要读取后面的数据了客户端完全清空掉该武将的宝石就好了/自动镶嵌(false)
-- gem_id: int[] // 各个槽位上面新的宝石id，如果是卸下所有，长度为0，客户端不需要处理，如果是自动镶嵌，该数组跟槽位一一对应，该数据中可能会存在为0的数据，表示没有宝石
local function S2COneKeyUseGemProto(data)
    if data.down_all then
        for k, v in ipairs(GemSlotDataConfig.Config) do
            DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[data.captain_id].Gems[k] = nil
        end
    else
        for k, v in ipairs(data.gem_id) do
            DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[data.captain_id].Gems[k - 1] = GemDataConfig:getConfigById(v)
        end
    end
    Event.dispatch(Event.DECORATE_OR_RELEASE_GEM_SUCCESS, data)
end
gem_decoder.RegisterAction(gem_decoder.S2C_ONE_KEY_USE_GEM, S2COneKeyUseGemProto)

-- 一键镶嵌/卸下宝石失败
local function S2CFailOneKeyUseGemProto(data)
    UIManager.showNetworkErrorTip(gem_decoder.ModuleID, gem_decoder.S2C_FAIL_ONE_KEY_USE_GEM, data)
end
gem_decoder.RegisterAction(gem_decoder.S2C_FAIL_ONE_KEY_USE_GEM, S2CFailOneKeyUseGemProto)

-- 合成宝石成功
-- captain_id: int // 武将id
-- slot_idx: int // 合成到哪个槽位的宝石上，即：GemSlotDataProto.slot_idx
-- gem_id: int // 新的宝石id
local function S2CCombineGemProto(data)
    DataTrunk.PlayerInfo.MilitaryAffairsData.Captains[data.captain_id].Gems[data.slot_idx] = GemDataConfig:getConfigById(data.gem_id)
    Event.dispatch(Event.COMBINE_GEM_SUCCESS, data)
end
gem_decoder.RegisterAction(gem_decoder.S2C_ONE_KEY_COMBINE_GEM, S2CCombineGemProto)

-- 合成宝石失败
local function S2CFailCombineGemProto(data)
    UIManager.showNetworkErrorTip(gem_decoder.ModuleID, gem_decoder.S2C_FAIL_ONE_KEY_COMBINE_GEM, data)
end
gem_decoder.RegisterAction(gem_decoder.S2C_FAIL_ONE_KEY_COMBINE_GEM, S2CFailCombineGemProto)

-- 获取宝石合成消耗
-- captain_id: int // 武将id
-- slot_idx: int // 合成到哪个槽位的宝石上，即：GemSlotDataProto.slot_idx
-- can_combine: bool // 能够合成(true)，读取下面的宝石id跟数量/不能够合成(false)，后面数据就不用读取了
-- gem_id: int[] // 要消耗的宝石id，跟宝石数量一一丢应
-- gem_count: int[] // 要消耗的宝石数量，可能存在数量为0的
local function S2CRequestOneKeyCombineCostProto(data)
    Event.dispatch(Event.REQUEST_COMBINE_COST_SUCCESS, data)
end
gem_decoder.RegisterAction(gem_decoder.S2C_REQUEST_ONE_KEY_COMBINE_COST, S2CRequestOneKeyCombineCostProto)

return ItemsData