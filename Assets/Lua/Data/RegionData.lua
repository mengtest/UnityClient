local militaryAffairsData = require "Data.MilitaryAffairsData"

-- *********************************************************************
-- 实例化信息
-- *********************************************************************
-- 野外区域实例化信息
local RegionData = { }
-- 所有地区
RegionData.RegionSort = { }
-- 玩家当前选择的地区
RegionData.CurSelectRegion = nil
-- 不可建城点的信息
RegionData.BlockPointInfo = { }
-- 指定的到某个地图某个位置的信息
RegionData.SpecifiedPosInfo = nil

local BlockInfo = Class()
BlockInfo.BlockType = nil
BlockInfo.BlockX = nil
BlockInfo.BlockY = nil

function BlockInfo:updateInfo(type, x, y)
    if type ~= nil then
        self.BlockType = type
    end
    if x ~= nil then
        self.BlockX = x
    end
    if y ~= nil then
        self.BlockY = y
    end
end

-- 更新主城内武将出征状态
local function updateCaptainOutSideStat(troopId, isOutSide)
    -- 设置为出征状态
    militaryAffairsData.Troops[troopId].OutSide = isOutSide
    -- 发出事件
    Event.dispatch(Event.TROOP_OUTSIDE_UPDATE)
end

-- 清理
function RegionData:clear()
    self.RegionSort = { }
    self.CurSelectRegion = nil
    self.BlockPointInfo = { }
    self.SpecifiedPosInfo = nil
end

-- 获取所有Region
function RegionData:getRegionSort()
    return self.RegionSort
end

-- 设置选择的地区
function RegionData:setSelectRegion(id)
    self.CurSelectRegion = id
end

-- 设置选择的进入地图查看的点
function RegionData:setSelectPos(x, y)
    if self.SpecifiedPosInfo == nil then
        self.SpecifiedPosInfo = { }
    end
    self.SpecifiedPosInfo.PosX = x
    self.SpecifiedPosInfo.PosY = y
end

-- 获取选择的地区
function RegionData:getSelectRegion()
    return self.CurSelectRegion
end

-- 根据id获取地图类型
function RegionData:getRegionTypeById(id)
    return math.floor(math.fmod(id, 256) / 2)
end

-- 根据id获取地图编号
function RegionData:getRegionIndexById(id)
    return math.floor(id / 256) + 1
end

-- 根据id获取地区名字
function RegionData:getRegionNameById(id)
    local regionType = self:getRegionTypeById(id)
    local regionIndex = self:getRegionIndexById(id)
    return RegionLevel:getConfigByLevel(regionType).name .. regionIndex
end

-- 更新不可建城点
function RegionData:UpdateBlockPointInfo(data)
    if data == nil then
        return
    end
    self.BlockPointInfo = { }
    for i, v in ipairs(data.type) do
        self.BlockPointInfo[i] = BlockInfo()
        self.BlockPointInfo[i]:updateInfo(data.type[i], data.x[i], data.y[i])
    end
end


-- *********************************************************************
-- 协议处理
-- *********************************************************************
-- 出城
-- 服务器主动推送以下消息
-- base_info 野外地图中的主城信息
-- map_military_info 野外地图中持续掠夺的军情，用于展示一匹马在打那个主城
--
-- 以上消息会在本消息的s2c消息返回之前先发送，
--
-- 回城
-- 客户端回城后，发送回城消息
-- moduleId = 7, msgId = 44
-- map_id: int // 地图id，发0表示回城
local function S2CSwitchMapProto(data)
    if data == nil or data.map_id == nil then
        return
    end

    print("我现在的地图Id", data.map_id)
    if data.map_id ~= 0 then
        Event.dispatch(Event.CHANGE_REGION, data.map_id)
    end

    if data.map_id == 0 then
        -- 移除所有当前地图上的军情
        DataTrunk.PlayerInfo.MilitaryInfoData:removeAllCurrMapMilitaryInfo()
        Event.dispatch(Event.ON_GO_HOME)
    else
        Event.dispatch(Event.ON_GO_OUTSIDE, data.map_id)
        -- 玩家处于流亡状态
        local monarchsData = DataTrunk.PlayerInfo.MonarchsData
        if monarchsData.BaseMapId == 0 or
            monarchsData.BaseLevel == 0 or
            monarchsData.BaseProsperity == 0 then
            Event.dispatch(Event.BASE_EXILE)
        end
    end
end
region_decoder.RegisterAction(region_decoder.S2C_SWITCH_MAP, S2CSwitchMapProto)

-- 请求进/出城失败
-- moduleId = 7, msgId = 48
local function S2CFailSwitchMapProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_SWITCH_MAP, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_SWITCH_MAP, S2CFailSwitchMapProto)

-- *********************************************************************
-- 出征
-- moduleId = 7, msgId = 25
-- target: string   // 出征的目的地
-- map_id: int      // 出征的地图id
-- troop_index: int // 使用哪个队伍出征 1队=1 2队=2
local function S2CInvasionProto(data)
    -- 主城内武将出征状态
    updateCaptainOutSideStat(data.troop_index, true)
    -- 发出事件
    Event.dispatch(Event.ON_INVASION, data.target)
end
region_decoder.RegisterAction(region_decoder.S2C_INVASION, S2CInvasionProto)

-- 出征失败
-- moduleId = 7, msgId = 34
-- invalid_target: 无效的目标id
-- invalid_target_invation: 无效的目标出征类型，
-- invalid_troop_index: 无效的队伍序号
-- outside: 队伍出征中
-- no_soldier: 武将士兵数为0
-- target_not_exist: 目标处于流亡状态
-- self_not_exist: 自己处于流亡状态
-- not_same_map: 不在同一个地图
-- max_invation_troops: 出征部队已达上限
-- server_error: 服务器忙，请稍后再试
-- no_base_in_map: 那张地图上没有你的主城或可用的行营
-- no_tent_to_tent: 行营不能攻击行营
-- tent_not_valid: 出发的行营还未建好. 等valid time
local function S2CFailInvasionProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_INVASION, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_INVASION, S2CFailInvasionProto)

-- 移除部队出征状态
-- troop_index: int // 部队序号 1队=1 2队=2
local function S2CRemoveTroopOutsideProto(data)
    if data == nil then
        return
    end
    updateCaptainOutSideStat(data.troop_index, false)
end
region_decoder.RegisterAction(region_decoder.S2C_REMOVE_TROOP_OUTSIDE, S2CRemoveTroopOutsideProto)

-- *********************************************************************
-- 召回
-- moduleId = 7, msgId = 28
-- id: string // 军情id
local function S2CCancelInvasionProto(data)
    -- 发出事件
    Event.dispatch(Event.CANCEL_INVASION)
end
region_decoder.RegisterAction(region_decoder.S2C_CANCEL_INVASION, S2CCancelInvasionProto)

-- 召回失败
-- moduleId = 7, msgId = 29
local function S2CFailCancelInvasionProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_CANCEL_INVASION, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_CANCEL_INVASION, S2CFailCancelInvasionProto)

-- *********************************************************************
-- 驱逐
-- moduleId = 7, msgId = 31
-- id: string // 军情id，只返回军情id，其他的通过军情更新消息推送
-- cooldown: int // 冷却时间，秒（0表示驱逐成功，不需要冷却）
local function S2CExpelProto(data)
    -- 发出事件
    Event.dispatch(Event.EXPEL_RESULT_UPDATE)
end
region_decoder.RegisterAction(region_decoder.S2C_EXPEL, S2CExpelProto)

-- 驱逐失败
-- moduleId = 7, msgId = 32
-- invalid_id: 无效的军情id
-- invalid_map: 无效的地图id
-- not_self: 这条军情的部队不是正在掠夺你的，不能操作
-- not_arrived: 这个军队当前不处于掠夺状态（还没到，或者回去了）
-- cooldown: 驱逐CD中
-- invalid_troop_index: 无效的队伍编号
-- outside: 队伍出征中，不能驱逐
-- no_soldier: 武将士兵数为0
-- server_error: 服务器忙，请稍后再试
local function S2CFailExpelProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_EXPEL, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_EXPEL, S2CFailExpelProto)
-- *********************************************************************

-- 遣返盟友部队
-- moduleId = 7, msgId = 72
-- id: string // 军情id
-- is_tent: bool // true表示遣返行营的盟友，false表示遣返主城的盟友
local function S2CRepatriateProto(data)
    if data == nil then
        return
    end
    UIManager.showTip( { result = true, content = Localization.RepatriateSuccess })
end
region_decoder.RegisterAction(region_decoder.S2C_REPATRIATE, S2CRepatriateProto)

-- 遣返失败
-- moduleId = 7, msgId = 73
-- id_not_found: 军情id没找到
-- no_defending: 不是驻扎在你城里的同盟部队，不能叫回家
-- server_error: 服务器忙，请稍后再试
local function S2CRepatriateFailProto(data)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_REPATRIATE, data)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_REPATRIATE, S2CRepatriateFailProto)

-- 更新部队士兵数据（用于一次更新整个出征部队的数据，包含多个武将数据和伤兵数据）
-- moduleId = 7, msgId = 56
-- id: int[] // 武将id列表
-- soldier: int[] // 武将士兵数列表
-- fight_amount: int[] // 武将战斗力列表
-- wounded_soldier: int // 当前最新的伤兵数量
-- remove_outside: bool // true表示武将已经回家了，更新武将回家状态
-- troop_index: int // 部队序号 1队=1 2队=2
local function S2CUpdateSelfTroopsProto(data)
    if data == nil then
        return
    end
    if militaryAffairsData.Troops[data.troop_index] == nil then
        militaryAffairsData.Troops[data.troop_index] = HeroTroopClass()
    end
    militaryAffairsData.Troops[data.troop_index].TroopId = data.troop_index
    militaryAffairsData.Troops[data.troop_index].OutSide = data.remove_outside
    for i = 1, #data.id do
        militaryAffairsData.Troops[data.troop_index].Captains[i] = data.id[i]
    end
    militaryAffairsData.WoundedSoldier = data.wounded_soldier
    for i, v in ipairs(data.id) do
        if militaryAffairsData.Captains[v] ~= nil then
            militaryAffairsData.Captains[v].Soldier = data.soldier[i]
            militaryAffairsData.Captains[v].FightAmount = data.fight_amount[i]
        end
    end
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_SELF_TROOPS, S2CUpdateSelfTroopsProto)

-- # 地区个数列表
-- moduleId = 7, msgId = 63
-- # 地区id规则
-- # 地区等级数据，读取配置表获取，shared_proto.RegionLevelProto
-- # 地区编号，从0开始，乡级地区1，县级地区1 的地区编号都是0，乡级地区2的编号=1
-- # 地区id = 地区编号 * 256 + 地区等级 * 2
-- # 地区编号 = 地区id / 256
-- # 地区等级 = (地区id % 256) / 2
-- # 用这个规则可以计算出任何一个地区id出来，任何的有效的地区id都可以知道是几级地区，地区编号是多少
-- # 那么最新的做法是，服务器只推送当前地区各个等级分别有几个地图，剩下的客户端来构建列表
-- # 当地区发生扩建的时候，会给客户端主动推送这条消息
-- count: int[] // 地区个数，第一个数据表示1级地区有多少个地图，客户端构建出地区列表
local function S2CRegionLevelCountProto(data)
    if data == nil or data.count == nil then
        return
    end

    RegionData.RegionSort = { }
    for i, v in ipairs(data.count) do
        for j = 1, v do
            table.insert(RegionData.RegionSort,(j - 1) * 256 + i * 2)
        end
    end
    Event.dispatch(Event.GET_REGION_LIST)
end
region_decoder.RegisterAction(region_decoder.S2C_REGION_LEVEL_COUNT, S2CRegionLevelCountProto)


return RegionData