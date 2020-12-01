local TimerManager = TimerManager or require "Manager.TimerManager"
local NetworkManager = NetworkManager or require "Manager.NetworkManager"
local baseData = require "Data.BaseData"

-- 心跳检测--
local function HeartBeat(clientTime)
    -- 秒数
    -- local clientTime = socket.gettime() * 1000
    NetworkManager.C2SHeartBeatProto(TimerManager.currentTime)
end

local function SyncTime()
    -- 同样的时间发送获取服务器时间请求
    NetworkManager.C2SSyncTimeProto(TimerManager.currentTime)
end

-- 杂七杂八信息
local MiscData = { }
MiscData.HeartBeatTimer = TimerManager.newTimer(10, true, true, nil, nil, HeartBeat)
MiscData.SyncTimeTimer = TimerManager.newTimer(1, true, true, nil, nil, SyncTime)

-- 配置更新--moduleId = 5, msgId = 4
-- bytes config = 1; // shared_proto.Config
-- todo: 如果需要热更新，则放到热更新之后解析配置
local function S2CConfigProto(data)
    local config = shared_pb.Config()
    config:ParseFromString(data.config)

    -- 这里顺序是有关联的 不能乱改.tks..!!!

    -- 物品数据（可堆叠）
    baseData.updateItemsConfig(config.goods)
    -- 装备品质数据
    baseData.updateEquipQualityConfig(config.equipment_quality)
    -- 装备强化数据
    baseData.updateEquipRefinedConfig(config.equipment_refined)
    -- 装备套装数据
    baseData.updateEquipTaozConfig(config.equipment_taoz)
    -- 装备数据
    baseData.updateEquipConfig(config.equipment)

    -- 建筑数据
    baseData.updateBuildingConfig(config.building_data)
    -- 科技数据
    baseData.updateTechnologyConfig(config.technology_data)
    -- 建筑布局
    baseData.updateBuildingLayoutConfig(config.building_layout)

    -- 士兵每一级对应的数据
    baseData.updateSoldierConfig(config.soldier)
    -- 君主每一级对应的数据
    baseData.updateMonarchsLevelConfig(config.hero)

    -- 帮派等级数据
    baseData.updateGuildLevelConfig(config.guild_level)
    -- 帮派阶级等级数据
    baseData.updateGuildClassLevelConfig(config.guild_class_level)
    -- 帮派职称数据
    baseData.updateGuildClassTitleConfig(config.guild_class_title)
    -- 帮派捐献数据
    baseData.updateGuildDonateConfig(config.guild_donate)
    -- 帮派目标数据
    baseData.updateGuildTargetConfig(config.guild_target)

    -- 主城每一级对应的数据
    baseData.updateMainCityLevelConfig(config.base_level)

    -- 武将每一级对应的数据
    baseData.updateCaptainLevelConfig(config.captain_level)

    -- 武将成长点数据
    baseData.updateCaptainAbilityConfig(config.captain_ability)

    -- 武将转生每一级对应数据
    baseData.updataCaptainRebirthConfig(config.captain_rebirth_level)

    -- 将魂数据
    baseData.updataCaptainSoulConfig(config.captain_soul_data)

    -- 羁绊数据
    baseData.updateCaptainSoulFettersConfig(config.captain_soul_fetters)

    -- 修炼馆等级数据
    baseData.updateTrainingLevelConfig(config.training_level)

    -- 千重楼楼层数据
    baseData.updateTowerConfig(config.tower)

    -- 主线任务数据
    baseData.updateMainTaskConfig(config.main_task)
    -- 支线任务数据
    baseData.updateBranchTaskConfig(config.branch_task)
    -- 任务宝箱数据
    baseData.updateTaskBoxConfig(config.task_box)

    -- 铁匠铺锻造数据
    baseData.updateSmithyForgeConfig(config.tie_jiang_pu_level)
    -- 铁匠铺合成数据
    baseData.updateSmithyCombineConfig(config.equip_combine)

    -- 宝石数据
    baseData.updateGemDataConfig(config.gem)

    -- 宝石槽位数据
    baseData.updateGemSlotDataConfig(config.gem_slot)

    -- 技能数据
    baseData.updateSkillDataConfig(config.spell_config)

    -- 职业数据
    baseData.UpdateRaceDataConfig(config.race_data)

    -- 重楼密室数据
    baseData.updateTowerBackroomConfig(config.secret_tower)
    -- 商店数据
    baseData.updateShopConfig(config.shop)
    -- 默认国家
    baseData.updateDefaultCountryConfig(config.default_country)

    -- 百战千军
    baseData.updatePvp100CommonConfig(config.bai_zhan_misc)
    -- 百战军衔等级
    baseData.updatePvp100RankLevelConfig(config.jun_xian_level)
    -- 百战军衔奖励
    baseData.updatePvp100RankPrizeConfig(config.jun_xian_level_prize)

    -- 模块配置
    baseData.updateGoodsCommonConfig(config.goods_config)
    baseData.updateMilitaryCommonConfig(config.military_config)
    baseData.updateRegionCommonConfig(config.region_config)
    baseData.updateRegionLevelConfig(config.region_level)
    baseData.updateMiscCommonConfig(config.misc_config)
    baseData.updateTowerBackroomCommonConfig(config.secret_tower_misc)
    baseData.updateGuildConfig(config.guild_config)

    -- 更新配置
    baseData.updateSettingConfig(config.setting)

    -- 排行榜配置
    baseData.updateRankingConfig(config.rank_misc)

    -- 初始化数据
    DataTrunk.initialize()

    -- 开始登录
    Event.dispatch(Event.LOG_READY)
end
misc_decoder.RegisterAction(misc_decoder.S2C_CONFIG, S2CConfigProto)

-- 断线原因--moduleId = 5, msgId = 5
-- must_login: 没有登陆就发送了别的模块消息
-- kick: 你被顶号了
local function S2CDisconnectReason(code)
    print("S2CDisconnectReason!!!! " .. tostring(code))
end
misc_decoder.RegisterAction(misc_decoder.S2C_FAIL_DISCONECT_REASON, S2CDisconnectReason)

-- **************************************************

-- 同步时间
-- moduleId = 5, msgId = 9
-- 客户端当前时间，CTIME
-- 消息返回的客户端时间: client_time
-- 消息返回的服务器时间: server_time
-- 服务器时间：SERVER_TIME
-- SERVER_TIME = Max(CTIME - client_time, 0) / 2 + server_time
-- client_time: int32 // 客户端发送的unix时间戳
-- server_time: int32 // 服务器当前的unix时间戳
local function S2CSyncTimeProto(data)
    local serverTime = math.max((TimerManager.currentTime - data.client_time), 0) / 2 + data.server_time
    local ping = math.ceil((TimerManager.currentTime - data.client_time) / 2)

    Event.dispatch(Event.UPDATE_SERVER_TIME, serverTime, ping)
end
misc_decoder.RegisterAction(misc_decoder.S2C_SYNC_TIME, S2CSyncTimeProto)

-- 每日重置
-- moduleId = 5, msgId = 6
local function S2CResetDaily(data)
    Event.dispatch(Event.DAILY_RESET)
end
misc_decoder.RegisterAction(misc_decoder.S2C_RESET_DAILY, S2CResetDaily)

-- 不可建城点信息
-- data: bytes // shared_proto.BlockInfoProto
local function S2CBlockProto(data)
    if data == nil then
        return
    end
    local blockInfo = shared_pb.BlockInfoProto()
    blockInfo:ParseFromString(data.data)
    DataTrunk.PlayerInfo.RegionData:UpdateBlockPointInfo(blockInfo)
end
misc_decoder.RegisterAction(misc_decoder.S2C_BLOCK, S2CBlockProto)

return MiscData