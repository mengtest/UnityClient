
local _C = UIManager.SubController(UIManager.ControllerName.ClimbingTowerBase, nil)
_C.view = nil

-- 共楼层
local towerTotalFloor = MiscCommonConfig.Config.TowerTotalFloor
-- 重楼实例化信息
local towerInsInfo = DataTrunk.PlayerInfo.TowerData
-- 挑战楼层数据
local battleDeploymentInfo = BattleDeploymentInfo()
-- 君主实例化数据
local monarchInsInfo = DataTrunk.PlayerInfo.MonarchsData.LevelConfig
-- 当前点击楼层
local curClickFloor = 0

-- 扫荡
local function btnToMoopingUp()
    UIManager.openController(UIManager.ControllerName.ClimbingTowerMoopingUpReady)
end
-- 攻略
local function btnToStrategy()
    UIManager.openController(UIManager.ControllerName.ClimbingTowerStrategy, curClickFloor)
end
-- 宝箱
local function btnToAwardBox()
    if nil == towerInsInfo.BoxFloor then
        UIManager.showTip( { content = Localization.TowerNoBoxReceive, result = false })
    else
        UIManager.openController(UIManager.ControllerName.ClimbingTowerBox, towerInsInfo.BoxFloor)
    end
end
-- 挑战
local function btnToChallenge()
    if MiscCommonConfig.Config.TowerChallengeMaxTimes - towerInsInfo.ChallengeTimes <= 0 then
        UIManager.showTip( { content = Localization.TowerNoNumOfChallenges, result = false })
        return
    end
    if towerInsInfo.CurrentFloor == towerTotalFloor then
        UIManager.showTip( { content = Localization.TowerFloorTop, result = false })
        return
    end

    -- 挑战楼层
    local floor = towerInsInfo.CurrentFloor + 1
    -- 楼层配置
    local floorConfig = TowerConfig:getConfigById(floor)

    -- 部署清除
    battleDeploymentInfo:clear()
    -- 战斗类型
    battleDeploymentInfo.Type = BattleDeploymentType.PVE_ClimbingTower
    -- 布阵方式
    battleDeploymentInfo.FightAmountShowType = 1
    -- 出征回调
    battleDeploymentInfo.ToCombat = function(captainId, count)
        print("请求挑战---楼层：", towerInsInfo.CurrentFloor, monarchInsInfo.TowerCaptainLimit, count)
        -- 上阵武将个数限制判断
        if nil ~= monarchInsInfo then
            -- 上阵武将太多
            if count > monarchInsInfo.TowerCaptainLimit then
                UIManager.showTip( { content = string.format(Localization.TowerCaptainTroopCount_1, monarchInsInfo.TowerCaptainLimit), result = false })
                return false
            end
            -- 上阵武将太少
            if count < monarchInsInfo.TowerCaptainLimit and DataTrunk.PlayerInfo.MilitaryAffairsData:getIdleCaptainCount() > count then
                UIManager.showTip( { content = string.format(Localization.TowerCaptainTroopCount_2, monarchInsInfo.TowerCaptainLimit), result = false })
                return false
            end
        end
        -- 挑战武将
        towerInsInfo.ChallengeCaptains = captainId
        -- 同步
        NetworkManager.C2SChallengeProto(towerInsInfo.CurrentFloor, captainId)
        return true
    end

    -- 奖励信息
    award = function(t, cornerType)
        if nil ~= t then
            for k, v in pairs(t) do
                v.CornerType = cornerType
                table.insert(battleDeploymentInfo.Awards, v)
            end
        end
    end
    battleDeploymentInfo.Awards = { }
    -- 首胜道具
    if floor > towerInsInfo.HistoryMaxFloor and nil ~= floorConfig.FirstPassPrize then
        award(floorConfig.FirstPassPrize.Goods, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Equips, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Currencys, ItemCornerType.FirstWin)
    end
    -- 展示道具
    if nil ~= floorConfig.ShowPrize then
        award(floorConfig.ShowPrize.Goods, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Equips, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Currencys, ItemCornerType.Prob)
    end

    -- 君主信息
    battleDeploymentInfo.Monarch = { }
    battleDeploymentInfo.Monarch.Name = floorConfig.MonsterMaster.Name
    battleDeploymentInfo.Monarch.Head = floorConfig.MonsterMaster.Head
    battleDeploymentInfo.Monarch.Guild = Localization["BuildingName" .. BuildingType.ClimbingTower]
    battleDeploymentInfo.Monarch.Level = Localization.None
    battleDeploymentInfo.Monarch.MainCityLevel = Localization.None
    battleDeploymentInfo.Monarch.Rank = Localization.None
    battleDeploymentInfo.Monarch.TowerFloor = floor
    battleDeploymentInfo.Monarch.FightAmount = floorConfig.MonsterMaster.FightAmount

    -- 武将信息
    battleDeploymentInfo.Troops = { }
    for i = 1, #floorConfig.MonsterMaster.Troops do
        local captain = floorConfig.MonsterMaster.Troops[i]
        if captain ~= nil then
            battleDeploymentInfo.Troops[i] = MonsterCaptainClass()
            battleDeploymentInfo.Troops[i].Name = captain.Name
            battleDeploymentInfo.Troops[i].Head = captain.Head
            battleDeploymentInfo.Troops[i].Race = captain.Race
            battleDeploymentInfo.Troops[i].Quality = captain.Quality
            battleDeploymentInfo.Troops[i].Solider = captain.Solider
            battleDeploymentInfo.Troops[i].MaxSolider = captain.Solider
            battleDeploymentInfo.Troops[i].Level = captain.Level
            battleDeploymentInfo.Troops[i].SoldierLevel = captain.SoldierLevel
            battleDeploymentInfo.Troops[i].Quality = captain.Quality
        end
    end
    -- 打开布阵
    UIManager.openController(UIManager.ControllerName.PreBattle, battleDeploymentInfo)
end
-- 挑战战斗回放
local function towerReplayInfo()
    if not _C.IsOpen then
        return
    end
    -- 应该刷新攻略
    replayRefreshTimer = true
    -- 回放
    LevelManager.loadScene(towerInsInfo.ChallengeReplay.MapRes, towerInsInfo.ChallengeReplay)
end
-- 更新塔状态
local function updateTowerInfo()
    if not _C.IsOpen then
        return
    end

    -- 爬塔信息
    if towerInsInfo.CurrentFloor == towerTotalFloor then
        _C.view.TowerFloorCur.text = string.format(Localization.TowerCurFloor_1, towerInsInfo.CurrentFloor)
    else
        _C.view.TowerFloorCur.text = string.format(Localization.TowerCurFloor_1, towerInsInfo.CurrentFloor + 1)
    end
    _C.view.TowerFloorMax.text = towerInsInfo.HistoryMaxFloor
    _C.view.ChallengeTimeStat.selectedIndex = towerInsInfo.ChallengeTimes

    -- 如果扫荡等级大于当前挑战等级，则进行扫荡
    if towerInsInfo.AutoMaxFloor > towerInsInfo.CurrentFloor then
        _C.view.TowerStat.selectedIndex = 0
    else
        _C.view.TowerStat.selectedIndex = 1
    end
    -- 挑战状态
    if MiscCommonConfig.Config.TowerChallengeMaxTimes - towerInsInfo.ChallengeTimes <= 0 or towerInsInfo.CurrentFloor == towerTotalFloor then
        _C.view.BtnChallenge.grayed = true
        _C.view.EffectChallenge:Stop()
    else
        _C.view.BtnChallenge.grayed = false
        _C.view.EffectChallenge:Play(-1, 0, nil)
    end
    -- 重置时间
    _C.view.ResetTime.text = string.format(Localization.TimeReset, MiscCommonConfig.Config.DailyResetTime)
end

-- 更新楼层奖励大宝箱
local function updateAwardBoxId()
    if not _C.IsOpen then
        return
    end

    if nil ~= towerInsInfo.BoxFloor then
        _C.view.AwardBoxId.text = towerInsInfo.BoxFloor
        _C.view.BtnBox.visible = true
    else
        _C.view.BtnBox.visible = false
    end
end
-- 刷新层级奖励信息
function _C:updateFloorAwardInfo(floor)
    -- 当前点击楼层
    curClickFloor = floor

    _C.view.AwardItemDesc.text = string.format(Localization.TowerFloorAward, floor)

    local floorConfig = TowerConfig:getConfigById(floor)
    _C.view.AwardItemList:RemoveChildrenToPool()

    -- 本层奖励
    local itemAward = { }
    award = function(t, cornerType)
        if nil ~= t then
            for k, v in pairs(t) do
                v.CornerType = cornerType
                table.insert(itemAward, v)
            end
        end
    end
    -- 首胜道具
    if floor > towerInsInfo.HistoryMaxFloor and nil ~= floorConfig.FirstPassPrize then
        award(floorConfig.FirstPassPrize.Goods, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Equips, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Currencys, ItemCornerType.FirstWin)
    end
    -- 展示道具
    if nil ~= floorConfig.ShowPrize then
        award(floorConfig.ShowPrize.Goods, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Equips, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Currencys, ItemCornerType.Prob)
    end

    for k, v in pairs(itemAward) do
        local item = _C.view.AwardItemList:AddItemFromPool()
        -- 添加监听
        item.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)

        -- 刷新数据
        item:GetController("State_C").selectedIndex = 1
        item:GetController("Count_C").selectedIndex = 1
        item:GetChild("title").text = v.Amount
        item:GetChild("icon").url = v.Config.Icon

        -- 角标
        if v.CornerType == ItemCornerType.Noraml then
            item:GetController("CornerMark_C").selectedIndex = 0
        elseif v.CornerType == ItemCornerType.FirstWin then
            item:GetController("CornerMark_C").selectedIndex = 1
        elseif v.CornerType == ItemCornerType.Prob then
            item:GetController("CornerMark_C").selectedIndex = 2
        end

        -- 品质
        if v.ClassifyType == ItemClassifyType.Equip then
            item:GetChild("quality").url = UIConfig.Item.EquipQuality[v.Config.Quality.Level]
        else
            item:GetChild("quality").url = UIConfig.Item.DefaultQuality[v.Config.Quality]
        end

        _C.view.AwardItemList:AddChild(item)
    end
end

function _C:onCreat()
    _C.view.BtnStrategy.onClick:Add(btnToStrategy)
    _C.view.BtnBox.onClick:Add(btnToAwardBox)
    _C.view.BtnChallenge.onClick:Add(btnToChallenge)
    _C.view.BtnMoopingUp.onClick:Add(btnToMoopingUp)

    Event.addListener(Event.TOWER_AWARD_BOX_UPDATE, updateAwardBoxId)
    Event.addListener(Event.TOWER_BATTLE_REPLAY_ACK, towerReplayInfo)
    Event.addListener(Event.TOWER_CHALLENGE_FAILURE, updateTowerInfo)
    Event.addListener(Event.TOWER_CHALLENGE_SUCCEED, updateTowerInfo)
    Event.addListener(Event.TOWER_AUTO_CHALLENGE_FAILURE, updateTowerInfo)
    Event.addListener(Event.TOWER_AUTO_CHALLENGE_SUCCEED, updateTowerInfo)
    Event.addListener(Event.TOWER_DAILY_RESET, updateTowerInfo)
end
function _C:onOpen(data)
    updateAwardBoxId()
    updateTowerInfo()
end
function _C:onDestroy()
    _C.view.BtnStrategy.onClick:Clear()
    _C.view.BtnBox.onClick:Clear()
    _C.view.BtnChallenge.onClick:Clear()
    _C.view.BtnMoopingUp.onClick:Clear()

    Event.removeListener(Event.TOWER_AWARD_BOX_UPDATE, updateAwardBoxId)
    Event.removeListener(Event.TOWER_BATTLE_REPLAY_ACK, towerReplayInfo)
    Event.removeListener(Event.TOWER_CHALLENGE_FAILURE, updateTowerInfo)
    Event.removeListener(Event.TOWER_CHALLENGE_SUCCEED, updateTowerInfo)
    Event.removeListener(Event.TOWER_AUTO_CHALLENGE_FAILURE, updateTowerInfo)
    Event.removeListener(Event.TOWER_AUTO_CHALLENGE_SUCCEED, updateTowerInfo)
    Event.removeListener(Event.TOWER_DAILY_RESET, updateTowerInfo)
end

return _C
