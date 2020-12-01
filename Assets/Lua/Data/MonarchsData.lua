-- *********************************************************************
-- 君主信息
-- *********************************************************************

-- 君主实例化信息--
local MonarchsData = { }
-- 是否是主玩家
MonarchsData.IsMainPlayer = true
-- 账号
MonarchsData.Id = ""
-- 昵称-
MonarchsData.Name = ""
-- 国家--
MonarchsData.Country = ""    
-- 联盟Id--
MonarchsData.GuildId = 0
-- 联盟Name--
MonarchsData.Guild = ""
-- 联盟旗号--
MonarchsData.GuildFlagName = ""
-- 联盟贡献币
MonarchsData.ContributionCoin = 0
-- 联盟捐献次数
MonarchsData.GuildDonateTimes = { }
-- 头像--
MonarchsData.Head = nil
-- 大头像--
MonarchsData.BigHead = ""
-- 君主等级--
MonarchsData.Level = 0
-- 经验--
MonarchsData.Exp = 0
-- 性别--
MonarchsData.Male = false
-- 是否有曾用名
MonarchsData.HasOldName = false
-- 下次可以改名的时间，小于这个时间表示cd中
MonarchsData.NextChangeNameTime = 0
-- 战斗力--
MonarchsData.FightAmount = 0
-- 军衔--
MonarchsData.Rank = 0
-- 好友印象--
MonarchsData.Impression = nil
-- 成就徽章--
MonarchsData.Achievement = nil   
-- 个人签名--
MonarchsData.Signature = ""
-- Vip等级--
MonarchsData.VipLv = 0
-- Vip经验--
MonarchsData.VipExp = 0
-- 元宝--
MonarchsData.Money = 0
-- 等级配置
MonarchsData.LevelConfig = nil

-- 野外相关
-- 主城所在地图Id--
MonarchsData.BaseMapId = 0
-- 主城等级
MonarchsData.BaseLevel = 0
-- 主城坐标（六边形Odd-q排列）--
MonarchsData.BaseX = 0
MonarchsData.BaseY = 0
-- 主城繁荣度
MonarchsData.BaseProsperity = 0
-- 主城缓慢迁移坐标
MonarchsData.BaseMoveToX = 0
MonarchsData.BaseMoveToY = 0
-- 表示当前主城正在缓慢移动，到点就移
MonarchsData.BaseMoveTime = 0
-- 行营所在地图
MonarchsData.CampMap = 0
-- 行营等级
MonarchsData.CampLvl = 0
-- 行营坐标
MonarchsData.CampX = 0
MonarchsData.CampY = 0
-- 行营繁荣度
MonarchsData.CampProsperity = 0
-- 最大繁荣度
MonarchsData.CampProsperityMax = 0
-- 恢复所要时间
MonarchsData.CampRecoveryTime = 0
-- 迁城时间
MonarchsData.CampMoveTime = 0
-- 行营修复材料
MonarchsData.CampRepairAmount = 0
-- 行营修复材料总量
MonarchsData.CampRepairTotal = 0

-- 商店数据
MonarchsData.Shop = nil
-- 玩家限购道具信息,k:id v:已购买次数
MonarchsData.DailyPropInfo = { }

-- 老家防守队伍
MonarchsData.HomeDefenseTroopId = 0
-- 行营防守队伍
MonarchsData.TentDefenseTroopId = 0

-- 插白旗的联盟Id
MonarchsData.FlagGuildId = 0
-- 插白旗的联盟旗号
MonarchsData.FlagGuildFlagName = nil
-- 插白旗的消失时间
MonarchsData.FlagExpire = nil

-- 更新地图信息
function MonarchsData:updateMapInfo(mapId, mapLv, x, y)
    if mapId ~= nil then
        self.BaseMapId = mapId
    end
    if mapLv ~= nil then
        self.BaseLevel = mapLv
    end
    if x ~= nil then
        self.BaseX = x
    end
    if y ~= nil then
        self.BaseY = y
    end
end
-- 更新联盟信息(一般数据)
function MonarchsData:updateGuildInfo(id, name, flagName)
    self.GuildId = id
    self.Guild = name
    self.GuildFlagName = flagName
end
-- 更新君主信息
function MonarchsData:updateInfo(data)
    self.Id = data.id
    self.Name = data.name
    self.Country = ""
    self.GuildId = data.guild_id
    self.Guild = data.guild_name
    self.GuildFlagName = data.guild_flag_name
    self.Head = UIConfig.MonarchsIcon[data.head]
    self.BigHead = data.big_head
    self.Male = data.male
    self.HasOldName = data.has_old_name
    self.NextChangeNameTime = data.next_change_name_time
    self.FightAmount = data.fight_amount
    self.Level = data.level
    self.Exp = data.exp
    self.Rank = 0
    self.Impression = nil
    self.Achievement = nil
    self.Signature = ""
    self.VipLv = 0
    self.VipExp = 0
    self.Money = data.yuanbao
    self.LevelConfig = MonarchsConfig:getLevelConfigById(data.level)

    -- 更新联盟信息(其他数据)
    if data.contribution_coin ~= nil then
        self.ContributionCoin = data.contribution_coin
    end

    if data.guild_donate_times ~= nil then
        self.GuildDonateTimes = { }

        for k, v in ipairs(data.guild_donate_times) do
            table.insert(self.GuildDonateTimes, v)
        end
    end

    self.Shop = HeroShopClass()
    self.Shop:updateInfo(data.shop)

    for k, v in pairs(self.Shop.DailyShopGoods) do
        self.DailyPropInfo[v] = self.Shop.DailyBuyTimes[k]
    end
end

function MonarchsData:updateRegionAllBaseInfo(data)
    if data == nil then
        return
    end
    self.BaseMapId = data.home.base_region
    self.BaseLevel = data.home.base_level
    self.BaseX = data.home.base_x
    self.BaseY = data.home.base_y
    self.BaseMoveToX = data.move_base_x
    self.BaseMoveToY = data.move_base_y
    self.BaseMoveTime = data.move_time
        
    self.HomeDefenseTroopId = data.home_defense_troop_index
    self.TentDefenseTroopId = data.tent_defense_troop_index

    self:upateBaseProsperity(data.home.prosperity, nil)
    self:updateRegionCampPos(data.tent.base_region, data.tent.base_level, data.tent.base_x, data.tent.base_y)
    self:updateReigonCampProsperity(data.tent.prosperity, data.tent_prosperity_capcity)
    self:updateRegionCampTime(data.tent_full_time, data.tent_valid_time)
    self:updateRepairInfo(data.tent_repair_amount, data.tent_repair_amount_capcity)
    self:updateWhiteFlagInfo(data.white_flag_guild_id, data.white_flag_guild_flag_name, data.white_flag_disappear_time)

end

function MonarchsData:upateBaseProsperity(prosperity, prosperitMax)
    if prosperity ~= nil then
        self.BaseProsperity = prosperity
    end
end

function MonarchsData:updateRegionCampPos(mapId, lvl, x, y)
    if mapId ~= nil then
        self.CampMap = mapId
    end
    if lvl ~= nil then
        self.CampLvl = lvl
    end
    if x ~= nil then
        self.CampX = x
    end
    if y ~= nil then
        self.CampY = y
    end
end

function MonarchsData:updateReigonCampProsperity(prosperity, prosperitMax)
    if prosperity ~= nil then
        self.CampProsperity = prosperity
    end
    if prosperitMax ~= nil then
        self.CampProsperityMax = prosperitMax
    end
end

function MonarchsData:updateRegionCampTime(recTime, moveTime)
    if recTime ~= nil then
        self.CampRecoveryTime = recTime
    end
    if moveTime ~= nil then
        self.CampMoveTime = moveTime
    end
end

function MonarchsData:updateRepairInfo(repairAmount, repairTotal)
    if repairAmount ~= nil then
        self.CampRepairAmount = repairAmount
    end
    if repairTotal ~= nil then
        self.CampRepairTotal = repairTotal
    end
end

function MonarchsData:updateWhiteFlagInfo(flagGuilId, flagGuildFlagName, flagExpire)
    if flagGuilId ~= nil then
        self.FlagGuildId = flagGuilId
    end
    if flagGuildFlagName ~= nil then
        self.FlagGuildFlagName = flagGuildFlagName
    end
    if flagExpire ~= nil then
        self.FlagExpire = flagExpire
    end
end

function MonarchsData:clear()
    self.Id = ""
    self.Name = ""
    self.Country = ""
    self.GuildId = 0
    self.Guild = ""
    self.GuildFlagName = ""
    self.ContributionCoin = 0
    self.GuildDonateTimes = { }
    self.Head = nil
    self.BigHead = ""
    self.Male = false
    self.HasOldName = false
    self.FightAmount = 0
    self.Level = 0
    self.Exp = 0
    self.Rank = 0
    self.Impression = nil
    self.Achievement = nil
    self.Signature = ""
    self.VipLv = 0
    self.VipExp = 0
    self.Money = 0
    self.BaseMapId = 0
    self.BaseLevel = 0
    self.BaseX = 0
    self.BaseY = 0
    self.LevelConfig = nil
    self.Shop = nil

    self.BaseProsperity = 0
    self.BaseMoveToX = 0
    self.BaseMoveToY = 0
    self.BaseMoveTime = 0
    self.CampMap = 0
    self.CampLvl = 0
    self.CampX = 0
    self.CampY = 0
    self.CampProsperity = 0
    self.CampProsperityMax = 0
    self.CampRecoveryTime = 0
    self.CampMoveTime = 0
    self.CampRepairAmount = 0
    self.CampRepairTotal = 0

    self.FlagGuildId = 0
    self.FlagGuildFlagName = nil
    self.FlagExpire = nil

end

-- *********************************************************************
-- 君主相关协议
-- *********************************************************************

-- 君主经验更新
-- moduleId = 2, msgId = 22
-- exp: int // 经验
local function S2CHeroUpdateExpProto(data)
    MonarchsData.Exp = data.exp

    Event.dispatch(Event.PLAYER_INFO_UPDATE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_HERO_UPDATE_EXP, S2CHeroUpdateExpProto)

-- 君主等级提升
-- moduleId = 2, msgId = 21
-- exp: int // 经验
-- level: int // 君主新等级
local function S2CHeroUpgradeLevelProto(data)
    MonarchsData.Exp = data.exp
    MonarchsData.Level = data.level
    MonarchsData.LevelConfig = MonarchsConfig:getLevelConfigById(data.level)

    Event.dispatch(Event.PLAYER_INFO_UPDATE)
    UIManager.openController(UIManager.ControllerName.MonarchOrMainCityUpgrade, 0)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_HERO_UPGRADE_LEVEL, S2CHeroUpgradeLevelProto)

-- 君主改名ACK
-- config.MiscConfig.ChangeHeroNameCost 改名消耗
-- heroProto.next_change_name_time 下次可以改名的时间，小于这个时间表示cd中
-- name: string // 新名字
-- next_change_name_time: int32 // 下次可以改名的时间
local function S2CChangeHeroNameProto(data)
    MonarchsData.Name = data.name
    -- 曾用名状态设置
    MonarchsData.HasOldName = true
    -- 获取曾用名列表
    NetworkManager.C2SListOldNameProto(MonarchsData.Id)
    local time = data.next_change_name_time

    MonarchsData.NextChangeNameTime = time
    Event.dispatch(Event.CHANGE_NAME_SUCCESS)
    Event.dispatch(Event.PLAYER_INFO_UPDATE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_CHANGE_HERO_NAME, S2CChangeHeroNameProto)

-- 改名失败
-- moduleId = 2, msgId = 32
local function S2CFailChangeHeroNameProto(code)
    UIManager.showNetworkErrorTip(domestic_decoder.ModuleID, domestic_decoder.S2C_FAIL_CHANGE_HERO_NAME, code)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_FAIL_CHANGE_HERO_NAME, S2CFailChangeHeroNameProto)

-- 更新君主战斗力
-- fight_amount: int // 君主防守战力
local function S2CUpdateHeroFightAmount(data)
    -- 更新君主战斗力
    MonarchsData.FightAmount = data.fight_amount

    Event.dispatch(Event.MONARCHS_UPDATE_HERO_FIGHT_AMOUNT)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPDATE_HERO_FIGHT_AMOUNT, S2CUpdateHeroFightAmount)

-- 更新元宝
-- yuanbao: int // 最新的元宝数
local function S2CUpdateYuanBao(data)
    MonarchsData.Money = data.yuanbao

    Event.dispatch(Event.YUANBAO_UPDATE)
end
domestic_decoder.RegisterAction(domestic_decoder.S2C_UPDATE_YUANBAO, S2CUpdateYuanBao)


-- 更新防御阵容--
-- troop_index: int // 0表示撤防，1表示1队 2表示2队
-- is_tent: bool // true表示行营防守武将，否则表示主城防守武将
local function S2CSetDefenseTroopProto(data)
    if data.is_tent then
        MonarchsData.TentDefenseTroopId = data.troop_index
    else
        MonarchsData.HomeDefenseTroopId = data.troop_index
    end
    Event.dispatch(Event.WALL_DEFENSE_GARRISON_CHANGE, MonarchsData.Id)
end
military_decoder.RegisterAction(military_decoder.S2C_SET_DEFENSE_TROOP, S2CSetDefenseTroopProto)

-- 更新防御阵容--
local function S2CFailSetDefenseTroopProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_SET_DEFENSE_TROOP, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_SET_DEFENSE_TROOP, S2CFailSetDefenseTroopProto)

return MonarchsData