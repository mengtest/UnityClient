-- *********************************************************************
-- 内政信息
-- *********************************************************************

-- 建筑队信息--
local Builders = Class() 
-- Id标识--
Builders.Id = 0
-- 状态--
Builders.State = BuilderState.None
-- 更新信息--
function Builders:updateInfo(data)
end

-- *********************************************************************
-- 资源点信息--
local ResourcePointInfo = Class() 
-- 资源点布局配置
ResourcePointInfo.LayoutConfig = nil
-- 资源点建筑配置
ResourcePointInfo.BuildingConfig = nil
-- 当前资源量
ResourcePointInfo.Amount = 0
-- 最大资源量
ResourcePointInfo.Capacity = 0
-- 产量，每小时
ResourcePointInfo.Output = 0
-- 从0升满所需时间
ResourcePointInfo.Fulltime = 0
-- true标识冲突
ResourcePointInfo.Conflict = false
-- 更新信息
function ResourcePointInfo:updateInfo(data)
    if data.amount ~= nil then
        self.Amount = data.amount
    end

    if data.capcity ~= nil then
        self.Capacity = data.capcity
    end

    if data.output ~= nil then
        self.Output = data.output
    end

    if data.full_time ~= nil then
        self.Fulltime = data.full_time
    end

    if data.conflict ~= nil then
        self.Conflict = data.conflict
    end

    if data.building ~= nil then
        self.BuildingConfig = BuildingConfig:getConfigById(data.building)
    end

    if data.id ~= nil then
        self.LayoutConfig = BuildingLayoutConfig:getConfigById(data.id)
    end
end
-- 分开更新信息
function ResourcePointInfo:updateInfoSeparately(id, building, amount, capacity, output, fullTime, conflict)
    if amount ~= nil then
        self.Amount = amount
    end
    if capacity ~= nil then
        self.Capacity = capacity
    end
    if output ~= nil then
        self.Output = output
    end
    if full_time ~= nil then
        self.Fulltime = full_time
    end
    if conflict ~= nil then
        self.Conflict = conflict
    end
    if building ~= nil then
        self.BuildingConfig = BuildingConfig:getConfigById(building)
    end
    if id ~= nil then
        self.LayoutConfig = BuildingLayoutConfig:getConfigById(id)
    end
end
-- *********************************************************************

-- 内政信息--
local InternalAffairsData = { }
-- 繁荣度--
InternalAffairsData.Prosperity = 0
-- 当天最高繁荣度--
InternalAffairsData.HighestProsperity = 0
-- 当天损失的繁荣度--
InternalAffairsData.LostProsperity = 0
-- 通货当前信息--
InternalAffairsData.CurrencyCurrInfo = { }
-- 通货上限信息--
InternalAffairsData.CurrencyLimitInfo = { }
-- 通货受保护信息--
InternalAffairsData.CurrencyProtectedInfo = 0
-- 资源点信息(key为LayoutId)--
InternalAffairsData.ResourcePointInfo = { }
-- 资源点信息(Key为Offset)--
InternalAffairsData.ResourcePointOffsetInfo = { }
-- 冲突的资源点Id列表
InternalAffairsData.ConflictResourcePointIdList = { }
-- 建筑物信息--
InternalAffairsData.BuildingsInfo = { }
-- 已获得的科技研究--
InternalAffairsData.TechnologiesInfo = { }
-- 工程队休息到什么时候，时间戳(毫秒数)
InternalAffairsData.BuildersTimeoutInfo = { }
-- 科技队列休息到什么时候，时间戳(毫秒数)
InternalAffairsData.TechnicianTimeOutInfo = { }
-- 建筑队cd系数，这个值除以1000，得到小数
InternalAffairsData.BuildingWorkerCoef = 0
-- 科研队cd系数，这个值除以1000，得到小数
InternalAffairsData.TechWorkerCoef = 0
-- 铁匠铺重铸回复起始时间
InternalAffairsData.SmithyForgeRecoveryTime = 0
-- 铁匠铺开放碎片合成的套装
InternalAffairsData.SmithyCombineSuits = { }
-- 建筑队疲劳时间，秒
InternalAffairsData.BuildingWorkerFatigueDuration = 0
-- 科技队疲劳时间，秒
InternalAffairsData.TechWorkerFatigueDuration = 0

-- 初始化
function InternalAffairsData:init()
    -- 更新以offset为key的资源点信息,value存LayoutId即可
    for k, v in pairs(BuildingLayoutConfig.BuildingLayoutConfigList) do
        local offset = v.RegionOffsetX .. "_" .. v.RegionOffsetY
        self.ResourcePointOffsetInfo[offset] = k
    end
end

-- 清除--
function InternalAffairsData:clear()
    self.Prosperity = 0
    self.HighestProsperity = 0
    self.LostProsperity = 0
    self.CurrencyCurrInfo = { }
    self.CurrencyLimitInfo = { }
    self.CurrencyProtectedInfo = 0
    self.ResourcePointInfo = { }
    self.ResourcePointOffsetInfo = { }
    self.ConflictResourcePointIdList = { }
    self.BuildingsInfo = { }
    self.TechnologiesInfo = { }
    self.BuildersTimeoutInfo = { }
    self.TechnicianTimeOutInfo = { }
    self.BuildingWorkerCoef = 0
    self.TechWorkerCoef = 0
    self.SmithyForgeRecoveryTime = 0
    self.SmithyCombineSuits = { }
end

-- 更新内政信息--
function InternalAffairsData:updateInfo(data)
    self.CurrencyCurrInfo[CurrencyType.Food] = data.food
    self.CurrencyCurrInfo[CurrencyType.Wood] = data.wood
    self.CurrencyCurrInfo[CurrencyType.Gold] = data.gold
    self.CurrencyCurrInfo[CurrencyType.Stone] = data.stone

    self.CurrencyLimitInfo[CurrencyType.Food] = data.food_capcity
    self.CurrencyLimitInfo[CurrencyType.Wood] = data.wood_capcity
    self.CurrencyLimitInfo[CurrencyType.Gold] = data.gold_capcity
    self.CurrencyLimitInfo[CurrencyType.Stone] = data.stone_capcity

    self.CurrencyProtectedInfo = data.protected_capcity

    self.Prosperity = data.prosperity
    self.HighestProsperity = data.max_prosperity
    self.LostProsperity = data.lost_prosperity

    -- 资源点
    if data.resource_building ~= nil then
        for k, v in ipairs(data.resource_building) do
            print("拥有资源点-布局Id:" .. v.key .. "   建筑id：" .. v.value)
            if self.ResourcePointInfo[v.key] == nil then
                self.ResourcePointInfo[v.key] = ResourcePointInfo()
            end

            self.ResourcePointInfo[v.key].LayoutConfig = BuildingLayoutConfig:getConfigById(v.key)
            self.ResourcePointInfo[v.key].BuildingConfig = BuildingConfig:getConfigById(v.value)
        end
    end

    -- 建筑
    if data.building ~= nil then
        self:updateBuildingInfo(data.building)
    end

    -- 科技
    for k, v in ipairs(data.technology) do
        print("拥有科技：" .. v)
        local tech = TechnologyConfig:getConfigById(v)

        if self.TechnologiesInfo[tech.Type] == nil then
            self.TechnologiesInfo[tech.Type] = { }
        end

        self.TechnologiesInfo[tech.Type][tech.Sequence] = tech
    end

    -- 建筑队时间戳(服务器发来缺省的是个负数,做判断的时候要注意)
    for k, v in ipairs(data.worker_rest_end_time) do
        self.BuildersTimeoutInfo[k] = v
    end

    for k, v in ipairs(data.technology_rest_end_time) do
        self.TechnicianTimeOutInfo[k] = v
    end

    self.SmithyForgeRecoveryTime = data.start_recovery_forging_times_time
    self.BuildingWorkerCoef = data.building_worker_coef * 0.001
    self.TechWorkerCoef = data.tech_worker_coef * 0.001
    self.BuildingWorkerFatigueDuration = data.building_worker_fatigue_duration
    self.TechWorkerFatigueDuration = data.tech_worker_fatigue_duration
end
-- 更新建筑物
function InternalAffairsData:updateBuildingInfo(building)
    if building ~= nil then
        for k, v in ipairs(building) do
            print("拥有建筑物", v)
            local config = BuildingConfig:getConfigById(v)
            self.BuildingsInfo[config.BuildingType] = config
        end
    end
end
-- 更新冲突的资源点
function InternalAffairsData:updateConflictResourcePoint(layoutId, isConflict)
    if isConflict == nil then
        isConflict = false
    end

    if self.ResourcePointInfo[layoutId] ~= nil then
        self.ResourcePointInfo[layoutId].Conflict = isConflict

        -- 更新冲突Id列表
        if isConflict == true then
            self.ConflictResourcePointIdList[layoutId] = layoutId
        else
            self.ConflictResourcePointIdList[layoutId] = nil
        end
    end
end

-- *********************************************************************
-- 资源点相关协议
-- *********************************************************************

-- 创建资源点--moduleId = 2, msgId = 2
-- id: int // 布局id
-- building: int // 新的建筑id，对应shared_proto.BuildingDataProto的id
-- worker_pos: int // 建筑队序号
-- worker_rest_end_time: int // 对应序号的建筑队进入cd，Unix时间戳（秒）
-- amount: int // 当前可以收集的量
-- capcity: int // 最大容量
-- full_time: int // 从零升满所需时间，Unix时间戳（秒）
local function S2CCreateBuildingProto(data)
    -- InternalAffairsData.BuildersTimeoutInfo[data.worker_pos] = TimerManager.waitTodo(data.worker_rest_end_time, 1)
    InternalAffairsData.BuildersTimeoutInfo[data.worker_pos + 1] = data.worker_rest_end_time

    -- 更新以LayoutId为key的资源点信息,含全部信息
    if InternalAffairsData.ResourcePointInfo[data.id] == nil then
        InternalAffairsData.ResourcePointInfo[data.id] = ResourcePointInfo()
    end
    InternalAffairsData.ResourcePointInfo[data.id]:updateInfo(data)

    print("资源点创建- 布局Id:" .. data.id .. "   建筑id：" .. data.building)
    Event.dispatch(Event.CREATE_RESOURCE_POINT, InternalAffairsData.ResourcePointInfo[data.id])
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_CREATE_BUILDING, S2CCreateBuildingProto)

-- 创建资源点失败--moduleId = 2, msgId = 3
local function S2CFailCreateBuildingProto(code)
    -- UI弹框提示
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_CREATE_BUILDING, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_CREATE_BUILDING, S2CFailCreateBuildingProto)
-- *********************************************************************

-- 升级资源点--moduleId = 2, msgId = 5
-- id: int // 布局id
-- building: int // 新的建筑id，对应shared_proto.BuildingDataProto的id
-- worker_pos: int // 建筑队序号
-- worker_rest_end_time: int // 对应序号的建筑队进入cd，Unix时间戳（秒）
-- amount: int // 当前可以收集的量
-- capcity: int // 最大容量
-- full_time: int // 从零升满所需时间，Unix时间戳（秒）
local function S2CUpgradeBuildingProto(data)
    InternalAffairsData.BuildersTimeoutInfo[data.worker_pos + 1] = data.worker_rest_end_time
    InternalAffairsData.ResourcePointInfo[data.id]:updateInfo(data)

    print("资源点更新- 布局Id:" .. data.id .. "   建筑id：" .. data.building)
    -- Event.dispatch(Event.OnUpgradeResourcePoint)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPGRADE_BUILDING, S2CUpgradeBuildingProto)

-- 升级资源点失败--moduleId = 2, msgId = 6
local function S2CFailUpgradeBuildingProto(code)
    -- UI弹框提示
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_UPGRADE_BUILDING, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_UPGRADE_BUILDING, S2CFailUpgradeBuildingProto)
-- *********************************************************************

-- 重建资源点--moduleId = 2, msgId = 8
-- id: int // 布局id
-- building: int // 新的建筑id，对应shared_proto.BuildingDataProto的id
-- worker_pos: int // 建筑队序号
-- worker_rest_end_time: int // 对应序号的建筑队进入cd，Unix时间戳（秒）
-- amount: int // 当前可以收集的量
-- capcity: int // 最大容量
-- full_time: int // 从零升满所需时间，Unix时间戳（秒）
local function S2CRebuildResourceBuildingProto(data)
    InternalAffairsData.BuildersTimeoutInfo[data.worker_pos + 1] = data.worker_rest_end_time
    InternalAffairsData.ResourcePointInfo[data.id]:updateInfo(data)

    print("资源点重建- 布局Id:" .. data.id .. "   建筑id：" .. data.building)
    Event.dispatch(Event.REBUILD_RESOURCE_POINT, InternalAffairsData.ResourcePointInfo[data.id])
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_REBUILD_RESOURCE_BUILDING, S2CRebuildResourceBuildingProto)

-- 重建资源点失败--moduleId = 2, msgId = 9
local function S2CFailRebuildResourceBuildingProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_REBUILD_RESOURCE_BUILDING, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_REBUILD_RESOURCE_BUILDING, S2CFailRebuildResourceBuildingProto)

-- *********************************************************************

-- 第一次打开城外，请求资源点数据--moduleId = 2, msgId = 11
-- id: int[] // 布局id
-- building: int[] // 建筑id, 对应BuildingDataProto的id
-- amount: int[] // 当前可以收集的量
-- capcity: int[] // 最大容量
-- full_time: int[] // 从零升满所需时间，Unix时间戳（秒）
-- conflict: bool[] // true表示冲突，此资源点不再增长
local function S2CResourceBuildingInfoProto(data)
    if data == nil then
        return
    end
    for i = 1,(#data.id) do
        local target = InternalAffairsData.ResourcePointInfo[data.id[i]]
        if target == nil then
            target = ResourcePointInfo()
            InternalAffairsData.ResourcePointInfo[data.id[i]] = target
        end
        target:updateInfoSeparately(data.id[i], data.building[i], data.amount[i], data.capcity[i], nil, data.full_time[i], data.conflict[i])
        -- print("资源点是否冲突", data.id[i], data.conflict[i])
        -- 更新冲突Id列表
        InternalAffairsData:updateConflictResourcePoint(data.id[i], data.conflict[i])
    end

    Event.dispatch(Event.ALL_RESOURCE_POINT_UPDATE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_RESOURCE_BUILDING_INFO, S2CResourceBuildingInfoProto)

-- *********************************************************************

-- 资源点更新--moduleId = 2, msgId = 12
-- id: int // 布局id
-- building: int // 建筑id, 对应BuildingDataProto的id
-- amount: int // 当前可以收集的量
-- capcity: int // 最大容量
-- output: int // 产量，每小时
-- conflict: bool // true表示冲突，此资源点不再增长
local function S2CResourceBuildingUpdateProto(data)
    if InternalAffairsData.ResourcePointInfo[data.id] == nil then
        InternalAffairsData.ResourcePointInfo[data.id] = ResourcePointInfo()
    end
    InternalAffairsData.ResourcePointInfo[data.id]:updateInfo(data)

    Event.dispatch(Event.RESOURCE_POINT_UPDATE, InternalAffairsData.ResourcePointInfo[data.id])
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_RESOURCE_BUILDING_UPDATE, S2CResourceBuildingUpdateProto)

-- *********************************************************************
-- 资源变化--moduleId = 2, msgId = 13
-- gold: int
-- food: int
-- wood: int
-- stone: int
local function S2CResourceUpdateProto(data)
    InternalAffairsData.CurrencyCurrInfo[CurrencyType.Food] = data.food
    InternalAffairsData.CurrencyCurrInfo[CurrencyType.Wood] = data.wood
    InternalAffairsData.CurrencyCurrInfo[CurrencyType.Gold] = data.gold
    InternalAffairsData.CurrencyCurrInfo[CurrencyType.Stone] = data.stone

    Event.dispatch(Event.CURRENCY_CURRENT_UPDATE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_RESOURCE_UPDATE, S2CResourceUpdateProto)
-- *********************************************************************
-- 单个资源变化--moduleId = 2, msgId = 28
-- res_type: int
-- amount: int
local function S2CResourceUpdateSingleProto(data)
    if InternalAffairsData.CurrencyCurrInfo[data.res_type] ~= nil then
        InternalAffairsData.CurrencyCurrInfo[data.res_type] = data.amount

        Event.dispatch(Event.CURRENCY_CURRENT_UPDATE)
    end
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_RESOURCE_UPDATE_SINGLE, S2CResourceUpdateSingleProto)
-- *********************************************************************
-- 资源最大容量更新--moduleId = 2, msgId = 14
-- gold_capcity: int // 金钱最大容量
-- food_capcity: int
-- wood_capcity: int
-- stone_capcity: int
-- protected_capcity: int // 受保护容量
local function S2CResourceCapcityUpdateProto(data)
    InternalAffairsData.CurrencyLimitInfo[CurrencyType.Food] = data.food_capcity
    InternalAffairsData.CurrencyLimitInfo[CurrencyType.Wood] = data.wood_capcity
    InternalAffairsData.CurrencyLimitInfo[CurrencyType.Gold] = data.gold_capcity
    InternalAffairsData.CurrencyLimitInfo[CurrencyType.Stone] = data.stone_capcity

    InternalAffairsData.CurrencyProtectedInfo = data.protected_capcity

    Event.dispatch(Event.CURRENCY_LIMIT_AND_PROTECTED_UPDATE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_RESOURCE_CAPCITY_UPDATE, S2CResourceCapcityUpdateProto)
-- *********************************************************************
-- 资源点资源收集信息--moduleId = 2, msgId = 16
-- id: int // 布局id
-- amount: int // 本次采集了多少
local function S2CCollectResourceProto(data)
    print("收集资源点资源-- 布局id：" .. data.id)
    local res = InternalAffairsData.ResourcePointInfo[data.id]
    res.Amount = res.Amount - data.amount
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_COLLECT_RESOURCE, S2CCollectResourceProto)

-- 资源点资源收集失败信息--moduleId = 2, msgId = 17
local function S2CFailCollectResourceProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_COLLECT_RESOURCE, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_COLLECT_RESOURCE, S2CFailCollectResourceProto)

-- *********************************************************************
-- 内政其他
-- *********************************************************************

-- 升级科技--moduleId = 2, msgId = 19
-- id: int // 学习到的科技idOnTechnologyUpgrade
-- worker_pos: int // 科研的序号
-- worker_rest_end_time: int // 选择对应序号的科研队进入cd，Unix时间戳（秒）
local function S2CLearnTechnologyProto(data)
    print("学习到科技点：" .. data.id)

    InternalAffairsData.TechnicianTimeOutInfo[data.worker_pos + 1] = data.worker_rest_end_time
    local tech = TechnologyConfig:getConfigById(data.id)

    if InternalAffairsData.TechnologiesInfo[tech.Type] == nil then
        InternalAffairsData.TechnologiesInfo[tech.Type] = { }
    end

    InternalAffairsData.TechnologiesInfo[tech.Type][tech.Sequence] = tech

    Event.dispatch(Event.TECHNOLOGY_UPGRADE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_LEARN_TECHNOLOGY, S2CLearnTechnologyProto)

-- 升级科技失败--moduleId = 2, msgId = 20
local function S2CFailLearnTechnologyProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_LEARN_TECHNOLOGY, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_LEARN_TECHNOLOGY, S2CFailLearnTechnologyProto)

-- *********************************************************************

-- 升级城内建筑--moduleId = 2, msgId = 25
-- building: int // 新的建筑id，对应shared_proto.BuildingDataProto的id
-- worker_pos: int // 建筑队序号
-- worker_rest_end_time: int // 对应序号的建筑队进入cd，Unix时间戳（秒）
local function S2CUpgradeStableBuildingProto(data)
    print("升级建筑：" .. data.building)
    InternalAffairsData.BuildersTimeoutInfo[data.worker_pos + 1] = data.worker_rest_end_time

    -- 新建筑配置
    local config = BuildingConfig:getConfigById(data.building)

    InternalAffairsData.BuildingsInfo[config.BuildingType] = config

    Event.dispatch(Event.BUILDING_UPGRADE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPGRADE_STABLE_BUILDING, S2CUpgradeStableBuildingProto)

-- 升级城内建筑失败--moduleId = 2, msgId = 26
local function S2CFailUpgradeStableBuildingProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_UPGRADE_STABLE_BUILDING, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_UPGRADE_STABLE_BUILDING, S2CFailUpgradeStableBuildingProto)

-- *********************************************************************
-- 更新繁荣度，包含最大值的更新--moduleId = 2, msgId = 27
-- prosperity: int // 当前繁荣度
-- capcity: int // 繁荣度最大值，这个值 >0 时候更新繁荣度
local function S2CHeroUpdateProsperityProto(data)
    InternalAffairsData.Prosperity = data.prosperity
    InternalAffairsData.HighestProsperity = data.capcity

    Event.dispatch(Event.PROSPERITY_UPDATE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_HERO_UPDATE_PROSPERITY, S2CHeroUpdateProsperityProto)

-- *********************************************************************
-- 更新曾用名列表
-- moduleId = 2, msgId = 34
-- name: string[] // 曾用名列表
local function S2CListOldNameProto(data)
    Event.dispatch(Event.OLD_NAME_LIST_UPDATE, data.name)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_LIST_OLD_NAME, S2CListOldNameProto)

-- 更新曾用名列表失败
-- moduleId = 2, msgId = 37
local function S2CFailListOldNameProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_LIST_OLD_NAME, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_LIST_OLD_NAME, S2CFailListOldNameProto)

-- *********************************************************************

-- 查看其它玩家消息
-- moduleId = 2, msgId = 36
-- id: string // 玩家id
-- name: string // 玩家名字
-- head: string // 玩家头像
-- level: int   //玩家等级
-- male: bool // 玩家性别，true表示男
-- guild_id: int // 联盟名字
-- guild_name: string // 联盟名字
-- fight_amount: int // 防御战力
-- base_region: int // 地图region
-- base_level: int // 主城等级
-- base_x: int // 主城坐标
-- base_y: int
-- prosperity: int // 繁荣度
-- has_old_name: bool // true表示有曾用名
-- white_flag_guild_flag_name: string // 插白旗联盟旗号，空表示没有
local function S2CViewOtherHeroProto(data)

    if data == nil then
        return
    end

    local player = { }
    player.IsMainPlayer = false
    player.Id = data.id
    player.Name = data.name
    player.Head = UIConfig.MonarchsIcon[data.head]
    player.Male = data.male
    -- 协议里缺这条数据，临时用1代替
    player.Level = data.level
    player.GuildId = data.guild_id
    player.Guild = data.guild_name
    player.FightAmount = data.fight_amount
    player.MapId = data.base_region
    player.BaseLevel = data.base_level
    player.BaseX = data.base_x
    player.BaseY = data.base_y
    player.BaseProsperity = data.prosperity
    player.HasOldName = data.has_old_name
    player.FlagGuildFlagName = data.white_flag_guild_flag_name
    Event.dispatch(Event.ON_VIEW_OTHER_HERO, player)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_VIEW_OTHER_HERO, S2CViewOtherHeroProto)

-- 查看其它玩家消息失败
-- moduleId = 2, msgId = 38
local function S2CFailViewOtherHeroProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_VIEW_OTHER_HERO, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_VIEW_OTHER_HERO, S2CFailViewOtherHeroProto)

-- 秒建筑队CD成功
-- worker_pos: int // 建筑队序号，将建筑队cd清0
local function S2CMiaoBuildingWorkerCdProto(data)
    InternalAffairsData.BuildersTimeoutInfo[data.worker_pos + 1] = TimerManager.currentTime
    -- Tips提示
    UIManager.showTip( { content = Localization.AllFetigueTimeIsCleared, result = true })

    Event.dispatch(Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_MIAO_BUILDING_WORKER_CD, S2CMiaoBuildingWorkerCdProto)

-- 秒建筑队CD失败
local function S2CFailMiaoBuildingWorkerCdProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_MIAO_BUILDING_WORKER_CD, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_MIAO_BUILDING_WORKER_CD, S2CFailMiaoBuildingWorkerCdProto)

-- 秒科技队CD成功
-- worker_pos: int // 建筑队序号，将建筑队cd清0
local function S2CMiaoTechWorkerCdProto(data)
    InternalAffairsData.TechnicianTimeOutInfo[data.worker_pos + 1] = TimerManager.currentTime
    -- Tips提示
    UIManager.showTip( { content = Localization.AllFetigueTimeIsCleared, result = true })

    Event.dispatch(Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_MIAO_TECH_WORKER_CD, S2CMiaoTechWorkerCdProto)

-- 秒科技队CD失败
local function S2CFailMiaoTechWorkerCdProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_MIAO_TECH_WORKER_CD, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_MIAO_TECH_WORKER_CD, S2CFailMiaoTechWorkerCdProto)

-- 更新建筑cd系数
-- coef: int32 // 系数，除以1000得到小数
local function S2CUpdateBuildingWorkerCoef(data)
    InternalAffairsData.BuildingWorkerCoef = data.coef * 0.001
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPDATE_BUILDING_WORKER_COEF, S2CUpdateBuildingWorkerCoef)

-- 更新科研队cd系数
-- coef: int32 // 系数，除以1000得到小数
local function S2CUpdateTechWorkerCoef(data)
    InternalAffairsData.TechWorkerCoef = data.coef * 0.001
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPDATE_TECH_WORKER_COEF, S2CUpdateTechWorkerCoef)

-- 更新建筑队疲劳时间
-- fatigue: int32 // 建筑队疲劳时间，秒
local function S2CUpdateBuildingWorkerFatigueDuration(data)
    InternalAffairsData.BuildingWorkerFatigueDuration = data.fatigue
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPDATE_BUILDING_WORKER_FATIGUE_DURATION, S2CUpdateBuildingWorkerFatigueDuration)

-- 更新科技队疲劳时间
-- fatigue: int32 // 建筑队疲劳时间，秒
local function S2CUpdateTechWorkerFatigueDuration(data)
    InternalAffairsData.TechWorkerFatigueDuration = data.fatigue
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPDATE_TECH_WORKER_FATIGUE_DURATION, S2CUpdateTechWorkerFatigueDuration)

-- 联盟其他君主名字变更, 收到此消息，将所有需要改名字的地方都改掉
-- id: string   // 君主id
-- name: string // 君主名字return InternalAffairsData
local function S2CHeroNameChangedBroadCast(data)
    -- 更改联盟数据中的玩家名称
    local myAllianceData = DataTrunk.PlayerInfo.AllianceData.MyAlliance
    if myAllianceData ~= nil then
        myAllianceData:othersChangeName(data)
    end
    Event.dispatch(Event.OTHER_CHANGE_NAME_SUCCESS, data)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_HERO_NAME_CHANGED_BROADCAST, S2CHeroNameChangedBroadCast)

-- 铁匠铺
-- 锻造间隔
-- start_time: int // 锻造开始恢复开始时间
-- duration: int // 恢复间隔
local function S2CRecoveryForgingTimeChange(data)
    InternalAffairsData.SmithyForgeRecoveryTime = data.start_time
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_RECOVERY_FORGING_TIME_CHANGE, S2CRecoveryForgingTimeChange)

-- 锻造成功
local function S2CForgingEquipSucess(data)
    Event.dispatch(Event.SMITHY_FORGE_SUCCESS)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FORGING_EQUIP, S2CForgingEquipSucess)

-- 锻造失败
-- times_not_enough: 次数不够
-- can_not_forging_eqiup: 这件装备不可以锻造
-- count_invalid: 打造数量无效
-- function_not_open: 功能没开启
local function S2CForgingEquipFail(data)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_FORGING_EQUIP, data)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_FORGING_EQUIP, S2CForgingEquipFail)

return InternalAffairsData