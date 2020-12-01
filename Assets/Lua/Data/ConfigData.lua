-- *********************************************************************
-- 通用定义
-- *********************************************************************

-- *********************************************************************
-- HeroDomesticProto在InternalAffairsData.lua中
-- HeroMilitaryProto在MilitaryAffairsData.lua中
-- HeroProto在MonarchsData.lua中
-- *********************************************************************

-- 渲染层级
SortingLayerId =
{
    Default = "Default",
    Layer1 = "Layer1",
}
-- 常量
Const = {
    -- 无限大
    INFINITE = 999999,
}
-- 聊天类型
ChatChannelType = {
    None = 0,
    -- 世界频道
    World = 1,
    -- 联盟频道
    Guild = 2,
    -- 好友频道
    Friend = 3,
    -- 敌对频道
    Opposite = 4,
}

-- 装备类型
EquipType = {
    None = 0,
    -- 武器
    WU_QI = 1,
    -- 头盔
    TOU_KUI = 2,
    -- 铠甲
    KAI_JIA = 3,
    -- 饰品
    SHI_PIN = 4,
    -- 护腿
    HU_TUI = 5,
}

-- 堆叠道具类型
ItemType = {
    None = 0,
    -- 资源
    Resource = 1,
    -- 加速
    Accelerate = 2,
    -- 经验丹
    EXP = 4,
    -- 随机迁城
    BaseMove = 10,
    -- 高级迁城
    AdvancedMove = 11,
}
-- 经验丹类型
ItemExpEffectType =
{
    None = - 1,
    -- 无效值
    InvalidGoodsExp = 0,
    -- 君主经验丹
    Hero = 1,
    -- 武将强化经验丹
    GeneralRefine = 2,
    -- 武将转生经验丹
    GeneralRebirth = 3,
}
-- 道具分类
ItemClassifyType = {
    -- 通货
    Currency = 0,
    -- 普通道具
    Default = 1,
    -- 装备道具
    Equip = 2,
    -- 宝石道具
    Gem = 3,
    -- 宝箱道具
    Box = 4,
    -- 将魂
    CaptainSoul = 5,
}

-- 道具角标
ItemCornerType = {
    -- 正常
    Noraml = 0,
    -- 首胜
    FirstWin = 1,
    -- 几率
    Prob = 2,
    -- 超级
    Super = 3,
}

-- 阵营--
CampType = {
    None = 0,
    -- 攻击方--
    Attacker = 1,
    -- 防御方--
    Defender = 2,
}

-- 攻击类型--
HurtType = {
    None = 0,
    -- 普通攻击--
    Normal = 1,
    -- 暴击--
    Crit = 2,
    -- 闪避--
    Miss = 3,
}

-- 技能类型--
SkillType = {
    None = 0,
    -- 普攻
    NormalAttack = 1,
    -- 克制技能
    Restrain = 2,
}

-- 战斗类型--
BattleStyleType = {
    None = 0,
    -- pvp
    PVP = 1,
    -- pve
    PVE = 2,
}
-- 战斗部署类型--
BattleDeploymentType = {
    None = 0,
    -- pvp出征
    PVP_Invasion = 1,
    -- pvp援助
    PVP_Assist = 2,
    -- pvp自己驱逐
    PVP_Expel_ForSelf = 3,
    -- pvp盟友驱逐
    PVP_Expel_ForFriend = 4,
    -- pve千重楼
    PVE_ClimbingTower = 5,
    -- pve重楼密室
    PVE_TowerBackroom = 6,
    -- pve剧情副本
    PVE_Plot = 7,
    -- pve百战千军
    PVE_Battle100 = 8,
}

-- 战斗结果类型--
BattleResultType = {
    None = 0,
    -- 完胜--
    CompleteWin = 1,
    -- 大胜--
    Victory = 2,
    -- 小胜--
    Win = 3,
    -- 险胜--
    Squeak = 4,
    -- 惜败
    Failure = 5,
}

-- 密室战斗类型
TowerBackroomBattleMode =
{
    -- 挑战
    Challenge = 0,
    -- 协助
    Help = 1,
}
-- 通货--
CurrencyType = {
    None = 0,
    -- 金币--
    Gold = 1,
    -- 粮食--
    Food = 2,
    -- 木材--
    Wood = 3,
    -- 石料--
    Stone = 4,
    -- 繁荣度--
    Prosperity = 5,
    -- 科技点--
    SATPoint = 6,
    -- 武将经验--
    CaptainExp = 7,
    -- 君主经验
    MonarchsExp = 8,
    -- 元宝--
    Money = 9,
    -- 联盟贡献--
    GuildContribution = 10,

    valueToKey = function(value)
        for k, v in pairs(CurrencyType) do
            if v == value then
                return k
            end
        end
    end
}

-- 科技类型
TechnologyType = {
    None = 0,
    -- 内政科技
    NeiZheng = 1,
    -- 士兵科技
    BuBing = 11,
    QiBing = 12,
    GongBing = 13,
    CheBing = 14,
    XieBing = 15,
}

-- 武将类型--
RaceType = {
    None = 0,
    -- 步兵--
    Infantry = 1,
    -- 骑兵--
    Cavalry = 2,
    -- 弓兵--
    Archer = 3,
    -- 车兵--
    Chariots = 4,
    -- 械兵--
    Catapult = 5,

    valueToKey = function(value)
        for k, v in pairs(CurrencyType) do
            if v == value then
                return k
            end
        end
    end
}

-- 兵种克制类型
RestraintRoundType = {
    None = 0,
    -- 奇数轮
    ODD = 1,
    -- 偶数轮
    EVEN = 2,
}

-- 品质
Quality = {
    None = - 1,
    -- 无效品质
    InvalidQuality = 0,
    -- 白色
    White = 1,
    -- 绿色
    Green = 2,
    -- 蓝色
    Blue = 3,
    -- 紫色
    Purple = 4,
    -- 橙色
    Orange = 5,
    -- 红色
    Red = 6,
}

-- 建筑类型--
BuildingType = {
    None = 0,

    -- 主城--
    MainCity = 1,
    -- 官府--
    FeudalOfficial = 2,
    -- 仓库--
    Warehouse = 3,
    -- 酒馆--
    Tavern = 4,
    -- 军营--
    Barrack = 5,
    -- 城墙--
    Rampart = 6,
    -- 书院--
    Academy = 7,
    -- 外使院--
    Recruitment = 8,
    -- 铁匠铺
    Smithy = 9,
    -- 修炼馆
    PracticeHall = 10,
    -- 市场
    Bazaar = 11,
    -- 行营 --
    Campsite = 12,
    -- 这里其实是客户端自己加的(为了城内建筑标签显示正确做的统一处理,包括以后的建筑图标显示)
    -- 千重楼
    ClimbingTower = 13,
    -- 鱼塘
    Fishpond = 14,
    -- 农场
    Farm = 15,

    -- 添加新建筑时请修改此值，用于判断建筑个数，任务跳转判断等！！！
    CityBuildingCount = 15,

    -- 铜矿--
    GoldMine = 21,
    -- 农田--
    Cropland = 22,
    -- 伐木场--
    Sawmill = 23,
    -- 采石场--
    StonePit = 24,
}

-- 建筑队状态--
BuilderState = {
    None = 0,
    -- 忙碌--
    Busy = 1,
    -- 休息--
    Resting = 2,
    -- 空闲--
    Idle = 3,
    -- 解散--
    Dissolve = 4,
}

-- 移动方向类型--
DirectionType = {
    -- 原地不动
    Origin = 0,
    Up = 1,
    Left_up = 2,
    Left = 3,
    Left_down = 4,
    Down = 5,
    Right_down = 6,
    Right = 7,
    Right_up = 8,
}

-- 攻击类型--
HurtType = {
    None = 0,
    -- 普通攻击--
    Normal = 1,
    -- 暴击--
    Crit = 2,
    -- 闪避--
    Miss = 3,
}

-- 角色移动方式
ActorMoveType = {
    -- 走动
    Walk = 0,
    -- 跑动
    Run = 1,
}
-- 角色槽位点类型
ActorSlotType =
{
    None = - 1,
    -- 脚底
    Base = 0,
    -- 中心
    Center = 1,
    -- 头部
    Head = 2,
    -- 左手
    LeftHand = 3,
    -- 右手
    RightHand = 4,
    -- 武器01
    Weapon01 = 5,
    -- 武器02
    Weapon02 = 6,
}

-- 军情移动状态
MilitaryMoveType =
{
    -- 往目标移动
    Forward = 0,
    -- 到达
    Arrived = 1,
    -- 回家
    Back = 2
}

-- 军情移动状态
MilitaryActionType =
{
    -- 入侵
    Invasion = 0,
    -- 救援
    Assist = 1,
}
-- 任务目标类型
TaskTargetType =
{
    -- 兼容proto2
    InvalidTaskTargetType = 0,
    -- 主城升到X级
    TASK_TARGET_BASE_LEVEL = 1,
    -- 君主升到X级
    TASK_TARGET_HERO_LEVEL = 2,
    -- 科技升到ID为X
    TASK_TARGET_TECH_LEVEL = 3,
    -- 建筑Y升到X级
    TASK_TARGET_BUILDING_LEVEL = 4,
    -- 拥有X个武将
    TASK_TARGET_CAPTAIN_COUNT = 5,
    -- 拥有X个Y级的武将
    TASK_TARGET_CAPTAIN_LEVEL_COUNT = 6,
    -- 拥有X个Y品质的武将
    TASK_TARGET_CAPTAIN_QUALITY_COUNT = 7,
    -- 拥有X个武将身上穿Y件Z级装备
    TASK_TARGET_CAPTAIN_EQUIPMENT = 8,
    -- 强化武将历史总次数达到X
    TASK_TARGET_CAPTAIN_REFINED_TIMES = 9,
    -- 拥有X个武将在修炼
    TASK_TARGET_TRAINING_USE_COUNT = 10,
    -- 拥有X个Y级的修炼位
    TASK_TARGET_TRAINING_LEVEL_COUNT = 11,
    -- 训练X个士兵
    TASK_TARGET_RECRUIT_SOLDIER_COUNT = 12,
    -- 治疗X个士兵
    TASK_TARGET_HEAL_SOLDIER_COUNT = 13,
    -- 士兵等级升到X级
    TASK_TARGET_SOLDIER_LEVEL = 14,
    -- 千重楼通关X层
    TASK_TARGET_TOWER_FLOOR = 15,
    -- 拥有X块Y类型资源（Y空表任意资源）
    TASK_TARGET_RESOURCE_POINT_COUNT = 16,
    -- 收获X数量的Y资源（Y空表任意资源）
    TASK_TARGET_COLLECT_RESOURCE = 17,
    -- 加入联盟
    TASK_TARGET_JOIN_GUILD = 18,
}

-- 联盟目标类型
GuildTargetType =
{
    InvalidGuildTargetType = 0,
    --  玩家升级到xxx职位
    UpgradeClassLevel = 1,
    --  由玩家弹劾盟主
    ImpeachLeader = 2,
    --  升级到x级
    GuildLevelUp = 3,
    --  联盟成员达到n人
    MemberCount = 4,
    --  建立联盟雕像
    PlaceStatue = 5,
    --  加入一个国家
    JoinCountry = 6,
}

-- *********************************************************************
-- 模块通用数据类
-- *********************************************************************
-- 花费配置
CostClass = Class()
CostClass.Gold = 0
CostClass.Food = 0
CostClass.Wood = 0
CostClass.Stone = 0
CostClass.YuanBao = 0
CostClass.GuildContributionCoin = 0
CostClass.GoodsId = { }
CostClass.GoodsCount = { }

function CostClass:updateInfo(data)
    if data == nil then
        return
    end

    self.Gold = data.gold
    self.Food = data.food
    self.Wood = data.wood
    self.Stone = data.stone
    self.YuanBao = data.yuanbao

    if data.guild_contribution_coin ~= nil then
        self.GuildContributionCoin = data.guild_contribution_coin
    end

    if data.goods_id ~= nil then
        for k, v in ipairs(data.goods_id) do
            self.GoodsId[k] = v
        end
    end

    if data.goods_count ~= nil then
        for k, v in ipairs(data.goods_count) do
            self.GoodsCount[k] = v
        end
    end
end

-- 兑换获得物品配置
PrizeClass = Class()
PrizeClass.Gold = 0
PrizeClass.Food = 0
PrizeClass.Wood = 0
PrizeClass.Stone = 0
PrizeClass.MonarchsExp = 0
PrizeClass.CaptainExp = 0
PrizeClass.Currencys = { }
PrizeClass.Goods = { }
PrizeClass.Equips = { }
PrizeClass.CaptainSoul = { }
PrizeClass.Gem = { }

local function checkPrizeEmpty(data)
    local result = true

    if data.gold > 0 then
        result = false
        return result
    end
    if data.food > 0 then
        result = false
        return result
    end
    if data.wood > 0 then
        result = false
        return result
    end
    if data.stone > 0 then
        result = false
        return result
    end
    if #data.goods_id > 0 then
        result = false
        return result
    end
    if #data.equipment_id > 0 then
        result = false
        return result
    end
    return result
end
function PrizeClass:clear()
    self.Gold = 0
    self.Food = 0
    self.Wood = 0
    self.Stone = 0
    self.MonarchsExp = 0
    self.CaptainExp = 0
    self.Currencys = { }
    self.Goods = { }
    self.Equips = { }
    -- 将魂
    self.CaptainSoul = { }
    self.Gem = { }
end
function PrizeClass:updateInfo(data)
    self.Gold = self.Gold + data.gold
    self.Food = self.Food + data.food
    self.Wood = self.Wood + data.wood
    self.Stone = self.Stone + data.stone
    self.CaptainExp = self.CaptainExp + data.captain_exp
    self.MonarchsExp = self.MonarchsExp + data.hero_exp

    -- 相加
    itemAdd = function(tab, classifyType, id, amount)
        if amount > 0 then
            if tab[id] ~= nil then
                tab[id].Amount = tab[id].Amount + amount
            else
                local itemShow = ItemShowInfo()
                itemShow:updateInfo(id, amount, classifyType)
                tab[id] = itemShow
            end
        end
    end

    -- 通货
    itemAdd(self.Currencys, ItemClassifyType.Currency, CurrencyType.Gold, data.gold)
    itemAdd(self.Currencys, ItemClassifyType.Currency, CurrencyType.Food, data.food)
    itemAdd(self.Currencys, ItemClassifyType.Currency, CurrencyType.Wood, data.wood)
    itemAdd(self.Currencys, ItemClassifyType.Currency, CurrencyType.Stone, data.stone)
    itemAdd(self.Currencys, ItemClassifyType.Currency, CurrencyType.CaptainExp, data.captain_exp)
    itemAdd(self.Currencys, ItemClassifyType.Currency, CurrencyType.MonarchsExp, data.hero_exp)

    -- 堆叠道具
    for i = 1, #data.goods_id, 1 do
        itemAdd(self.Goods, ItemClassifyType.Default, data.goods_id[i], data.goods_count[i])
    end
    -- 装备
    for i = 1, #data.equipment_id, 1 do
        itemAdd(self.Equips, ItemClassifyType.Equip, data.equipment_id[i], data.equipment_count[i])
    end
    -- 将魂
    for i = 1, #data.captain_soul_id, 1 do
        itemAdd(self.CaptainSoul, ItemClassifyType.CaptainSoul, data.captain_soul_id[i], data.captain_soul_count[i])
    end
    -- 宝石
    for i = 1, #data.gem_id, 1 do
        itemAdd(self.Gem, ItemClassifyType.Gem, data.gem_id[i], data.gem_count[i])
    end
end

-- *********************************************************************
-- 道具通用模块配置
GoodsCommonLocalConfig = Class()
-- 装备升级所需道具
GoodsCommonLocalConfig.EquipUpgradeReqGood = nil
-- 装备进阶所需道具
GoodsCommonLocalConfig.EquipRefinedReqGood = nil
-- 武将强化符的物品id
GoodsCommonLocalConfig.CaptainRefineGoods = nil
-- 武将转职的物品id
GoodsCommonLocalConfig.CaptainChangeRaceGood = nil
-- 武将转生道具Id
GoodsCommonLocalConfig.CaptainRebirthGoods = nil
-- 高级迁城的物品Id
GoodsCommonLocalConfig.AdvancedMoveBaseGoods = nil
-- 随机迁城的物品Id
GoodsCommonLocalConfig.RandomMoveBaseGoods = nil
-- 迁徙行营的物品Id
GoodsCommonLocalConfig.MoveCampsiteGoods = nil
-- 免战牌物品Id
GoodsCommonLocalConfig.AvoidWarGoods = nil

-- 更新信息--
function GoodsCommonLocalConfig:updateInfo(data)
    self.EquipUpgradeReqGood = ItemsConfig:getConfigById(data.equipment_upgrade_goods)
    self.EquipRefinedReqGood = ItemsConfig:getConfigById(data.equipment_refined_goods)
    self.CaptainChangeRaceGood = ItemsConfig:getConfigById(data.change_captain_race_goods)
    self.CaptainRefineGoods = { }
    self.CaptainRebirthGoods = { }
    if nil ~= data.captain_refined_goods then
        for k, v in ipairs(data.captain_refined_goods) do
            self.CaptainRefineGoods[v] = ItemsConfig:getConfigById(v)
        end
    end

    if nil ~= data.captain_rebirth_goods then
        for k, v in ipairs(data.captain_rebirth_goods) do
            self.CaptainRebirthGoods[v] = ItemsConfig:getConfigById(v)
        end
    end
    self.AdvancedMoveBaseGoods = ItemsConfig:getConfigById(data.move_base_goods)
    self.RandomMoveBaseGoods = ItemsConfig:getConfigById(data.random_move_base_goods)
    self.MoveCampsiteGoods = ItemsConfig:getConfigById(data.move_tent_goods)
    self.AvoidWarGoods = { }
    if nil ~= data.mian_goods then
        for k, v in ipairs(data.mian_goods) do
            self.AvoidWarGoods[v] = ItemsConfig:getConfigById(v)
        end
    end
end

-- 军政模块配置
MilitaryCommonLocalConfig = Class()
-- 每次寻访武将个数
MilitaryCommonLocalConfig.GenSeekCount = 0
-- 寻访武将时间间隔
MilitaryCommonLocalConfig.SeekDuration = 0
-- 最多寻访次数
MilitaryCommonLocalConfig.SeekMaxTimes = 0
-- 防守武将个数
MilitaryCommonLocalConfig.DefenserCount = 0
-- 解雇武将最高等级
MilitaryCommonLocalConfig.FireLevelLimit = 0
-- 每个训练位开启的英雄等级
MilitaryCommonLocalConfig.TrainingHeroLevel = { }
-- 每个训练位开启的初始等级
MilitaryCommonLocalConfig.TrainingInitLevel = { }
-- 每个训练位的等级上限
MilitaryCommonLocalConfig.TrainingLevelLimit = { }
-- 更新信息
function MilitaryCommonLocalConfig:updateInfo(data)
    self.GenSeekCount = data.gen_seek_count
    self.SeekDuration = data.seek_duration
    self.SeekMaxTimes = data.seek_max_times
    self.DefenserCount = data.defenser_count
    self.FireLevelLimit = data.fire_level_limit

    for k, v in ipairs(data.training_hero_level) do
        table.insert(self.TrainingHeroLevel, v)
    end

    for k, v in ipairs(data.training_init_level) do
        table.insert(self.TrainingInitLevel, v)
    end

    for k, v in ipairs(data.training_level_limit) do
        table.insert(self.TrainingLevelLimit, v)
    end
end

-- 大地图通用模块配置
RegionCommonLocalConfig = Class()
-- 野外地图坐标
RegionCommonLocalConfig.MapLenX = 0
RegionCommonLocalConfig.MapLenY = 0

RegionCommonLocalConfig.CampsiteBuildingTime = 0
RegionCommonLocalConfig.CampsiteBuildingDuration = nil
-- 插白旗持续时间
RegionCommonLocalConfig.WhiteFlagDuration = 0

function RegionCommonLocalConfig:init()
    self.CampsiteBuildingCost = CostClass()
end

-- 更新信息--
function RegionCommonLocalConfig:updateInfo(data)
    self.MapLenX = data.map_x_len
    self.MapLenY = data.map_y_len

    self.CampsiteBuildingTime = data.tent_building_duration
    self.CampsiteBuildingDuration = data.miao_tent_building_duration
    self.CampsiteBuildingCost:updateInfo(data.miao_tent_building_cost)

    self.WhiteFlagDuration = data.white_flag_duration
end

-- Misc通用模块配置
MiscCommonLocalConfig = Class()
-- 君主改名消耗
MiscCommonLocalConfig.ChangeHeroNameCost = nil
-- 邮件每批返回多少个
MiscCommonLocalConfig.MailBatchCount = 0
-- 千重楼挑战最大次数
MiscCommonLocalConfig.TowerChallengeMaxTimes = 0
-- 千重楼最高楼层
MiscCommonLocalConfig.TowerTotalFloor = 100
-- 每日重置小时
MiscCommonLocalConfig.DailyResetHour = 0
-- 每日重置分钟
MiscCommonLocalConfig.DailyResetMinute = 0
-- 每日重置时间
MiscCommonLocalConfig.DailyResetTime = ""
-- 每X时间需要Y消耗
-- 秒建筑队间隔，这个值 <= 0表示关闭秒CD功能
MiscCommonLocalConfig.MiaoBuildingWorkerDuration = 0
-- 秒建筑队消耗
MiscCommonLocalConfig.MiaoBuildingWorkerCost = nil
-- 秒科研队间隔，这个值 <= 0表示关闭秒CD功能
MiscCommonLocalConfig.MiaoTechWorkerDuration = 0
-- 秒科研队消耗
MiscCommonLocalConfig.MiaoTechWorkerCost = nil
-- 武将改名消耗
MiscCommonLocalConfig.ChangeCaptainNameCost = nil
-- 武将转职CD
MiscCommonLocalConfig.CaptainChangeRaceCD = 0
-- 武将转职等级限制
MiscCommonLocalConfig.CaptainChangeRaceLevel = 0

function MiscCommonLocalConfig:init()
    self.ChangeHeroNameCost = CostClass()
    self.MiaoBuildingWorkerCost = CostClass()
    self.MiaoTechWorkerCost = CostClass()
    self.ChangeCaptainNameCost = CostClass()
end

function MiscCommonLocalConfig:updateInfo(data)
    self.ChangeHeroNameCost:updateInfo(data.change_hero_name_cost)
    self.MailBatchCount = data.mail_batch_count
    self.TowerChallengeMaxTimes = data.tower_challenge_max_times
    self.DailyResetHour = data.daily_reset_hour
    self.DailyResetMinute = data.daily_reset_minute
    self.DailyResetTime = data.daily_reset_hour .. ":" .. data.daily_reset_minute
    self.MiaoBuildingWorkerDuration = data.miao_building_worker_duration
    self.MiaoBuildingWorkerCost:updateInfo(data.miao_building_worker_cost)
    self.MiaoTechWorkerDuration = data.miao_tech_worker_duration
    self.MiaoTechWorkerCost:updateInfo(data.miao_tech_worker_cost)
    self.ChangeCaptainNameCost:updateInfo(data.change_captain_name_cost)
    self.CaptainChangeRaceCD = data.change_captain_race_duration
    self.CaptainChangeRaceLevel = data.change_captain_race_level
end

-- 联盟通用模块配置
GuildConfigClass = Class()
GuildConfigClass.GuildNumPerPage = 0                        -- 每页多少个帮派数
GuildConfigClass.CreateGuildCost = nil                      -- 创建帮派消耗
GuildConfigClass.ChangeGuildNameCost = nil                  -- 帮派改名消耗
GuildConfigClass.ChangeGuildNameDuration = 0                -- 帮派改名cd，秒
GuildConfigClass.GuildLabelLimitChar = 0                    -- 联盟标签字数限制，1字符=1个汉字或者2个英文
GuildConfigClass.GuildLabelLimitCount = 0                   -- 联盟标签个数限制
GuildConfigClass.ChangeLeaderCountdownMemberCount = 0       -- 联盟人数触发禅让倒计时
GuildConfigClass.ChangeLeaderCountdownDuration = 0          -- 禅让盟主倒计时
GuildConfigClass.ImpeachRequiredMemberCount = 0	            -- 需要联盟内存在多少玩家数量才能弹劾
GuildConfigClass.ImpeachLeaderOfflineDuration = 0	        -- 玩家盟主多长时间不在线可以弹劾，单位秒
GuildConfigClass.ImpeachNpcLeaderHour = 0	                -- 弹劾npc盟主小时数，如23
GuildConfigClass.ImpeachNpcLeaderMinute = 0	                -- 弹劾npc盟主分钟数，如40
-- 表示每天23点40分之前可以发起NPC弹劾，超过这个时候不能发起弹劾
GuildConfigClass.userMaxJoinRequestCount = 0	            -- 用户最大申请加入联盟数量
GuildConfigClass.GuildMaxInvateCount = 0	                -- 联盟最大邀请数量
GuildConfigClass.DailyMaxKickCount = 0	                    -- 联盟每日最多可以踢多少人
GuildConfigClass.GuildClassTitleMaxCount = 0	            -- 联盟自定义职称个数上限
GuildConfigClass.GuildClassTitleMaxCharCount = 0	        -- 联盟自定义职称最大字宽数，一个汉字算两个

function GuildConfigClass:init()
    self.CreateGuildCost = CostClass()
    self.ChangeGuildNameCost = CostClass()
end

function GuildConfigClass:updateInfo(data)
    self.GuildNumPerPage = data.guild_num_per_page
    self.CreateGuildCost:updateInfo(data.create_guild_cost)
    self.ChangeGuildNameCost:updateInfo(data.change_guild_name_cost)
    self.ChangeGuildNameDuration = data.change_guild_name_duration
    self.GuildLabelLimitChar = data.guild_label_limit_char
    self.GuildLabelLimitCount = data.guild_label_limit_count
    self.ChangeLeaderCountdownMemberCount = data.change_leader_countdown_member_count
    self.ChangeLeaderCountdownDuration = data.change_leader_countdown_duration
    self.ImpeachRequiredMemberCount = data.impeach_required_member_count
    self.ImpeachLeaderOfflineDuration = data.impeach_leader_offline_duration
    self.ImpeachNpcLeaderHour = data.impeach_npc_leader_hour
    self.ImpeachNpcLeaderMinute = data.impeach_npc_leader_minute
    self.userMaxJoinRequestCount = data.user_max_join_request_count
    self.GuildMaxInvateCount = data.guild_max_invate_count
    self.DailyMaxKickCount = data.daily_max_kick_count
    self.GuildClassTitleMaxCount = data.guild_class_title_max_count
    self.GuildClassTitleMaxCharCount = data.guild_class_title_max_char_count
end
-- *********************************************************************
-- 基础类
-- *********************************************************************

-- 总数配置
AmountClass = Class()
AmountClass.Amount = 0             -- 总量
AmountClass.Percent = 0            -- 万分比

-- 更新信息--
function AmountClass:updateInfo(data)
    self.Amount = data.amount
    self.Percent = data.percent
end

-- *********************************************************************
-- Int32 Pair
Int32PairClass = Class()
Int32PairClass.Key = 0
Int32PairClass.Value = 0
-- 更新信息--
function Int32PairClass:updateInfo(data)
    self.Key = data.key
    self.Value = data.value
end
-- *********************************************************************
-- String Pair
StringPairClass = Class()
StringPairClass.Key = ""
StringPairClass.Value = ""
-- 更新信息--
function StringPairClass:updateInfo(data)
    self.Key = data.key
    self.Value = data.value
end
-- *********************************************************************
-- 兵将属性信息--
SpriteStatClass = Class()

SpriteStatClass.Attack = 0                     -- 攻击力--
SpriteStatClass.Defense = 0                    -- 防御力--
SpriteStatClass.Strength = 0                   -- 强壮力--
SpriteStatClass.Dexterity = 0                  -- 灵敏度--
SpriteStatClass.SoldierCapcity = 0             -- 最大带兵数--
-- 更新信息--
function SpriteStatClass:updateInfo(data)
    if data == nil then
        return
    end

    self.Attack = data.attack
    self.Defense = data.defense
    self.Strength = data.strength
    self.Dexterity = data.dexterity
    self.SoldierCapcity = data.soldier_capcity
end
-- 清空信息--
function SpriteStatClass:clear()
    self.Attack = 0
    self.Defense = 0
    self.Strength = 0
    self.Dexterity = 0
    self.SoldierCapcity = 0
end

-- ********************************************************************
-- 铁匠铺相关
-- ********************************************************************

-- 锻造
SmithyForgeClass = Class()
SmithyForgeClass.MaxForgeTimes = 0                   -- 最大锻造次数
SmithyForgeClass.ForgeRecoveryDur = 0                -- 锻造的回复间隔
SmithyForgeClass.EquipForge = { }                    -- 可锻造的装备列表
SmithyForgeClass.EquipLocked = { }                   -- 未解锁的锻造位置
SmithyForgeClass.OneKeyFunctionOpened = false        -- 一键功能是否开启
SmithyForgeClass.LockLevel = { }                     -- 开放等级
SmithyForgeClass.EquipForgePos = { }                 -- 可锻造的装备位置
SmithyForgeClass.EquipLockedPos = { }                -- 未解锁的装备位置

function SmithyForgeClass:updateInfo(data)
    if data == nil then
        return
    end
    if data.max_forging_times ~= nil then
        self.MaxForgeTimes = data.max_forging_times
    end
    if data.recovery_forging_duration ~= nil then
        self.ForgeRecoveryDur = data.recovery_forging_duration
    end
    if data.can_one_key_forging ~= nil then
        self.OneKeyFunctionOpened = data.can_one_key_forging
    end
    if data.can_forging_equip ~= nil then
        for k, v in ipairs(data.can_forging_equip) do
            table.insert(self.EquipForge, v)
        end
    end
    if data.locked_can_forging_equip ~= nil then
        for k, v in ipairs(data.locked_can_forging_equip) do
            table.insert(self.EquipLocked, v)
        end
    end
    if data.locked_equip_need_level ~= nil then
        for k, v in ipairs(data.locked_equip_need_level) do
            table.insert(self.LockLevel, v)
        end
    end

    if data.can_forging_equip_pos ~= nil then
        for k, v in ipairs(data.can_forging_equip_pos) do
            table.insert(self.EquipForgePos, v)
        end
    end

    if data.locked_can_forging_equip_pos ~= nil then
        for k, v in ipairs(data.locked_can_forging_equip_pos) do
            table.insert(self.EquipLockedPos, v)
        end
    end
end

-- 合成
SmithyCombineClass = Class()
SmithyCombineClass.Id = nil
SmithyCombineClass.SuitName = nil
SmithyCombineClass.FragmentId = nil
SmithyCombineClass.EquipInfo = { }

function SmithyCombineClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.id ~= nil then
        self.Id = data.id
    end
    if data.group_name ~= nil then
        self.SuitName = data.group_name
    end
    if data.cost_goods_id ~= nil then
        print("data.cost_goods_id", data.cost_goods_id)
        self.FragmentId = data.cost_goods_id
    end

    if data.combine_data ~= nil then
        for i, v in ipairs(data.combine_data) do
            if v ~= nil and v.id ~= nil then
                local cost = nil
                local prize = nil
                if v.cost ~= nil then
                    for j, u in ipairs(v.cost.goods_id) do
                        if u == self.FragmentId then
                            cost = v.cost.goods_count[j]
                        end
                    end
                end
                if v.prize ~= nil then
                    prize = PrizeClass()
                    prize:updateInfo(v.prize)
                end
                table.insert(self.EquipInfo, { equipId = data.combine_equip_id[i], combineId = v.id, combineCost = cost, combinePrize = prize })
            end
        end
    end
end
-- *********************************************************************
-- 任务相关
-- *********************************************************************

-- 任务宝箱
TaskBoxClass = Class()
-- 宝箱id
TaskBoxClass.Id = 0
-- 累积任务个数
TaskBoxClass.Count = 0
-- 宝箱奖励
TaskBoxClass.Prize = PrizeClass()

function TaskBoxClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.id ~= nil then
        self.Id = data.id
    end

    if data.count ~= nil then
        self.Count = data.count
    end

    if data.prize ~= nil then
        self.Prize:updateInfo(data.prize)
    end
end

-- *********************************************************************
-- 从任务目标中可以获取任务总进度
TaskTargetClass = Class()
-- 任务类型
TaskTargetClass.Type = TaskTargetType.InvalidTaskTargetType
-- 任务总进度
TaskTargetClass.TotalProgress = 0
-- 客户端跳转使用，建筑类型/科技id
TaskTargetClass.SubType = 0

function TaskTargetClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.type ~= nil then
        self.Type = data.type
    end

    if data.total_progress ~= nil then
        self.TotalProgress = data.total_progress
    end

    if data.sub_type ~= nil then
        self.SubType = data.sub_type
    end
end

-- *********************************************************************
-- 任务配置数据
TaskDataClass = Class()
-- 任务id
TaskDataClass.Id = 0
-- 任务名字
TaskDataClass.Name = ""
-- 任务内容
TaskDataClass.Text = ""
-- 任务目标
TaskDataClass.Target = nil
-- 任务奖励
TaskDataClass.Prize = nil

-- 构造函数，自动调用
function TaskDataClass:init()
    self.Target = TaskTargetClass()
    self.Prize = PrizeClass()
end

function TaskDataClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.id ~= nil then
        self.Id = data.id
    end

    if data.name ~= nil then
        self.Name = data.name
    end

    if data.text ~= nil then
        self.Text = data.text
    end

    if data.target ~= nil then
        self.Target:updateInfo(data.target)
    end

    if data.prize ~= nil then
        self.Prize:updateInfo(data.prize)
    end
end

-- *********************************************************************
-- 军政相关
-- *********************************************************************

-- 武将配置信息--
CaptainDataClass = Class()

CaptainDataClass.Id = 0                        -- 标识Id--
CaptainDataClass.Name = ""                     -- 名称--
CaptainDataClass.Head = ""                     -- 头像--
CaptainDataClass.Type = RaceType.None          -- 类型--
CaptainDataClass.BaseStat = nil                -- 属性--

-- 更新信息--
function CaptainDataClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Type = data.race
    self.Head = data.head
    if data.base_stat ~= nil then
        self.BaseStat = SpriteStatClass()
        self.BaseStat:updateInfo(data.base_stat)
    end
end
-- *********************************************************************
-- 武将寻访
CaptainSeekerClass = Class()
-- 索引号，从0开始
CaptainSeekerClass.Index = 0 
-- 系统随机的姓氏
CaptainSeekerClass.FamilyName = ""
-- 名字
CaptainSeekerClass.Name = ""
-- 头像
CaptainSeekerClass.Head = ""
-- 大头像
CaptainSeekerClass.BigHead = ""
-- true表示男人
CaptainSeekerClass.Male = false
-- 兵种
CaptainSeekerClass.Race = RaceType.None
-- 品质
CaptainSeekerClass.Quality = Quality.None
-- 成长值
CaptainSeekerClass.Ability = 0
-- 更新信息
function CaptainSeekerClass:updateInfo(data)
    self.Index = data.index
    self.FamilyName = data.family_name
    self.Name = data.name
    self.Head = string.format(UIConfig.CaptainSmallHead, data.head)
    self.BigHead = string.format(UIConfig.CaptainBigHead, data.head)
    self.Male = data.male
    self.Race = data.race
    self.Quality = data.quality
    self.Ability = data.ability
end

-- *********************************************************************
-- 出征的武将
CaptainInfoClass = Class()
CaptainInfoClass.Id = 0                        -- 武将id
CaptainInfoClass.Level = 0                     -- 武将等级
CaptainInfoClass.Name = ""                     -- 武将名称
CaptainInfoClass.Head = ""                     -- 武将小头像
CaptainInfoClass.BigHead = ""                     -- 武将大头像
CaptainInfoClass.RaceType = RaceType.None      -- 武将兵种
CaptainInfoClass.Quality = Quality.None        -- 品质
CaptainInfoClass.Soldier = 0                   -- 当前士兵数量
CaptainInfoClass.TotalSoldier = 0              -- 带兵总量
CaptainInfoClass.FightAmount = 0               -- 战斗力
CaptainInfoClass.Morale = 0                    -- 士气
CaptainInfoClass.SoldierLevel = 0              -- 士兵等级

CaptainInfoClass.OpenRestraintSkill = false -- 能否触发克制技能
CaptainInfoClass.Outside = false               -- true表示出征中
CaptainInfoClass.TotalStat = nil               -- 总属性

CaptainInfoClass.LifePerSoldier = 0            -- 单兵血量
CaptainInfoClass.LoadPerSoldier = 0            -- 单兵负载

function CaptainInfoClass:init()
    self.TotalStat = SpriteStatClass()
end

-- 更新信息
function CaptainInfoClass:updateInfo(data)
    self.Id = data.id
    self.Level = data.level
    self.Name = data.name
    self.Head = string.format(UIConfig.CaptainSmallHead, data.head)
    self.BigHead = string.format(UIConfig.CaptainBigHead, data.head)
    self.RaceType = data.race
    self.Quality = data.quality
    self.Soldier = data.soldier
    self.TotalSoldier = data.total_soldier
    self.FightAmount = data.fight_amount
    self.Morale = data.morale
    self.SoldierLevel = data.soldier_level
    self.Outside = data.outside
    self.TotalStat:updateInfo(data.total_stat)
    self.LifePerSoldier = data.life_per_soldier
    self.LoadPerSoldier = data.load_per_soldier
    self.OpenRestraintSkill = can_trigger_restraint_spell

    -- print("出征武将！！", string.format(UIConfig.CaptainSmallHead, data.head))
end
-- *********************************************************************
-- 玩家拥有的武将信息
HeroCaptainClass = Class()
-- 基础信息Id
HeroCaptainClass.Id = 0
-- 系统随机的姓氏，玩家改名后会清空
-- HeroCaptainClass.FamilyName = ""
-- 玩家手动修改的名字
HeroCaptainClass.Name = ""
-- 头像
HeroCaptainClass.Head = ""
-- 大头像
HeroCaptainClass.BigHead = ""
-- 中头像
HeroCaptainClass.MiddleHead = ""
-- 性别，true表示男人
HeroCaptainClass.Male = false
-- 兵种
HeroCaptainClass.Race = RaceType.None
-- 品质
HeroCaptainClass.Quality = Quality.None
-- 成长值
HeroCaptainClass.Ability = 0
-- 成长值经验值
HeroCaptainClass.AbilityExp = 0
-- 经验
HeroCaptainClass.Exp = 0
-- 等级
HeroCaptainClass.Level = 0
-- 当前带兵数
HeroCaptainClass.Soldier = 0
-- 最大带兵数
HeroCaptainClass.MaxSoldier = 0
-- 战斗力
HeroCaptainClass.FightAmount = 0
-- 满兵战斗力
HeroCaptainClass.FullSoldierFightAmount = 0
-- 总属性,四维属性
HeroCaptainClass.TotalStat = nil
-- 是否出征
HeroCaptainClass.OutSide = false
-- 士气
HeroCaptainClass.Morale = 0
-- 套装等级
HeroCaptainClass.EquipTaoZLv = 0
-- 武将装备
HeroCaptainClass.Equips = { }
-- 武将套装配置
HeroCaptainClass.EquipTaoZ = nil
-- 武将配置
HeroCaptainClass.Config = nil
-- 武将转职CD时间
HeroCaptainClass.RaceCdEndTime = nil
-- 行动力
HeroCaptainClass.Mobility = 0
-- 行动力阈值
HeroCaptainClass.MobilityNeed = 0


-- 转生等级
CaptainInfoClass.RebirthLevel = 0   
-- 转生经验           
CaptainInfoClass.RebirthExp = 0  
-- 附身的将魂id,0表示没有附身
CaptainInfoClass.AttachedCaptainSoulId = 0
-- 已经镶嵌的宝石
CaptainInfoClass.Gems = { }

function HeroCaptainClass:init()
    self.TotalStat = SpriteStatClass()
end

-- 更新信息
function HeroCaptainClass:updateInfo(data)
    self.Id = data.id
    -- self.FamilyName = data.family_name
    self.Name = data.name
    -- 约定
    self.Head = string.format(UIConfig.CaptainSmallHead, data.head)
    self.BigHead = string.format(UIConfig.CaptainBigHead, data.head)
    self.MiddleHead = string.format(UIConfig.CaptainMiddleHead, data.head)
    self.Male = data.male
    self.Race = data.race
    self.Quality = data.quality
    self.Ability = data.ability
    self.AbilityExp = data.ability_exp
    self.Exp = data.exp
    self.Level = data.level
    self.Soldier = data.soldier
    self.MaxSoldier = data.soldier_capcity
    self.FightAmount = data.fight_amount
    self.FullSoldierFightAmount = data.full_soldier_fight_amount
    self.TotalStat:updateInfo(data.total_stat)
    self.OutSide = data.outside
    self.Morale = data.morale
    self.Config = CaptainConfig:getConfigById(data.id)
    self.EquipTaoZLv = data.taoz
    self.EquipTaoZ = EquipTaozConfig:getConfigById(data.taoz)
    self.RaceCdEndTime = data.race_cd_end_time
    self.RebirthExp = data.rebirth_exp
    self.RebirthLevel = data.rebirth
    self.AttachedCaptainSoulId = data.fu_shen_captain_soul_id
    -- 武将装备
    self.Equips = { }
    for k, v in ipairs(data.equipment) do
        local equip = EquipInsInfo()
        equip:updateInfo(v)

        -- 依据部位存放
        self.Equips[equip.Config.Type] = equip
    end
    -- 镶嵌宝石
    self.Gems = { }
    for k, v in ipairs(data.gems) do
        local gem = GemDataConfig:getConfigById(v.gem)
        self.Gems[v.slot_idx] = gem
    end
end
-- 获取装备信息
function HeroCaptainClass:getEquipById(insId)
    for k, v in pairs(self.Equips) do
        if v.InsId == insId then
            return v
        end
    end
    return nil
end

-- 拥有的部队信息
HeroTroopClass = Class()
-- 队伍Id
HeroTroopClass.TroopId = 0
-- 出征状态
HeroTroopClass.OutSide = false
-- 部队武将
HeroTroopClass.Captains = nil
-- 更新信息
function HeroTroopClass:updateInfo(data)
    self.TroopId = data.sequence + 1
    self.OutSide = data.is_outside
    self.Captains = { }
    for i = 1, 5 do
        if data.captains[i] == nil then
            self.Captains[i] = 0
        else
            self.Captains[i] = data.captains[i]
        end
    end
end
function HeroTroopClass:updateCaptainsId(ids)
    for i = 1, 5 do
        if ids[i] == nil then
            self.Captains[i] = 0
        else
            self.Captains[i] = ids[i]
        end
    end
end
-- *********************************************************************
-- 将魂
-- *********************************************************************
CaptainSoulInfoClass = Class()
-- id
CaptainSoulInfoClass.Id = 0
-- 品质
CaptainSoulInfoClass.Quality = 0
-- 名字
CaptainSoulInfoClass.Name = nil
-- 图标
CaptainSoulInfoClass.Icon = nil
-- 描述
CaptainSoulInfoClass.Desc = nil
-- 在有将魂的情况下，获得该将魂时转换成的奖励
CaptainSoulInfoClass.Prize = nil
-- 激活后的聊天内容
CaptainSoulInfoClass.ChatContent = nil
-- 加的士气
CaptainSoulInfoClass.AddMorale = 0

function CaptainSoulInfoClass:init()
    self.Prize = PrizeClass()
end

-- 更新信息
function CaptainSoulInfoClass:updateInfo(data)
    self.Id = data.id
    self.Quality = data.quality
    self.Name = data.name
    self.Icon = data.icon
    self.Desc = data.desc
    self.Prize:updateInfo(data.prize_if_has_soul)
    self.ChatContent = data.chat_content_when_activated
    self.AddMorale = data.add_morale
end


-- *********************************************************************
-- 羁绊
-- *********************************************************************
CaptainSoulFettersClass = Class()
-- id
CaptainSoulFettersClass.Id = 0
-- 名字
CaptainSoulFettersClass.Name = nil
-- 羁绊激活了的奖励
CaptainSoulFettersClass.FettersPrize = nil
-- 需要的将魂id
CaptainSoulFettersClass.Souls = { }
-- 羁绊的故事
CaptainSoulFettersClass.Story = nil

function CaptainSoulFettersClass:init()
    self.FettersPrize = PrizeClass()
end

function CaptainSoulFettersClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.FettersPrize:updateInfo(data.fetters_prize)
    self.Story = data.story

    self.Souls = { }
    for k, v in ipairs(data.souls) do
        table.insert(self.Souls, v)
    end
end
-- *********************************************************************
-- 技能
-- *********************************************************************
SkillInfoClass = Class()
-- 技能Id
SkillInfoClass.Id = 0
-- 技能名字
SkillInfoClass.Name = nil
-- 技能图标
SkillInfoClass.Icon = nil
-- 技能描述
SkillInfoClass.Desc = nil

function SkillInfoClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Icon = string.format("%s%s", UIConfig.SkillIcon, data.icon)
    self.Desc = data.desc
end

-- *********************************************************************
-- 职业
-- *********************************************************************
RaceDataClass = Class()
-- id
RaceDataClass.Id = 0
-- 职业类型(实际上与Id相同，使用时不用Id，使用Race)
RaceDataClass.Race = RaceType.None

RaceDataClass.AttackRage = 0

RaceDataClass.MoveTimesPerRound = 0

RaceDataClass.MoveSpeed = 0

-- 高优先级在前面
RaceDataClass.RacePriority = { }
-- 兵种克制系数
RaceDataClass.RaceCoef = { }
-- 克制职业
RaceDataClass.RestraintRace = { }
-- 克制轮次类型
RaceDataClass.RestraintRoundType = 0
-- 克制技id
RaceDataClass.RestraintSkillId = 0
-- 解锁克制技需要的成长值
RaceDataClass.UnlockRetraintSkillAbility = 0

function RaceDataClass:updateInfo(data)
    self.Id = data.id
    self.Race = data.race
    self.AttackRage = data.attack_range
    self.MoveTimesPerRound = data.move_times_per_round
    self.MoveSpeed = data.move_speed
    self.RestraintRoundType = data.restraint_round_type
    self.RestraintSkillId = data.restraint_spell_id
    self.UnlockRetraintSkillAbility = data.unlock_restraint_spell_need_ability

    if data.priority ~= nil then
        for k, v in ipairs(data.priority) do
            table.insert(self.RacePriority, v)
        end
    end

    if data.race_coef ~= nil then
        for k, v in ipairs(data.race_coef) do
            table.insert(self.RaceCoef, v)
        end
    end

    if data.restraint_race ~= nil then
        for k, v in ipairs(data.restraint_race) do
            table.insert(self.RestraintRace, v)
        end
    end
end

-- *********************************************************************
-- 士兵相关
-- *********************************************************************
-- 士兵信息--
SoldierLevelClass = Class()
-- 等级--
SoldierLevelClass.Level = 0
-- 单兵负载
SoldierLevelClass.Load = 0
-- 当前等级描述
SoldierLevelClass.Desc = 0
-- 招募消耗--
SoldierLevelClass.RecruitCost = nil
-- 伤兵治疗消耗--
SoldierLevelClass.WoundedCost = nil
-- 升级消耗--
SoldierLevelClass.UpgradeCost = nil

function SoldierLevelClass:init()
    self.RecruitCost = CostClass()
    self.WoundedCost = CostClass()
    self.UpgradeCost = CostClass()
end

-- 更新信息--
function SoldierLevelClass:updateInfo(data)
    self.Level = data.level
    self.Load = data.load
    self.Desc = data.desc
    self.RecruitCost:updateInfo(data.recruit_cost)
    self.WoundedCost:updateInfo(data.wounded_cost)
    self.UpgradeCost:updateInfo(data.upgrade_cost)
end
-- *********************************************************************
-- 内政相关
-- *********************************************************************
-- 建筑布局配置
BuildingLayoutClass = Class()
BuildingLayoutClass.Id = 0
BuildingLayoutClass.BuildingTypes = { }              -- 这个位置允许新建的建筑类型，可为多个
BuildingLayoutClass.RequireBaseLevel = 0            -- 需要主城等级
BuildingLayoutClass.RegionOffsetX = 0               -- 与主城的坐标偏移X
BuildingLayoutClass.RegionOffsetY = 0               -- 与主城的坐标偏移Y

-- 更新信息--
function BuildingLayoutClass:updateInfo(data)
    self.Id = data.id
    self.BuildingTypes = data.building
    self.RequireBaseLevel = data.require_base_level
    self.RegionOffsetX = data.region_offset_x
    self.RegionOffsetY = data.region_offset_y
end

-- *********************************************************************
-- 资源信息--
ResourceClass = Class()

ResourceClass.Type = CurrencyType.None             -- 资源类型--
ResourceClass.Amount = 0                           -- 资源数量--
ResourceClass.Percent = 0                          -- 资源万分比--

-- 更新信息--
function ResourceClass:updateInfo(data)
    if data.type == 0 then
        self.Type = CurrencyType.Coin
    elseif data.type == 1 then
        self.Type = CurrencyType.Food
    elseif data.type == 2 then
        self.Type = CurrencyType.Wood
    elseif data.type == 3 then
        self.Type = CurrencyType.Stone
    end
    self.Amount = data.amount
    self.Percent = data.percent
end
-- *********************************************************************
-- 建筑储备信息--
DomesticEffectClass = Class()
-- 建筑队/科技队相关
-- 建筑cd系数, 这个值需要除以 1000，得到小数系数
DomesticEffectClass.BuildingWorkerCoef = 0
-- 建筑队疲劳时间
DomesticEffectClass.BuildingWorkerFatigueDuration = 0 
-- 科技cd系数, 这个值需要除以 1000，得到小数系数
DomesticEffectClass.TechWorkerCoef = 0
-- 科技队疲劳时间
DomesticEffectClass.TechWorkerFatigueDuration = 0 

-- 仓库相关----
DomesticEffectClass.Capacity = { }                  -- 仓库容量
DomesticEffectClass.ProtectedCapacity = nil         -- 仓库受保护容量

-- 资源点相关--
DomesticEffectClass.OutputType = CurrencyType.None  -- 资源类型
DomesticEffectClass.Output = nil                    -- 资源产出量，每小时
DomesticEffectClass.OutputCapacity = nil            -- 资源存储上限

-- 军营相关----
DomesticEffectClass.SoldierCapacity = 0             -- 士兵最大容量
DomesticEffectClass.NewSoldierOutput = 0            -- 新兵产量每小时
DomesticEffectClass.NewSoldierCapacity = 0          -- 新兵最大容量
DomesticEffectClass.WoundedSoldierCapacity = 0      -- 伤兵最大容量

-- 士兵相关----
DomesticEffectClass.SoldierLoad = 0                 -- 士兵负载
DomesticEffectClass.SoldierRace = RaceType.None     -- 兵种
DomesticEffectClass.SoldierStat = nil               -- 士兵科技附加属性

function DomesticEffectClass:init()
    self.ProtectedCapacity = AmountClass()
    self.Output = AmountClass()
    self.OutputCapacity = AmountClass()
    self.SoldierStat = SpriteStatClass()
end

-- 更新信息--
function DomesticEffectClass:updateInfo(data)
    self.BuildingWorkerCoef = data.building_worker_coef * 0.001
    self.BuildingWorkerFatigueDuration = data.building_worker_fatigue_duration
    self.TechWorkerCoef = data.tech_worker_coef * 0.001
    self.TechWorkerFatigueDuration = data.tech_worker_fatigue_duration

    for k, v in pairs(data.capcity) do
        if self.Capacity[k] == nil then
            self.Capacity[k] = AmountClass()
        end
        self.Capacity[k]:updateInfo(v)
    end
    self.ProtectedCapacity:updateInfo(data.protected_capcity)
    self.OutputType = data.output_type
    self.Output:updateInfo(data.output)
    self.OutputCapacity:updateInfo(data.output_capcity)

    self.SoldierCapacity = data.soldier_capcity
    self.NewSoldierOutput = data.new_soldier_output
    self.NewSoldierCapacity = data.new_soldier_capcity
    self.WoundedSoldierCapacity = data.wounded_soldier_capcity
    self.SoldierLoad = data.soldier_load
    self.SoldierRace = RaceType.valueToKey(self, data.soldier_race)

    if data.soldier_stat ~= nil then
        self.SoldierStat:updateInfo(data.soldier_stat)
    end
end

-- *********************************************************************
-- 建筑信息
BuildingDataClass = Class()
BuildingDataClass.Id = 0
BuildingDataClass.BuildingType = BuildingType.None      -- 建筑类型
BuildingDataClass.Level = 0
BuildingDataClass.BuilderWorkTime = 0                   -- 施工时间（施工队休息时间）
BuildingDataClass.Prosperity = 0                        -- 繁荣度
BuildingDataClass.HeroExp = 0                           -- 升级君主获得的经验值
BuildingDataClass.Desc = ""                             -- 描述
BuildingDataClass.Effect = nil                          -- 储备
BuildingDataClass.Cost = nil                            -- 建造或者升级所需花费
BuildingDataClass.RequiredBuildingIds = { }             -- 前提条件，所需的建筑
BuildingDataClass.BaseLevel = 0                         -- 建设时候要求主城等级

function BuildingDataClass:init()
    self.Effect = DomesticEffectClass()
    self.Cost = CostClass()
end

-- 更新信息
function BuildingDataClass:updateInfo(data)
    self.Id = data.id
    self.BuildingType = data.type
    self.Level = data.level
    self.Prosperity = data.prosperity
    self.BuilderWorkTime = data.work_time
    self.Desc = data.desc
    self.Effect:updateInfo(data.effect)
    self.Cost:updateInfo(data.cost)
    self.RequiredBuildingIds = data.require_ids
    self.BaseLevel = data.base_level
end

-- *********************************************************************
-- 科技点信息
TechnologyDataClass = Class()
-- Id
TechnologyDataClass.Id = 0
-- 名称
TechnologyDataClass.Name = ""
-- 描述
TechnologyDataClass.Desc = ""
-- 枚举类型
TechnologyDataClass.Type = TechnologyType.None
-- 序号
TechnologyDataClass.Sequence = 0
-- 图标
TechnologyDataClass.Icon = ""
-- 图标
TechnologyDataClass.Group = 0
-- 等级
TechnologyDataClass.Level = 0
-- 研究耗时
TechnologyDataClass.StudyTimeCost = 0
-- 研究消耗
TechnologyDataClass.Cost = nil
-- 所需前置建筑条件
TechnologyDataClass.RequireBuildingIds = { }
-- 所需前置科技条件
TechnologyDataClass.RequireTechnologyIds = { }

function TechnologyDataClass:init()
    self.Cost = CostClass()
end

-- 更新信息--
function TechnologyDataClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Desc = data.desc
    self.Type = data.type
    self.Icon = data.icon
    self.Group = data.group
    self.Sequence = data.sequence
    self.Level = data.level
    self.StudyTimeCost = data.work_time
    self.Cost:updateInfo(data.cost)

    self.RequireBuildingIds = { }

    for k, v in ipairs(data.require_building_ids) do
        table.insert(self.RequireBuildingIds, v)
    end

    self.RequireTechnologyIds = { }

    for k, v in ipairs(data.require_tech_ids) do
        table.insert(self.RequireTechnologyIds, v)
    end
end

-- *********************************************************************
-- 野外相关
-- *********************************************************************

-- 军情
MilitaryInfoClass = Class()

MilitaryInfoClass.CombineId = ""            -- 军情id
MilitaryInfoClass.Action = 0                -- 行为，0-入侵 1-救援
MilitaryInfoClass.MoveType = 0              -- 移动类型，0-forward(往目标移动) 1-arrived(到达) 2-back(回家)       
MilitaryInfoClass.MoveStartTime = 0         -- 行军开始时间
MilitaryInfoClass.MoveArrivedTime = 0       -- 行军到达时间

MilitaryInfoClass.PriorityActionId = 0      -- 援助时优先打哪个目标，0表示没有优先目标

-- 发起方
MilitaryInfoClass.Self = nil
MilitaryInfoClass.SelfIsCamp = false
-- 发起方带的部队
MilitaryInfoClass.CaptainIndexList = { }    -- 部队序号
MilitaryInfoClass.CaptainInfoList = { }     -- 出征带的部队

-- 目标
MilitaryInfoClass.Target = nil
MilitaryInfoClass.TargetIsCamp = false
-- 目标主城坐标（用这个，Target里面那个是最新坐标，比如迁城后的新坐标）
MilitaryInfoClass.TargetBaseX = 0
MilitaryInfoClass.TargetBaseY = 0

-- 当行为是入侵时，下面字段有效
-- 掠夺的资源
MilitaryInfoClass.Gold = 0
MilitaryInfoClass.Food = 0
MilitaryInfoClass.Wood = 0
MilitaryInfoClass.Stone = 0

-- 当行为是援助时,下面字段有效
MilitaryInfoClass.KillEnemies = { }

-- 构造
function MilitaryInfoClass:init()
    self.Self = HeroBasicSnapshotClass()
    self.Target = HeroBasicSnapshotClass()
    self.CaptainIndexList = { }
    self.CaptainInfoList = { }
end
-- 更新信息
function MilitaryInfoClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.combine_id ~= nil then
        self.CombineId = data.combine_id
    end

    if data.action ~= nil then
        self.Action = data.action
    end

    if data.move_type ~= nil then
        self.MoveType = data.move_type
    end

    if data.move_start_time ~= nil then
        self.MoveStartTime = data.move_start_time
    end

    if data.move_arrived_time ~= nil then
        self.MoveArrivedTime = data.move_arrived_time
    end

    if data.priority_action_id ~= nil then
        self.PriorityActionId = data.priority_action_id
    end

    if data.self ~= nil then
        self.Self:updateInfo(data.self)
    end

    if data.self_is_tent ~= nil then
        self.SelfIsCamp = data.self_is_tent
    end

    if data.captain_index ~= nil then
        for k, v in ipairs(data.captain_index) do
            self.CaptainIndexList[k] = v
        end
    end

    if data.captains ~= nil then
        for k, v in ipairs(data.captains) do
            if self.CaptainInfoList[k] == nil then
                self.CaptainInfoList[k] = CaptainInfoClass()
            end
            self.CaptainInfoList[k]:updateInfo(v)
        end
    end

    if data.target ~= nil then
        self.Target:updateInfo(data.target)
    end

    if data.target_is_tent ~= nil then
        self.TargetIsCamp = data.target_is_tent
    end

    if data.target_base_x ~= nil then
        self.TargetBaseX = data.target_base_x
    end

    if data.target_base_y ~= nil then
        self.TargetBaseY = data.target_base_y
    end

    if data.gold ~= nil then
        self.Gold = data.gold
    end

    if data.food ~= nil then
        self.Food = data.food
    end

    if data.wood ~= nil then
        self.Wood = data.wood
    end

    if data.stone ~= nil then
        self.Stone = data.stone
    end

    if data.kill_enemy ~= nil then
        for i, v in ipairs(data.kill_enemy) do
            table.insert(self.KillEnemies, v)
        end
    end
end

-- *********************************************************************
-- 君主相关
-- *********************************************************************
-- 君主基础信息
HeroBasicClass = Class()
HeroBasicClass.Id = ""              -- Id
HeroBasicClass.Name = ""            -- 名字
HeroBasicClass.Head = ""            -- 头像
HeroBasicClass.Level = 0            -- 君主等级
HeroBasicClass.Male = false         -- 君主性别，true-男，false-女
HeroBasicClass.GuildId = 0          -- 联盟Id
HeroBasicClass.GuildName = ""       -- 联盟名称
HeroBasicClass.GuildFlagName = ""   -- 联盟旗号
function HeroBasicClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Head = data.head
    self.Level = data.level
    self.Male = data.male
    self.GuildId = data.guild_id
    self.GuildName = data.guild_name
    self.GuildFlagName = data.guild_flag_name
end
-- 君主信息
HeroBasicSnapshotClass = Class()
HeroBasicSnapshotClass.Basic = nil
HeroBasicSnapshotClass.Id = ""              -- Id
HeroBasicSnapshotClass.Name = ""            -- 名字
HeroBasicSnapshotClass.Head = ""            -- 头像
HeroBasicSnapshotClass.Level = 0            -- 君主等级
HeroBasicSnapshotClass.Male = false         -- 君主性别，true-男，false-女
HeroBasicSnapshotClass.BaseRegion = 0       -- 主城所在区域
HeroBasicSnapshotClass.BaseLevel = 0        -- 主城等级
HeroBasicSnapshotClass.BaseX = 0            -- 主城X坐标
HeroBasicSnapshotClass.BaseY = 0            -- 主城Y坐标
HeroBasicSnapshotClass.FightAmount = 0      -- 战斗力
HeroBasicSnapshotClass.Prosperity = 0       -- 繁荣度
HeroBasicSnapshotClass.GuildId = 0          -- 联盟Id
HeroBasicSnapshotClass.GuildName = ""       -- 联盟名称
HeroBasicSnapshotClass.GuildFlagName = ""   -- 联盟旗号
HeroBasicSnapshotClass.TowerMaxFloor = 0    -- 千重楼最高层数
HeroBasicSnapshotClass.LastOfflineTime = 0  -- 上次离线时间, 0表示在线，其他表示离线了
HeroBasicSnapshotClass.Pvp100RankLv = 0     -- 百战军衔等级

function HeroBasicSnapshotClass:init()
    self.Basic = HeroBasicClass()
end
function HeroBasicSnapshotClass:updateInfo(data)
    -- 基础信息
    self.Basic:updateInfo(data.basic)
    if data == nil then
        return
    end

    if data.id ~= nil then
        self.Id = data.id
    end

    if data.name ~= nil then
        self.Name = data.name
    end

    if data.head ~= nil then
        self.Head = data.head
    end

    if data.level ~= nil then
        self.Level = data.level
    end

    if data.male ~= nil then
        self.Male = data.male
    end

    if data.base_region ~= nil then
        self.BaseRegion = data.base_region
    end

    if data.base_level ~= nil then
        self.BaseLevel = data.base_level
    end

    if data.base_x ~= nil then
        self.BaseX = data.base_x
    end

    if data.base_y ~= nil then
        self.BaseY = data.base_y
    end

    if data.fight_amount ~= nil then
        self.FightAmount = data.fight_amount
    end

    if data.prosperity ~= nil then
        self.Prosperity = data.prosperity
    end

    if data.guild_id ~= nil then
        self.GuildId = data.guild_id
    end

    if data.guild_name ~= nil then
        self.GuildName = data.guild_name
    end

    if data.guild_flag_name ~= nil then
        self.GuildFlagName = data.guild_flag_name
    end

    if data.tower_max_floor ~= nil then
        self.TowerMaxFloor = data.tower_max_floor
    end

    if data.last_offline_time ~= nil then
        self.LastOfflineTime = data.last_offline_time
    end

    self.Pvp100RankLv = data.jun_xian_level
end
-- *********************************************************************

-- 君主等级配置信息--
HeroLevelClass = Class()
-- 等级
HeroLevelClass.Level = 0
-- 升级所需经验
HeroLevelClass.UpgradeExp = 0
-- 装备等级限制
HeroLevelClass.EquipmentLevelLimit = 0
-- 武将等级限制
HeroLevelClass.CaptainLevelLimit = 0
-- 武将个数限制
HeroLevelClass.CaptainCountLimit = 0
-- 千重楼上阵武将个数限制
HeroLevelClass.TowerCaptainLimit = 0
-- 百战千军上阵武将个数限制
HeroLevelClass.Pvp100CaptainLimit = 0
-- 已解锁的武将兵种
HeroLevelClass.UnlockedRaces = { }
-- 武将修炼位个数限制
HeroLevelClass.CaptainTrainingLevel = { }
-- 武将修炼位等级限制
HeroLevelClass.CaptainTrainingLevelLimit = { }
-- 更新信息--
function HeroLevelClass:updateInfo(data)
    self.Level = data.level
    self.UpgradeExp = data.upgrade_exp
    self.EquipmentLevelLimit = data.equipment_level_limit
    self.CaptainLevelLimit = data.captain_level_limit
    self.CaptainCountLimit = data.captain_count_limit
    self.TowerCaptainLimit = data.tower_captain_limit
    self.Pvp100CaptainLimit = data.bai_zhan_captain_limit
    for k, v in ipairs(data.unlocked_races) do
        table.insert(self.UnlockedRaces, v)
    end
    for k, v in ipairs(data.captain_training_level) do
        table.insert(self.CaptainTrainingLevel, v)
    end
    for k, v in ipairs(data.captain_training_level_limit) do
        table.insert(self.CaptainTrainingLevelLimit, v)
    end
end

-- *********************************************************************
-- 修炼位相关
-- *********************************************************************
HeroTrainingClass = Class()
-- 修炼位
HeroTrainingClass.Id = 0
-- 修炼位等级
HeroTrainingClass.Level = 0
-- 修炼位等级上限
HeroTrainingClass.LevelLimit = 0
-- 当前修炼武将
HeroTrainingClass.Captain = 0
-- 当前可领取经验，（经验上限,产量，从等级数据中获取）
HeroTrainingClass.Exp = 0
-- 经验产出，每小时
HeroTrainingClass.Output = 0
-- 经验产出最大上限
HeroTrainingClass.Capcity = 0
-- 经验计时器
HeroTrainingClass.Timer = nil
-- 经验计时器结束回调
function HeroTrainingClass:TimerComplete()
    if self.Captain == 0 then
        return
    end

    self.Exp = self.Exp + self.Output / 3600

    if self.Exp >= self.Capcity then
        self.Exp = self.Capcity
    end
end
-- 更新信息
function HeroTrainingClass:updateInfo(data)
    self.Id = data.id
    self.Level = data.level
    self.LevelLimit = data.level_limit
    self.Captain = data.captain
    self.Exp = data.exp
    self.Output = data.output
    self.Capcity = data.capcity

    if nil == self.htcTimer then
        self.Timer = TimerManager.newTimer(1, true, true, nil, nil, self.TimerComplete, self)
    end

    self.Timer:start()
end

-- *********************************************************************
-- 道具相关
-- *********************************************************************

-- 道具信息(普通，装备，宝石，宝箱等)
ItemShowInfo = Class()
-- 道具Id
ItemShowInfo.Id = 0
-- 道具个数
ItemShowInfo.Amount = 0
-- 道具分类类型
ItemShowInfo.ClassifyType = ItemClassifyType.Default
-- 道具角标类型
ItemShowInfo.CornerType = ItemCornerType.Normal
-- 道具配置
ItemShowInfo.Config = nil
-- 更新数据
function ItemShowInfo:updateInfo(id, amount, classifyType)
    self.Id = id
    self.Amount = amount
    self.ClassifyType = classifyType

    if classifyType == ItemClassifyType.Default then
        self.Config = ItemsConfig:getConfigById(id)
    elseif classifyType == ItemClassifyType.Equip then
        self.Config = EquipsConfig:getConfigById(id)
    elseif classifyType == ItemClassifyType.Currency then
        self.Config = CurrencyConfig:getConfigById(id)
    end
end

-- *********************************************************************
-- 堆叠道具相关
-- *********************************************************************

-- 道具效果
ItemEffectInfo = Class()
-- 资源类物品
-- 金币
ItemEffectInfo.Gold = 0
-- 食物
ItemEffectInfo.Food = 0
-- 木材
ItemEffectInfo.Wood = 0
-- 石料
ItemEffectInfo.Stone = 0

-- 减少cd类物品
-- true表示可以用于建筑减cd
ItemEffectInfo.UseBuildCdr = false
-- true表示可以用于科技减cd
ItemEffectInfo.UseTechCdr = false
-- 减少cd时间，单位秒
ItemEffectInfo.Cdr = ""

-- 迁移城池物品
-- true表示随机迁城令（低级），false表示高级迁城令（可以指定坐标）
ItemEffectInfo.RandomMove = false
ItemEffectInfo.MoveCamp = false

-- 经验丹物品
-- 经验丹类型
ItemEffectInfo.ExpType = ItemExpEffectType.None
-- 经验值
ItemEffectInfo.Exp = 0

-- 更新信息--
function ItemEffectInfo:updateInfo(data)
    self.Gold = data.gold
    self.Food = data.food
    self.Wood = data.wood
    self.Stone = data.stone

    self.ExpType = data.exp_type
    self.Exp = data.exp

    self.RandomMove = data.random_pos

    self.UseBuildCdr = data.building_cdr
    self.UseTechCdr = data.tech_cdr
    self.Cdr = data.cdr

    self.MoveCamp = data.move_tent
end

-- 道具信息--
ItemLocalInfo = Class()
-- 标识Id--
ItemLocalInfo.Id = 0
-- 名称--
ItemLocalInfo.Name = ""
-- 描述--
ItemLocalInfo.Desc = ""
-- Icon--
ItemLocalInfo.Icon = ""
-- 品质--
ItemLocalInfo.Quality = 0
-- 道具效果
ItemLocalInfo.Effect = nil
-- 道具类型
ItemLocalInfo.Type = ItemType.Resource
-- 消耗元宝
ItemLocalInfo.YuanBaoPrice = 0
-- 初始化--
function ItemLocalInfo:init()
    self.Effect = ItemEffectInfo()
end

-- 更新信息--
function ItemLocalInfo:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Desc = data.desc
    self.Icon = string.format("%s%s", UIConfig.ItemIcon, data.icon)
    self.Quality = data.quality
    self.Effect:updateInfo(data.goods_effect)
    self.YuanBaoPrice = data.yuanbao_price

    -- 服务器和客户端有些出入
    if data.effect_type == 0 then
        self.Type = ItemType.None
    elseif data.effect_type == 1 then
        self.Type = ItemType.Resource
    elseif data.effect_type == 2 then
        self.Type = ItemType.Accelerate
    elseif data.effect_type == 3 then
        self.Type = ItemType.BaseMove
        if not self.Effect.RandomMove == true then
            self.Type = ItemType.AdvancedMove
        end
    elseif data.effect_type == 4 then
        self.Type = ItemType.EXP
    end
end

-- 道具基础实例化道具
ItemInsInfo = Class()
-- 实例化Id
ItemInsInfo.InsId = 0
-- 个数--
ItemInsInfo.Amount = 0
-- 配置--
ItemInsInfo.Config = nil
-- 更新信息
function ItemInsInfo:updateInfo(data)
    self.InsId = data.key
    self.Amount = data.value
    self.Config = ItemsConfig:getConfigById(data.key)
end

-- *********************************************************************
-- 宝石相关
-- *********************************************************************
-- 宝石信息
GemLocalInfo = Class()
-- id
GemLocalInfo.Id = 0
-- 名称
GemLocalInfo.Name = nil
-- 描述
GemLocalInfo.Desc = nil
-- 图标
GemLocalInfo.Icon = nil
-- 类型
GemLocalInfo.GemType = 0
-- 等级
GemLocalInfo.Level = 0
-- 品质
GemLocalInfo.Quality = 0
-- 基础属性
GemLocalInfo.TotalStat = nil
-- 该等级升级到下一级需要的数量
GemLocalInfo.UpgradeNeedCount = 0
-- 上一级的id，0表示没有上一级
GemLocalInfo.PreLevel = 0
-- 下一级的id，0表示没有下一级
GemLocalInfo.NextLevel = 0
function GemLocalInfo:init()
    self.TotalStat = SpriteStatClass()
end

function GemLocalInfo:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Desc = data.desc
    self.Icon = data.icon
    self.GemType = data.gem_type
    self.Level = data.level
    self.Quality = data.quality
    self.UpgradeNeedCount = data.upgrade_need_count
    self.PreLevel = data.prev_level
    self.NextLevel = data.next_level
    self.TotalStat:clear()
    self.TotalStat:updateInfo(data.base_stat)
end

-- *********************************************************************
-- 宝石实例化数据
GemInsInfo = ItemInsInfo:extend()
-- 更新信息
function GemInsInfo:updateInfo(data)
    self.InsId = data.key
    self.Amount = data.value
    self.Config = GemDataConfig:getConfigById(data.key)
end

-- *********************************************************************
-- 宝石槽位
GemSlotDataClass = Class()
-- 槽位号（0开始）
GemSlotDataClass.SlotIndex = -1
-- 需要的成长值
GemSlotDataClass.NeedAbility = 0
-- 部件
GemSlotDataClass.Type = EquipType.None

function GemSlotDataClass:updateInfo(data)
    self.SlotIndex = data.slot_idx
    self.NeedAbility = data.need_ability
    self.Type = data.type
end

-- *********************************************************************
-- 装备相关
-- *********************************************************************

-- 装备信息--
EquipLocalInfo = Class()
-- 标识Id--
EquipLocalInfo.Id = 0
-- 名称--
EquipLocalInfo.Name = ""
-- 描述--
EquipLocalInfo.Desc = ""
-- Icon--
EquipLocalInfo.Icon = ""
-- 类型--
EquipLocalInfo.Type = EquipType.None
-- 品质Id--
EquipLocalInfo.Quality = nil
-- 基础属性--
EquipLocalInfo.BaseStat = nil

-- 更新信息--
function EquipLocalInfo:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Desc = data.desc
    self.Icon = string.format("%s%s", UIConfig.EquipIcon, data.icon)
    self.Type = data.type
    self.Quality = EquipQualityConfig:getConfigById(data.quality)

    self.BaseStat = nil
    if nil ~= data.base_stat then
        self.BaseStat = SpriteStatClass()
        self.BaseStat:updateInfo(data.base_stat)
    end
end

-- 装备品质信息--
EquipQualityLocalInfo = Class()
-- 装备品质编号
EquipQualityLocalInfo.Id = 0
-- 从1开始，依次表示,白，绿，蓝，紫（紫1，紫2，紫3，具体问策划有多少个），橙，红
EquipQualityLocalInfo.Level = 0
-- 品质类型
EquipQualityLocalInfo.Type = Quality.None
-- 最大可强化次数
EquipQualityLocalInfo.RefinedLevelLimit = 0
-- 装备熔炼返还物品个数
EquipQualityLocalInfo.SmeltBackCount = 0
-- 获取品质类型--
local function getQualityType(level)
    if level == 1 then
        return Quality.White
    elseif level == 2 then
        return Quality.Blue
    elseif level >= 3 and level <= 4 then
        return Quality.Blue
    elseif level >= 5 and level <= 7 then
        return Quality.Purple
    elseif level >= 8 and level <= 10 then
        return Quality.Orange
    elseif level >= 11 and level <= 14 then
        return Quality.Red
    end
end
-- 更新信息--
function EquipQualityLocalInfo:updateInfo(data)
    self.Id = data.id
    self.Level = data.level
    self.Type = getQualityType(data.level)
    self.RefinedLevelLimit = data.refined_level_limit
    self.SmeltBackCount = data.smelt_back_count
end

-- 装备强化信息--
EquipRefinedLocalInfo = Class()
-- 强化等级
EquipRefinedLocalInfo.Level = 0
-- 强化消耗物品个数
EquipRefinedLocalInfo.CostCount = 0
-- 当前等级总强化消耗个数（用于熔炼时候显示返回物品个数）
EquipRefinedLocalInfo.TotalCostCount = 0
-- 强化属性百分比
EquipRefinedLocalInfo.RefineStatPercent = 0
-- 总属性百分比
EquipRefinedLocalInfo.TotalStatPercent = 0
-- 更新信息--
function EquipRefinedLocalInfo:updateInfo(data)
    self.Level = data.level
    self.CostCount = data.cost_count
    self.TotalCostCount = data.total_cost_count
    self.RefineStatPercent = data.stat_percent
    self.TotalStatPercent = data.total_stat_percent
end

-- 装备套装信息--
EquipTaozLocalInfo = Class()
-- 套装等级
EquipTaozLocalInfo.Level = 0
-- 需要装备强化件数
EquipTaozLocalInfo.EquipCount = 0
-- 需要装备强化等级
EquipTaozLocalInfo.RefinedLevel = 0
-- 套装士气
EquipTaozLocalInfo.Morale = 0
-- 更新信息--
function EquipTaozLocalInfo:updateInfo(data)
    self.EquipCount = data.count
    self.RefinedLevel = data.refined_level
    self.Morale = data.morale
    self.Level = data.level
end

-- 装备实例化道具
EquipInsInfo = ItemInsInfo:extend()
-- 装备等级
EquipInsInfo.Level = 0
-- 装备强化等级
EquipInsInfo.RefinedLevel = 0
-- 装备总属性
EquipInsInfo.TotalStat = nil
-- 下一等级属性增加（客户端要处理最后一级，这个时候是没有数据的）
EquipInsInfo.NextLvStatAdd = nil
-- 下一强化等级属性增加（客户端要处理最后一级，这个时候是没有数据的）
EquipInsInfo.NextRefineLvStatAdd = nil
-- 下一等级道具消耗个数
EquipInsInfo.NextLvItemCostCount = 0
-- 下一强化等级道具消耗个数
EquipInsInfo.NextRefineLvItemCostCount = nil
-- 强化属性提升百分比
EquipInsInfo.RefineStatAddPercent = 0
-- 升级消耗返回个数(重铸时)
EquipInsInfo.UpgradeRebuildReturnItemCount = 0
-- 熔炼时升级消耗返回个数（熔炼时 = 重铸返还个数 + EquipmentQualityProto.smelt_back_count）
EquipInsInfo.UpgradeSmeltReturnItemCount = 0
-- 强化消耗返回个数
EquipInsInfo.RefineItemCostTotalCount = 0 
-- 强化配置
EquipInsInfo.RefineConfig = 0 
-- 临时道具计时器--
EquipInsInfo.Timer = nil
-- 更新信息
function EquipInsInfo:updateInfo(data)
    self.InsId = data.id
    self.Amount = 1
    self.Config = EquipsConfig:getConfigById(data.data_id)
    self.Level = data.level
    self.RefinedLevel = data.refined_level
    self.NextLvItemCostCount = data.upgrade_level_cost

    -- 强化提升百分比
    self.RefineStatAddPercent = data.refined_stat_percent
    -- 强化配置
    self.RefineConfig = EquipRefinedConfig:getConfigById(data.refined_level)

    -- 升级总消耗
    self.UpgradeRebuildReturnItemCount = data.upgrade_level_total_cost
    self.UpgradeSmeltReturnItemCount = data.upgrade_level_total_cost + self.Config.Quality.SmeltBackCount
    -- 强化总消耗(初始1级开始累加)
    self.RefineItemCostTotalCount = 0
    for i = 1, self.RefinedLevel do self.RefineItemCostTotalCount = self.RefineItemCostTotalCount + EquipRefinedConfig:getConfigById(i).CostCount end

    -- 下一强化消耗
    local nextRefineConfig = EquipRefinedConfig:getConfigById(data.refined_level + 1)
    self.NextRefineLvItemCostCount = 0
    if nil ~= nextRefineConfig then
        self.NextRefineLvItemCostCount = nextRefineConfig.CostCount
    end

    if nil ~= data.total_stat then
        if nil == self.TotalStat then
            self.TotalStat = SpriteStatClass()
        end
        self.TotalStat:updateInfo(data.total_stat)
    else
        self.TotalStat = nil
    end
    if nil ~= data.upgrade_level_stat then
        if nil == self.NextLvStatAdd then
            self.NextLvStatAdd = SpriteStatClass()
        end
        self.NextLvStatAdd:updateInfo(data.upgrade_level_stat)
    else
        self.NextLvStatAdd = nil
    end
    if nil ~= data.refined_stat then
        if nil == self.NextRefineLvStatAdd then
            self.NextRefineLvStatAdd = SpriteStatClass()
        end
        self.NextRefineLvStatAdd:updateInfo(data.refined_stat)
    else
        self.NextRefineLvStatAdd = nil
    end
end

-- 武将成长点信息
CaptainAbilityLocalInfo = Class()
-- 成长值
CaptainAbilityLocalInfo.Ability = 0
-- 升级经验（1级放的是1升2的升级经验）
CaptainAbilityLocalInfo.UpgradeExp = 0
-- 这个成长值的武将卖强化符
CaptainAbilityLocalInfo.SellPrice = nil 
-- 这个成长值的武将解雇返还多少强化符
CaptainAbilityLocalInfo.FirePrice = nil
-- 这个成长值的武将什么品质
CaptainAbilityLocalInfo.Quality = Quality.None
-- 描述文字
CaptainAbilityLocalInfo.Desc = ""

function CaptainAbilityLocalInfo:init()
    self.SellPrice = PrizeClass()
    self.FirePrice = PrizeClass()
end

-- 更新信息
function CaptainAbilityLocalInfo:updateInfo(data)
    self.Ability = data.ability
    self.UpgradeExp = data.upgrade_exp
    self.SellPrice:updateInfo(data.sell_price)
    self.FirePrice:updateInfo(data.fire_price)
    self.Quality = data.quality
    self.Desc = data.desc
end
-- *********************************************************************
-- 武将转生数据配置
CaptainRebirthLevelInfo = Class()
-- 等级
CaptainRebirthLevelInfo.Level = 0
-- 转生所需经验
CaptainRebirthLevelInfo.UpgradeExp = 0
-- 转生等级上限
CaptainRebirthLevelInfo.LevelLimit = 0
-- 转生所需元宝
CaptainRebirthLevelInfo.Yuanbao = 0
-- 转生属性
CaptainRebirthLevelInfo.StatPoint = 0
-- 转生统率
CaptainRebirthLevelInfo.SoldierCapcity = 0
-- 成长上限
CaptainRebirthLevelInfo.AbilityLimit = 0
-- 转生赠送成长经验
CaptainRebirthLevelInfo.AbilityExp = 0
function CaptainRebirthLevelInfo:init()

end

-- 更新信息
function CaptainRebirthLevelInfo:updateInfo(data)
    self.Level = data.level
    self.UpgradeExp = data.rebirth_upgrade_exp
    self.LevelLimit = data.captain_level_limit
    self.Yuanbao = data.yuanbao
    self.StatPoint = data.sprite_stat_point
    self.SoldierCapcity = data.soldier_capcity
    self.AbilityLimit = data.ability_limit
    self.AbilityExp = data.ability_exp
end

-- 修炼馆等级信息
TrainingLevelLocalInfo = Class()
-- 等级
TrainingLevelLocalInfo.Level = 0
-- 名称
TrainingLevelLocalInfo.Name = ""
-- 描述
TrainingLevelLocalInfo.Desc = ""
-- 经验产出（每小时）
TrainingLevelLocalInfo.ExpOutput = 0
-- 经验产出上限
TrainingLevelLocalInfo.ExpCapcity = 0
-- 升级消耗
TrainingLevelLocalInfo.Cost = nil
-- 系数, 这个值需要除以 1000，得到小数系数
TrainingLevelLocalInfo.Coef = 0

function TrainingLevelLocalInfo:init()
    self.Cost = CostClass()
end

-- 更新信息
function TrainingLevelLocalInfo:updateInfo(data)
    self.Level = data.level
    self.Name = data.name
    self.Desc = data.desc
    self.ExpOutput = data.exp_output
    self.ExpCapcity = data.exp_capcity
    self.Cost:updateInfo(data.cost)
    self.Coef = data.coef / 1000
end

-- *********************************************************************
-- 邮件相关
-- *********************************************************************
-- 战报英雄数据
ReportHeroClass = Class()
-- 君主id
ReportHeroClass.Id = ""
-- 君主名字
ReportHeroClass.Name = ""
-- 君主头像
ReportHeroClass.Head = ""
-- 主城坐标
ReportHeroClass.BaseX = 0
ReportHeroClass.BaseY = 0
-- 存活士兵
ReportHeroClass.AliveSoldier = 0
-- 总士兵
ReportHeroClass.TotalSoldier = 0
-- 更新信息
function ReportHeroClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Head = data.head
    self.BaseX = data.base_x
    self.BaseY = data.base_y
    self.AliveSoldier = data.alive_soldier
    self.TotalSoldier = data.total_soldier
end

-- 战报
FightReportClass = Class()
-- 资源
FightReportClass.Gold = 0
FightReportClass.Food = 0
FightReportClass.Wood = 0
FightReportClass.Stone = 0
-- 战斗发生的位置
FightReportClass.FightX = 0
FightReportClass.FightY = 0

-- true表示进攻方胜利
FightReportClass.AttackerWin = false
FightReportClass.Attacker = nil
FightReportClass.Defenser = nil
FightReportClass.AttackerDesc = ""
FightReportClass.DefenserDesc = ""

-- 战斗录像地址，特别的战报地址为空，不显示回放按钮（有的战报就是没有回放的）
FightReportClass.ReplayUrl = ""
-- true观看战斗回放，攻方为蓝色，守方为红色，false则反过来
FightReportClass.AttackerSide = false

function FightReportClass:init()
    self.Attacker = ReportHeroClass()
    self.Defenser = ReportHeroClass()
end

-- 更新信息
function FightReportClass:updateInfo(data)
    -- 资源
    self.Gold = data.gold
    self.Food = data.food
    self.Wood = data.wood
    self.Stone = data.stone

    -- 战斗发生的位置
    self.FightX = data.fight_x
    self.FightY = data.fight_y

    -- true表示进攻方胜利
    self.AttackerWin = data.attacker_win
    self.Attacker:updateInfo(data.attacker)
    self.Defenser:updateInfo(data.defenser)
    self.AttackerDesc = data.attacker_desc
    self.DefenserDesc = data.defenser_desc

    -- 战斗录像地址
    self.ReplayUrl = data.replay_url
    self.AttackerSide = data.attacker_side
end

-- *********************************************************************
-- 邮件信息
MailClass = Class()
-- 邮件id
MailClass.Id = ""
-- 邮件标题
MailClass.Title = ""
-- 邮件副标题
MailClass.SubTitle = ""
-- 邮件正文
MailClass.Text = ""
-- 发送时间
MailClass.SendTime = 0
-- icon
MailClass.Icon = 0
-- 是否收藏
MailClass.Keep = false
-- 是否已读
MailClass.Read = false
-- true表示这个邮件是战报邮件
MailClass.HasReport = false
-- true表示这个邮件是有奖励的邮件
MailClass.HasPrize = false
-- true表示这个邮件是已领取
MailClass.Collected = false
-- 战报数据
MailClass.Report = nil
-- 奖励数据
MailClass.Prize = nil

function MailClass:init()
    self.Report = FightReportClass()
    self.Prize = PrizeClass()
end

function MailClass:updateInfo(data)
    self.Id = data.id
    self.Title = data.title
    self.SubTitle = data.sub_title
    self.Text = data.text
    self.SendTime = data.send_time
    self.Icon = data.icon
    self.Keep = data.keep
    self.Read = data.read
    self.HasReport = data.has_report
    self.HasPrize = data.has_prize
    self.Collected = data.collected

    if data.report ~= nil then
        self.Report:updateInfo(data.report)
    end

    if data.prize ~= nil then
        self.Prize:updateInfo(data.prize)
    end
end

-- *********************************************************************
-- 战前相关
-- *********************************************************************

-- 战斗目标信息
BattleDeploymentInfo = Class()
-- 战斗部署类型
BattleDeploymentInfo.Type = BattleDeploymentType.None
-- 战力显示方式(0表示真实战力显示：比如pvp，1表示最高战力显示：比如pve千重楼等)
BattleDeploymentInfo.FightAmountShowType = 0
-- 出征回掉(四个参数，分别为：布阵武将id，武将个数，是否为联盟出征, 军队Id)
BattleDeploymentInfo.ToCombat = nil
-- 战斗武将
BattleDeploymentInfo.Troops = nil
-- 战斗获得
BattleDeploymentInfo.Awards = nil
-- 重楼密室
--    -- 楼层
--    FloorId = 0,
--    -- 最小玩家个数
--    MinPlayerNum = 0,
--    -- 最大玩家个数
--    MaxPlayerNum = 0,
--    -- 部队个数
--    TroopsNum = 0,
--    -- 最大连胜次数
--    MaxContinueNum = 0
--    -- 创建团队
--    IsCreatTroop = false,
BattleDeploymentInfo.Backroom = nil
-- 君主信息
--    -- 名称
--    Name = "",
--    -- 头像
--    Head = nil,
--    -- 联盟
--    Guild = "",
--    -- 军衔
--    Rank = "",
--    -- 等级
--    Level = 0,
--    -- 主城等级
--    MainCityLevel = 0,
--    -- 千重楼层级
--    TowerFloor = 0,
--    -- 战斗力
--    FightAmount = 0,
--    -- 目标坐标
--    PosX = 0,
--    -- 目标坐标
--    PosY = 0,
--    -- 出征时间
--    Time = 0,
BattleDeploymentInfo.Monarch = nil
-- 出征信息
--    -- 目标
--    Name = "",
--    -- 目标坐标
--    PosX = 0,
--    -- 目标坐标
--    PosY = 0,
--    -- 出征时间
--    Time = 0,
BattleDeploymentInfo.Expedition = nil
-- 清除
function BattleDeploymentInfo:clear()
    self.Type = BattleDeploymentType.None
    self.ToCombat = nil
    self.Troops = nil
    self.Awards = nil
    self.Monarch = nil
    self.Expedition = nil
    self.Backroom = nil
end

-- *********************************************************************
-- 战斗相关
-- *********************************************************************

-- 参战部队信息--
CombatTroopsClass = Class()
-- 实例化id标识
CombatTroopsClass.InsId = 0
-- 初始x轴Id
CombatTroopsClass.IdX = 0
-- 初始y轴Id
CombatTroopsClass.IdY = 0
-- 武将阵营--
CombatTroopsClass.Camp = CampType.None
-- 武将配置
CombatTroopsClass.Captain = nil
-- 更新信息--
function CombatTroopsClass:init()
    self.Captain = CaptainInfoClass()
end
-- 更新数据
function CombatTroopsClass:updateInfo(data)
    self.InsId = data.index
    self.IdX = data.x
    self.IdY = data.y
    self.Captain:updateInfo(data.captain)
end
-- 更新士兵数量
function CombatTroopsClass:updateSoliderNum(id, num)
    if self.InsId == id and nil ~= self.Captain then
        self.Captain.Soldier = num
    end
end
-- *********************************************************************

-- 参战玩家信息--
CombatPlayerClass = Class()
-- Id--
CombatPlayerClass.Id = "nil"
-- 昵称--
CombatPlayerClass.Name = "nil"
-- 头像--
CombatPlayerClass.Head = nil
-- 联盟Id-
CombatPlayerClass.GuildId = 0
-- 联盟名称-
CombatPlayerClass.GuildName = "nil"
-- 联盟旗号名称--
CombatPlayerClass.GuildFlagName = "nil"
-- 国家名称--
CombatPlayerClass.Country = "nil"
-- 战斗力--
CombatPlayerClass.FightAmount = 0
-- 部队列表--
CombatPlayerClass.TroopsList = nil
-- 总兵力
CombatPlayerClass.TotalSolider = 0
-- 总负载
CombatPlayerClass.TotalLoadResource = 0
-- 更新玩家信息
function CombatPlayerClass:updateInfo(camp, data)
    self.Id = data.id
    self.Head = UIConfig.MonarchsIcon[data.head]
    self.Name = data.name
    self.GuildId = data.guild_id
    self.GuildName = data.guild
    self.GuildFlagName = data.guild_flag_name
    self.FightAmount = data.total_fight_amount
    self.TroopsList = { }
    for k, v in ipairs(data.troops) do
        local troops = CombatTroopsClass()
        troops:updateInfo(v)
        troops.Camp = camp

        table.insert(self.TroopsList, troops)
        -- 总兵力计算--
        self.TotalSolider = self.TotalSolider + troops.Captain.TotalSoldier
        -- 总负载计算--
        self.TotalLoadResource = self.TotalLoadResource + troops.Captain.LoadPerSoldier
    end
end
-- 获取武将
function CombatPlayerClass:getCaptainById(id)
    for k, v in ipairs(self.TroopsList) do
        if v.InsId == id then
            return v
        end
    end
end
-- 更新士兵数量
function CombatPlayerClass:updateSoliderNum(id, num)
    for k, v in ipairs(self.TroopsList) do
        v:updateSoliderNum(id, num)
    end
end
-- 计算总兵力
function CombatPlayerClass:calcSoliderNum()
    self.TotalSolider = 0
    for k, v in ipairs(self.TroopsList) do
        self.TotalSolider = self.TotalSolider + v.Captain.TotalSoldier
    end
end
-- 清除
function CombatPlayerClass:clear()
    self.Id = "nil"
    self.Head = "nil"
    self.Name = "nil"
    self.Guild = "nil"
    self.Country = "nil"
    self.FightAmount = 0
    self.TroopsList = nil
    self.TotalSolider = 0
    self.TotalLoadResource = 0
end
-- *********************************************************************
-- 战斗行为信息--
CombatActionClass = Class()    
-- 所在回合--
CombatActionClass.BoutId = 0
-- 标识Id,标识武将单位--
CombatActionClass.Id = 0
-- 当Direction不为nil或者不为origin,下字段为移动方向--
CombatActionClass.Direction = DirectionType.None
-- 被攻击对象和伤害值，0表示没有对象可以打--
CombatActionClass.AttackTargetId = 0
-- 总击杀的士兵数，此处 = 普通技能击杀的士兵数 + 克制技击杀的士兵数 + 后面其他的击杀的士兵数，计算普通技能击杀的士兵数 = 总击杀的士兵数 - 克制技击杀的士兵数 - 后面其他的击杀的士兵数
CombatActionClass.AttackDamage = 0    
-- 克制技击杀的士兵数，可能为0， >0表示触发了克制技；如果当前释放了克制技(技能获取:RaceDataProto.restraint_spell.id)，客户端将特效显示该技能的动作/特效，如果找不到该技能的配置，默认释放普通技能的动作/特效
CombatActionClass.AttackRestraintSpellDamage = 0    
-- 伤害类型--
CombatActionClass.HurtType = HurtType.None
-- 攻击者技能类型
CombatActionClass.AttackerSkillType = SkillType.None
-- 普攻技能Id
CombatActionClass.NormalAttackSkillId = 0
-- 克制技能Id
CombatActionClass.RestrainSkillId = 0
-- 更新信息--
function CombatActionClass:updateInfo(data)
    self.Id = data.index
    self.Direction = data.move_direction
    self.AttackTargetId = data.target_index
    self.AttackDamage = data.damage
    self.HurtType = data.hurt_type
    self.AttackRestraintSpellDamage = data.restraint_spell_damage
    self.NormalAttackSkillId = data.normal_spell
    self.RestrainSkillId = data.restraint_spell

    -- 技能类型判断
    if data.restraint_spell ~= 0 then
        self.AttackerSkillType = SkillType.Restrain
    else
        self.AttackerSkillType = SkillType.NormalAttack
    end
end

-- *********************************************************************
-- pvp结算信息--
local BattlePVPAwardInfo = Class()
-- 通货获得
BattlePVPAwardInfo.Currency = { }
-- 军队负载当前
BattlePVPAwardInfo.CurLoadResource = 0
-- 更新信息--
function BattlePVPAwardInfo:updateInfo(data)
    self.Currency[CurrencyType.Food] = data.food
    self.Currency[CurrencyType.Wood] = data.wood
    self.Currency[CurrencyType.Stone] = data.stone
    self.Currency[CurrencyType.Gold] = data.gold

    self.CurLoadResource = data.food + data.wood + data.stone + data.gold
end

-- pve结算信息--
local BattlePVEAwardInfo = Class()
-- 玩家经验
BattlePVEAwardInfo.PlayerExp = 0
-- 武将经验
BattlePVEAwardInfo.GeneralExp = 0
-- 上阵武将
BattlePVEAwardInfo.Captains = nil
-- 道具获得
BattlePVEAwardInfo.Items = nil
-- 更新信息--
function BattlePVEAwardInfo:updateInfo(data)
    self.PlayerExp = data.CaptainExp
    self.GeneralExp = data.CaptainExp
    self.Captains = data.Captains

    self.Items = { }
    for k, v in pairs(data.Equips) do
        table.insert(self.Items, v)
    end
    for k, v in pairs(data.Goods) do
        table.insert(self.Items, v)
    end
end
    
-- 战斗结算信息--
local BattleResultInfo = Class()
-- 战斗结果
BattleResultInfo.AttackerWin = false
-- 战斗结果类型
BattleResultInfo.BattleResultType = BattleResultType.None
-- 存活兵
BattleResultInfo.AliveSolider = nil   
-- pve获得
BattleResultInfo.PVEAward = nil   
-- pvp获得
BattleResultInfo.PVPAward = nil  
-- 其他
BattleResultInfo.OtherResultInfo = nil  
-- 更新信息--
function BattleResultInfo:updateBaseInfo(data)
    self.AttackerWin = data.attacker_win
    -- 评分
    if data.score == 0 then
        self.BattleResultType = BattleResultType.Squeak
    elseif data.score == 1 then
        self.BattleResultType = BattleResultType.Win
    elseif data.score == 2 then
        self.BattleResultType = BattleResultType.Victory
    elseif data.score == 3 then
        self.BattleResultType = BattleResultType.CompleteWin
    end
    -- 存活兵
    self.AliveSolider = { }
    for k, v in ipairs(data.alive_solider) do
        self.AliveSolider[v.key] = v.value
    end
end
-- 更新pve结算(data = PrizeClass())
function BattleResultInfo:updatePVEInfo(data)
    if data.pveAward == nil then
        self.PVEAward = BattlePVEAwardInfo()
    end
    self.PVEAward:updateInfo(data)
end
-- 更新pvp结算
function BattleResultInfo:updatePVPInfo(data)
    if data.pvpAward ~= nil then
        local award = BattlePVPAwardInfo()
        award:updateInfo(data.pvpAward)
        self.PVPAward = award
    end
end
-- 清除
function BattleResultInfo:clear()
    self.AttackerWin = false
    self.BattleResultType = BattleResultType.None
    self.AliveSolider = nil
    self.PVEAward = nil
    self.PVPAward = nil
end
-- *********************************************************************
-- 战斗回放信息--
BattleReplayInfo = Class()
-- 战场地图资源--
BattleReplayInfo.MapRes = ""
-- 战场x轴向格子个数--
BattleReplayInfo.XGridNum = 0
-- 战场y轴向格子个数--
BattleReplayInfo.YGridNum = 0
-- 战斗类型--
BattleReplayInfo.Style = BattleStyleType.None
-- 攻击方信息--
BattleReplayInfo.AttackerPlayer = nil
-- 守御方信息--
BattleReplayInfo.DefenserPlayer = nil
-- 战斗信息--
BattleReplayInfo.ActionList = { }
-- 连胜离场
BattleReplayInfo.WinnerContinueWinLeave = false
-- 连胜次数
BattleReplayInfo.WinnerContinueWinNum = 0
-- 所在队列Id
BattleReplayInfo.InTheQueueId = 0
-- 战斗结果
BattleReplayInfo.Result = nil

function BattleReplayInfo:init()
    self.AttackerPlayer = CombatPlayerClass()
    self.DefenserPlayer = CombatPlayerClass()
    self.Result = BattleResultInfo()
end

-- 更新信息--
function BattleReplayInfo:updateInfo(data)
    self.MapRes = data.map_res
    self.XGridNum = data.map_x_len
    self.YGridNum = data.map_y_len
    self.WinnerContinueWinLeave = data.is_winner_continue_win_leave
    self.WinnerContinueWinNum = data.winner_continue_win_times
    self.InTheQueueId = data.fight_queue

    -- 更新基础结算
    self.Result:updateBaseInfo(data)
    self.AttackerPlayer:updateInfo(CampType.Attacker, data.attacker)
    self.DefenserPlayer:updateInfo(CampType.Defender, data.defenser)

    -- 更新上阵士兵数量
    for k, v in ipairs(data.combat_solider) do
        self.AttackerPlayer:updateSoliderNum(v.key, v.value)
        self.DefenserPlayer:updateSoliderNum(v.key, v.value)
    end

    print("所在队列", data.fight_queue, "战斗格子：" .. data.map_x_len .. "--" .. data.map_y_len, "地图信息：", data.map_res)
    self.ActionList = { }
    for k, v in ipairs(data.rounds) do
        print("回合：" .. v.round .. " 共轮次：" .. tostring(#v.actions))
        for k1, v1 in ipairs(v.actions) do
            local action = CombatActionClass()
            action.BoutId = v.round
            action:updateInfo(v1)
            table.insert(self.ActionList, action)
        end
    end
    print("共轮次：" .. #(self.ActionList))
end
-- 更新pve获得信息--
function BattleReplayInfo:updatePVEAward(data)
    self.Style = BattleStyleType.PVE
    self.Result:updatePVEInfo(data)
end
-- 更新pvp获得信息--
function BattleReplayInfo:updatePVPAward(data)
    self.Style = BattleStyleType.PVP
    self.Result:updatePVPInfo(data)
end
-- 清除
function BattleReplayInfo:clear()
    self.MapRes = ""
    self.XGridNum = 0
    self.YGridNum = 0
    self.Style = BattleStyleType.None
    self.AttackerPlayer:clear()
    self.DefenserPlayer:clear()
    self.ActionList = { }
    self.Result:clear()
end

-- 多人战斗结算信息--
local MultiBattleResultInfo = Class()
-- 战斗结果
MultiBattleResultInfo.AttackerWin = false
-- 战斗结果类型
MultiBattleResultInfo.BattleResultType = 0
-- 进攻方死亡队伍数量
MultiBattleResultInfo.AttackerDeadCount = 0
-- 防守方死亡队伍数量
MultiBattleResultInfo.DefenderDeadCount = 0
-- 进攻方连胜离场队伍数量
MultiBattleResultInfo.AttackerLeaveCount = 0
-- 防守方连胜离场队伍数量 
MultiBattleResultInfo.DefenderLeaveCount = 0
-- 其他信息
MultiBattleResultInfo.OtherResultInfo = nil
-- 更新信息--
function MultiBattleResultInfo:updateBaseInfo(data)
    self.AttackerWin = data.attacker_win
    -- 评分
    if data.score == 0 then
        self.BattleResultType = BattleResultType.Squeak
    elseif data.score == 1 then
        self.BattleResultType = BattleResultType.Win
    elseif data.score == 2 then
        self.BattleResultType = BattleResultType.Victory
    elseif data.score == 3 then
        self.BattleResultType = BattleResultType.CompleteWin
    end

    self.AttackerDeadCount = data.attacker_dead_count
    self.DefenderDeadCount = data.defenser_dead_count
    self.AttackerLeaveCount = data.attacker_leave_count
    self.DefenderLeaveCount = data.defenser_leave_count
end
-- 清除
function MultiBattleResultInfo:clear()
    self.AttackerWin = false
    self.BattleResultType = BattleResultType.None
end

-- 多人战斗回放信息--
MultiBattleReplayInfo = Class()
-- 战场地图资源--
MultiBattleReplayInfo.MapRes = ""
-- 战场x轴向格子个数--
MultiBattleReplayInfo.XGridNum = 0
-- 战场y轴向格子个数--
MultiBattleReplayInfo.YGridNum = 0
-- 队列个数--
MultiBattleReplayInfo.QueueNum = 0
-- 战斗类型--
MultiBattleReplayInfo.Style = BattleStyleType.None
-- 攻击方信息--
MultiBattleReplayInfo.AttackerPlayer = { }
-- 守御方信息--
MultiBattleReplayInfo.DefenserPlayer = { }
-- 各支部队连胜次数信息--
MultiBattleReplayInfo.PlayerWinNum = { }
-- 战斗队列信息--
MultiBattleReplayInfo.FightList = { }
-- 战斗结果
MultiBattleReplayInfo.Result = nil

function MultiBattleReplayInfo:init()
    self.Result = MultiBattleResultInfo()
end

-- 更新信息--
function MultiBattleReplayInfo:updateInfo(data)
    self.MapRes = data.map_res
    self.XGridNum = data.map_x_len
    self.YGridNum = data.map_y_len
    self.QueueNum = data.concurrent_fight_count
    print("战斗格子：" .. data.map_x_len .. "--" .. data.map_y_len)

    -- 更新基础结算
    self.Result:updateBaseInfo(data)

    self.AttackerPlayer = { }
    for k, v in ipairs(data.attacker) do
        print("攻击者Id", v.id)
        local player = CombatPlayerClass()
        player:updateInfo(CampType.Attacker, v)
        table.insert(self.AttackerPlayer, player)
    end
    self.DefenserPlayer = { }
    for k, v in ipairs(data.defenser) do
        print("防御者Id", v.id)
        local player = CombatPlayerClass()
        player:updateInfo(CampType.Defender, v)
        table.insert(self.DefenserPlayer, player)
    end

    self.PlayerWinNum = { }
    for k, v in ipairs(data.win_times) do
        self.PlayerWinNum[v.key] = v.value
    end

    self.FightList = { }
    for k, v in ipairs(data.combats) do
        local fight = BattleReplayInfo()
        fight:updateInfo(v)
        table.insert(self.FightList, fight)
    end

    print("共战斗场次：" .. #(self.FightList))
end
-- 清除
function MultiBattleReplayInfo:clear()
    self.MapRes = ""
    self.XGridNum = 0
    self.YGridNum = 0
    self.Style = BattleStyleType.None
    self.AttackerPlayer = { }
    self.DefenserPlayer = { }
    self.FightList = { }
    self.Result:clear()
end
-- *********************************************************************
-- 主城等级配置信息
MainCityLevelClass = Class()
-- 等级
MainCityLevelClass.Level = 0 
-- 升级所需繁荣度
MainCityLevelClass.RequireProsperity = 0 
-- 更新信息--
function MainCityLevelClass:updateInfo(data)
    self.Level = data.level
    self.RequireProsperity = data.upgrade_prosperity
end

-- *********************************************************************
-- 千重楼相关
-- *********************************************************************
-- 守楼武将
MonsterCaptainClass = Class()
-- 标识Id
MonsterCaptainClass.Id = 0
-- 名字
MonsterCaptainClass.Name = 0
-- 头像
MonsterCaptainClass.Head = 0
-- 兵种
MonsterCaptainClass.Race = 0
-- 品质
MonsterCaptainClass.Quality = 0
-- 士兵数/最大士兵数
MonsterCaptainClass.Solider = 0
-- 最大士兵数
MonsterCaptainClass.MaxSolider = 0
-- 战斗力
MonsterCaptainClass.FightAmount = 0
-- 武将等级
MonsterCaptainClass.Level = 0
-- 士兵等级
MonsterCaptainClass.SoldierLevel = 0
-- tip， 0-普通 1-首领 用于做一些特殊的表示，比如千重楼里的首领
MonsterCaptainClass.Label = 0
-- 数据更新
function MonsterCaptainClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Head = string.format(UIConfig.CaptainSmallHead, data.head)
    self.Race = data.race
    self.Quality = data.quality
    self.Solider = data.soldier
    self.FightAmount = data.fight_amount
    self.Level = data.level
    self.SoldierLevel = data.soldier_level
    self.Label = data.label
end

-- 守楼首领
MonsterMasterClass = Class()
-- 标识Id
MonsterMasterClass.Id = 0
-- 名字
MonsterMasterClass.Name = 0
-- 头像
MonsterMasterClass.Head = nil
-- 武将布阵
MonsterMasterClass.Troops = nil
-- 战斗力
MonsterMasterClass.FightAmount = 0
-- 数据更新
function MonsterMasterClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Head = UIConfig.MonarchsIcon[data.head]

    -- 守将
    self.Troops = { }
    self.FightAmount = 0
    if nil ~= data.captains then
        for k, v in ipairs(data.captains) do
            local captain = MonsterCaptainClass()
            captain:updateInfo(v)
            table.insert(self.Troops, captain)
            self.FightAmount = self.FightAmount + captain.FightAmount
        end
    end
end

-- 千层楼本地配置
TowerLocalInfo = Class()
-- 层数
TowerLocalInfo.Floor = 0
-- 描述
TowerLocalInfo.Desc = ""
-- 开放密室楼层
TowerLocalInfo.OpenBackroomFloor = 0
-- 首胜奖励
TowerLocalInfo.FirstPassPrize = nil
-- 展示奖励（除了首胜奖励外的其他奖励）
TowerLocalInfo.ShowPrize = nil
-- 重楼宝箱，只有重点楼层才有
TowerLocalInfo.BoxPrize = nil
-- 防守将领信息
TowerLocalInfo.MonsterMaster = nil
-- 数据更新
function TowerLocalInfo:updateInfo(data)
    self.Floor = data.floor
    self.Desc = data.desc
    self.OpenBackroomFloor = data.unlock_secret_tower_id

    if nil ~= data.first_pass_prize then
        if nil == self.FirstPassPrize then
            self.FirstPassPrize = PrizeClass()
        end
        self.FirstPassPrize:updateInfo(data.first_pass_prize)
    end

    if nil ~= data.show_prize then
        if nil == self.ShowPrize then
            self.ShowPrize = PrizeClass()
        end
        self.ShowPrize:updateInfo(data.show_prize)
    end
    if not checkPrizeEmpty(data.box_prize) then
        if nil == self.BoxPrize then
            self.BoxPrize = PrizeClass()
        end
        self.BoxPrize:updateInfo(data.box_prize)
    else
        self.BoxPrize = nil
    end

    if data.monster ~= nil then
        if nil == self.MonsterMaster then
            self.MonsterMaster = MonsterMasterClass()
        end
        self.MonsterMaster:updateInfo(data.monster)
    end
end

-- 重楼回放信息
TowerReplayClass = Class()
-- 楼层
TowerReplayClass.Floor = 0
-- 头像
TowerReplayClass.Head = nil
-- 通关时间
TowerReplayClass.Time = ""
-- 通关回放地址
TowerReplayClass.Link = ""
-- 通关奖励
TowerReplayClass.Prize = nil
-- 君主id
TowerReplayClass.HeroId = 0
-- 君主名字
TowerReplayClass.Name = ""
-- 联盟id
TowerReplayClass.GuildId = 0
-- 联盟名字
TowerReplayClass.GuildName = ""
-- 旗号
TowerReplayClass.GuildFlagName = ""
-- 阵容搭配
TowerReplayClass.Race = { }
-- 战斗力
TowerReplayClass.FightAmount = 0
function TowerReplayClass:init()
    self.Prize = PrizeClass()
end
-- 更新数据
function TowerReplayClass:updateInfo(data)
    self.Floor = data.floor
    self.Time = Utils.getTimeStamp(data.time)
    self.Link = data.link
    self.HeroId = data.hero_id
    self.Name = data.hero_name
    self.GuildId = data.guild_id
    self.GuildName = data.guild_name
    self.GuildFlagName = data.guild_flag_name
    self.FightAmount = data.fight_amount
    self.Head = UIConfig.MonarchsIcon["0"]
    -- 奖励
    self.Prize:clear()
    if nil ~= data.first_pass_prize then
        self.Prize:updateInfo(data.first_pass_prize)
    end
    if nil ~= data.prize then
        self.Prize:updateInfo(data.prize)
    end
    -- 兵种
    self.Race = { }
    for k, v in ipairs(data.race) do
        table.insert(self.Race, v)
    end
end

-- 重楼每层回放信息
TowerFloorReplayClass = Class()
-- 楼层
TowerFloorReplayClass.Floor = 0
-- 按顺序，第一个时间最早
TowerFloorReplayClass.Replay = { }
-- 最低战力通关
TowerFloorReplayClass.LowestReplay = nil
-- 是否应该刷新本层数据
TowerFloorReplayClass.ShouldRefresh = true
-- 刷新计时器
TowerFloorReplayClass.RefreshTimer = nil
-- 初始化
function TowerFloorReplayClass:init()
    self.LowestReplay = TowerReplayClass()
    self.RefreshTimer = TimerManager.newTimer(60, false, true, function() self.ShouldRefresh = false end, nil, function() self.ShouldRefresh = true end, self)
end
-- 更新数据
function TowerFloorReplayClass:updateInfo(data)
    print("重楼回放！！", data)
    self.Floor = data.floor

    local num = #data.replay
    -- 复用对象
    if num < #self.Replay then
        for i = #data.replay + 1, #self.Replay do
            self.Replay[i] = nil
        end
    end
    for i = 1, num do
        local parse = self.Replay[i]
        if nil == parse then
            parse = TowerReplayClass()
        end

        parse:updateInfo(data.replay[i])
        self.Replay[i] = parse
    end
    -- 最低通关
    self.LowestReplay:updateInfo(data.lowest_replay)
    -- 开始计时
    self.RefreshTimer:start()
end
-- *********************************************************************
-- 重楼密室相关
-- *********************************************************************
-- 重楼密室通用信息
TowerBackroomCommonLocalInfo = Class()
-- 恢复间隔(单位秒)
TowerBackroomCommonLocalInfo.RecoverDuration = 0
-- 最大挑战次数，即最大可以恢复到几次
TowerBackroomCommonLocalInfo.MaxChallengeTimes = 0
-- 最大协助次数，即最大可以恢复到几次
TowerBackroomCommonLocalInfo.MaxHelpTimes = 0
-- 数据更新
function TowerBackroomCommonLocalInfo:updateInfo(data)
    self.RecoverDuration = data.recover_duration
    self.MaxChallengeTimes = data.max_times
    self.MaxHelpTimes = data.max_help_times
end

-- 重楼密室本地配置
TowerBackroomLocalInfo = Class()
-- 楼层id，id从1开始，逐层递增
TowerBackroomLocalInfo.Floor = 0
-- 楼层名字
TowerBackroomLocalInfo.Name = ""
-- 描述
TowerBackroomLocalInfo.Desc = ""
-- 最大连胜次数
TowerBackroomLocalInfo.MaxContinueWinTimes = 0
-- 最大进攻方数量
TowerBackroomLocalInfo.MaxAttackerCount = 0
-- 最小进攻方数量
TowerBackroomLocalInfo.MinAttackerCount = 0
-- 首胜奖励
TowerBackroomLocalInfo.FirstPassPrize = nil
-- 展示奖励（除了首胜奖励外的其他奖励）
TowerBackroomLocalInfo.ShowPrize = nil
-- 超级大奖
TowerBackroomLocalInfo.SuperPrize = nil
-- 协助的联盟贡献奖励
TowerBackroomLocalInfo.ContributionForGuild = nil
-- 防守部队队长id
TowerBackroomLocalInfo.LeaderId = 0
-- 防守部队信息
TowerBackroomLocalInfo.MonsterMasters = nil
-- 初始化
function TowerBackroomLocalInfo:init()
    self.ContributionForGuild = ItemShowInfo()
end
-- 数据更新
function TowerBackroomLocalInfo:updateInfo(data)
    self.Floor = data.id
    self.Name = data.name
    self.Desc = data.desc
    self.LeaderId = data.monster_leader_id
    self.MaxContinueWinTimes = data.max_attacker_continuew_win_times
    self.MaxAttackerCount = data.max_attacker_count
    self.MinAttackerCount = data.min_attacker_count
    self.ContributionForGuild:updateInfo(CurrencyType.GuildContribution, data.guild_help_contribution, ItemClassifyType.Currency)

    if nil ~= data.first_pass_prize then
        if nil == self.FirstPassPrize then
            self.FirstPassPrize = PrizeClass()
        end
        self.FirstPassPrize:updateInfo(data.first_pass_prize)
    end

    if nil ~= data.prize then
        if nil == self.ShowPrize then
            self.ShowPrize = PrizeClass()
        end
        self.ShowPrize:updateInfo(data.prize)
    end
    if not checkPrizeEmpty(data.super_prize) then
        if nil == self.BoxPrize then
            self.BoxPrize = PrizeClass()
        end
        self.BoxPrize:updateInfo(data.super_prize)
    else
        self.BoxPrize = nil
    end

    self.MonsterMasters = { }
    for k, v in ipairs(data.monster) do
        local master = MonsterMasterClass()
        master:updateInfo(v)
        table.insert(self.MonsterMasters, master)
    end
end
-- 密室楼层队伍成员
TowerBackroomTroopsMemberClass = Class()
-- 玩家Id
TowerBackroomTroopsMemberClass.Id = 0
-- 玩家名字
TowerBackroomTroopsMemberClass.Name = ""
-- 参战类型,0挑战，1协助
TowerBackroomTroopsMemberClass.Mode = 0
-- 战斗力
TowerBackroomTroopsMemberClass.FightAmount = 0
-- 上阵士兵类型
TowerBackroomTroopsMemberClass.CaptainsRaceType = { }
-- 玩家帮派id，为0后面的帮旗、帮派名都不用读了
TowerBackroomTroopsMemberClass.GuildId = 0
-- 忘记帮派名称
TowerBackroomTroopsMemberClass.GuildName = 0
-- 玩家帮旗
TowerBackroomTroopsMemberClass.GuildFlagName = 0
-- 更新数据
function TowerBackroomTroopsMemberClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Mode = data.mode
    self.FightAmount = data.fight_amount
    self.GuildId = data.guildId
    self.GuildName = data.guildName
    self.GuildFlagName = data.guildFlagName

    self.CaptainsRaceType = { }
    for k, v in ipairs(data.captain_race) do
        table.insert(self.CaptainsRaceType, v)
    end
end

-- 密室楼层队伍详细信息
TowerBackroomTroopsDetailClass = Class()
-- 队伍Id,小于0时表示已退出队伍
TowerBackroomTroopsDetailClass.TeamId = -1
-- 队长Id
TowerBackroomTroopsDetailClass.LeaderId = ""
-- 密室楼层
TowerBackroomTroopsDetailClass.FloorId = 0
-- 密室配置
TowerBackroomTroopsDetailClass.FloorConfig = nil
-- 需要的联盟id，如果此处>0显示仅限盟友，如果该联盟id等于我的联盟id，那么表示是我的盟友创建的
TowerBackroomTroopsDetailClass.GuildId = 0
-- 队伍成员
TowerBackroomTroopsDetailClass.Members = nil
-- 开始保护结束时间，就是这个时间之前无法开启战斗
TowerBackroomTroopsDetailClass.ProtectEndTime = 0
-- 更新数据
function TowerBackroomTroopsDetailClass:updateInfo(data)
    self.TeamId = data.team_id
    self.LeaderId = data.leader_id
    self.FloorId = data.secret_tower_id
    self.GuildId = data.guild_id
    self.ProtectEndTime = data.protect_end_time
    self.FloorConfig = BackroomConfig:getConfigById(self.FloorId)

    self.Members = { }
    for k, v in ipairs(data.members) do
        local bytes = shared_pb.SecretTowerTeamMemberProto()
        bytes:ParseFromString(v)

        local member = TowerBackroomTroopsMemberClass()
        member:updateInfo(bytes)

        table.insert(self.Members, member)
    end
    print("队伍成员个数：", #self.Members)
end

-- 密室楼层队伍简单信息
TowerBackroomTroopsBriefClass = Class()
-- 队伍Id
TowerBackroomTroopsBriefClass.TeamId = 0
-- 密室楼层
TowerBackroomTroopsBriefClass.FloorId = 0
-- 密室楼层配置
TowerBackroomTroopsBriefClass.FloorConfig = nil
-- 需要的联盟id，如果此处>0显示仅限盟友，如果该联盟id等于我的联盟id，那么表示是我的盟友创建的
TowerBackroomTroopsBriefClass.GuildId = 0
-- 队长信息
TowerBackroomTroopsBriefClass.LeaderInfo = nil
-- 当前成员数量
TowerBackroomTroopsBriefClass.CurMemberCount = 0
-- 最大成员数量
TowerBackroomTroopsBriefClass.MaxMemberCount = 0
-- 初始化
function TowerBackroomTroopsBriefClass:init()
    self.LeaderInfo = TowerBackroomTroopsMemberClass()
end
-- 更新数据
function TowerBackroomTroopsBriefClass:updateInfo(data)
    self.TeamId = data.team_id
    self.FloorId = data.secret_tower_id
    self.GuildId = data.guild_id
    self.CurMemberCount = data.cur_member_count
    self.MaxMemberCount = data.max_member_count
    self.FloorConfig = BackroomConfig:getConfigById(self.FloorId)

    -- 队长
    if nil ~= data.leader then
        local leader = shared_pb.SecretTowerTeamMemberProto()
        leader:ParseFromString(data.leader)

        self.LeaderInfo:updateInfo(leader)
    end
end

-- 密室楼层信息
TowerBackroomFloorClass = Class()
-- 楼层
TowerBackroomFloorClass.Floor = 0
-- 楼层队伍个数
TowerBackroomFloorClass.TroopsCount = 0
-- 楼层首胜奖励已领取
TowerBackroomFloorClass.FirstPrizeCollected = false
-- 楼层队伍
TowerBackroomFloorClass.Troops = { }
-- 是否应该刷新本层数据
TowerBackroomFloorClass.ShouldRefresh = true
-- 刷新计时器
TowerBackroomFloorClass.RefreshTimer = nil
-- 初始化
function TowerBackroomFloorClass:init()
    self.RefreshTimer = TimerManager.newTimer(10, false, true, function() self.ShouldRefresh = false end, nil, function() self.ShouldRefresh = true end, self)
end
-- 更新数据
function TowerBackroomFloorClass:clear()
    self.Floor = -1
    self.Troops = { }
    self.TroopsCount = 0
    self.ShouldRefresh = false
    self.RefreshTimer:reset()
end
-- 更新数据
function TowerBackroomFloorClass:updateInfo(data, myTeamId)
    self.Floor = data.secret_tower_id
    -- 队伍
    self.Troops = { }
    for k, v in ipairs(data.team_list) do
        local bytes = shared_pb.SecretTeamShowProto()
        bytes:ParseFromString(v)

        local troops = TowerBackroomTroopsBriefClass()
        troops:updateInfo(bytes)

        if troops.TeamId == myTeamId then
            table.insert(self.Troops, 1, troops)
        else
            table.insert(self.Troops, troops)
        end
    end
    self.TroopsCount = #self.Troops
    -- 开始计时
    self.RefreshTimer:start()
end

-- 密室楼层队伍战斗结果
TowerBackroomBattleMemberResultClass = Class()
-- 玩家Id
TowerBackroomBattleMemberResultClass.Id = 0
-- 玩家名字
TowerBackroomBattleMemberResultClass.Name = ""
-- 玩家帮派id，为0后面的帮旗、帮派名都不用读了
TowerBackroomBattleMemberResultClass.GuildId = 0
-- 忘记帮派名称
TowerBackroomBattleMemberResultClass.GuildName = 0
-- 玩家帮旗
TowerBackroomBattleMemberResultClass.GuildFlagName = 0
-- 连胜次数
TowerBackroomBattleMemberResultClass.ContinueWinTime = 0
-- 是否首胜奖励
TowerBackroomBattleMemberResultClass.IsFirstPass = false
-- 通关奖励
TowerBackroomBattleMemberResultClass.PassPrize = nil
-- 联盟贡献
TowerBackroomBattleMemberResultClass.GuildContribution = 0
-- 初始化
function TowerBackroomBattleMemberResultClass:init()
    self.PassPrize = PrizeClass()
end
-- 更新数据
function TowerBackroomBattleMemberResultClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.GuildId = data.guildId
    self.GuildName = data.guildName
    self.GuildFlagName = data.guildFlagName
    self.IsFirstPass = data.first_pass_prize
    self.GuildContribution = data.guild_contribution
    self.ContinueWinTime = data.continue_kill_count

    if nil ~= data.prize then
        self.PassPrize:updateInfo(data.prize)
    end
end

-- 密室楼层队伍战斗结果
TowerBackroomBattleResultClass = Class()
-- 赢了还是输了
TowerBackroomBattleResultClass.Win = false
-- 回放链接
TowerBackroomBattleResultClass.Link = ""
-- 楼层Id
TowerBackroomBattleResultClass.FloorId = 0
-- 楼层配置
TowerBackroomBattleResultClass.FloorConfig = nil
-- 攻击方队长Id
TowerBackroomBattleResultClass.AttackLeaderId = 0
-- 防御方队长Id
TowerBackroomBattleResultClass.DefendLeaderId = 0
-- 攻击方描述
TowerBackroomBattleResultClass.AttackDesc = ""
-- 防御方描述
TowerBackroomBattleResultClass.DefendDesc = ""
-- 击杀目标队伍个数
TowerBackroomBattleResultClass.KillTargetTroops = 0
-- 剩余目标队伍个数
TowerBackroomBattleResultClass.LeftTargetTroops = 0
-- 获得超级奖励的部队,拿到超级大奖的id，空表示没人拿到
TowerBackroomBattleResultClass.GetSuperPrizeTroopId = 0
-- 超级奖励
TowerBackroomBattleResultClass.SuperPrize = nil
-- 成员奖励信息
TowerBackroomBattleResultClass.Members = nil
-- 初始化
function TowerBackroomBattleResultClass:init()
    self.SuperPrize = PrizeClass()
end
-- 更新数据
function TowerBackroomBattleResultClass:updateInfo(data)
    self.Win = data.win
    self.Link = data.link
    self.FloorId = data.secret_tower_id
    self.FloorConfig = BackroomConfig:getConfigById(self.FloorId)
    self.KillTargetTroops = data.kill_monster
    self.LeftTargetTroops = data.left_monster
    self.GetSuperPrizeTroopId = data.super_prize_id
    self.AttackLeaderId = data.attack_leader_id
    self.DefendLeaderId = data.defence_leader_id

    if nil ~= data.super_prize then
        self.SuperPrize:updateInfo(data.super_prize)
    end

    self.Members = { }
    for k, v in ipairs(data.members) do
        local member = TowerBackroomBattleMemberResultClass()
        member:updateInfo(v)
        table.insert(self.Members, member)

        -- 攻击方描述
        if member.Id == self.AttackLeaderId then
            if member.GuildId > 0 then
                self.AttackDesc = string.format("[%s]%s", member.GuildFlagName, member.Name)
            else
                self.AttackDesc = member.Name
            end
        end
    end
    self.DefendDesc = string.format(Localization.BackroomDefendDesc, self.FloorId)
end
-- *********************************************************************
-- 社交相关
-- *********************************************************************
--  聊天信息
ChatInsInfo = Class()
-- 君主id
ChatInsInfo.Id = ""
-- 君主名字
ChatInsInfo.Name = ""
-- 君主头像
ChatInsInfo.Head = nil
-- 联盟旗号
ChatInsInfo.GuildFlagName = ""
-- 目标（0别人，1自身，2时间）
ChatInsInfo.YouOrMe = 0
-- 内容
ChatInsInfo.Content = ""
-- 时间戳，单位秒
ChatInsInfo.Timestamp = 0
-- 所在频道
ChatInsInfo.Channel = ChatChannelType.None
-- 已读
ChatInsInfo.MarkRead = false
-- 更新
function ChatInsInfo:updateInfo(data, channel)
    self.Id = data.id
    self.Name = data.name
    self.Head = UIConfig.MonarchsIcon[data.head]
    self.GuildFlagName = data.guild_flag
    self.Content = data.text
    self.Timestamp = os.time()
    self.Channel = channel
    self.YouOrMe = 0
    self.MarkRead = false
end

-- *********************************************************************
-- GM命令相关
-- *********************************************************************
-- GM命令
GmCmdClass = Class()
-- 命令名称
GmCmdClass.CMD = ""
-- 描述
GmCmdClass.Desc = ""
-- true表示有文本输入框
GmCmdClass.HasInput = false
-- 默认显示在输入框中的内容
GmCmdClass.DefaultInput = ""
-- cmd = proto.cmd + "空格" + 文本框里面的值
function GmCmdClass:updateInfo(data)
    self.CMD = data.cmd
    self.Desc = data.desc
    self.HasInput = data.has_input
    self.DefaultInput = data.default_input
end

-- GM命令列表
GmCmdListClass = Class()
GmCmdListClass.Tab = ""
GmCmdListClass.CMD = { }
-- 更新
function GmCmdListClass:updateInfo(data)
    self.Tab = data.tab

    for k, v in ipairs(data.cmd) do
        local order = GmCmdClass()
        order:updateInfo(v)
        table.insert(self.CMD, order)
    end
end
-- *********************************************************************
-- 国家相关 (Author:Garden)
-- *********************************************************************
-- 国家
DefaultCountryClass = Class()
DefaultCountryClass.Id = 0      -- 国家id
DefaultCountryClass.Name = ""   -- 国家名字

function DefaultCountryClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
end
-- *********************************************************************
-- 联盟相关 (Author:Garden)
-- *********************************************************************
-- 联盟目标
GuildTargetClass = Class()
GuildTargetClass.Id = 0
GuildTargetClass.Name = ""
GuildTargetClass.Desc = ""
GuildTargetClass.TargetType = GuildTargetType.InvalidGuildTargetType
-- （1）	有1名玩家升级到副盟主（仅NPC联盟有），通过 target 去找 GuildClassLevelProto
-- （2）	由玩家弹劾NPC盟主（仅NPC联盟有）
-- （3）	联盟升级到x级, 通过 target 去找 GuildLevelProto
-- （4）	联盟成员达到n人
-- （5）	建立联盟雕像
-- （6）	加入一个国家（0.2版本不做）
GuildTargetClass.Target = 0

function GuildTargetClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Desc = data.desc
    self.TargetType = data.target_type
    self.Target = data.target
end

-- 联盟成员权限信息
GuildPermissionClass = Class()
GuildPermissionClass.InvateOther = false                    -- true表示允许邀请他人入盟
GuildPermissionClass.AgreeJoin = false                      -- true表示允许同意申请入盟
GuildPermissionClass.UpdateText = false                     -- true表示允许修改联盟宣言
GuildPermissionClass.UpdateInternalText = false             -- true表示允许修改联盟公告
GuildPermissionClass.UpdateLabel = false                    -- true表示允许修改联盟标签
GuildPermissionClass.UpdateClassName = false                -- true表示允许修改阶级名称
GuildPermissionClass.UpdateFlagType = false                 -- true表示允许修改联盟旗帜
GuildPermissionClass.UpdateLowerMemberClassLevel = false    -- true表示允许修改低等级盟友的阶级（变成副帮主之类的）
GuildPermissionClass.UpdateLowerMemberClassTitle = false    -- true表示允许修改低等级盟友的职称
GuildPermissionClass.KickLowerMember = false                -- true表示允许踢人（低阶级盟友）
GuildPermissionClass.UpdateJoinCondition = false            -- true表示允许修改联盟入盟条件
GuildPermissionClass.ImpeachNPCLeader = false               -- true表示允许弹劾NPC盟主
GuildPermissionClass.VoteScore = 0                          -- 弹劾NPC盟主，这个职位的票数
GuildPermissionClass.UpgradeLevel = false                   -- true表示允许升级联盟等级
GuildPermissionClass.UpgradeLevelCdr = false                -- true表示允许加速联盟升级
GuildPermissionClass.UpgradeBuilding = false                -- true表示允许升级联盟建筑
GuildPermissionClass.UpgradeTechnology = false              -- true表示允许升级联盟科技
GuildPermissionClass.UpgradeFriendGuild = false             -- true表示允许修改友盟
GuildPermissionClass.UpgradeEnemyGuild = false              -- true表示允许修改敌盟

function GuildPermissionClass:updateInfo(data)
    self.InvateOther = data.invate_other
    self.AgreeJoin = data.agree_join
    self.UpdateText = data.update_text
    self.UpdateInternalText = data.update_internal_text
    self.UpdateLabel = data.update_label
    self.UpdateClassName = data.update_class_name
    self.UpdateFlagType = data.update_flag_type
    self.UpdateLowerMemberClassLevel = data.update_lower_member_class_level
    self.UpdateLowerMemberClassTitle = data.update_lower_member_class_title
    self.KickLowerMember = data.kick_lower_member
    self.UpdateJoinCondition = data.update_join_condition
    self.ImpeachNPCLeader = data.impeach_npc_leader
    self.VoteScore = data.vote_score
    self.UpgradeLevel = data.upgrade_level
    self.UpgradeLevelCdr = data.upgrade_level_cdr
    self.UpgradeBuilding = data.upgrade_building
    self.UpgradeTechnology = data.upgrade_technology
    self.UpgradeFriendGuild = data.update_friend_guild
    self.UpgradeEnemyGuild = data.update_enemy_guild
end

-- 联盟职位等级信息
GuildClassLevelClass = Class()
GuildClassLevelClass.Level = 0          -- 阶级等级
GuildClassLevelClass.Name = ""          -- 阶级名字
GuildClassLevelClass.Count = 0          -- 阶级最大成员数（比如说副帮主有几个,0表示不限人数）
GuildClassLevelClass.Permission = nil   -- 权限
GuildClassLevelClass.VoteScore = 0      -- 弹劾NPC盟主，这个职位的票数

function GuildClassLevelClass:init()
    self.Permission = GuildPermissionClass()
end

function GuildClassLevelClass:updateInfo(data)
    self.Level = data.level
    self.Name = data.name
    self.Count = data.count
    self.Permission:updateInfo(data.permission)
    self.VoteScore = data.vote_score
end

-- 联盟捐献
GuildDonateClass = Class()
GuildDonateClass.Sequence = 0               -- 序号，从1开始，1表示第一个捐献项目
GuildDonateClass.Times = 0                  -- 捐献次数，从1开始，1表示第一次捐献数据
GuildDonateClass.Cost = nil                 -- 捐献消耗
GuildDonateClass.GuildBuildingAmount = 0    -- 给联盟加多少建设值
GuildDonateClass.ContributionAmount = 0     -- 给自己加多少贡献值
GuildDonateClass.DonationAmount = 0         -- 给自己加多少捐献值
GuildDonateClass.ContributionCoin = 0       -- 给自己加多少贡献币

function GuildDonateClass:init()
    self.Cost = CostClass()
end

function GuildDonateClass:updateInfo(data)
    self.Sequence = data.sequence
    self.Times = data.times
    self.Cost:updateInfo(data.cost)
    self.GuildBuildingAmount = data.guild_building_amount
    self.ContributionAmount = data.contribution_amount
    self.DonationAmount = data.donation_amount
    self.ContributionCoin = data.contribution_coin
end

-- 联盟等级信息
GuildLevelClass = Class()
GuildLevelClass.Level = 0               -- 联盟等级
GuildLevelClass.MemberCount = 0         -- 联盟最大成员数
GuildLevelClass.ClassMemberCount = { }  -- 联盟职位人数上限，第一个是1阶人数上限(比如说副帮主有几个，0表示不限)
GuildLevelClass.UpgradeBuilding = 0     -- 升级所需的建设值，1升2，读1级的数据
GuildLevelClass.UpgradeDuration = 0     -- 升级所需的时间，1升2，读1级数据

function GuildLevelClass:updateInfo(data)
    self.Level = data.level
    self.MemberCount = data.member_count

    for k, v in ipairs(data.class_member_count) do
        table.insert(self.ClassMemberCount, v)
    end

    self.UpgradeBuilding = data.upgrade_building
    self.UpgradeDuration = data.upgrade_duration
end

-- 联盟成员信息
GuildMemberClass = Class()
GuildMemberClass.Hero = nil                     -- 英雄数据
GuildMemberClass.ClassLevel = 0                 -- 职务位置，从0开始（最低职务）
GuildMemberClass.LastOfflineTime = 0            -- 最后一次离线时间，用于计算离线时间（0表示当前在线）
GuildMemberClass.ContributionAmount = 0         -- 今日贡献值
GuildMemberClass.ContributionTotalAmount = 0    -- 总贡献值
GuildMemberClass.ContributionAmount7 = 0        -- 7日贡献值
GuildMemberClass.DonationAmount = 0             -- 今日捐献值
GuildMemberClass.DonationTotalAmount = 0        -- 总捐献值
GuildMemberClass.DonationAmount7 = 0            -- 7日捐献值
GuildMemberClass.DonationTotalYuanBao = 0       -- 总捐献元宝数

function GuildMemberClass:init()
    self.Hero = HeroBasicSnapshotClass()
end

function GuildMemberClass:updateInfo(data)
    self.Hero:updateInfo(data.hero)
    self.ClassLevel = data.class_level
    self.LastOfflineTime = data.last_offline_time
    self.ContributionAmount = data.contribution_amount
    self.ContributionTotalAmount = data.contribution_total_amount
    self.ContributionAmount7 = data.contribution_amount7
    self.DonationAmount = data.donation_amount
    self.DonationTotalAmount = data.donation_total_amount
    self.DonationAmount7 = data.donation_amount7
    self.DonationTotalYuanBao = data.donation_total_yuanbao
end

-- 弹劾信息
GuildImpeachClass = Class()
GuildImpeachClass.ImpeachEndTime = 0    -- 弹劾结束时间，unix时间戳，0表示当前没有弹劾
GuildImpeachClass.Candidates = { }      -- 候选人
GuildImpeachClass.Points = { }          -- 每个人对应的得票数
GuildImpeachClass.VoteHeros = { }       -- 选民（不在这里的帮派成员，说明还未投票）
GuildImpeachClass.VoteTarget = { }      -- 选民投给谁

function GuildImpeachClass:updateInfo(data)
    self.ImpeachEndTime = data.impeach_end_time

    for k, v in ipairs(data.candidates) do
        table.insert(self.Candidates, v)
    end

    for k, v in ipairs(data.points) do
        table.insert(self.Points, v)
    end

    for k, v in ipairs(data.vote_heros) do
        table.insert(self.VoteHeros, v)
    end

    for k, v in ipairs(data.vote_target) do
        table.insert(self.VoteTarget, v)
    end
end

-- 联盟等级CD信息
GuildLevelCdrClass = Class()
GuildLevelCdrClass.Level = 0        -- 联盟等级
GuildLevelCdrClass.Times = 0        -- 加速次数
GuildLevelCdrClass.Cost = 0         -- 加速消耗的建设值
GuildLevelCdrClass.Cdr = 0          -- 减多少cd，秒

function GuildLevelCdrClass:updateInfo(data)
    self.Level = data.level
    self.Level = data.level
    self.Level = data.level
    self.Level = data.level
end

-- String 数组
StringArrayClass = Class()
StringArrayClass.V = { }

function StringArrayClass:updateInfo(data)
    self.V = { }

    for key, value in ipairs(data.v) do
        table.insert(self.V, value)
    end
end

-- 捐献记录
GuildDonateRecordClass = Class()
GuildDonateRecordClass.Name = ""        -- 捐献玩家的名字
GuildDonateRecordClass.Sequence = 0     -- 捐献的类型
GuildDonateRecordClass.Times = 0        -- 次数
GuildDonateRecordClass.DonateTime = 0   -- 时间

function GuildDonateRecordClass:updateInfo(data)
    self.Name = data.name
    self.Sequence = data.sequence
    self.Times = data.times
    self.DonateTime = data.donate_time
end

-- 联盟职称配置数据
GuildClassTitleDataClass = Class()
GuildClassTitleDataClass.Id = 0             -- 职称等级
GuildClassTitleDataClass.Name = ""          -- 职称名字
GuildClassTitleDataClass.Permission = nil   -- 权限

function GuildClassTitleDataClass:init()
    self.Permission = GuildPermissionClass()
end

function GuildClassTitleDataClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Permission:updateInfo(data.permission)
end

-- 联盟职称信息
GuildClassTitleClass = Class()
GuildClassTitleClass.SystemClassTitleId = { }       -- 系统职称id
GuildClassTitleClass.SystemClassTitleMemberId = { } -- 系统职称拥有者id
GuildClassTitleClass.CustomClassTitleName = { }     -- 自定义职称名字
GuildClassTitleClass.CustomClassTitleMemberId = { } -- 自定义职称拥有者id

function GuildClassTitleClass:updateInfo(data)
    self.SystemClassTitleId = { }

    for k, v in ipairs(data.system_class_title_id) do
        table.insert(self.SystemClassTitleId, v)
    end

    self.SystemClassTitleMemberId = { }

    for k, v in ipairs(data.system_class_title_member_id) do
        table.insert(self.SystemClassTitleMemberId, v)
    end

    self.CustomClassTitleName = { }

    for k, v in ipairs(data.custom_class_title_name) do
        table.insert(self.CustomClassTitleName, v)
    end

    self.CustomClassTitleMemberId = { }

    for k, v in ipairs(data.custom_class_title_member_id) do
        local data = StringArrayClass()
        data:updateInfo(v)
        table.insert(self.CustomClassTitleMemberId, data)
    end
end

-- 雕像
StatueClass = Class()
StatueClass.LeaderId = ""       -- 盟主id
StatueClass.LeaderName = ""     -- 盟主名字
StatueClass.RegionId = 0        -- 地区id
StatueClass.RegionName = ""     -- 地区名字

function StatueClass:updateInfo(data)
    self.LeaderId = data.leader_id
    self.LeaderName = data.leader_name
    self.RegionId = data.region_id
    self.RegionName = data.region_name
end

-- 联盟等级
LevelUpClass = Class()
LevelUpClass.Level = 0      -- 新的等级

function LevelUpClass:updateInfo(data)
    self.Level = data.level
end

-- 弹劾
ImpeachClass = Class()
ImpeachClass.OldLeaderId = ""       -- 旧的盟主id
ImpeachClass.OldLeaderName = ""     -- 旧的盟主名字
ImpeachClass.NewLeaderId = ""       -- 新的盟主id
ImpeachClass.NewLeaderName = ""     -- 新的盟主名字

function ImpeachClass:updateInfo(data)
    self.OldLeaderId = data.old_leader_id
    self.OldLeaderName = data.old_leader_name
    self.NewLeaderId = data.new_leader_id
    self.NewLeaderName = data.new_leader_name
end

-- 禅让
DemiseClass = Class()
DemiseClass.OldLeaderId = ""       -- 旧的盟主id
DemiseClass.OldLeaderName = ""     -- 旧的盟主名字
DemiseClass.NewLeaderId = ""       -- 新的盟主id
DemiseClass.NewLeaderName = ""     -- 新的盟主名字

function DemiseClass:updateInfo(data)
    self.OldLeaderId = data.old_leader_id
    self.OldLeaderName = data.old_leader_name
    self.NewLeaderId = data.new_leader_id
    self.NewLeaderName = data.new_leader_name
end

-- 联盟大事件
GuildBigEventClass = Class()
GuildBigEventClass.time = 0         -- 事件发生的时间
-- 下面的数据可能为空，客户端发现哪个数据不为空就显示哪个
GuildBigEventClass.Satue = nil      -- 雕像
GuildBigEventClass.LevelUp = nil    -- 升级
GuildBigEventClass.Impeach = nil    -- 弹劾
GuildBigEventClass.Demise = nil     -- 禅让

function GuildBigEventClass:init()
    self.Satue = StatueClass()
    self.LevelUp = LevelUpClass()
    self.Impeach = ImpeachClass()
    self.Demise = DemiseClass()
end

function GuildBigEventClass:updateInfo(data)
    self.Satue:updateInfo(data.statue)
    self.LevelUp:updateInfo(data.level_up)
    self.Impeach:updateInfo(data.impeach)
    self.Demise:updateInfo(data.demise)
end

-- 战斗动态信息
FightClass = Class()
FightClass.AttackerId = ""      -- 攻击方id
FightClass.AttackerName = ""      -- 攻击方名字
FightClass.AttackerHead = ""    -- 攻击方头像
FightClass.BeenAttackerId = ""  -- 被攻击方id
FightClass.BeenAttackerName = ""  -- 被攻击方名字
FightClass.BeenAttackerHead = ""  -- 被攻击方头像

function FightClass:updateInfo(data)
    self.AttackerId = data.attacker_id
    self.AttackerName = data.attacker_name
    self.AttackerHead = UIConfig.MonarchsIcon[data.attacker_head]
    self.BeenAttackerId = data.been_attacker_id
    self.BeenAttackerName = data.been_attacker_name
    self.BeenAttackerHead = UIConfig.MonarchsIcon[data.been_attacker_head]
end

-- 联盟加入信息
JoinClass = Class()
JoinClass.Id = ""       -- id
JoinClass.Name = ""     -- 名字
JoinClass.Head = ""     -- 头像

function JoinClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Head = UIConfig.MonarchsIcon[data.head]
end

-- 联盟动态
GuildDynamicClass = Class()
GuildDynamicClass.Time = 0          -- 动态发生的时间
-- 下面的数据可能为空，客户端发现哪个数据不为空就显示哪个
GuildDynamicClass.Attack = nil      -- 攻击，里面的进攻方是本盟的
GuildDynamicClass.BeenAttack = nil  -- 被攻击，里面的被进攻方是本盟的
GuildDynamicClass.Join = nil        -- 加入了

function GuildDynamicClass:init()
    self.Attack = FightClass()
    self.BeenAttack = FightClass()
    self.Join = JoinClass()
end

function GuildDynamicClass:updateInfo(data)
    self.Time = data.time
    self.Attack:updateInfo(data.attack)
    self.BeenAttack:updateInfo(data.been_attack)
    self.Join:updateInfo(data.join)
end

-- 联盟实例化信息--
GuildClass = Class()
GuildClass.Id = 0                       -- Id
GuildClass.Name = ""                    -- 名字   
GuildClass.FlagName = ""                -- 旗号
GuildClass.FlagType = 0                 -- 旗子类型
GuildClass.Level = 0                    -- 联盟等级
GuildClass.BuildingAmount = 0           -- 联盟建设值
GuildClass.UpgradeEndTime = 0           -- 升级结束时间（0表示当前没有在升级），unix时间戳，秒
GuildClass.CdrTimes = 0                 -- 联盟升级已加速次数
GuildClass.MemberCount = 0              -- 成员个数
GuildClass.Leader = nil                 -- 盟主
GuildClass.Text = ""                    -- 联盟宣言
GuildClass.InternalText = ""            -- 对内公告
GuildClass.Labels = { }                 -- 联盟标签
-- 入盟条件
GuildClass.RejectAutoJoin = false       -- false表示达到条件直接入盟，true表示需要申请才能加入
GuildClass.RequiredHeroLevel = 0        -- 君主等级
GuildClass.RequiredJunXianLevel = 0     -- 百战军衔等级
GuildClass.RequiredTowerMaxFloor = 0    -- 需要的最大千重楼的层数
-- 下面部分数据只有请求详细情况时候才有设值
GuildClass.ClassNames = { }             -- 阶级名字，从低级到高级
GuildClass.Members = { }                -- 帮派成员
GuildClass.KickMemberCount = 0          -- 踢人数，限制每日最多踢几个
GuildClass.ChangeLeaderId = ""          -- 禅让盟主id
GuildClass.ChangeLeaderTime = 0         -- 禅让盟主倒计时，unix时间戳，秒
GuildClass.NextChangeNameTime = 0       -- 下次改名时间
GuildClass.FreeChangeName = false       -- true表示允许免费改名
GuildClass.ImpeachLeader = nil          -- 弹劾盟主
GuildClass.InvateHero = { }             -- 邀请列表
GuildClass.RequestJoinHero = { }        -- 申请加入列表
GuildClass.ClassTitle = nil             -- 职称
GuildClass.PrestigeTarget = 0           -- 声望目标，客户端去 Config.default_country 里面去取
GuildClass.FriendGuildText = ""         -- 友盟公告
GuildClass.EnemyGuildText = ""          -- 敌盟公告
GuildClass.DonateRecords = { }          -- 捐献记录(GuildDonateRecordClass[])
GuildClass.BigEvents = { }              -- 大事件(GuildBigEventClass[])
GuildClass.Dynamics = { }               -- 动态(GuildDynamicClass[])
GuildClass.GuildTargetId = 0            -- 当前联盟目标id，0表示没有

function GuildClass:init()
    self.Leader = GuildMemberClass()
    self.ImpeachLeader = GuildImpeachClass()
    self.ClassTitle = GuildClassTitleClass()
end

function GuildClass:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.FlagName = data.flagName
    self.FlagType = data.flagType
    self.Level = data.level
    self.BuildingAmount = data.building_amount
    self.UpgradeEndTime = data.upgrade_end_time
    self.CdrTimes = data.cdr_times
    self.MemberCount = data.member_count
    self.Leader:updateInfo(data.leader)
    self.Text = data.text
    self.InternalText = data.internal_text
    self.Labels = { }

    for k, v in ipairs(data.labels) do
        table.insert(self.Labels, v)
    end

    self.RejectAutoJoin = data.reject_auto_join
    self.RequiredHeroLevel = data.required_hero_level
    self.RequiredJunXianLevel = data.required_jun_xian_level
    self.RequiredTowerMaxFloor = data.required_tower_max_floor
    self.ClassNames = { }

    for k, v in ipairs(data.class_names) do
        table.insert(self.ClassNames, v)
    end

    self.Members = { }

    for k, v in ipairs(data.members) do
        local data = GuildMemberClass()
        data:updateInfo(v)
        table.insert(self.Members, data)
    end

    self.KickMemberCount = data.kick_member_count
    self.ChangeLeaderId = data.change_leader_id
    self.ChangeLeaderTime = data.change_leader_time
    self.NextChangeNameTime = data.next_change_name_time
    self.FreeChangeName = data.free_change_name
    self.ImpeachLeader:updateInfo(data.impeach_leader)
    self.InvateHero = { }

    for k, v in ipairs(data.invate_hero) do
        local data = HeroBasicSnapshotClass()
        data:updateInfo(v)
        table.insert(self.InvateHero, data)
    end

    self.RequestJoinHero = { }

    for k, v in ipairs(data.request_join_hero) do
        local data = HeroBasicSnapshotClass()
        data:updateInfo(v)
        table.insert(self.RequestJoinHero, data)
    end

    self.ClassTitle:updateInfo(data.class_title)
    self.PrestigeTarget = data.prestige_target
    self.FriendGuildText = data.friend_guild_text
    self.EnemyGuildText = data.enemy_guild_text
    self.DonateRecords = { }

    for k, v in ipairs(data.donate_records) do
        local info = GuildDonateRecordClass()
        info:updateInfo(v)
        table.insert(self.DonateRecords, info)
    end

    -- 按照捐献时间排序
    table.sort(self.DonateRecords, function(a, b) return a.Times > b.Times end)

    self.BigEvents = { }

    for k, v in ipairs(data.big_events) do
        local data = GuildBigEventClass()
        data:updateInfo(v)
        table.insert(self.BigEvents, data)
    end

    self.Dynamics = { }

    for k, v in ipairs(data.dynamics) do
        local data = GuildDynamicClass()
        data:updateInfo(v)
        table.insert(self.Dynamics, data)
    end

    self.GuildTargetId = data.guild_target_id
end

-- 别人离开盟会
function GuildClass:leaveGuildForOther(data)
    if data == nil then
        return
    end

    -- 是否为盟主
    if data.id == self.Leader.Id then
        self.Leader = nil
        -- 其他成员
    elseif self.Members ~= nil then
        if self.Members[data.id] ~= nil then
            self.Members[data.id] = nil
            self.MemberCount = self.MemberCount - 1
        end
    end
end
-- 新成员加入
function GuildClass:newMember(data)
    if data == nil then
        return
    end

    if self.Members ~= nil then
        if self.Members[data.id] == nil then
            self.Members[data.id] = GuildMemberClass()
        end
        self.Members[data.id]:updateInfo(data)
        self.MemberCount = self.MemberCount + 1
    end
end
-- 剔除某人
function GuildClass:kickOther(data)
    if data == nil then
        return
    end

    if self.Members ~= nil then
        if self.Members[data.id] ~= nil then
            self.Members[data.id] = nil
        end
    end
end
-- 更新其他玩家名字
function GuildClass:othersChangeName(data)
    if self.Members == nil then
        return
    end

    for k, v in ipairs(self.Members) do
        v.Name = data.name
    end
end

-- 每日限购的物品
HeroShopClass = Class()
HeroShopClass.DailyShopGoods = { }      -- 每日购买物品id
HeroShopClass.DailyBuyTimes = { }       -- 每日已购买次数次数，用于限购使用

function HeroShopClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.daily_shop_goods ~= nil then
        self.DailyShopGoods = { }

        for k, v in ipairs(data.daily_shop_goods) do
            table.insert(self.DailyShopGoods, v)
        end
    end

    if data.daily_buy_times ~= nil then
        self.DailyBuyTimes = { }

        for k, v in ipairs(data.daily_buy_times) do
            table.insert(self.DailyBuyTimes, v)
        end
    end
end

-- 解锁条件
UnlockConditionClass = Class()
UnlockConditionClass.RequireHeroLevel = 0       -- 需要君主等级
UnlockConditionClass.RequireBaseLevel = 0       -- 需要主城等级
UnlockConditionClass.RequireGuildLevel = 0      -- 需要联盟等级

function UnlockConditionClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.required_hero_level ~= nil then
        self.RequireHeroLevel = data.required_hero_level
    end

    if data.required_base_level ~= nil then
        self.RequireBaseLevel = data.required_base_level
    end

    if data.required_guild_level ~= nil then
        self.RequireGuildLevel = data.required_guild_level
    end
end

-- 兑换数据
ExchangeDataClass = Class()
ExchangeDataClass.Id = 0                -- id
ExchangeDataClass.Cost = nil            -- 扣一个东西
ExchangeDataClass.Prize = nil           -- 给一个东西

function ExchangeDataClass:init()
    self.Cost = CostClass()
    self.Prize = PrizeClass()
end

function ExchangeDataClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.id ~= nil then
        self.Id = data.id
    end

    if data.cost ~= nil then
        self.Cost:updateInfo(data.cost)
    end

    if data.prize ~= nil then
        self.Prize:updateInfo(data.prize)
    end
end

-- 商店物品
ShopGoodsClass = Class()
ShopGoodsClass.Id = 0                   -- 商品id
ShopGoodsClass.ExchangeData = nil       -- 兑换的物品（里面包含消耗Cost和获得内容Prize）
ShopGoodsClass.CountLimit = 0           -- 限购个数，0表示不限购
ShopGoodsClass.UnLockCondition = nil    -- 解锁条件
ShopGoodsClass.FirstTimesFree = false   -- 首次免费，第一次购买免费
-- 对应限购个数=1， 又是首次免费的商品，这种属于免费领取商品，这种物品买完第一次应该显示已领取
-- 其他的应该显示已售馨(有限购的)
function ShopGoodsClass:init()
    self.ExchangeData = ExchangeDataClass()
    self.UnLockCondition = UnlockConditionClass()
end

function ShopGoodsClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.id ~= nil then
        self.Id = data.id
    end

    if data.exchange_data ~= nil then
        self.ExchangeData:updateInfo(data.exchange_data)
    end

    if data.count_limit ~= nil then
        self.CountLimit = data.count_limit
    end

    if data.unlock_condition ~= nil then
        self.UnLockCondition:updateInfo(data.unlock_condition)
    end

    if data.first_times_free ~= nil then
        self.FirstTimesFree = data.first_times_free
    end
end

-- 商店
ShopClass = Class()
ShopClass.Type = 0      -- 商店类型, 1表示帮派商店
ShopClass.Goods = { }   -- 商品

function ShopClass:updateInfo(data)
    if data == nil then
        return
    end

    if data.type ~= nil then
        self.Type = data.type
    end

    if data.goods ~= nil then
        self.Goods = { }

        for k, v in ipairs(data.goods) do
            local goodsData = ShopGoodsClass()
            goodsData:updateInfo(v)
            table.insert(self.Goods, goodsData)
        end
    end
end

RegionLevelClass = Class()
RegionLevelClass.name = nil

function RegionLevelClass:updateInfo(data)
    if data == nil then
        return
    end
    if data.name ~= nil then
        self.name = data.name
    end
end

-- *********************************************************************
-- 百战相关
-- *********************************************************************
-- 百战信息
Pvp100CommonClass = Class()
-- 胜利加的积分
Pvp100CommonClass.WinPoint = 0
-- 失败加的积分
Pvp100CommonClass.FailPoint = 0
-- 恢复的次数
Pvp100CommonClass.RecoverTimes = { }
-- 最大挑战次数记录
Pvp100CommonClass.MaxChallengeRecord = 0
-- 排行榜的展示数量
Pvp100CommonClass.ShowRankCount = 0
-- 更新
function Pvp100CommonClass:updateInfo(data)
    self.WinPoint = data.win_point
    self.FailPoint = data.win_point
    self.MaxChallengeRecord = data.max_record
    self.ShowRankCount = data.show_rank_count

    self.RecoverTimes = { }
    for i = 1, #data.recover_times do
        self.RecoverTimes[data.recover_times_time[i]] = data.recover_times[i]
    end
end

-- 军衔等级等级信息
Pvp100RankLevelClass = Class()
-- 等级
Pvp100RankLevelClass.Level = 0
-- 军衔名字
Pvp100RankLevelClass.Name = 0
-- 军衔Icon
Pvp100RankLevelClass.Icon = ""
-- 等级上升的百分比，最后一级不需要读取该数据
Pvp100RankLevelClass.LevelUpPercent = 0
-- 等级上升的分数，最后一级不需要读取该数据
Pvp100RankLevelClass.LevelUpPoint = 0
-- 等级下降的百分比，第一级不需要读取该数据
Pvp100RankLevelClass.LevelDownPercent = 0
-- 等级上升的分数，第一级不需要读取该数据
Pvp100RankLevelClass.LevelDownPoint = 0
-- 每日俸禄
Pvp100RankLevelClass.DailaySalary = nil
-- 初始化
function Pvp100RankLevelClass:init()
    self.DailaySalary = PrizeClass()
end
-- 更新
function Pvp100RankLevelClass:updateInfo(data)
    self.Level = data.level
    self.Name = data.name
    self.LevelUpPercent = data.level_up_percent
    self.LevelUpPoint = data.level_up_point
    self.LevelDownPercent = data.level_down_percent
    self.LevelDownPoint = data.level_down_point

    self.DailaySalary:updateInfo(data.daily_salary)
end

-- 军衔等级奖励信息
Pvp100RankPrizeClass = Class()
-- id
Pvp100RankPrizeClass.Id = 0
-- 需要的军衔等级
Pvp100RankPrizeClass.RankLv = 0
-- 需要的积分
Pvp100RankPrizeClass.Point = 0
-- 达成奖励
Pvp100RankPrizeClass.Prize = nil
-- 初始化
function Pvp100RankPrizeClass:init()
    self.Prize = PrizeClass()
end
-- 更新
function Pvp100RankPrizeClass:updateInfo(data)
    self.Id = data.id
    self.RankLv = data.level
    self.Point = data.point
    self.Prize:updateInfo(data.prize)
end

-- 百战玩家积分
Pvp100PlayerPointClass = Class()
-- 基础信息
Pvp100PlayerPointClass.Basic = nil
-- 排名
Pvp100PlayerPointClass.Ranking = 0
-- 积分
Pvp100PlayerPointClass.Point = 0
-- 初始化
function Pvp100PlayerPointClass:init()
    self.Basic = HeroBasicClass()
end
-- 更新
function Pvp100PlayerPointClass:updateInfo(data)
    self.Basic:updateInfo(data.basic)
    self.Point = data.point
end

-- 百战军衔排行榜
Pvp100RankingListClass = Class()
-- 自己在其中
Pvp100RankingListClass.SelfInside = false
-- 军衔等级
Pvp100RankingListClass.RankLv = 0
-- 军衔配置
Pvp100RankingListClass.RankConfig = nil
-- 开始id
Pvp100RankingListClass.StartId = 0
-- 参战人数
Pvp100RankingListClass.TotalCount = 0
-- 是否应该刷新本层数据
Pvp100RankingListClass.Player = { }
-- 更新
function Pvp100RankingListClass:updateInfo(data)
    -- 开始位置
    local startRankId = data.start_rank
    local hadCount = #self.Player
    for k, v in ipairs(data.data) do
        local info = shared_pb.BaiZhanRankObjProto()
        info:ParseFromString(v)

        local player = self.Player[startRankId]
        if player == nil then
            player = Pvp100PlayerPointClass()
            self.Player[startRankId] = player
        end
        player:updateInfo(info)
        player.Ranking = startRankId

        startRankId = startRankId + 1
    end
    for i = startRankId, hadCount do
        self.Player[i] = nil
    end

    self.SelfInside = data.self
    self.StartId = data.start_rank
    self.TotalCount = data.total_rank_count
    self.RankLv = data.jun_xian_level
    self.RankConfig = Pvp100RankLevelConfig:getConfigByLevel(self.RankLv)
end
