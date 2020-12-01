---------------------------------------------------------------
--- 基础信息----------------------------------------------------
---------------------------------------------------------------
require "Data.ConfigData"

-- 道具通用模块配置
GoodsCommonConfig = { }
-- 配置
GoodsCommonConfig.Config = nil
-- *********************************************************************
-- 军政通用模块配置
MilitaryCommonConfig = { }
-- 配置
MilitaryCommonConfig.Config = nil
-- *********************************************************************
-- 大地图通用模块配置
RegionCommonConfig = { }
-- 配置
RegionCommonConfig.Config = nil
-- *********************************************************************
-- Misc通用模块配置
MiscCommonConfig = { }
-- 配置
MiscCommonConfig.Config = nil
-- *********************************************************************
-- 重楼密室通用模块配置
BackroomCommonConfig = { }
-- 配置
BackroomCommonConfig.Config = nil
-- *********************************************************************
-- *********************************************************************
-- 百战通用模块配置
Pvp100CommonConfig = { }
-- 配置
Pvp100CommonConfig.Config = nil
-- *********************************************************************

-- 联盟通用模块配置
GuildConfig = { }
-- 配置
GuildConfig.Config = nil

-- *********************************************************************
-- 道具描述配置--
ItemsConfig = { }
-- 配置--
ItemsConfig.Config = nil
-- 获取道具配置
function ItemsConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end 
-- *********************************************************************
-- 装备描述配置--
EquipsConfig = { }
-- 配置--
EquipsConfig.Config = nil
-- 获取装备配置
function EquipsConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end 
-- *********************************************************************
-- 装备品质描述配置--
EquipQualityConfig = { }
-- 配置--
EquipQualityConfig.Config = nil
-- 获取装备品质配置
function EquipQualityConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end 
-- *********************************************************************
-- 装备强化描述配置--
EquipRefinedConfig = { }
-- 配置--
EquipRefinedConfig.Config = nil
-- 获取装备强化配置
function EquipRefinedConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end 
-- *********************************************************************
-- 装备套装描述配置--
EquipTaozConfig = { }
-- 配置--
EquipTaozConfig.Config = nil
-- 获取装备套装配置
function EquipTaozConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end 
-- *********************************************************************
-- 武将每一级对应的数据配置
CaptainLevelConfig = { }
-- 配置
CaptainLevelConfig.Config = nil
-- 根据等级获得最大经验值
function CaptainLevelConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end

    return self.Config[level]
end 
-- *********************************************************************
-- 武将成长点数据
CaptainAbilityConfig = { }
-- 配置
CaptainAbilityConfig.Config = nil
-- 根据成长点获得数据
function CaptainAbilityConfig:getConfigById(ability)
    if self.Config == nil or self.Config[ability] == nil then
        return nil
    end

    return self.Config[ability]
end 
-- *********************************************************************
-- 武将转生每一级数据配置
CaptainRebirthConfig = { }
-- 配置
CaptainRebirthConfig.Config = nil
-- 最高等级
CaptainRebirthConfig.MaxLevel = 0
-- 获取数据
function CaptainRebirthConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end

    return self.Config[level]
end
-- *********************************************************************
-- 将魂数据配置
CaptainSoulConfig = { }
-- 配置
CaptainSoulConfig.Config = nil
-- 获取数据
function CaptainSoulConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- *********************************************************************
-- 羁绊数据配置
CaptainSoulFettersConfig = { }
-- 配置
CaptainSoulFettersConfig.Config = nil
-- 获取数据
function CaptainSoulFettersConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- *********************************************************************
-- 修炼馆等级数据
TrainingLevelConfig = { }
-- 配置
TrainingLevelConfig.Config = nil
-- 根据等级获得修炼馆信息
function TrainingLevelConfig:getConfigById(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end

    return self.Config[level]
end
-- *********************************************************************
-- 千重楼数据配置
TowerConfig = { }
-- 配置
TowerConfig.Config = nil
-- 根据楼层获取配置
function TowerConfig:getConfigById(floor)
    if self.Config == nil or self.Config[floor] == nil then
        return nil
    end

    return self.Config[floor]
end
-- *********************************************************************
-- 重楼密室数据配置
BackroomConfig = { }
-- 配置
BackroomConfig.Config = nil
-- 根据楼层获取配置
function BackroomConfig:getConfigById(floor)
    if self.Config == nil or self.Config[floor] == nil then
        return nil
    end

    return self.Config[floor]
end
-- *********************************************************************
-- 君主升级配置--
MonarchsConfig = { }
-- 配置--
MonarchsConfig.LevelConfig = nil    
-- 配置--
MonarchsConfig.VipConfig = nil
-- 获取升级配置
function MonarchsConfig:getLevelConfigById(id)
    if self.LevelConfig == nil or self.LevelConfig[id] == nil then
        return nil
    end
    return self.LevelConfig[id]
end 
-- 获取vip升级配置
function MonarchsConfig:getVipConfigById(id)
    if self.VipConfig == nil or self.VipConfig[id] == nil then
        return nil
    end
    return self.VipConfig[id]
end 
-- *********************************************************************
-- 建筑描述配置--
BuildingConfig = { }
-- key值为建筑标识Id
BuildingConfig.Config = nil
BuildingConfig.ConfigByTypeAndLevel = nil
-- 获取建筑配置--
function BuildingConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- *********************************************************************
-- 建筑布局配置--
BuildingLayoutConfig = { }
-- key值为布局标识Id,value为可建造的建筑类型，详见BuildingType
BuildingLayoutConfig.BuildingLayoutConfigList = nil

-- 基地各等级解锁的布局Id列表
BuildingLayoutConfig.BaseLevelUnlockLayouts = nil

-- 以OddQ坐标偏移为Key保存的布局Id列表
BuildingLayoutConfig.CoordinatesOffsetToLayouts = nil

-- 通过布局Id获取建筑类型配置
function BuildingLayoutConfig:getConfigById(layoutId)
    if self.BuildingLayoutConfigList == nil or self.BuildingLayoutConfigList[layoutId] == nil then
        return nil
    end
    return self.BuildingLayoutConfigList[layoutId]
end
-- 通过基地等级获取布局Id列表
function BuildingLayoutConfig:getUnlockLayoutsByBaseLevel(baseLevel)
    if self.BaseLevelUnlockLayouts == nil or self.BaseLevelUnlockLayouts[baseLevel] == nil then
        return nil
    end
    return self.BaseLevelUnlockLayouts[baseLevel]
end
-- 通过基地等级获得土地数量
function BuildingLayoutConfig:getGroundCountByBaseLevel(baseLevel)
    if self.BaseLevelUnlockLayouts == nil or self.BaseLevelUnlockLayouts[baseLevel] == nil then
        return nil
    end

    local count = 0

    for i = baseLevel, 1, -1 do
        count = count + Utils.GetTableLength(self:getUnlockLayoutsByBaseLevel(i))
    end

    return count
end
-- 通过OddQ坐标偏移获取布局Id
function BuildingLayoutConfig:getLayoutByCoordinatesOffset(offsetX, offsetY)
    local offset = offsetX .. "_" .. offsetY
    if self.CoordinatesOffsetToLayouts == nil or self.CoordinatesOffsetToLayouts[offset] == nil then
        return nil
    end
    return self.CoordinatesOffsetToLayouts[offset]
end

-- *********************************************************************
-- 科技点描述配置--
TechnologyConfig = { }
-- key值为科技点标识Id
TechnologyConfig.Config = nil   
-- key值科技(类型+序号)+等级
TechnologyConfig.ConfigByTypeAndSequenceAndLevel = nil     
-- 获取科技点配置
function TechnologyConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- 获取下一等级科技点配置
function TechnologyConfig:getNextLvConfigById(id)
    local tech = self:getConfigById(id)
    if tech == nil then
        return nil
    end
    return self:getConfigByTypeAndSequenceAndLevel(tech.Type, tech.Sequence, tech.Level + 1)
end
-- 获取某等级的科技点配置
function TechnologyConfig:getConfigByTypeAndSequenceAndLevel(techType, sequence, level)
    -- key值约定
    if self.ConfigByTypeAndSequenceAndLevel == nil or self.ConfigByTypeAndSequenceAndLevel[techType][sequence][level] == nil then
        return nil
    end
    return self.ConfigByTypeAndSequenceAndLevel[techType][sequence][level]
end
-- *********************************************************************
-- 士兵描述配置--
SoldierConfig = { }
-- 配置--
SoldierConfig.Config = nil
-- 获取士兵配置
function SoldierConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- *********************************************************************
-- 武将描述配置--
CaptainConfig = { }
-- 配置--
CaptainConfig.Config = nil    
-- 获取士兵配置
function CaptainConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- *********************************************************************
-- 设置配置--
SettingConfig = { }
-- 配置--
SettingConfig.Config = nil
-- 获取配置信息
function SettingConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- *********************************************************************
-- 联盟等级配置--
GuildLevelConfig = { }
-- 配置
GuildLevelConfig.Config = { }
-- 获取配置信息
function GuildLevelConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end
    return self.Config[level]
end
-- *********************************************************************
-- 联盟阶级等级配置--
GuildClassLevelConfig = { }
-- 配置
GuildClassLevelConfig.Config = { }
-- 获取配置信息
function GuildClassLevelConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end
    return self.Config[level]
end
-- *********************************************************************
-- 联盟职称配置
GuildClassTitleConfig = { }
-- 配置
GuildClassTitleConfig.Config = { }
-- 获取配置信息
function GuildClassTitleConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end
    return self.Config[level]
end
-- *********************************************************************
-- 联盟捐献配置
GuildDonateConfig = { }
-- 配置
GuildDonateConfig.Config = { }
-- 获取配置信息
-- key = sequence .. "_" .. times
function GuildDonateConfig:getConfigByTimes(key)
    if self.Config == nil or self.Config[key] == nil then
        return nil
    end
    return self.Config[key]
end
-- *********************************************************************
-- 联盟目标配置
GuildTargetConfig = { }
-- 配置
GuildTargetConfig.Config = { }
-- 获取配置信息
function GuildTargetConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end
-- *********************************************************************
-- 主城等级配置--
MainCityLevelConfig = { }
-- 配置
MainCityLevelConfig.Config = { }
-- 获取配置信息
function MainCityLevelConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end
    return self.Config[level]
end
-- *********************************************************************
-- 任务配置
TaskConfig = { }
-- 主线任务
TaskConfig.MainTaskConfig = { }
-- 支线任务
TaskConfig.BranchTaskConfig = { }
-- 任务宝箱
TaskConfig.TaskBoxConfig = { }
-- 获取主线任务配置
function TaskConfig:getMainTaskConfigById(id)
    if self.MainTaskConfig == nil then
        return nil
    end
    return self.MainTaskConfig[id]
end
-- 获取支线任务配置
function TaskConfig:getBranchTaskConfigById(id)
    if self.BranchTaskConfig == nil then
        return nil
    end
    return self.BranchTaskConfig[id]
end
-- 获取任务宝箱配置
function TaskConfig:getTaskBoxConfigById(id)
    if self.TaskBoxConfig == nil then
        return nil
    end
    return self.TaskBoxConfig[id]
end

--- *********************************************************************
-- 铁匠铺
-- 锻造配置
SmithyForgeConfig = { }
SmithyForgeConfig.Config = { }

function SmithyForgeConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end
    return self.Config[level]
end
-- 碎片合成配置
SmithyCombineConfig = { }
SmithyCombineConfig.Config = { }

function SmithyCombineConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end

-- *********************************************************************
-- 技能--
-- *********************************************************************
SkillDataConfig = { }
SkillDataConfig.Config = { }

function SkillDataConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end

-- *********************************************************************
-- 宝石配置--
-- *********************************************************************
GemDataConfig = { }
GemDataConfig.Config = { }

function GemDataConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end

-- *********************************************************************
-- 宝石槽位配置--
-- *********************************************************************
GemSlotDataConfig = { }
GemSlotDataConfig.Config = { }
GemSlotDataConfig.SlotList =
{
    [EquipType.WU_QI] = { },
    [EquipType.TOU_KUI] = { },
    [EquipType.KAI_JIA] = { },
    [EquipType.SHI_PIN] = { },
    [EquipType.HU_TUI] = { },
}
function GemSlotDataConfig:getConfigByIndex(index)
    if self.Config == nil or self.Config[index] == nil then
        return nil
    end
    return self.Config[index]
end

-- *********************************************************************
-- 职业、兵种--
-- *********************************************************************
RaceDataConfig = { }
RaceDataConfig.Config = { }

function RaceDataConfig:getConfigByRace(raceType)
    -- 根据职业类型而不是职业Id
    if self.Config == nil or self.Config[raceType] == nil then
        return nil
    end
    return self.Config[raceType]
end

-- *********************************************************************
-- 商店
-- *********************************************************************
ShopConfig = { }
ShopConfig.Config = { }

function ShopConfig:getConfigByType(shopType)
    if self.Config == nil or self.Config[shopType] == nil then
        return nil
    end
    return self.Config[shopType]
end

-- *********************************************************************
-- 国家
-- *********************************************************************
DefaultCountryConfig = { }
DefaultCountryConfig.Config = { }

function DefaultCountryConfig:getConfigById(Id)
    if self.Config == nil or self.Config[Id] == nil then
        return nil
    end

    return self.Config[Id]
end
-- *********************************************************************
-- 野区
-- **
-- *********************************************************************
RegionLevel = { }
RegionLevel.Config = { }
function RegionLevel:getConfigByLevel(lvl)
    if self.Config == nil or self.Config[lvl] == nil then
        return nil
    end
    return self.Config[lvl]
end

-- *********************************************************************
-- 百战军衔等级配置
Pvp100RankLevelConfig = { }
-- 配置
Pvp100RankLevelConfig.Config = { }
-- 获取配置信息
function Pvp100RankLevelConfig:getConfigByLevel(level)
    if self.Config == nil or self.Config[level] == nil then
        return nil
    end
    return self.Config[level]
end
-- 百战军衔奖励配置
Pvp100RankPrizeConfig = { }
-- 配置
Pvp100RankPrizeConfig.Config = { }
-- 获取配置信息
function Pvp100RankPrizeConfig:getConfigById(id)
    if self.Config == nil or self.Config[id] == nil then
        return nil
    end
    return self.Config[id]
end

-- 基础信息--
-- *********************************************************************
local BaseData = { }
-- 清除--
function BaseData:clear()
    MonarchsConfig.VipConfig = nil
    MonarchsConfig.LevelConfig = nil
    ItemsConfig.Config = nil
    CaptainConfig.Config = nil
    SoldierConfig.Config = nil
    TechnologyConfig.Config = nil
    TechnologyConfig.ConfigByTypeAndSequenceAndLevel = nil
    BuildingLayoutConfig.BuildingLayoutConfigList = nil
    BuildingLayoutConfig.BaseLevelUnlockLayouts = nil
    BuildingLayoutConfig.CoordinatesOffsetToLayouts = nil
    BuildingConfig.Config = nil
    SettingConfig.Config = nil
    SmithyForgeConfig.Config = nil
    SmithyCombineConfig.Config = nil
end
-- 更新道具模块配置--
function BaseData.updateGoodsCommonConfig(data)
    GoodsCommonConfig.Config = GoodsCommonLocalConfig()
    GoodsCommonConfig.Config:updateInfo(data)
end
-- 更新军政模块配置--
function BaseData.updateMilitaryCommonConfig(data)
    MilitaryCommonConfig.Config = MilitaryCommonLocalConfig()
    MilitaryCommonConfig.Config:updateInfo(data)
end
-- 更新大地图模块配置--
function BaseData.updateRegionCommonConfig(data)
    RegionCommonConfig.Config = RegionCommonLocalConfig()
    RegionCommonConfig.Config:updateInfo(data)
end
-- 更新Misc配置
function BaseData.updateMiscCommonConfig(data)
    MiscCommonConfig.Config = MiscCommonLocalConfig()
    MiscCommonConfig.Config:updateInfo(data)
end
-- 更新联盟配置
function BaseData.updateGuildConfig(data)
    GuildConfig.Config = GuildConfigClass()
    GuildConfig.Config:updateInfo(data)
end
-- 更新君主vip配置--
--    function BaseData.updateMonarchsVipConfig(data)

--        MonarchsConfig.VipConfig = {}
--        for k,v in ipairs(data) do
--            MonarchsConfig.VipConfig[k] = v
--        end
--    end
-- 更新君主等级配置--
function BaseData.updateMonarchsLevelConfig(data)
    MonarchsConfig.LevelConfig = { }
    for k, v in ipairs(data) do
        local config = HeroLevelClass()
        config:updateInfo(v)
        MonarchsConfig.LevelConfig[config.Level] = config
    end
end
-- 更新道具配置--
function BaseData.updateItemsConfig(data)
    ItemsConfig.Config = { }
    for k, v in ipairs(data) do
        local item = ItemLocalInfo()
        item:updateInfo(v)
        ItemsConfig.Config[item.Id] = item
    end
end
-- 更新武将配置--
function BaseData.updateCaptainConfig(data)
    CaptainConfig.Config = { }
    for k, v in ipairs(data) do
        local captainBase = CaptainDataClass()
        captainBase:updateInfo(v)
        CaptainConfig.Config[captainBase.Id] = captainBase
    end
end
-- 更新武将转生配置
function BaseData.updataCaptainRebirthConfig(data)
    CaptainRebirthConfig.Config = { }
    CaptainRebirthConfig.MaxLevel = 0
    for k, v in ipairs(data) do
        local captainRebirthBase = CaptainRebirthLevelInfo()
        captainRebirthBase:updateInfo(v)
        CaptainRebirthConfig.Config[captainRebirthBase.Level] = captainRebirthBase
        if v.level > CaptainRebirthConfig.MaxLevel then
            CaptainRebirthConfig.MaxLevel = v.level
        end
    end
end
-- 更新士兵配置--
function BaseData.updateSoldierConfig(data)
    SoldierConfig.Config = { }
    for k, v in ipairs(data) do
        local soldier = SoldierLevelClass()
        soldier:updateInfo(v)
        SoldierConfig.Config[soldier.Level] = soldier
    end
end
-- 更新科技点配置--
function BaseData.updateTechnologyConfig(data)
    TechnologyConfig.Config = { }
    TechnologyConfig.ConfigByTypeAndSequenceAndLevel = { }

    local strKey
    for k, v in ipairs(data) do
        local tech = TechnologyDataClass()
        tech:updateInfo(v)
        TechnologyConfig.Config[tech.Id] = tech

        if tech ~= nil then
            if TechnologyConfig.ConfigByTypeAndSequenceAndLevel[tech.Type] == nil then
                TechnologyConfig.ConfigByTypeAndSequenceAndLevel[tech.Type] = { }
            end

            if TechnologyConfig.ConfigByTypeAndSequenceAndLevel[tech.Type][tech.Sequence] == nil then
                TechnologyConfig.ConfigByTypeAndSequenceAndLevel[tech.Type][tech.Sequence] = { }
            end

            if TechnologyConfig.ConfigByTypeAndSequenceAndLevel[tech.Type][tech.Sequence][tech.Level] == nil then
                TechnologyConfig.ConfigByTypeAndSequenceAndLevel[tech.Type][tech.Sequence][tech.Level] = tech
            end
        end
    end
end
-- 更新建筑布局配置--
function BaseData.updateBuildingLayoutConfig(data)
    BuildingLayoutConfig.BuildingLayoutConfigList = { }
    BuildingLayoutConfig.BaseLevelUnlockLayouts = { }
    BuildingLayoutConfig.CoordinatesOffsetToLayouts = { }

    for k, v in ipairs(data) do
        BuildingLayoutConfig.BuildingLayoutConfigList[v.id] = BuildingLayoutClass()
        BuildingLayoutConfig.BuildingLayoutConfigList[v.id]:updateInfo(v)

        -- 更新基地等级解锁的布局Id列表
        if BuildingLayoutConfig.BaseLevelUnlockLayouts[v.require_base_level] == nil then
            BuildingLayoutConfig.BaseLevelUnlockLayouts[v.require_base_level] = { }
        end
        table.insert(BuildingLayoutConfig.BaseLevelUnlockLayouts[v.require_base_level], v.id)

        -- 更新ODDQ坐标偏移对应的布局Id列表
        local offset = v.region_offset_x .. "_" .. v.region_offset_y

        if BuildingLayoutConfig.CoordinatesOffsetToLayouts[offset] == nil then
            BuildingLayoutConfig.CoordinatesOffsetToLayouts[offset] = v.id
        end
    end
end
-- 更新建筑配置--
function BaseData.updateBuildingConfig(data)
    BuildingConfig.Config = { }
    BuildingConfig.ConfigByTypeAndLevel = { }
    for k, v in ipairs(data) do
        local building = BuildingDataClass()
        building:updateInfo(v)
        BuildingConfig.Config[v.id] = building
        BuildingConfig.ConfigByTypeAndLevel[v.type .. "_" .. v.level] = building
    end
end

-- 更新设置配置--
function BaseData.updateSettingConfig(data)
    SettingConfig.Config = { }
    for k, v in ipairs(data) do
        local config = StringPairClass()
        config:updateInfo(v)
        SettingConfig.Config[config.Key] = config
    end
end
-- 更新帮派等级配置--
function BaseData.updateGuildLevelConfig(data)
    GuildLevelConfig.Config = { }
    for k, v in ipairs(data) do
        print("updateGuildLevelConfig", k, v.level, v.upgrade_building)
        local config = GuildLevelClass()
        config:updateInfo(v)
        GuildLevelConfig.Config[v.level] = config
    end
end

-- 更新帮派职位配置
function BaseData.updateGuildClassLevelConfig(data)
    GuildClassLevelConfig.Config = { }
    for k, v in ipairs(data) do
        local config = GuildClassLevelClass()
        config:updateInfo(v)
        GuildClassLevelConfig.Config[v.level] = config
    end
end

-- 更新联盟系统职称配置
function BaseData.updateGuildClassTitleConfig(data)
    GuildClassTitleConfig.Config = { }

    for k, v in ipairs(data) do
        local config = GuildClassTitleDataClass()
        config:updateInfo(v)
        GuildClassTitleConfig.Config[v.id] = config
    end
end
-- 更新帮派捐献数据
function BaseData.updateGuildDonateConfig(data)
    GuildDonateConfig.Config = { }

    for k, v in ipairs(data) do
        local config = GuildDonateClass()
        config:updateInfo(v)
        GuildDonateConfig.Config[v.sequence .. "_" .. v.times] = config
    end
end
-- 更新帮派目标数据
function BaseData.updateGuildTargetConfig(data)
    GuildTargetConfig.Config = { }

    for k, v in ipairs(data) do
        local config = GuildTargetClass()
        config:updateInfo(v)
        GuildTargetConfig.Config[v.id] = config
    end
end
-- 更新主城每一级对应的数据配置--
function BaseData.updateMainCityLevelConfig(data)
    MainCityLevelConfig.Config = { }
    for k, v in ipairs(data) do
        local config = MainCityLevelClass()
        config:updateInfo(v)
        MainCityLevelConfig.Config[config.Level] = config
    end
end
-- 更新装备数据配置--
function BaseData.updateEquipConfig(data)
    EquipsConfig.Config = { }
    for k, v in ipairs(data) do
        local config = EquipLocalInfo()
        config:updateInfo(v)
        EquipsConfig.Config[config.Id] = config
    end
end
-- 更新装备品质数据配置--
function BaseData.updateEquipQualityConfig(data)
    EquipQualityConfig.Config = { }
    for k, v in ipairs(data) do
        local config = EquipQualityLocalInfo()
        config:updateInfo(v)
        EquipQualityConfig.Config[config.Id] = config
    end
end
-- 更新装备强化数据配置--
function BaseData.updateEquipRefinedConfig(data)
    EquipRefinedConfig.Config = { }
    for k, v in ipairs(data) do
        local config = EquipRefinedLocalInfo()
        config:updateInfo(v)
        EquipRefinedConfig.Config[config.Level] = config
    end
end
-- 更新装备套装数据配置--
function BaseData.updateEquipTaozConfig(data)
    EquipTaozConfig.Config = { }
    for k, v in ipairs(data) do
        local config = EquipTaozLocalInfo()
        config:updateInfo(v)
        EquipTaozConfig.Config[config.Level] = config
    end
end

-- 更新武将每一级对应的数据配置
function BaseData.updateCaptainLevelConfig(data)
    CaptainLevelConfig.Config = { }
    for k, v in ipairs(data) do
        CaptainLevelConfig.Config[v.level] = v.upgrade_exp
    end
end

-- 更新武将成长点数据配置
function BaseData.updateCaptainAbilityConfig(data)
    CaptainAbilityConfig.Config = { }

    for k, v in ipairs(data) do
        local config = CaptainAbilityLocalInfo()
        config:updateInfo(v)
        CaptainAbilityConfig.Config[config.Ability] = config
    end
end

-- 更新将魂配置信息
function BaseData.updataCaptainSoulConfig(data)
    CaptainSoulConfig.Config = { }

    for k, v in ipairs(data) do
        local config = CaptainSoulInfoClass()
        config:updateInfo(v)
        CaptainSoulConfig.Config[config.Id] = config
    end
end

-- 更新羁绊配置信息
function BaseData.updateCaptainSoulFettersConfig(data)
    CaptainSoulFettersConfig.Config = { }

    for k, v in ipairs(data) do
        local config = CaptainSoulFettersClass()
        config:updateInfo(v)
        CaptainSoulFettersConfig.Config[config.Id] = config
    end
end

-- 更新修炼馆等级数据配置
function BaseData.updateTrainingLevelConfig(data)
    TrainingLevelConfig.Config = { }

    for k, v in ipairs(data) do
        local config = TrainingLevelLocalInfo()
        config:updateInfo(v)
        TrainingLevelConfig.Config[config.Level] = config
    end
end

-- 更新千重楼数据配置
function BaseData.updateTowerConfig(data)
    TowerConfig.Config = { }

    for k, v in ipairs(data) do
        local config = TowerLocalInfo()
        config:updateInfo(v)
        TowerConfig.Config[config.Floor] = config
    end
end
-- 更新重楼密室数据配置
function BaseData.updateTowerBackroomConfig(data)
    BackroomConfig.Config = { }

    for k, v in ipairs(data) do
        local config = TowerBackroomLocalInfo()
        config:updateInfo(v)
        BackroomConfig.Config[config.Floor] = config
    end
end
-- 更新重楼密室通用数据配置
function BaseData.updateTowerBackroomCommonConfig(data)
    BackroomCommonConfig.Config = TowerBackroomCommonLocalInfo()
    BackroomCommonConfig.Config:updateInfo(data)
end

-- 更新主线任务配置
function BaseData.updateMainTaskConfig(data)
    if data == nil then
        return
    end

    TaskConfig.MainTaskConfig = { }

    for k, v in ipairs(data) do
        local config = TaskDataClass()
        config:updateInfo(v)
        TaskConfig.MainTaskConfig[v.id] = config
    end
end
-- 更新支线任务配置
function BaseData.updateBranchTaskConfig(data)
    if data == nil then
        return
    end

    TaskConfig.BranchTaskConfig = { }

    for k, v in ipairs(data) do
        local config = TaskDataClass()
        config:updateInfo(v)
        TaskConfig.BranchTaskConfig[v.id] = config
    end
end
-- 更新主线任务配置
function BaseData.updateTaskBoxConfig(data)
    if data == nil then
        return
    end

    TaskConfig.TaskBoxConfig = { }

    for k, v in ipairs(data) do
        local config = TaskBoxClass()
        config:updateInfo(v)
        TaskConfig.TaskBoxConfig[v.id] = config
    end
end

-- 更新铁匠铺重铸配置
function BaseData.updateSmithyForgeConfig(data)
    if data == nil then
        return
    end

    SmithyForgeConfig.Config = { }
    for k, v in ipairs(data) do
        local config = SmithyForgeClass()
        config:updateInfo(v)
        SmithyForgeConfig.Config[v.level] = config
    end
end

-- 更新铁匠铺合成配置
function BaseData.updateSmithyCombineConfig(data)
    if data == nil then
        return
    end

    SmithyCombineConfig.Config = { }
    for k, v in ipairs(data) do
        local config = SmithyCombineClass()
        config:updateInfo(v)
        SmithyCombineConfig.Config[v.id] = config
    end
end

-- 技能数据配置
function BaseData.updateSkillDataConfig(data)
    if data == nil then
        return
    end

    SkillDataConfig.Config = { }
    for k, v in ipairs(data) do
        local config = SkillInfoClass()
        config:updateInfo(v)
        SkillDataConfig.Config[config.Id] = config
    end
end

-- 宝石数据配置
function BaseData.updateGemDataConfig(data)
    if data == nil then
        return
    end

    GemDataConfig.Config = { }
    for k, v in ipairs(data) do
        local config = GemLocalInfo()
        config:updateInfo(v)
        GemDataConfig.Config[config.Id] = config
    end
end

-- 更新宝石槽位数据配置
function BaseData.updateGemSlotDataConfig(data)
    if data == nil then
        return
    end

    GemSlotDataConfig.Config = { }
    GemSlotDataConfig.SlotList =
    {
        [EquipType.WU_QI] = { },
        [EquipType.TOU_KUI] = { },
        [EquipType.KAI_JIA] = { },
        [EquipType.SHI_PIN] = { },
        [EquipType.HU_TUI] = { },
    }
    for k, v in ipairs(data) do
        local config = GemSlotDataClass()
        config:updateInfo(v)
        GemSlotDataConfig.Config[v.slot_idx] = config
        table.insert(GemSlotDataConfig.SlotList[config.Type], config)
    end
end

-- 职业数据配置
function BaseData.UpdateRaceDataConfig(data)
    if data == nil then
        return
    end

    RaceDataConfig.Config = { }
    for k, v in ipairs(data) do
        local config = RaceDataClass()
        config:updateInfo(v)
        RaceDataConfig.Config[v.race] = config
    end
end

-- 商店数据配置
function BaseData.updateShopConfig(data)
    if data == nil then
        return
    end

    ShopConfig.Config = { }

    for k, v in ipairs(data) do
        local config = ShopClass()
        config:updateInfo(v)
        ShopConfig.Config[v.type] = config
    end
end

-- 国家配置
function BaseData.updateDefaultCountryConfig(data)
    if data == nil then
        return
    end

    DefaultCountryConfig.Config = { }

    for k, v in ipairs(data) do
        local config = DefaultCountryClass()
        config:updateInfo(v)
        DefaultCountryConfig.Config[v.id] = config
    end
end

-- 更新地区配置数据
function BaseData.updateRegionLevelConfig(data)
    if data == nil then
        return
    end

    for i, v in ipairs(data) do
        RegionLevel.Config[v.level] = RegionLevelClass()
        RegionLevel.Config[v.level]:updateInfo(v)
    end
end

-- 更新百战基础信息配置
function BaseData.updatePvp100CommonConfig(data)
    if data == nil then
        return
    end
    Pvp100CommonConfig.Config = Pvp100CommonClass()
    Pvp100CommonConfig.Config:updateInfo(data)
end

-- 更新百战军衔等级配置
function BaseData.updatePvp100RankLevelConfig(data)
    if data == nil then
        return
    end

    for i, v in ipairs(data) do
        local config = Pvp100RankLevelClass()
        config:updateInfo(v)
        Pvp100RankLevelConfig.Config[config.Level] = config
    end
end

-- 更新百战军衔奖励配置
function BaseData.updatePvp100RankPrizeConfig(data)
    if data == nil then
        return
    end

    for i, v in ipairs(data) do
        local config = Pvp100RankPrizeClass()
        config:updateInfo(v)
        Pvp100RankPrizeConfig.Config[config.Id] = config
    end
end

-- 更新排行榜配置
function BaseData.updateRankingConfig(data)
    DataTrunk.PlayerInfo.RankingData.RankingDataCount = data.rank_count_per_page
end

return BaseData