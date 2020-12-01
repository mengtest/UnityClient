-- *********************************************************************
-- 军政信息
-- *********************************************************************


-- 军政信息--
local MilitaryAffairsData = { }
-- 处于战斗状态
MilitaryAffairsData.IsBattleState = false
-- 拥有的武将
MilitaryAffairsData.Captains = { }
-- 将魂附身状态(将魂id与附身武将id的map,如果没有，则为nil)
MilitaryAffairsData.CaptainSoulAttachedInfo = { }
-- 武将寻访时间（用于计算当前可寻访次数）
MilitaryAffairsData.CaptainGenTime = 0
-- 寻访到的武将
MilitaryAffairsData.SeekedCaptainList = { }
-- 武将编队
-- 目前可以设置3个编队，每个编队5人
MilitaryAffairsData.Troops = { }
-- 编队个数
MilitaryAffairsData.TroopsCount = 3
-- 队伍武将个数
MilitaryAffairsData.TroopsCaptainsCount = 5

-- 士兵等级
MilitaryAffairsData.SoldierLevel = 0
-- 士兵最大容量
MilitaryAffairsData.SoldierCapacity = 0
-- 空闲士兵数量
MilitaryAffairsData.FreeSoldier = 0
-- 伤兵数量
MilitaryAffairsData.WoundedSoldier = 0
-- 伤兵最大容量
MilitaryAffairsData.WoundedSoldierCapacity = 0

-- 当前新兵数量
MilitaryAffairsData.NewSoldier = 0
-- 新兵增长计时器
local newSoldierTimer = nil
-- 新兵最大容量
MilitaryAffairsData.NewSoldierCapacity = 0
-- 新兵产量，每小时
MilitaryAffairsData.NewSoldierOutput = 0

-- 训练位
MilitaryAffairsData.Training = { }
-- 武将个数受君主等级影响
MilitaryAffairsData.CaptainsCountByMonarchLv =
{
    { Level = 6, Count = 6 },
    { Level = 11, Count = 7 },
    { Level = 16, Count = 8 },
    { Level = 21, Count = 9 },
    { Level = 26, Count = 10 },
    { Level = 31, Count = 11 },
    { Level = 36, Count = 12 },
    { Level = 41, Count = 13 },
    { Level = 46, Count = 14 },
    { Level = 51, Count = 15 },
    { Level = 999, Count = 15 },
}

-- 更新军政信息--
function MilitaryAffairsData:updateInfo(data)
    -- 拥有的武将
    if data.captains ~= nil then
        self.CaptainSoulAttachedInfo = { }
        for k, v in ipairs(data.captains) do
            print("拥有武将！", v.id)
            if self.Captains[v.id] == nil then
                self.Captains[v.id] = HeroCaptainClass()
            end
            -- 按武将编号更新
            self.Captains[v.id]:updateInfo(v)
            -- 添加将魂索引附身武将
            if self.Captains[v.id].AttachedCaptainSoulId ~= 0 then
                self.CaptainSoulAttachedInfo[self.Captains[v.id].AttachedCaptainSoulId] = v.id
            end
        end
    end

    self.CaptainGenTime = data.captain_gen_time

    if data.seeker ~= nil then
        for k, v in ipairs(data.seeker) do
            if self.SeekedCaptainList[v.index] == nil then
                self.SeekedCaptainList[v.index] = CaptainSeekerClass()
            end

            self.SeekedCaptainList[v.index]:updateInfo(v)
        end
    end
    -- 编队信息
    self.Troops = { }
    for k, v in ipairs(data.troops) do
        local troop = HeroTroopClass()
        troop:updateInfo(v)

        self.Troops[troop.TroopId] = troop
    end

    self.SoldierLevel = data.soldier_level
    self.SoldierCapacity = data.soldier_capcity
    self.FreeSoldier = data.free_soldier
    self.WoundedSoldier = data.wounded_soldier
    self.WoundedSoldierCapacity = data.wounded_soldier_capcity
    self.NewSoldier = data.new_soldier
    self.NewSoldierCapacity = data.new_soldier_capcity
    self.NewSoldierOutput = data.new_soldier_output

    -- 新兵计时器
    local function TimerComplete()
        self.NewSoldier = self.NewSoldier + self.NewSoldierOutput / 3600

        if self.NewSoldier >= self.NewSoldierCapacity then
            self.NewSoldier = self.NewSoldierCapacity
        end
    end

    if newSoldierTimer == nil then
        newSoldierTimer = TimerManager.newTimer(1, true, true, nil, nil, TimerComplete)
    end

    newSoldierTimer:start()

    -- 训练位
    for k, v in ipairs(data.training) do
        print("拥有修炼位", v, type(v.id), v.id)
        self.Training[v.id] = HeroTrainingClass()
        self.Training[v.id]:updateInfo(v)
    end
end

function MilitaryAffairsData:clear()
    self.Captains = { }
    MilitaryAffairsData.CaptainSoulAttachedInfo = { }
    self.CaptainGenTime = 0
    self.SeekedCaptainList = { }

    self.SoldierLevel = 0
    self.SoldierCapacity = 0
    self.FreeSoldier = 0
    self.WoundedSoldier = 0
    self.WoundedSoldierCapacity = 0

    self.NewSoldier = 0
    self.NewSoldierCapacity = 0
    self.NewSoldierOutput = 0
end

-- 获取空闲武将个数
function MilitaryAffairsData:getIdleCaptainCount()
    local len = 0
    for k, v in pairs(MilitaryAffairsData.Captains) do
        if not v.OutSide then
            len = len + 1
        end
    end
    return len
end

-- 更新武将将魂数据
-- captain: int // 武将id
-- up_soul_id: int // 附身的将魂id(0表示将附身的将魂取下来了，非0表示附身了新的将魂，如果是非0且此前有附身的将魂的话，处理此前的将魂没有附身任何武将)
function MilitaryAffairsData:updataCaptainSoul(captainId, soulId)
    if soulId == 0 then
        -- 卸下将魂
        self.CaptainSoulAttachedInfo[self.Captains[captainId].AttachedCaptainSoulId] = nil
        self.Captains[captainId].AttachedCaptainSoulId = 0
    else
        -- 装载将魂
        self.CaptainSoulAttachedInfo[soulId] = captainId
        self.Captains[captainId].AttachedCaptainSoulId = soulId
    end
end

-- *********************************************************************
-- 军政相关协议
-- *********************************************************************

-- 空闲士兵更新
-- moduleId = 4, msgId = 80
-- free_soldier: int // 空闲士兵
local function S2CUpdateFreeSoldierProto(data)
    MilitaryAffairsData.FreeSoldier = data.free_soldier
end
military_decoder.RegisterAction(military_decoder.S2C_UPDATE_FREE_SOLDIER, S2CUpdateFreeSoldierProto)

-- 士兵更新
-- 升级兵营或者科技导致变化时收到此消息
-- moduleId = 4, msgId = 1
-- soldier_capcity: int // 士兵最大容量
-- wounded_soldier_capcity: int // 伤兵最大容量
-- new_soldier_capcity: int // 新兵最大容量
-- new_soldier_output: int // 新兵产量，每小时
local function S2CUpdateSoldierCapcityProto(data)
    print("士兵更新！！")
    MilitaryAffairsData.SoldierCapacity = data.soldier_capcity
    MilitaryAffairsData.WoundedSoldierCapacity = data.wounded_soldier_capcity
    MilitaryAffairsData.NewSoldierCapacity = data.new_soldier_capcity
    MilitaryAffairsData.NewSoldierOutput = data.new_soldier_output

    Event.dispatch(Event.SOLDIER_INFO_UPDATE)
end
military_decoder.RegisterAction(military_decoder.S2C_UPDATE_SOLDIER_CAPCITY, S2CUpdateSoldierCapcityProto)

-- *********************************************************************

-- 招募新兵(4,3)
-- new_soldier: int // 新兵数量
-- free_soldier: int // 空闲士兵数量
local function S2CRecruitSoldierProto(data)
    print("招募士兵！！", data.count, MilitaryAffairsData.NewSoldier)
    MilitaryAffairsData.NewSoldier = data.new_soldier
    MilitaryAffairsData.FreeSoldier = data.free_soldier

    Event.dispatch(Event.BARRACK_RECRUIT_SOLDIER_SUCCESS)
end
military_decoder.RegisterAction(military_decoder.S2C_RECRUIT_SOLDIER, S2CRecruitSoldierProto)

-- 招募新兵失败--moduleId = 4, msgId = 4
local function S2CFailRecruitSoldierProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_RECRUIT_SOLDIER, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_RECRUIT_SOLDIER, S2CFailRecruitSoldierProto)

-- *********************************************************************

-- 增加伤兵，服务器主动推送--moduleId = 4, msgId = 5
-- toAdd: int
-- total: int
local function S2CAddWoundedSoldierProto(data)
    MilitaryAffairsData.WoundedSoldier = data.total
end
military_decoder.RegisterAction(military_decoder.S2C_ADD_WOUNDED_SOLDIER, S2CAddWoundedSoldierProto)

-- *********************************************************************

-- 治疗伤兵--moduleId = 4, msgId = 7
-- count: int // 治疗数量，空闲士兵 += count 伤兵数量 -= count
local function S2CHealWoundedSoldierProto(data)
    print("治疗伤兵！！", data.count)
    MilitaryAffairsData.FreeSoldier = MilitaryAffairsData.FreeSoldier + data.count
    MilitaryAffairsData.WoundedSoldier = MilitaryAffairsData.WoundedSoldier - data.count

    Event.dispatch(Event.BARRACK_HEAL_SOLDIER_SUCCESS)
end
military_decoder.RegisterAction(military_decoder.S2C_HEAL_WOUNDED_SOLDIER, S2CHealWoundedSoldierProto)

-- 治疗伤兵失败--moduleId = 4, msgId = 8
-- fail_code- 1: 伤兵数量没这么多
-- fail_code- 2: 超出最大士兵上限
-- fail_code- 3: 消耗资源不足
local function S2CFailHealWoundedSoldierProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_HEAL_WOUNDED_SOLDIER, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_HEAL_WOUNDED_SOLDIER, S2CFailHealWoundedSoldierProto)

-- *********************************************************************

-- 武将补兵--moduleId = 4, msgId = 10
-- id: int // 武将id
-- soldier: int // 总兵数
-- fight_amount: int // 战斗力
-- free_soldier: int // 剩余空闲士兵数
local function S2CCaptainChangeSoldierProto(data)
    print("武将补兵！！ 武将Id:" .. data.id .. " 士兵个数：" .. data.soldier)
    local captain = MilitaryAffairsData.Captains[data.id]
    captain.Soldier = data.soldier
    captain.FightAmount = data.fight_amount

    MilitaryAffairsData.FreeSoldier = data.free_soldier
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_CHANGE_SOLDIER, S2CCaptainChangeSoldierProto)

-- 武将补兵失败--moduleId = 4, msgId = 14
local function S2CFailCaptainChangeSoldierProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CAPTAIN_CHANGE_SOLDIER, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CAPTAIN_CHANGE_SOLDIER, S2CFailCaptainChangeSoldierProto)

-- 武将一键补兵--moduleId = 4, msgId = 67
-- id: int // 武将id
-- soldier: int // 总兵数
-- fight_amount: int // 战斗力
-- free_soldier: int // 剩余空闲士兵数
local function S2CCaptainFullSoldierProto(data)
    print("武将一键补兵回复！！！")
    local len = #data.id
    for i = 1, len, 1 do
        local captain = MilitaryAffairsData.Captains[data.id[i]]
        captain.Soldier = data.soldier[i]
        captain.FightAmount = data.fight_amount[i]

    end
    MilitaryAffairsData.FreeSoldier = data.free_soldier

    Event.dispatch(Event.TROOP_ADD_SOLIDER_SUCCEED, DataTrunk.PlayerInfo.MonarchsData.Id)
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_FULL_SOLDIER, S2CCaptainFullSoldierProto)

-- 武将一键补兵失败--moduleId = 4, msgId = 68
-- captain_not_exist: 武将Id不存在
-- duplicate: 武将id重复
-- empty_soldier: 没有空闲士兵
-- server_busy: 服务器忙，请稍后再试
local function S2CFailCaptainFullSoldierProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CAPTAIN_FULL_SOLDIER, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CAPTAIN_FULL_SOLDIER, S2CFailCaptainFullSoldierProto)

-- *********************************************************************

-- 武将数据更新，如战斗损兵，武将升级等等会触发--moduleId = 4, msgId = 11
-- id: int // 武将id
-- soldier: int // 当前带兵数
-- max_soldier: int // 总带兵数
-- fight_amount: int // 战斗力
local function S2CCaptainChangeDataProto(data)
    local captain = MilitaryAffairsData.Captains[data.id]
    captain.Soldier = data.soldier
    captain.MaxSoldier = data.max_soldier
    captain.FightAmount = data.fight_amount
    MilitaryAffairsData.Captains[data.id] = captain
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_CHANGE_DATA, S2CCaptainChangeDataProto)

-- *********************************************************************

-- 升级士兵等级--moduleId = 4, msgId = 16
-- level: int // 最新士兵等级
local function S2CUpgradeSoldierLevelProto(data)
    MilitaryAffairsData.SoldierLevel = data.level

    Event.dispatch(Event.BARRACK_UPGRADE_SOLDIER_SUCCESS)
end
military_decoder.RegisterAction(military_decoder.S2C_UPGRADE_SOLDIER_LEVEL, S2CUpgradeSoldierLevelProto)

-- 升级士兵等级失败--moduleId = 4, msgId = 17
local function S2CFailUpgradeSoldierLevelProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_UPGRADE_SOLDIER_LEVEL, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_UPGRADE_SOLDIER_LEVEL, S2CFailUpgradeSoldierLevelProto)

-- *********************************************************************

-- 武将寻访--moduleId = 4, msgId = 21
-- captains: bytes[] // shared_proto.CaptainSeekerProto
-- gen_time: int // 寻访时间，根据这个时间更新寻访列表
local function S2CSeekCaptainProto(data)
    for k, v in ipairs(data.captains) do
        local captain = shared_pb.CaptainSeekerProto()
        captain:ParseFromString(v)
        if MilitaryAffairsData.SeekedCaptainList[captain.index] == nil then
            MilitaryAffairsData.SeekedCaptainList[captain.index] = CaptainSeekerClass()
        end
        MilitaryAffairsData.SeekedCaptainList[captain.index]:updateInfo(captain)
    end

    MilitaryAffairsData.CaptainGenTime = data.gen_time

    Event.dispatch(Event.SEEK_CAPTAIN_UPDATE)
end
military_decoder.RegisterAction(military_decoder.S2C_SEEK_CAPTAIN, S2CSeekCaptainProto)

-- 武将寻访失败--moduleId = 4, msgId = 33
local function S2CFailSeekCaptainProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_SEEK_CAPTAIN, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_SEEK_CAPTAIN, S2CFailSeekCaptainProto)
-- *********************************************************************
-- 招募寻访武将--moduleId = 4, msgId = 23
-- index: int // 客户端将寻访武将列表中这个index的移除
-- captain: bytes // shared_proto.HeroCaptainProto
-- captain_index: int // 武将默认编队序号，从1开始（这里跟别的地方不太一样，从1开始，0表示不加入武将编队）
local function S2CRecruitCaptainProto(data)
    -- 从寻访到的列表中移除
    MilitaryAffairsData.SeekedCaptainList[data.index] = nill

    -- 加入已有武将列表
    local heroCaptain = shared_pb.HeroCaptainProto()
    heroCaptain:ParseFromString(data.captain)
    if MilitaryAffairsData.Captains[heroCaptain.id] == nil then
        MilitaryAffairsData.Captains[heroCaptain.id] = HeroCaptainClass()
    end
    -- 按武将编号更新
    MilitaryAffairsData.Captains[heroCaptain.id]:updateInfo(heroCaptain)
    -- 更新武将库
    Event.dispatch(Event.GENERAL_UPDATE)

    -- 加入武将编队序号
    if data.captain_index > 0 then
        local troopId = math.floor((data.captain_index - 1) / MilitaryAffairsData.TroopsCaptainsCount)
        local posId = data.captain_index - troopId * MilitaryAffairsData.TroopsCaptainsCount
        MilitaryAffairsData.Troops[troopId + 1].Captains[posId] = heroCaptain.id
    end
    print("招募成功!!!", data.index)
    Event.dispatch(Event.RECRUIT_CAPTAIN_SUCCESS, data.index)
end
military_decoder.RegisterAction(military_decoder.S2C_RECRUIT_CAPTAIN, S2CRecruitCaptainProto)

-- 招募寻访武将失败--moduleId = 4, msgId = 36
local function S2CFailRecruitCaptainProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_RECRUIT_CAPTAIN, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_RECRUIT_CAPTAIN, S2CFailRecruitCaptainProto)

-- 将寻访武将转换成强化符--moduleId = 4, msgId = 35
-- count: int // 强化符个数
local function S2CSellSeekCaptainProto(data)
    -- 清空寻访到的列表
    MilitaryAffairsData.SeekedCaptainList = { }

    Event.dispatch(Event.SELL_SEEK_CAPTAIN_SUCCESS)
end
military_decoder.RegisterAction(military_decoder.S2C_SELL_SEEK_CAPTAIN, S2CSellSeekCaptainProto)

-- 将寻访武将转换成强化符失败--moduleId = 4, msgId = 37
local function S2CFailSellSeekCaptainProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_SELL_SEEK_CAPTAIN, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_SELL_SEEK_CAPTAIN, S2CFailSellSeekCaptainProto)

-- *********************************************************************
-- 布阵--moduleId = 4, msgId = 46
-- 序号，0表示全改 一队发1，二队发2，3队发3
-- index: int // 序号，从0开始
-- id: int // 数组，武将id，0表示移除这个位置的武将
local function S2CSetMultiCaptainIndexProto(data)
    if data.index ~= 0 then
        MilitaryAffairsData.Troops[data.index]:updateCaptainsId(data.id)
    else
        for i = 1, #MilitaryAffairsData.Troops do
            local troop = { }
            -- 每支队伍五个武将
            for m = 1, MilitaryAffairsData.TroopsCaptainsCount do
                troop[m] = data.id[(i - 1) * MilitaryAffairsData.TroopsCaptainsCount + m]
            end
            -- 更新武将
            MilitaryAffairsData.Troops[i]:updateCaptainsId(troop)
        end
    end
    Event.dispatch(Event.TROOP_SYNC_ACK)
end
military_decoder.RegisterAction(military_decoder.S2C_SET_MULTI_CAPTAIN_INDEX, S2CSetMultiCaptainIndexProto)

-- 布阵失败--moduleId = 4, msgId = 47
-- invalid_index: 无效的序号
-- invalid_id: 无效的武将id
-- other_index: 武将已经在别的编队中
local function S2CFailSetMultiCaptainIndexProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_SET_MULTI_CAPTAIN_INDEX, code)
    Event.dispatch(Event.TROOP_SYNC_FAILURE)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_SET_MULTI_CAPTAIN_INDEX, S2CFailSetMultiCaptainIndexProto)

-- *********************************************************************
-- 武将解雇--moduleId = 4, msgId = 39
-- id: int // 解雇武将id（客户端同时将防守阵容和武将编队里面这个武将移除）
local function S2CFireCaptainProto(data)
    -- 从武将列表中移除此武将
    MilitaryAffairsData.Captains[data.id] = nil

    -- 从武将编队里移除此武将
    for i = 1, #MilitaryAffairsData.Troops do
        for m = 1, #MilitaryAffairsData.Troops[i].Captains do
            if MilitaryAffairsData.Troops[i].Captains[m] == data.id then
                MilitaryAffairsData.Troops[i].Captains[m] = 0
            end
        end
    end

    Event.dispatch(Event.GENERAL_UPDATE)
end
military_decoder.RegisterAction(military_decoder.S2C_FIRE_CAPTAIN, S2CFireCaptainProto)

-- 武将解雇失败--moduleId = 4, msgId = 40
local function S2CFailFireCaptainProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_FIRE_CAPTAIN, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_FIRE_CAPTAIN, S2CFailFireCaptainProto)

local function S2CCaptainRefinedProto(data)
    print("武将强化成功", data)
    MilitaryAffairsData.Captains[data.captain].AbilityExp = data.exp

    Event.dispatch(Event.GENERAL_INTENSIFY_SUCCESS, data.captain)
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_REFINED, S2CCaptainRefinedProto)

-- 武将强化失败--moduleId = 4, msgId = 50
local function S2CFailCaptainRefinedProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CAPTAIN_REFINED, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CAPTAIN_REFINED, S2CCaptainRefinedProto)
-- *********************************************************************
-- 武将强化更新--moduleId = 4, msgId = 51
-- captain: int // 武将id
-- exp: int // 更新后的强化经验
-- ability: int // 更新后的能力值
-- name: string // 更新后的武将名字
local function S2CCaptainRefinedUpgradeProto(data)
    print("武将强化升级", data)
    local generalData = MilitaryAffairsData.Captains[data.captain]
    generalData.AbilityExp = data.exp
    generalData.Ability = data.ability
    generalData.Name = data.name
    generalData.Quality = data.quality
    Event.dispatch(Event.GENERAL_INTENSIFY_UPGRADE, data.captain)
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_REFINED_UPGRADE, S2CCaptainRefinedUpgradeProto)

-- 更新武将属性，以下情况会推送此消息
-- 强化武将
-- 武将升级
-- 装备属性改变时候
-- captain: int // 武将id
-- total_stat: bytes // shared_proto.SpriteStatProto 总属性
-- fight_amount: int // 当前战力
-- full_fight_amount: int // 满兵战力
local function S2CUpdateCaptainStatProto(data)
    local generalData = MilitaryAffairsData.Captains[data.captain]
    -- 评分提升飘字
    if generalData.FullSoldierFightAmount < data.full_fight_amount and not MilitaryAffairsData.IsBattleState then
        UIManager.showTip( { content = string.format("武将评分+ %d", data.full_fight_amount - generalData.FullSoldierFightAmount), result = true })
    end
    -- 更新
    generalData.FightAmount = data.fight_amount
    generalData.FullSoldierFightAmount = data.full_fight_amount

    local stat = shared_pb.SpriteStatProto()
    stat:ParseFromString(data.total_stat)
    generalData.TotalStat:updateInfo(stat)

    Event.dispatch(Event.GENERAL_STATUS_UPDATE, data.captain)
end
military_decoder.RegisterAction(military_decoder.S2C_UPDATE_CAPTAIN_STAT, S2CUpdateCaptainStatProto)

-- *********************************************************************
-- 武将加经验--moduleId = 4, msgId = 52
-- 特别的（经验可能超出升级上限）
-- 武将如果出征状态，那么只加经验不会升级，等到武将回来的时候，才会触发升级操作
-- captain: int // 武将id
-- exp: int // 更新后的经验
local function S2CUpdateCaptainExpProto(data)
    print("武将加经验")
    MilitaryAffairsData.Captains[data.captain].Exp = data.exp
end
military_decoder.RegisterAction(military_decoder.S2C_UPDATE_CAPTAIN_EXP, S2CUpdateCaptainExpProto)
-- *********************************************************************
-- 武将升级--moduleId = 4, msgId = 51
-- captain: int // 武将id
-- exp: int // 更新后的经验
-- level: int // 更新后的等级
-- name: string // 更新后的武将名字
local function S2CUpdateCaptainLevelProto(data)
    print("武将升级")
    local generalData = MilitaryAffairsData.Captains[data.captain]
    generalData.Exp = data.exp
    generalData.Level = data.level
    generalData.Name = data.name
    generalData.MaxSoldier = data.soldier_capcity

    print(data.soldier_capcity, "武将带兵数！！")
end
military_decoder.RegisterAction(military_decoder.S2C_UPDATE_CAPTAIN_LEVEL, S2CUpdateCaptainLevelProto)

-- *********************************************************************
-- 修炼馆设置武将槽位成功--58
-- index: int // 武将修炼馆槽位，从0开始
-- captain: int // 武将id
local function S2CSetTrainingCaptainProto(data)
    print('修炼馆设置武将槽位成功')

end
military_decoder.RegisterAction(military_decoder.S2C_SET_TRAINING_CAPTAIN, S2CSetTrainingCaptainProto)

-- 修炼馆设置武将槽位失败--59
local function S2CFailSetTrainingCaptainProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_SET_TRAINING_CAPTAIN, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_SET_TRAINING_CAPTAIN, S2CFailSetTrainingCaptainProto)
-- *********************************************************************
-- 修炼馆交换武将槽位成功--61
-- index: int // 武将修炼馆槽位，从0开始
-- captain: int // 武将id
local function S2CSwapTrainingCaptainProto(data)
    print('修炼馆交换武将槽位成功')

end
military_decoder.RegisterAction(military_decoder.S2C_SWAP_TRAINING_CAPTAIN, S2CSwapTrainingCaptainProto)

-- 修炼馆交换武将槽位失败--65
local function S2CFailSwapTrainingCaptainProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_SWAP_TRAINING_CAPTAIN, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_SWAP_TRAINING_CAPTAIN, S2CFailSwapTrainingCaptainProto)
-- *********************************************************************
-- 领取修炼馆经验成功--63
-- index: int // 领取修炼位经验，从0开始
local function S2CCollectTrainingExpProto(data)
    print('领取修炼馆经验成功')
end
military_decoder.RegisterAction(military_decoder.S2C_COLLECT_TRAINING_EXP, S2CCollectTrainingExpProto)

-- 领取修炼馆经验失败--64
local function S2CFailCollectTrainingExpProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_COLLECT_TRAINING_EXP, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_COLLECT_TRAINING_EXP, S2CFailCollectTrainingExpProto)
-- *********************************************************************
-- 升级修炼馆槽位成功--55
-- index: int // 武将修炼馆槽位，从0开始
-- level: int // 升级后的等级
local function S2CUpgradeTrainingProto(data)
    print('升级修炼馆槽位成功')
    MilitaryAffairsData.Training[data.index + 1].Level = data.level

    Event.dispatch(Event.PRACTICEHALL_UPGRADE_SUCCESS)
end
military_decoder.RegisterAction(military_decoder.S2C_UPGRADE_TRAINING, S2CUpgradeTrainingProto)

-- 升级修炼馆槽位失败--56
local function S2CFailUpgradeTrainingProto(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_UPGRADE_TRAINING, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_UPGRADE_TRAINING, S2CFailUpgradeTrainingProto)
-- *********************************************************************
-- 更新修炼馆产出
-- index: int[] // 武将修炼馆槽位，从0开始
-- output: int[] // 修炼馆产出，每小时
-- capcity: int[] // 修炼馆产出上限
-- exp: int[] // 当前可领取经验，（经验上限,产量，从等级数据中获取）
local function S2CUpdateTrainingOutput(data)
    print("更新修炼馆产出", data)

    for k, v in ipairs(data.index) do
        -- 可能会新增位置直接新开
        MilitaryAffairsData.Training[v + 1] = HeroTrainingClass()
        MilitaryAffairsData.Training[v + 1].Output = data.output[k]
        MilitaryAffairsData.Training[v + 1].Capcity = data.capcity[k]
        MilitaryAffairsData.Training[v + 1].Exp = data.exp[k]
    end

    Event.dispatch(Event.PRACTICEHALL_UPDATE_TRAINING_OUTPUT)
end
military_decoder.RegisterAction(military_decoder.S2C_UPDATE_TRAINING_OUTPUT, S2CUpdateTrainingOutput)
-- *********************************************************************
-- 一键领取修炼馆经验成功
-- 客户端将所有槽位的可领取经验设为0（服务器会给武将加经验）
local function S2CCollectAllTrainingExpProto()
    print("一键领取修炼馆经验成功")

    for k, v in pairs(MilitaryAffairsData.Training) do
        v.Exp = 0
    end

    UIManager.showTip( { content = "一键领取修炼馆经验成功", result = true })
    Event.dispatch(Event.PRACTICEHALL_COLLECT_ALL_TRAINING_EXP_SUCCESS)
end
military_decoder.RegisterAction(military_decoder.S2C_COLLECT_ALL_TRAINING_EXP, S2CCollectAllTrainingExpProto)
-- *********************************************************************
-- 修炼馆一键修炼成功
-- index: int[] // 武将修炼馆槽位，从0开始
-- captain: int[] // 武将id
local function S2CAutoSetTrainingCaptainProto(data)
    print("修炼馆一键修炼成功", data)
    local trainingData = nil

    for k, v in ipairs(data.index) do
        local index = v + 1
        trainingData = MilitaryAffairsData.Training[index]

        if trainingData == nil then
            trainingData = HeroTrainingClass()
        end

        trainingData.Captain = data.captain[k]
    end

    Event.dispatch(Event.PRACTICEHALL_AUTO_SET_TRAINING_CAPTAIN_SUCCESS)
end
military_decoder.RegisterAction(military_decoder.S2C_AUTO_SET_TRAINING_CAPTAIN, S2CAutoSetTrainingCaptainProto)
-- *********************************************************************
-- 获取最大可招募士兵数量成功
-- count: int // 最大可招募士兵数量
local function S2CGetMaxRecruitSoldierProto(data)
    print("获取最大可招募士兵数量成功", data)
    Event.dispatch(Event.BARRACK_GET_MAX_Recruit_SOLDIER_SUCCESS, data.count)
end
military_decoder.RegisterAction(military_decoder.S2C_GET_MAX_RECRUIT_SOLDIER, S2CGetMaxRecruitSoldierProto)

-- 获取最大可治疗伤兵数成功
-- count: int // 最大可治疗伤兵数量
local function S2CGetMaxHealSoldierProto(data)
    print("获取最大可治疗伤兵数成功", data)
    Event.dispatch(Event.BARRACK_GET_MAX_HEAL_SOLDIER_SUCCESS, data.count)
end
military_decoder.RegisterAction(military_decoder.S2C_GET_MAX_HEAL_SOLDIER, S2CGetMaxHealSoldierProto)
-- *********************************************************************

-- add by theo
-- 武将改名消耗配置，Config.MiscConfig.ChangeCaptainNameCost
-- id: int // 武将id
-- name: string // 武将名字
local function S2CChangeCaptainName(data)
    UIManager.showTip( { content = Localization.RenameSucc, result = true })
    Event.dispatch(Event.GENERAL_RENAME_SUCCESS, data.id, data.name)
end
military_decoder.RegisterAction(military_decoder.S2C_CHANGE_CAPTAIN_NAME, S2CChangeCaptainName)

-- 武将改名失败
local function S2CFailChangeCaptainName(data)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CHANGE_CAPTAIN_NAME, data)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CHANGE_CAPTAIN_NAME, S2CFailChangeCaptainName)

-- 武将转职成功
-- id: int // 武将id
-- race: int // 武将职业 shared_proto.Race
-- cooldown: int // cd结束时间，单位秒
-- name: string // 武将名字
local function S2CChangeCaptainRace(data)
    Event.dispatch(Event.GENERAL_CHANGE_RACE_SUCCESS, data)
end
military_decoder.RegisterAction(military_decoder.S2C_CHANGE_CAPTAIN_RACE, S2CChangeCaptainRace)

-- 武将转职失败
local function S2CFailChangeCaptainRace(code)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CHANGE_CAPTAIN_RACE, code)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CHANGE_CAPTAIN_RACE, S2CFailChangeCaptainRace)

-- 武将转生界面数据获取成功
-- id: int // 武将id
-- name: string // 武将名字
-- rebirth_level: int // 转生等级，1表示1转
-- quality: int // 品质
-- ability: int // 成长值
-- ability_limit: int // 成长上限
-- total_stat: bytes // shared_proto.SpriteStatProto 总属性
-- full_fight_amount: int // 满兵战力
local function S2CCaptainRebirthPreview(data)
    Event.dispatch(Event.GENERAL_REBIRTH_PREVIEW_SUCCESS, data)
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_REBIRTH_PREVIEW, S2CCaptainRebirthPreview)

-- 武将转生界面数据获取失败
local function S2CFailCaptainRebirthPreview(data)
    Event.dispatch(Event.GENERAL_REBIRTH_PREVIEW_FAIL)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_PREVIEW, data)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_PREVIEW, S2CFailCaptainRebirthPreview)

-- 武将转生
-- id: int // 武将id
-- name: string // 武将名字
-- rebirth_level: int // 转生等级，1表示1转
-- rebirth_exp: int // 转生经验
-- quality: int // 品质
-- ability: int // 成长值
-- ability_exp: int // 成长经验
-- ability_limit: int // 成长上限
-- soldier: int // 武将士兵数
-- soldier_capcity: int // 武将士兵上限
-- total_stat: bytes // shared_proto.SpriteStatProto 总属性
-- fight_amount: int // 当前战力
-- full_fight_amount: int // 满兵战力
local function S2CCaptainRebirth(data)
    Event.dispatch(Event.GENERAL_REBIRTH_SUCCESS, data)
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_REBIRTH, S2CCaptainRebirth)

--  武将转生失败
local function S2CFailCaptainRebirth(data)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CAPTAIN_REBIRTH, data)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CAPTAIN_REBIRTH, S2CFailCaptainRebirth)

-- 使用转生道具成功
-- id: int // 武将id
-- exp: int // 转生经验
local function S2CUseRebirthGoods(data)
    Event.dispatch(Event.General_USE_GOODS_SUCCESS, data)
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_REBIRTH_GOODS, S2CUseRebirthGoods)

-- 使用转生道具失败
local function S2CFailUseRebirthGoods(data)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_GOODS, data)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_GOODS, S2CFailUseRebirthGoods)

-- 使用元宝加转生经验成功
local function S2CCaptainRebirthYuanbao(data)
    Event.dispatch(Event.General_USE_YUANBAO_SUCCESS, data)
end
military_decoder.RegisterAction(military_decoder.S2C_CAPTAIN_REBIRTH_YUANBAO, S2CCaptainRebirthYuanbao)

-- 使用元宝加转生经验失败
local function S2CFailCaptainRebirthYuanbao(data)
    UIManager.showNetworkErrorTip(military_decoder.ModuleID, military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_YUANBAO, data)
end
military_decoder.RegisterAction(military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_YUANBAO, S2CFailCaptainRebirthYuanbao)

return MilitaryAffairsData