local internalAffairsData = require "Data.InternalAffairsData"

-- 野外区域所有玩家主城信息
local BaseInfo = Class()
-- 地图Id
BaseInfo.MapId = 0
-- 玩家的id
BaseInfo.Id = ""
-- 玩家的名字
BaseInfo.Name = ""
-- 玩家主城等级
BaseInfo.BaseLevel = 0
-- x坐标
BaseInfo.BaseX = 0
-- y坐标
BaseInfo.BaseY = 0
-- 联盟Id
BaseInfo.GuildId = 0
-- 联盟名字
BaseInfo.GuildName = ""
-- 联盟旗号
BaseInfo.GuildFlagName = ""
-- 是否是行营
BaseInfo.IsCampsite = false
-- 行营生效时间(行营正常生效开始时间. 主城必为0. 如果是0表示已生效. 如果当前时间超过这个时间, 也已生效. 客户端自动变化状态和表现)
BaseInfo.CampsiteValidTime = nil
-- 繁荣度
BaseInfo.Prosperity = 0
-- 最大繁荣度
BaseInfo.ProsperityMax = 0
-- 驻防部队
BaseInfo.Defenser = nil
-- 插旗联盟
BaseInfo.FlagGuildId = 0
-- 插旗人联盟旗号
BaseInfo.FlagGuildFlagName = ""
-- 旗子到期时间
BaseInfo.FlagExpire = 0

-- 更新所有信息
function BaseInfo:updateInfo(id, name, baseLevel, baseX, baseY, guildId, guildName, guildFlagName, mapId, isCampsite, campsiteValideTime,
    prosperity, prosperityMax, defenser, flagGuildId, flagGuldFalgName, flagDisppearTime)
    if mapId ~= nil then
        self.MapId = mapId
    end
    if id ~= nil then
        self.Id = id
    end
    if name ~= nil then
        self.Name = name
    end
    if baseLevel ~= nil then
        self.BaseLevel = baseLevel
    end
    if baseX ~= nil then
        self.BaseX = baseX
    end
    if baseY ~= nil then
        self.BaseY = baseY
    end
    if guildId ~= nil then
        self.GuildId = guildId
    end
    if guildName ~= nil then
        self.GuildName = guildName
    end
    if guildFlagName ~= nil then
        self.GuildFlagName = guildFlagName
    end
    if isCampsite ~= nil then
        self.IsCampsite = isCampsite
    end
    if campsiteValideTime ~= nil then
        self.CampsiteValidTime = campsiteValideTime
    end
    if prosperity ~= nil then
        self.Prosperity = prosperity
    end
    if prosperityMax ~= nil then
        self.ProsperityMax = prosperityMax
    end
    if defenser ~= nil then
        local defenserData = shared_pb.BaseDefenserProto()
        defenserData:ParseFromString(defenser)
        self.Defenser = defenserData
    end
    if flagGuildId ~= nil then
        self.FlagGuildId = flagGuildId
    end
    if flagGuldFalgName ~= nil then
        self.FlagGuildFlagName = flagGuldFalgName
    end
    if flagDisppearTime ~= nil then
        self.FlagExpire = flagDisppearTime
        if TimerManager.currentTime > self.FlagExpire then
            self.FlagGuildFlagName = ""
        end
    end
end

function BaseInfo:updateProsperity(prosperity, prosperityMax)
    if prosperity ~= nil then
        self.Prosperity = prosperity
    end
    if prosperityMax ~= nil then
        self.ProsperityMax = prosperityMax
    end
end

function BaseInfo:updateWhiteFlag(guildId, guildFlagName, flagDisppearTime)
    if guildId ~= nil then
        self.FlagGuildId = guildId
    end
    if guildFlagName ~= nil then
        self.FlagGuildFlagName = guildFlagName
    end
    if flagDisppearTime ~= nil then
        self.FlagExpire = flagDisppearTime
    end
end

RegionBaseData = { }
-- 玩家城池列表
RegionBaseData.BaseInfoList = nil -- { mapId = value: { playerId = value: BaseInfo } }
RegionBaseData.BaseWhiteFlagList = nil -- { heroId = value: { info } }

-- 清除数据
function RegionBaseData:clear()
    self.BaseInfoList = nil
    self.BaseWhiteFlagList = nil
end

-- 更新此区域内多个玩家信息
function RegionBaseData:updateInfos(data)
    if self.BaseInfoList == nil then
        self.BaseInfoList = { }
    end

    for i, v in ipairs(data.hero_id) do
        self:updateOneInfo(data.hero_id[i], data.hero_name[i], data.level[i], data.base_x[i], data.base_y[i], data.guild_id[i], data.guild_name[i],
            data.guild_flag_name[i], data.map_id, data.is_tent[i], data.tent_valid_time[i], data.prosperity[i], data.prosperity_capcity[i], data.defenser[i],
            data.white_flag_guild_id[i], data.white_flag_guild_flag_name[i], data.white_flag_disappear_time[i])
    end
end

-- 更新此区域内单个玩家的信息
function RegionBaseData:updateOneInfo(monarchId, monarchName, baseLevel, baseX, baseY, guildId, guildName, guildFlagName,
    mapId, isCampsite, campsiteValideTime, prosperity, prosperityMax, defenser, flagGuildId, flagGuildFlagName, flagExpire)
    if self.BaseInfoList == nil then
        return
    end
    if self.BaseInfoList[mapId] == nil then
        self.BaseInfoList[mapId] = { }
    end

    if self.BaseInfoList[mapId][monarchId] == nil then
        self.BaseInfoList[mapId][monarchId] = BaseInfo()
    end

    self.BaseInfoList[mapId][monarchId]:updateInfo(monarchId, monarchName, baseLevel, baseX, baseY, guildId, guildName, guildFlagName, mapId, 
        isCampsite, campsiteValideTime, prosperity, prosperityMax, defenser, flagGuildId, flagGuildFlagName, flagExpire)
end

-- 更新单个玩家城的繁荣度
function RegionBaseData:updateOneProsperity(id, prosperity, prosperityMax)
    if self.BaseInfoList[id] == nil then
        self.BaseInfoList[id] = BaseInfo()
    end

    self.BaseInfoList[id]:updateProsperity(prosperity, prosperityMax)
end
-- 移除此区域内某个玩家
function RegionBaseData:removeOneBase(mapId, monarchId)
    if self.BaseInfoList[mapId] == nil then
        return
    end

    self.BaseInfoList[mapId][monarchId] = nil
end

-- 获取此区域内某个玩家的信息
function RegionBaseData:getBaseInfo(mapId, monarchId)
    if self.BaseInfoList == nil or self.BaseInfoList[mapId] == nil then
        return nil
    else
        return self.BaseInfoList[mapId][monarchId]
    end
end

-- 获取某个地图上的所有玩家信息
function RegionBaseData:getRegionInfo(mapId)
    if self.BaseInfoList == nil then
        return nil
    end
    return self.BaseInfoList[mapId]
end

-- **********************************协议处理*******************************
-- 创建主城（流亡状态）
-- moduleId = 7, msgId = 2
-- map_id: int // 地图id
-- new_x: int // 坐标
-- new_y: int
-- level: int // 主城等级
-- prosperity: int // 当前繁荣度
local function S2CCreateBaseProto(data)
    if data == nil then
        return
    end
    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    RegionBaseData:updateOneInfo(monarchsData.Id, monarchsData.Name, data.level, data.new_x, data.new_y, monarchsData.GuildId, monarchsData.Guild, monarchsData.GuildFlagName, data.map_id)
    -- 更新我的地图信息
    monarchsData:updateMapInfo(data.map_id, data.level, data.new_x, data.new_y)
    monarchsData:upateBaseProsperity(data.prosperity, nil)
    internalAffairsData.Prosperity = data.prosperity
    local cityInfo = RegionBaseData:getBaseInfo(data.map_id, monarchsData.Id)
    -- 发出事件
    Event.dispatch(Event.CREATE_BASE, cityInfo)
    Event.dispatch(Event.PROSPERITY_UPDATE)
end
region_decoder.RegisterAction(region_decoder.S2C_CREATE_BASE, S2CCreateBaseProto)

-- 创建主城失败
-- moduleId = 7, msgId = 3
local function S2CFailCreateBaseProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_CREATE_BASE, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_CREATE_BASE, S2CFailCreateBaseProto)

-- 移除一个主城
-- moduleId = 7, msgId = 19
-- map_id: int // 地图id
-- hero_id: string // 玩家的id
local function S2CRemoveBaseProto(data)
    if data == nil then
        return
    end

    -- 先获取数据再删除
    local cityInfo = RegionBaseData:getBaseInfo(data.map_id, data.hero_id)
    RegionBaseData:removeOneBase(data.map_id, data.hero_id)

    -- 如果为本君主
    if data.hero_id == DataTrunk.PlayerInfo.MonarchsData.Id then
        if data.map_id == DataTrunk.PlayerInfo.MonarchsData.BaseMapId then
            DataTrunk.PlayerInfo.MonarchsData:updateMapInfo(data.map_id, 0, -1, -1)
            Event.dispatch(Event.BASE_EXILE)
        else
            DataTrunk.PlayerInfo.MonarchsData:updateRegionCampPos(0, nil, nil)
        end
    end

    -- 发出事件
    Event.dispatch(Event.REMOVE_BASE, cityInfo)
end
region_decoder.RegisterAction(region_decoder.S2C_REMOVE_BASE, S2CRemoveBaseProto)

-- 更新主城成功
-- moduleId = 7, msgId = 20
-- map_id:int // 地图id
-- hero_id:string  // 玩家的id
-- hero_name: string // 玩家名字
-- guild_id: int // 联盟Id
-- guild_name: string // 联盟名字
-- guild_flag_name: string // 联盟旗号
-- level:int   // 玩家主城等级
-- base_x:int  // x坐标 x坐标和y坐标都发0，表示随机建城
-- base_y:int  // y坐标
-- prosperity: int // 繁荣度
-- prosperity_capcity: int // 繁荣度上限
-- is_tent:bool //是否是行营
-- tent_valid_time:int //行营正常生效开始时间. 如果是0表示已生效. 如果当前时间超过这个时间, 也已生效. 客户端自动变化状态和表现
local function S2CUpdateBaseInfoProto(data)
    if data == nil then
        return
    end
    
    RegionBaseData:updateOneInfo(data.hero_id, data.hero_name, data.level, data.base_x, data.base_y, data.guild_id, data.guild_name, data.guild_flag_name,
    data.map_id, data.is_tent, data.tent_valid_time, data.prosperity, data.prosperity_capcity)
    -- 如果为本君主
    if data.hero_id == DataTrunk.PlayerInfo.MonarchsData.Id then
        if data.is_tent then
            DataTrunk.PlayerInfo.MonarchsData:updateRegionCampPos(data.map_id, data.level, data.base_x, data.base_y)
        else
            DataTrunk.PlayerInfo.MonarchsData:updateMapInfo(data.map_id, data.level, data.new_x, data.new_y)
        end
    end

    local cityInfo = RegionBaseData:getBaseInfo(data.map_id, data.hero_id)
    -- 发出事件
    Event.dispatch(Event.UPDATE_BASE, cityInfo)

end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_BASE_INFO, S2CUpdateBaseInfoProto)

-- 升级主城
-- moduleId = 7, msgId = 41
-- 繁荣度达到升级条件时候，可以升级
local function S2CUpgradeBaseInfoProto()
    local heroId = DataTrunk.PlayerInfo.MonarchsData.Id
    -- 发出事件
    Event.dispatch(Event.UPGRADE_BASE)
end
region_decoder.RegisterAction(region_decoder.S2C_UPGRADE_BASE, S2CUpgradeBaseInfoProto)

-- 升级主城失败
-- moduleId = 7, msgId = 42
local function S2CFailUpdateBaseInfoProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_UPGRADE_BASE, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_UPGRADE_BASE, S2CFailUpdateBaseInfoProto)

-- *********************************************************************

-- 正常_迁移主城
-- moduleId = 7, msgId = 6
-- new_x: int // 坐标
-- new_y: int
-- time:int // 迁城时间（等到那个时候再给你迁），Unix时间戳（秒）
local function S2CSlowlyMoveBaseProto(data)
    -- TODO
end
region_decoder.RegisterAction(region_decoder.S2C_SLOWLY_MOVE_BASE, S2CSlowlyMoveBaseProto)

-- 缓慢迁城失败
-- moduleId = 7, msgId = 7
-- invalid_map_id: 无效的地图id
-- invalid_pos: 坐标无效，只能移动到周围一格距离（城市不能建在边缘，需要满足周围6格都有位置）
-- waiting: 迁移等待中不能再次迁移（要先取消上一次迁移）
-- base_not_exist: 流亡状态
-- too_close_other: 距离其他玩家太近
-- tent: 行营不能缓慢迁移
-- server_error: 服务器忙，请稍后再试
local function S2CFailSlowlyMoveBase(data)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_SLOWLY_MOVE_BASE, data)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_SLOWLY_MOVE_BASE, S2CFailSlowlyMoveBase)

-- 迁城令_迁移主城
-- moduleId = 7, msgId = 15
-- map_id: int // 地图id
-- new_x: int // 坐标
-- new_y: int
-- is_tent: bool // true表示行营，false表示主城
local function S2CFastMoveBaseProto(data)
    if data == nil then
        return
    end

    local monarchData = DataTrunk.PlayerInfo.MonarchsData
    if data.is_tent then
        if monarchData.CampMap ~= data.map_id then
            RegionBaseData.BaseInfoList[DataTrunk.PlayerInfo.MonarchsData.CampMap][monarchData.Id] = nil
        end
        monarchData:updateRegionCampPos(data.map_id, nil, data.new_x, data.new_y)
        RegionBaseData:updateOneInfo(monarchData.Id, monarchData.Name, monarchData.CampLvl, data.new_x, data.new_y, monarchData.GuildId, monarchData.Guild, monarchData.GuildFlagName, data.map_id, data.is_tent)
    else
        if DataTrunk.PlayerInfo.MonarchsData.BaseMapId ~= data.map_id then
            RegionBaseData.BaseInfoList[DataTrunk.PlayerInfo.MonarchsData.BaseMapId][monarchData.Id] = nil
        end
        DataTrunk.PlayerInfo.MonarchsData:updateMapInfo(data.map_id, nil, data.new_x, data.new_y)
        RegionBaseData:updateOneInfo(monarchData.Id, monarchData.Name, monarchData.BaseLevel, data.new_x, data.new_y, monarchData.GuildId, monarchData.Guild, monarchData.GuildFlagName, data.map_id, data.is_tent)
    end
    local cityInfo = RegionBaseData:getBaseInfo(data.map_id, monarchData.Id)
    -- 发出事件
    Event.dispatch(Event.FAST_MOVE_BASE, cityInfo)
end
region_decoder.RegisterAction(region_decoder.S2C_FAST_MOVE_BASE, S2CFastMoveBaseProto)

-- 迁城令_迁移主城失败
-- moduleId = 7, msgId = 16
local function S2CFailFastMoveBaseProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_FAST_MOVE_BASE, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_FAST_MOVE_BASE, S2CFailFastMoveBaseProto)

-- 获取本地图所有的主城信息
-- moduleId = 7, msgId = 18
-- map_id: int // 地图id
-- hero_id: string[] // 玩家的id
-- hero_name: string[] // 君主名字
-- guild_id: int[] // 联盟Id
-- guild_name: string[] // 联盟名字
-- guild_flag_name: string[] // 联盟旗号
-- level: int[] // 玩家主城等级
-- base_x: int[] // x坐标 x坐标和y坐标都发0，表示随机建城
-- base_y: int[] // y坐标
-- prosperity: int[] // 繁荣度
-- prosperity_capcity: int[] // 繁荣度上限
-- is_tent: bool[] // 是否是行营
-- tent_valid_time: int[] // 行营正常生效开始时间. 主城必为0. 如果是0表示已生效. 如果当前时间超过这个时间, 也已生效. 客户端自动变化状态和表现
-- defenser: bytes[] // shared_proto.BaseDefenserProto 基地驻守部队
-- white_flag_guild_id: int[] // 插白旗的联盟id
-- white_flag_guild_flag_name: string[] // 插白旗的联盟旗号
-- white_flag_disappear_time: int[] // 插白旗的过期时间，unix时间戳（秒）
local function S2CBaseInfoProto(data)
    if data == nil then
        return
    end

    RegionBaseData:updateInfos(data)
    Event.dispatch(Event.ON_ALL_CURRENT_MAP_BASE_UPDATED)
end
region_decoder.RegisterAction(region_decoder.S2C_BASE_INFO, S2CBaseInfoProto)

-- 获取本地图所有的主城信息失败
-- moduleId = 7, msgId = 27
local function S2CFailBaseInfoProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_BASE_INFO, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_BASE_INFO, S2CFailBaseInfoProto)

-- 更新主城等级
-- moduleId = 7, msgId = 52
-- level: int // 最新的主城等级
local function S2CSelfUpdateBaseLevelProto(data)
    if data == nil then
        return
    end
    local monarchData = DataTrunk.PlayerInfo.MonarchsData
    monarchData.BaseLevel = data.level
    RegionBaseData:updateOneInfo(monarchData.Id, monarchData.Name, data.level, nil, nil, nil, nil, nil, monarchData.BaseMapId)
end
region_decoder.RegisterAction(region_decoder.S2C_SELF_UPDATE_BASE_LEVEL, S2CSelfUpdateBaseLevelProto)

-- *********************************************************************
-- 资源点冲突状态变化推送
-- moduleId = 7, msgId = 11
-- no_conflict_ids: int[] // 不再冲突的布局id
-- conflict_ids: int[] // 处于冲突的布局id
local function S2CResourceBuildingConflicProto(data)
    if data == nil then
        return
    end
    -- 不再冲突的资源点
    for k, v in ipairs(data.no_conflict_ids) do
        print("不冲突的", v)
        internalAffairsData:updateConflictResourcePoint(v, false)
    end

    -- 处于冲突的资源点
    for k, v in ipairs(data.conflict_ids) do
        print("冲突的", v)
        internalAffairsData:updateConflictResourcePoint(v, true)
    end

    -- 抛出event
    Event.dispatch(Event.ON_RESOURCE_POINT_CONFLICT)
end
region_decoder.RegisterAction(region_decoder.S2C_RESOURCE_BUILDING_CONFLIC, S2CResourceBuildingConflicProto)

-- 将行营建到主城外面
-- moduleId = 7, msgId = 54
-- map_id: int // 地图id
-- new_x: int // 坐标
-- new_y: int
-- level: int // 主城等级
-- prosperity: int // 当前繁荣度
-- valid_time: int // 正式生效时间. 0 表示已生效.
local function S2CNewTentProto(data)
    if data == nil then
        return
    end

    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    RegionBaseData:updateOneInfo(monarchsData.Id, monarchsData.Name, data.level, data.new_x, data.new_y, monarchsData.GuildId, monarchsData.Guild, data.GuildFlagName, data.map_id, true, data.valid_time)
    local campsiteInfo = RegionBaseData:getBaseInfo(data.map_id, monarchsData.Id)
    monarchsData:updateRegionCampPos(data.map_id, data.level, data.new_x, data.new_y)
    monarchsData:updateReigonCampProsperity(data.prosperity, nil)
    monarchsData:updateRegionCampTime(nil, data.valid_time)
    Event.dispatch(Event.PUT_CAMPSITE, campsiteInfo)
end
region_decoder.RegisterAction(region_decoder.S2C_NEW_TENT, S2CNewTentProto)

-- 行营建造失败
-- moduleId = 7, msgId = 55
-- invalid_map_id: 发送的mapid无效
-- invalid_pos: 发送的坐标无效（需要满足周围6格都有位置）
-- too_close_other: 距离其他玩家太近
-- has_tent: 已经有行营了, 不能再建了
-- no_home: 老家流亡中
-- map_has_home: 老家也在这张地图中
-- no_tent_count: 没有行营材料或者不够cd造行营 (预留等以后增加类似的限制)
-- server_error: 服务器忙，请稍后再试
local function S2CFailNewTent(data)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_NEW_TENT, data)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_NEW_TENT, S2CFailNewTent)

-- 收回行营
-- moduleId = 7, msgId = 60
-- prosperity: int // 繁荣度，跟繁荣度上限一起，计算恢复进度条比例
-- prosperity_capcity: int // 繁荣度上限
-- full_time: int // 到什么时间恢复满，unix时间戳（秒）
local function S2CRemoveTentProto(data)
    if data == nil then
        return
    end

    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    RegionBaseData:removeOneBase(monarchsData.CampMap, monarchData.Id)
    monarchsData:updateRegionCampPos(0, nil, nil)
    monarchsData:updateReigonCampProsperity(data.prosperity, data.prosperity_capcity)
    monarchsData:updateRegionCampTime(data.full_time, nil)
end
region_decoder.RegisterAction(region_decoder.S2C_REMOVE_TENT, S2CRemoveTentProto)

-- 收回行营失败
-- moduleId = 7, msgId = 61
-- no_outside: 行营不是出征中，不能收回
-- captain_outside: 行营中有出征部队，不能收回
-- server_error: 服务器忙，请稍后再试
local function S2CRemoveTentFailProto(data)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_REMOVE_TENT, data)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_REMOVE_TENT, S2CRemoveTentFailProto)

-- 更新行营繁荣度
-- moduleId = 7, msgId = 64
-- prosperity: int // 行营繁荣度
local function S2CUpdateTentProsperityProto(data)
    if data == nil then
        return
    end
    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    monarchsData:updateReigonCampProsperity(data.prosperity, nil)
    local campInfo = RegionBaseData:getBaseInfo(monarchsData.CampMap, monarchsData.Id)
    if campInfo ~= nil then
        campInfo:updateProsperity(data.prosperity, nil)
    end

    Event.dispatch(Event.CAMPSITE_PROPERITY, monarchsData.Id)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_TENT_PROSPERITY, S2CUpdateTentProsperityProto)

-- 更新行营抢修值
-- moduleId = 7, msgId = 66
-- repair_amount: int // 行营抢修值
local function S2CUpdateTentRepairAmountProto(data)
    if data == nil then
        return
    end
    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    monarchsData:updateRepairInfo(data.repair_amount, nil)
    Event.dispatch(Event.CAMPSITE_REPAIR)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_TENT_REPAIR_AMOUNT, S2CUpdateTentRepairAmountProto)

-- 修复行营
-- moduleId = 7, msgId = 68
-- prosperity: int // 更新后行营繁荣度
-- repair_amount: int // 更新后行营抢修值
-- full_time: int // 繁荣度到什么时间恢复满，0表示已恢复满
local function S2CRepairTentProto(data)
    if data == nil then
        return
    end
    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    monarchsData:updateReigonCampProsperity(data.prosperity, nil)
    monarchsData:updateRegionCampTime(data.full_time, nil)
    monarchsData:updateRepairInfo(data.repair_amount, nil)
    local campInfo = RegionBaseData:getBaseInfo(monarchsData.CampMap, monarchsData.Id)
    if campInfo ~= nil then
        campInfo:updateProsperity(data.prosperity, nil)
    end

    Event.dispatch(Event.CAMPSITE_REPAIR, monarchsData.Id)
end
region_decoder.RegisterAction(region_decoder.S2C_REPAIR_TENT, S2CRepairTentProto)

-- 修理失败
-- moduleId = 7, msgId = 69
-- full: 当前繁荣度已满，不需要修理
-- cost_not_enough: 抢修材料不足
-- outside: 行营出征中，不能修理
local function S2CRepairTentFailProto(data)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_REPAIR_TENT, data)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_REPAIR_TENT, S2CRepairTentFailProto)

-- 更新行营信息
-- moduleId = 7, msgId = 70
-- prosperity: int // 行营繁荣度
-- prosperity_capcity: int // 繁荣度上限
-- full_time: int // 到什么时间恢复满，unix时间戳（秒）
-- repair: int // 抢修值
-- repair_capcity: int // 抢修值上限
local function S2CUpdateTentInfoProto(data)
    if data == nil then
        return
    end
    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    monarchsData:updateReigonCampProsperity(data.prosperity, data.prosperity_capcity)
    monarchsData:updateRegionCampTime(data.full_time, nil)
    monarchsData:updateRepairInfo(data.repair, data.repair_capcity)
    local campInfo = RegionBaseData:getBaseInfo(monarchsData.CampMap, monarchsData.Id)
    if campInfo ~= nil then
        campInfo:updateProsperity(data.prosperity, data.prosperity_capcity)
    end

    Event.dispatch(Event.CAMPSITE_UPDATE, monarchsData.Id)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_TENT_INFO, S2CUpdateTentInfoProto)

-- 更新驻防部队
-- moduleId = 7, msgId = 74
-- map_id: int // 地图id
-- hero_id: string // 玩家的id
-- defenser: bytes // shared_proto.BaseDefenserProto 基地驻守部队
local function S2CUpdateBaseDefenserProto(data)
    if data == nil then
        return
    end

    local baseInfo = RegionBaseData:getBaseInfo(data.map_id, data.hero_id)
    local defenserData = shared_pb.BaseDefenserProto()
    defenserData:ParseFromString(data.defenser)
    baseInfo.Defenser = defenserData
    Event.dispatch(Event.DEFENSER_UPDATE, data.hero_id)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_BASE_DEFENSER, S2CUpdateBaseDefenserProto)

-- 行营入侵
-- moduleId = 7, msgId = 75
-- hero_id: string[] // 英雄id
-- hero_name: string[] // 英雄名字
-- flag_name: string[] // 旗号
-- base_x: int[] // 行营坐标
-- base_y: int[]
local function S2CInitInvateTentProto(data)
    if data == nil then
        return
    end
    Event.dispatch(Event.CAMPSITE_INVADE_INFO, data)
end
region_decoder.RegisterAction(region_decoder.S2C_INIT_INVATE_TENT, S2CInitInvateTentProto)

-- 行营入侵添加消息
-- moduleId = 7, msgId = 76
-- hero_id: string // 英雄id
-- hero_name: string // 英雄名字
-- flag_name: string // 旗号
-- base_x: int // 行营坐标
-- base_y: int
local function S2CAddInvateTentProto(data)
    if data == nil then
        return
    end
    Event.dispatch(Event.CAMPSITE_INVADE_ADD, data)
end
region_decoder.RegisterAction(region_decoder.S2C_ADD_INVATE_TENT, S2CAddInvateTentProto)

-- 行营入侵移除消息
-- moduleId = 7, msgId = 77
-- hero_id: string // 英雄id
local function S2CRemoveInvateTentProto(data)
    if data == nil then
        return
    end
    Event.dispatch(Event.CAMPSITE_INVADE_REMOVE, data)
end
region_decoder.RegisterAction(region_decoder.S2C_REMOVE_INVATE_TENT, S2CRemoveInvateTentProto)

-- 更新繁荣度
-- moduleId = 7, msgId = 80
-- map_id: int // 地图id
-- hero_id: string // 玩家的id
-- prosperity: int // 繁荣度
local function S2CUpdateBaseProsperityProto(data)
    if data == nil then
        return
    end

    RegionBaseData:updateOneProsperity(data.hero_id, data.prosperity, nil)
    local monarchData = DataTrunk.PlayerInfo.MonarchsData
    if data.hero_id == monarchData.Id then
        if monarchData.BaseMapId == data.map_id then
            monarchData:upateBaseProsperity(data.prosperity, nil)
        elseif monarchData.CampMap == data.map_id then
            monarchData:updateReigonCampProsperity(data.prosperity, nil)
        end
    end
    Event.dispatch(Event.CAMPSITE_PROPERITY, data.hero_id)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_BASE_PROSPERITY, S2CUpdateBaseProsperityProto)

-- 行营建筑加速
-- moduleId = 7, msgId = 83
local function S2CMiaoTentBuildingCd()
-- 直接加速到位...
    UIManager.showTip( { result = true, content = Localization.CampBuildSpeedUpSuccess } )
    local monarchData = DataTrunk.PlayerInfo.MonarchsData
    RegionBaseData.BaseInfoList[monarchData.CampMap][monarchData.Id].CampsiteValidTime = 0
    monarchData:updateRegionCampTime(nil, 0)
    Event.dispatch(Event.CAMP_BUILD_SPEEDUP, monarchData.Id)
end
region_decoder.RegisterAction(region_decoder.S2C_MIAO_TENT_BUILDING_CD, S2CMiaoTentBuildingCd)

-- 行营建筑加速失败
-- moduleId = 7, msgId = 84
-- no_building_tent: 没有建造中的行营
-- cost_not_enough: 秒行营建造cd，消耗不足
-- server_error: 服务器忙，请稍后再试
local function S2CFailMiaoTentBuildingCd(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_MIAO_TENT_BUILDING_CD, code)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_MIAO_TENT_BUILDING_CD, S2CFailMiaoTentBuildingCd)

-- 更新白旗
-- 收到帮派名字更新消息时候，同时更新这个旗号更新 (guild.update_guild_name_broadcast.s2c 消息)
-- moduleId = 7, msgId = 85
-- hero_id: string // 被插白旗的英雄id
-- white_flag_guild_id: int // 插旗人的帮派id, 0表示删除白旗
-- white_flag_flag_name:  string // 插旗人的帮派id
-- white_flag_disappear_time: int // 白旗过期时间，unix时间戳
local function S2CUpdateWhiteFlagProto(data)
    if data == nil then
        return
    end
    if data.white_flag_guild_id == 0 then
        data.white_flag_flag_name = ""
    end

    local selectRegionId = DataTrunk.PlayerInfo.MonarchsData.BaseMapId
    if DataTrunk.PlayerInfo.RegionData:getSelectRegion() ~= nil then
        selectRegionId = DataTrunk.PlayerInfo.RegionData:getSelectRegion()
    end
    local baseData = RegionBaseData:getBaseInfo(selectRegionId, data.hero_id)
    if baseData ~= nil then
        baseData:updateWhiteFlag(data.white_flag_guild_id, data.white_flag_flag_name, data.white_flag_disappear_time)
    end
    local monarchData = DataTrunk.PlayerInfo.MonarchsData
    if monarchData.Id == data.hero_id then
        monarchData:updateWhiteFlagInfo(data.white_flag_guild_id, data.white_flag_flag_name, data.white_flag_disappear_time)
    end
    Event.dispatch(Event.WHITE_FLAG_UPDATE, data)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_WHITE_FLAG, S2CUpdateWhiteFlagProto)

-- 请求插白旗详情
-- moduleId = 7, msgId = 87
-- hero_id: string // 请求谁的信息
-- white_flag_hero_id: string // 插旗人的id
-- white_flag_hero_name: string // 插旗人的名字
-- white_flag_guild_id: int // 插旗人的帮派id
-- white_flag_guild_name: string // 插旗人的帮派名字
-- white_flag_disappear_time: int // 白旗消失时间，unix时间戳(秒)
local function S2CWhiteFlagDetailProto(data)
    if data == nil then
        return
    end

    local selectRegionId = DataTrunk.PlayerInfo.MonarchsData.BaseMapId
    if DataTrunk.PlayerInfo.RegionData:getSelectRegion() ~= nil then
        selectRegionId = DataTrunk.PlayerInfo.RegionData:getSelectRegion()
    end
    local baseData = RegionBaseData:getBaseInfo(selectRegionId, data.hero_id)
    if baseData ~= nil then
        baseData:updateWhiteFlag(data.white_flag_guild_id, data.white_flag_flag_name, data.white_flag_disappear_time)
    end
    local monarchData = DataTrunk.PlayerInfo.MonarchsData
    if data.hero_id == monarchData.Id then
        monarchData:updateWhiteFlagInfo(data.white_flag_guild_id, data.white_flag_flag_name, data.white_flag_disappear_time)
    end

    Event.dispatch(Event.WHITE_FLAG, data)
end
region_decoder.RegisterAction(region_decoder.S2C_WHITE_FLAG_DETAIL, S2CWhiteFlagDetailProto)

-- 请求插白旗详情失败
-- moduleId = 7, msgId = 88
-- no_flag: 英雄当前没有插白旗
local function S2CWhiteFlagDetailFailProto(code)
    UIManager.showNetworkErrorTip(region_decoder.ModuleID, region_decoder.S2C_FAIL_WHITE_FLAG_DETAIL, code)
    Event.dispatch(Event.WHITE_FLAG_FAIL)
end
region_decoder.RegisterAction(region_decoder.S2C_FAIL_WHITE_FLAG_DETAIL, S2CWhiteFlagDetailFailProto)

return RegionBaseData