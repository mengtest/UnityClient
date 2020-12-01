-- 依据方向获取轴向值改变
local function directionGrid(directionType)
    if directionType == DirectionType.Up then
        return 0, -1

    elseif directionType == DirectionType.Left then
        return -1, 0

    elseif directionType == DirectionType.Down then
        return 0, 1

    elseif directionType == DirectionType.Right then
        return 1, 0
    else
        return 0, 0
    end
end

---------------------------------------------------------
--- 回放帮助----------------------------------------
---------------------------------------------------------
local ReplayHelp = { }
-- 摄像头参数,对应的动画参数：MotionType
ReplayHelp.CamEffTyper = {
    -- 初始状态
    init = 0,
    -- 当进入状态
    onEnter = 1,
}
-- 画格子
function ReplayHelp:drawGrid(pos, scale)
    local map = CS.LPCFramework.LogicUtils.LoadResource("Prefabs/Misc/BattleGrid")
    map = CS.UnityEngine.Object.Instantiate(map)

    map.transform.localScale = CS.UnityEngine.Vector3.one * scale
    -- 抬高2
    map.transform.position = pos + CS.UnityEngine.Vector3(0, 0.2, 0)
end
-- 生成格子
function ReplayHelp:creatGrid(xGridNum, yGridNum, xGirdLen, yGirdLen, numGrid, scale)
    local tempGrid = { }
    local middleXid =(xGridNum - 1) * 0.5
    local middleYid =(yGridNum - 1) * 0.5
    for x = 0, xGridNum - 1, 1 do
        tempGrid[x] = { }
        for y = 0, yGridNum - 1, 1 do
            tempGrid[x][y] = CS.UnityEngine.Vector3((x - middleXid) * xGirdLen, 0,(middleYid - y) * yGirdLen)
        end
    end

    -- 队列所在格子
    local newGrid = { }
    local totalLen = yGirdLen * yGridNum * numGrid + yGirdLen *(numGrid - 1) - yGirdLen * yGridNum
    local offsetZ = totalLen * 0.5
    local intervalLen = 0
    if numGrid ~= 1 then intervalLen = totalLen /(numGrid - 1) end
    for i = 1, numGrid do
        newGrid[i] = { }
        for x = 0, xGridNum - 1, 1 do
            newGrid[i][x] = { }
            for y = 0, yGridNum - 1, 1 do
                newGrid[i][x][y] = tempGrid[x][y] + CS.UnityEngine.Vector3(0, 0, offsetZ -(i - 1) * intervalLen)
            end
        end
    end

    -- 画格子
    for k, v in pairs(newGrid) do
        for m, n in pairs(v) do
            for y, z in pairs(n) do
                self:drawGrid(z, scale)
            end
        end
    end

    -- 如果只有一个
    if numGrid == 1 then
        return newGrid[1]
    end

    return newGrid
end
-- 生成动画
function ReplayHelp:creatCamAnim(animCtrlPath)
    local camera = CS.UnityEngine.Camera.main.gameObject
    local cameraAnimator = camera:GetComponent(typeof((CS.UnityEngine.Animator)))
    if nil == cameraAnimator or cameraAnimator:Equals(nil) then
        cameraAnimator = camera:AddComponent(typeof((CS.UnityEngine.Animator)))
    end

    local animCtrl = nil
    if nil ~= animCtrlPath then
        animCtrl = CS.LPCFramework.LogicUtils.LoadResource(animCtrlPath)
    end
    if nil ~= animCtrl then
        cameraAnimator.runtimeAnimatorController = animCtrl
    end
    return cameraAnimator
end
---------------------------------------------------------
--- 战斗回放逻辑----------------------------------------
---------------------------------------------------------
local ReplayLogic = Class()
-- 基础信息----------------------------------------

-- 場景配置
ReplayLogic.levelConfig = nil
-- 回放信息--
ReplayLogic.battleReplayInfo = nil
-- 摄像机动画--
ReplayLogic.cameraAnimator = nil
-- 地面上的网格--
ReplayLogic.mapGrid = nil
-- 轮次计时器--
ReplayLogic.roundTimer = nil
-- 回合计时器--
ReplayLogic.boutTimer = nil
-- 当回放结束
ReplayLogic.onOver = nil
-- 延时开始--
ReplayLogic.delayDoStart = 0
-- 延时战斗--
ReplayLogic.delayDoBattle = 2.5
-- 冲刺特效Id--
ReplayLogic.dashParticleId = 31

-- 初始信息----------------------------------------

-- 初始回合id--
ReplayLogic.initBoutId = 1
-- 初始轮次id--
ReplayLogic.initRoundId = 1
-- 初始武将经过格子
ReplayLogic.initCaptainPassGrid = nil
-- 初始武将所在格子
ReplayLogic.initCaptainLastGridId = nil

-- 进行信息----------------------------------------

-- 播放速度
ReplayLogic.speedRate = 1
-- 回合id--
ReplayLogic.boutId = 1
-- 轮次id--
ReplayLogic.roundId = 1
-- 下一步指令--
ReplayLogic.actionInfo = nil
-- 战斗进展记录--
ReplayLogic.battleProgress = nil
-- 上一次武将所在格子id
ReplayLogic.captainLastGridId = nil
-- 上阵武将列表
ReplayLogic.actorList = nil

-- 延时管理
ReplayLogic.delayCenter = setmetatable( { }, { __mode = 'k' })

-- 战斗回合记录
function ReplayLogic:recordBoutLog(boutId)
    local desc = string.format(Localization.BattleLog_Bout, boutId)
    table.insert(self.battleProgress, desc)

    Event.dispatch(Event.BATTLE_PROGRESS_REFRESH, self.battleProgress)
end
-- 战斗移动记录
function ReplayLogic:recordMoveLog(playerId, gridX, gridY)
    local desc = #self.battleProgress + self.initBoutId - self.boutId
    local player = self.battleReplayInfo.AttackerPlayer:getCaptainById(playerId)

    if nil ~= player then
        desc = string.format(Localization.BattleLog_AttackColor, desc)
    else
        desc = string.format(Localization.BattleLog_DefendColor, desc)

        player = self.battleReplayInfo.DefenserPlayer:getCaptainById(playerId)
    end
    desc = string.format("%s:%s", desc, string.format(Localization.BattleLog_Move, player.Captain.Name, player.Captain.SoldierLevel, Localization["SoliderRaceType" .. player.Captain.RaceType], gridX + 1, gridY + 1))
    table.insert(self.battleProgress, desc)

    Event.dispatch(Event.BATTLE_PROGRESS_REFRESH, self.battleProgress)
end
-- 战斗攻击记录
function ReplayLogic:recordAttackLog(attackerId, targetId, damageV1, damageV2, hurtType, skillType, skillId)
    local desc = #self.battleProgress + self.initBoutId - self.boutId
    local attackerPlayer = self.battleReplayInfo.AttackerPlayer:getCaptainById(attackerId)
    local defenderPlayer = self.battleReplayInfo.DefenserPlayer:getCaptainById(targetId)
    if nil ~= attackerPlayer then
        desc = string.format(Localization.BattleLog_AttackColor, desc)
    else
        desc = string.format(Localization.BattleLog_DefendColor, desc)

        attackerPlayer = self.battleReplayInfo.DefenserPlayer:getCaptainById(attackerId)
        defenderPlayer = self.battleReplayInfo.AttackerPlayer:getCaptainById(targetId)
    end
    if skillType == SkillType.Restrain then
        local skillDesc = ""
        local skillConfig = SkillConfig:getConfigByKey(skillId)
        if skillConfig ~= nil then
            skillDesc = skillConfig.desc
        end
        -- 普攻技能伤害
        desc = string.format("%s:%s", desc, string.format(Localization.BattleLog_Attack,
        attackerPlayer.Captain.Name, attackerPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. attackerPlayer.Captain.RaceType],
        defenderPlayer.Captain.Name, defenderPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. defenderPlayer.Captain.RaceType],
        damageV1))
        -- 克制技能伤害
        desc = string.format("%s\n%s", desc, string.format(Localization.BattleLog_SkillRestrain,
        attackerPlayer.Captain.Name, attackerPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. attackerPlayer.Captain.RaceType],
        skillDesc,
        defenderPlayer.Captain.Name, defenderPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. defenderPlayer.Captain.RaceType],
        damageV2))
    elseif hurtType == HurtType.Normal then
        -- 正常攻击
        desc = string.format("%s:%s", desc, string.format(Localization.BattleLog_Attack,
        attackerPlayer.Captain.Name, attackerPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. attackerPlayer.Captain.RaceType],
        defenderPlayer.Captain.Name, defenderPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. defenderPlayer.Captain.RaceType],
        damageV1))
    elseif hurtType == HurtType.Crit then
        -- 暴击攻击
        desc = string.format("%s:%s", desc, string.format(Localization.BattleLog_AttackCrit,
        attackerPlayer.Captain.Name, attackerPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. attackerPlayer.Captain.RaceType],
        defenderPlayer.Captain.Name, defenderPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. attackerPlayer.Captain.RaceType],
        damageV1))
    elseif hurtType == HurtType.Miss then
        -- 闪避
        desc = string.format("%s:%s", desc, string.format(Localization.BattleLog_Dodge,
        attackerPlayer.Captain.Name, attackerPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. attackerPlayer.Captain.RaceType],
        defenderPlayer.Captain.Name, defenderPlayer.Captain.SoldierLevel, Localization["SoliderRaceType" .. defenderPlayer.Captain.RaceType]
        ))
    end
    table.insert(self.battleProgress, desc)

    Event.dispatch(Event.BATTLE_PROGRESS_REFRESH, self.battleProgress)
end
-- 获取下一格子Id
function ReplayLogic:getNextGridId(captainLastGridId, captainId, directionType)
    local nextX, nextY = directionGrid(directionType)
    nextX = nextX + captainLastGridId[captainId].x
    nextY = nextY + captainLastGridId[captainId].y
    captainLastGridId[captainId].x = nextX
    captainLastGridId[captainId].y = nextY

    return nextX, nextY
end
-- 延时执行
function ReplayLogic:delayToDo(maxCd, speedRate, funcToDo, params)
    timer = TimerManager.waitTodo(maxCd, speedRate, funcToDo, params, self)
    table.insert(self.delayCenter, timer)
end
-- 销毁所有延时
function ReplayLogic:disposeDelayToDo()
    for k, v in pairs(self.delayCenter) do
        TimerManager.disposeTimer(v)
    end
end
-- 更改回合和轮次计时时间
function ReplayLogic:setRound2BoutTimerCd(roundTime, boutTime)
    self.roundTimer:addCd(roundTime - self.roundTimer.MaxCd)
    self.boutTimer:addCd(boutTime - self.boutTimer.MaxCd)
end
-- 回合计时开始--
function ReplayLogic:onBoutTimeStart()
    -- 回合记录--
    self:recordBoutLog(self.boutId)
end
-- 轮次计时开始--
function ReplayLogic:onRoundTimeStart()
    assert(self.actionInfo ~= nil, "battle self.actionInfo is nil!!!!!!")

    -- 恢复计时时间
    self:setRound2BoutTimerCd(self.levelConfig.RoundInterval, self.levelConfig.BoutInterval)
    -- 若回合id不一致，则进行回合时间等待
    if self.actionInfo.BoutId ~= self.boutId then
        -- 回合累加
        self.boutId = self.boutId + 1
        self.roundTimer:reset()
        self.boutTimer:start()
    else
        -- 轮次累加
        self.roundId = self.roundId + 1
        -- 进行下一步指令
        if self.actionInfo.Direction == nil or self.actionInfo.Direction == DirectionType.Origin then
            -- 技能Id
            local skillId = 0
            -- 判断攻击类型
            if self.actionInfo.AttackerSkillType == SkillType.Restrain then
                skillId = self.actionInfo.RestrainSkillId
                self:setRound2BoutTimerCd(self.levelConfig.RoundInterval + 1, self.levelConfig.BoutInterval + 1)
            else
                skillId = self.actionInfo.NormalAttackSkillId
            end

            -- 攻击记录
            self:recordAttackLog(self.actionInfo.Id,
            self.actionInfo.AttackTargetId,
            self.actionInfo.AttackDamage - self.actionInfo.AttackRestraintSpellDamage,
            self.actionInfo.AttackRestraintSpellDamage,
            self.actionInfo.HurtType,
            self.actionInfo.AttackerSkillType,
            skillId)
            -- 进行攻击
            self.actorList[self.actionInfo.Id]:onAttack(self.actorList[self.actionInfo.AttackTargetId], skillId, self.actionInfo.AttackDamage, self.actionInfo.HurtType)
        else
            -- 目标点
            local nextX, nextY = self:getNextGridId(self.captainLastGridId, self.actionInfo.Id, self.actionInfo.Direction)
            -- 移动记录
            self:recordMoveLog(self.actionInfo.Id, nextX, nextY)
            -- 进行移动
            self.actorList[self.actionInfo.Id]:movePoint(self.mapGrid[nextX][nextY], self.levelConfig.MoveStepDuration, ActorMoveType.Walk)

            -- 移动结束进行攻击
            if self.actionInfo.AttackTargetId ~= 0 then
                -- 技能Id
                local skillId = 0
                -- 判断攻击类型
                if self.actionInfo.AttackerSkillType == SkillType.Restrain then
                    skillId = self.actionInfo.RestrainSkillId
                    self:setRound2BoutTimerCd(self.levelConfig.RoundInterval + self.levelConfig.MoveStepDuration + 1, self.levelConfig.BoutInterval + self.levelConfig.MoveStepDuration + 1)
                else
                    skillId = self.actionInfo.NormalAttackSkillId
                    self:setRound2BoutTimerCd(self.levelConfig.RoundInterval + self.levelConfig.MoveStepDuration, self.levelConfig.BoutInterval + self.levelConfig.MoveStepDuration)
                end
                -- 延时伤害
                self:delayToDo(self.levelConfig.MoveStepDuration, self.speedRate, self.delayDoAttack, {
                    ActionInfo = self.actionInfo,
                    SkillId = skillId
                } )
            end
        end
    end
end
-- 计时结束--
function ReplayLogic:onTimeComplete()
    -- 战斗指令获取
    self.actionInfo = self.battleReplayInfo.ActionList[self.roundId]
    -- 无下一步指令，战斗结束
    if self.actionInfo == nil then
        -- 结束
        self:over()
    else
        self.boutTimer:reset()
        self.roundTimer:start()
    end
end
-- 延时攻击
function ReplayLogic:delayDoAttack(action)
    -- 攻击记录
    self:recordAttackLog(action.ActionInfo.Id,
    action.ActionInfo.AttackTargetId,
    action.ActionInfo.AttackDamage - action.ActionInfo.AttackRestraintSpellDamage,
    action.ActionInfo.AttackRestraintSpellDamage,
    action.ActionInfo.HurtType,
    action.ActionInfo.AttackerSkillType,
    action.skillId)
    -- 进行攻击
    self.actorList[action.ActionInfo.Id]:onAttack(self.actorList[action.ActionInfo.AttackTargetId], action.SkillId, action.ActionInfo.AttackDamage, action.ActionInfo.HurtType)
end

-- 开始冲刺--
function ReplayLogic:start()
    for k, v in pairs(self.initCaptainPassGrid) do
        -- 冲刺效果
        self.actorList[k]:spawnParticle(self.dashParticleId)
        -- 进行冲刺
        self.actorList[k]:movePoints(Utils.deepCopy(v), self.delayDoBattle - self.delayDoStart, ActorMoveType.Run)
    end
end

-- 开始战斗--
function ReplayLogic:battle()
    self.boutTimer:start()
end

-- 结束战斗--
function ReplayLogic:over()
    -- 暂停战斗--
    self:pause()
    -- 结束战斗--
    self.onOver()
end

-- 快进战斗--
function ReplayLogic:speed(speed)
    self.speedRate = speed
    self.roundTimer:setSpeed(self.speedRate)
    self.boutTimer:setSpeed(self.speedRate)

    for k, v in pairs(self.delayCenter) do
        v:setSpeed(self.speedRate)
    end
end

-- 暂停战斗--
function ReplayLogic:pause()
    if not self.roundTimer.IsPause then
        self.roundTimer:pause()
    end
    if not self.boutTimer.IsPause then
        self.boutTimer:pause()
    end
    for k, v in pairs(self.delayCenter) do
        v:pause()
    end
end

-- 恢复战斗--
function ReplayLogic:resume()
    if self.roundTimer.IsPause then
        self.roundTimer:resume()
    end
    if self.boutTimer.IsPause then
        self.boutTimer:resume()
    end
    for k, v in pairs(self.delayCenter) do
        v:resume()
    end
end

-- 重置计时器--
function ReplayLogic:reset()
    -- 重置战报
    self.battleProgress = { }
    -- 重置格子
    self.captainLastGridId = Utils.deepCopy(self.initCaptainLastGridId)
    -- 信息重置--
    self.boutId = self.initBoutId
    self.roundId = self.initRoundId

    self.roundTimer:pause()
    self.boutTimer:pause()
    self.roundTimer:reset()
    self.boutTimer:reset()
    self:disposeDelayToDo()
end
-- 进行回放--
function ReplayLogic:playBack()
    -- 重置信息--
    self:reset()
    -- 恢复计时--
    self:setRound2BoutTimerCd(0.2, 0.2)

    -- 初始化武将--
    local pos, rot
    local spawnActor = function(troops, v3Forward)
        for k, v in pairs(troops) do
            pos = self.mapGrid[v.IdX][v.IdY]
            rot = CS.UnityEngine.Quaternion.Euler(CS.UnityEngine.Vector3(0, Utils.horizontalAngle(v3Forward), 0))
            local actor = GameObjectManager.spawnActor(v, v.Captain.RaceType, self.speedRate, pos, rot, nil)
            -- 保存武将
            self.actorList[v.InsId] = actor
            -- 通知UI刷新武将
            Event.dispatch(Event.BATTLE_CAPTAIN_REFRESH, actor)
        end
    end
    self.actorList = { }

    -- 获取攻方信息--
    local attackTroops = self.battleReplayInfo.AttackerPlayer.TroopsList
    spawnActor(attackTroops, CS.UnityEngine.Vector3.right)

    -- 获取守方信息--
    local defenserTroops = self.battleReplayInfo.DefenserPlayer.TroopsList
    spawnActor(defenserTroops, CS.UnityEngine.Vector3.left)

    -- 延时开始
    self:delayToDo(self.delayDoStart, self.speedRate, self.start)
    -- 延时战斗
    self:delayToDo(self.delayDoBattle, self.speedRate, self.battle)

    -- 通知ui--
    Event.dispatch(Event.BATTLE_PLAYER_REFRESH, self.battleReplayInfo)
    -- 进展
    Event.dispatch(Event.BATTLE_PROGRESS_REFRESH, self.battleProgress)
end

-- 初始信息筛选--
function ReplayLogic:initFiltrate()
    -- 初始轮次和回合
    self.initBoutId = 1
    self.initRoundId = 1
    -- 初始所在格子
    self.initCaptainLastGridId = { }
    -- 初始经过格子
    self.initCaptainPassGrid = { }
    for k, v in pairs(self.battleReplayInfo.AttackerPlayer.TroopsList) do
        self.initCaptainLastGridId[v.InsId] = { x = v.IdX, y = v.IdY }
        self.initCaptainPassGrid[v.InsId] = { }
    end
    for k, v in pairs(self.battleReplayInfo.DefenserPlayer.TroopsList) do
        self.initCaptainLastGridId[v.InsId] = { x = v.IdX, y = v.IdY }
        self.initCaptainPassGrid[v.InsId] = { }
    end

    -- 开始筛选
    local nextAction = nil
    for i = 1, #self.battleReplayInfo.ActionList do
        nextAction = self.battleReplayInfo.ActionList[i]

        -- 回合检测
        if self.initBoutId ~= nextAction.BoutId then
            self.initBoutId = nextAction.BoutId
            self.initRoundId = i
        end
        -- 攻击判断
        if nextAction.Direction == nil or nextAction.Direction == DirectionType.Origin then
            break
        elseif nextAction.AttackTargetId ~= 0 then
            break
        end
    end
    for i = 1, self.initRoundId - 1 do
        nextAction = self.battleReplayInfo.ActionList[i]

        -- 移动判断
        if nextAction.Direction ~= nil and nextAction.Direction ~= DirectionType.Origin then
            -- 最后格子记录
            local nextX, nextY = self:getNextGridId(self.initCaptainLastGridId, nextAction.Id, nextAction.Direction)
            -- 经过格子记录
            table.insert(self.initCaptainPassGrid[nextAction.Id], self.mapGrid[nextX][nextY])
        end
    end
end
-- 初始化战斗逻辑--
function ReplayLogic:initialize(battleReplay, levelConfig, mapGrid, camAnim, onOver)
    self.battleReplayInfo = battleReplay
    self.levelConfig = levelConfig
    self.cameraAnimator = camAnim
    self.mapGrid = mapGrid
    self.onOver = onOver
    self:initFiltrate()

    -- 生成所有计时器--
    if self.roundTimer == nil then
        self.roundTimer = TimerManager.newTimer(0, false, false, self.onRoundTimeStart, nil, self.onTimeComplete, self)
    end
    if self.boutTimer == nil then
        self.boutTimer = TimerManager.newTimer(0, false, false, self.onBoutTimeStart, nil, self.onTimeComplete, self)
    end
end

return {
    ReplayLogic = ReplayLogic,
    ReplayHelp = ReplayHelp
}
