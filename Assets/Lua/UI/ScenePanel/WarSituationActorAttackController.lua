local UIController = UIManager.Controller(UIManager.ControllerName.WarSituationActorAttack, UIManager.ViewName.WarSituationActorAttack)
local attackSituations = nil
local attckTargetId = nil
local timer = nil

function UIController:onCreat()
    self.View.Bg.onClick:Set(self.OnBgClick)
    Event.addListener(Event.ON_CURRENT_MAP_MILITARY_UPDATED, self.OnSituationUpdate)
    Event.addListener(Event.ON_CURRENT_MAP_MILITARY_REMOVED, self.OnSituationUpdate)
end

function UIController.OnBgClick()
    UIController:close()
end

function UIController.OnSituationUpdate()
    if not UIController.IsOpen then
        return
    end
    UIController:refreshWarSituation()
    UIController:refreshListItem()
end

function UIController:onOpen(targetId)
    attckTargetId = targetId
    self:refreshWarSituation(targetId)
    self:refreshListItem()
end

function UIController:refreshWarSituation()
    attackSituations = { }
    local militaryInfo = DataTrunk.PlayerInfo.MilitaryInfoData.CurrMapMilitaryInfoList
    for k, v in pairs(militaryInfo) do
        if v ~= nil and v.Target ~= nil and v.Target.Id == attckTargetId 
            and v.Action == MilitaryActionType.Invasion and v.MoveType == MilitaryMoveType.Arrived then
            table.insert(attackSituations, v)
        end
    end
end

function UIController:refreshListItem()
    if attackSituations == nil or #attackSituations == 0 then
        self:OnBgClick()
        return
    end
    self.View.List:RemoveChildrenToPool()
    for i, v in ipairs(attackSituations) do
        local item = self.View.List:AddItemFromPool()
        if v.Self.GuildId == 0 then
            item:GetChild("txt_wanjiaming").text = v.Self.Name
        else
            item:GetChild("txt_wanjiaming").text = "[" .. v.Self.GuildFlagName .. "]" .. v.Self.Name
        end

        local troopsList = item:GetChild("list_zhenying")
        troopsList:RemoveChildrenToPool()

        local fightAmount = 0
        local totalLoad = 0
        local totalTroops = 0
        local currnetTroops = 0
        for k, v in pairs(v.CaptainInfoList) do
            if v ~= nil then
                fightAmount = fightAmount + v.FightAmount
                totalTroops = totalTroops + v.Soldier
                totalLoad = totalLoad + v.Soldier * v.LoadPerSoldier
                currnetTroops = currnetTroops + v.TotalSoldier
                if v.RaceType ~= nil then
                    local item = troopsList:AddItemFromPool()
                    item.icon = UIConfig.Race[v.RaceType]
                end
            end
        end

        item:GetChild("txt_zhanli").text = fightAmount
        local troopsPower = item:GetChild("progress_bingli")
        troopsPower.max = totalTroops
        troopsPower.value = currnetTroops
        local troopsLoad = item:GetChild("progress_fuzai")
        troopsLoad.max = totalLoad
        local currentLoad = attackSituations[i].Gold + attackSituations[i].Food + attackSituations[i].Wood + attackSituations[i].Stone
        troopsLoad.value = currentLoad
        item:GetChild("txt_fuzai").text = currentLoad

        local timerIcon = item:GetChild("image_time")
        local timerText = item:GetChild("txt_jishi")
        
        if timer == nil then
            timer = { }
        end
        if timer[i + 1] ~= nil then
            TimerManager.disposeTimer(timer[i + 1])
        end
        local remainSeconds = math.abs(TimerManager.currentTime - attackSituations[i].MoveArrivedTime)
        remainSeconds = math.floor(remainSeconds + 0.5)
        local maxCount = 999999
        timer[i + 1] = TimerManager.newTimer(maxCount, false, true, nil,
            function(t, f)
                timerIcon.visible = true
                timerText.visible = true
                timerText.text = Utils.secondConversion(math.floor(f))
            end,
            function()
                timerIcon.visible = false
                timerText.visible = false
            end,
            self, true)
        timer[i + 1]:start(remainSeconds)
        local visibleCtr = item:GetController("Visible_C")
        local textCtr = item:GetController("Text_C")
        -- 我是发起者
        if attackSituations[i].Self.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
            visibleCtr.selectedIndex = 0
            textCtr.selectedIndex = 1
            -- 可以召回军队
            item:GetChild("btn_quzhu").onClick:Set( function()
                NetworkManager.C2SCancelInvasionProto(attackSituations[i].CombineId)
                end)
        -- 我或者盟友是被攻击者
        elseif attckTargetId == DataTrunk.PlayerInfo.MonarchsData.Id or
            (v.Target.GuildId ~= nil and v.Target.GuildId == DataTrunk.PlayerInfo.MonarchsData.GuildId) then
            visibleCtr.selectedIndex = 0
            textCtr.selectedIndex = 0
            -- 驱逐
            item:GetChild("btn_quzhu").onClick:Set( function()
                self:OnExpel(attackSituations[i], DataTrunk.PlayerInfo.MonarchsData.Id == attckTargetId)
                end)
        else
            -- 不显示按钮
            visibleCtr.selectedIndex = 1
        end
    end
end

-- 驱逐军队
-- 默认驱逐战斗力最低的对手
-- 当我自己被掠夺时，可以指定驱逐对象
function UIController:OnExpel(info, isAttackMe)
    if info ~= nil then
        local combatInfo = BattleDeploymentInfo()
        combatInfo:clear()
        -- 请求出征
        combatInfo.ToCombat = function(captainId, count, selected, troopId)
            if isAttackMe then 
                NetworkManager.C2SExpelProto(info.CombineId, DataTrunk.PlayerInfo.RegionData:getSelectRegion(), troopId)
            else
                NetworkManager.C2SInvasionProto(false, info.Target.Id, DataTrunk.PlayerInfo.RegionData:getSelectRegion(), troopId)
            end
            return true
        end
        combatInfo.Monarch = { }
        -- 驱逐自己
        if info.Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
            -- 战斗类型
            combatInfo.Type = BattleStyleType.PVP_Expel_ForSelf
            -- 对方君主信息（军情的发起者）
            combatInfo.Monarch.Name = info.Self.Name
            combatInfo.Monarch.Head = UIConfig.MonarchsIcon[info.Self.Head]
            combatInfo.Monarch.Guild = info.Self.GuildName
            combatInfo.Monarch.Level = info.Self.Level
            combatInfo.Monarch.MainCityLevel = info.Self.BaseLevel
            combatInfo.Monarch.FightAmount = info.Self.FightAmount
            combatInfo.Monarch.TowerFloor = 0
            combatInfo.Monarch.Rank = Localization.None
        -- 帮助盟友驱逐
        else
            -- 战斗类型
            combatInfo.Type = BattleStyleType.PVP_Expel_ForFriend
            -- 对方君主信息（军情的发起者）
            combatInfo.Monarch.Name = info.Target.Name
            combatInfo.Monarch.Head = UIConfig.MonarchsIcon[info.Target.Head]
            combatInfo.Monarch.Guild = info.Target.GuildName
            combatInfo.Monarch.Level = info.Target.Level
            combatInfo.Monarch.MainCityLevel = info.Target.BaseLevel
            combatInfo.Monarch.FightAmount = info.Target.FightAmount
            combatInfo.Monarch.TowerFloor = 0
            combatInfo.Monarch.Rank = Localization.None
        end
        -- 武将(共五个槽位)
        combatInfo.Troops = { }
        for k, v in pairs(info.CaptainInfoList) do
            if v ~= nil then
                combatInfo.Troops[k] = MonsterCaptainClass()
                combatInfo.Troops[k].Name = v.Name
                combatInfo.Troops[k].Head = v.Head
                combatInfo.Troops[k].Race = v.RaceType
                combatInfo.Troops[k].Quality = v.Quality
                combatInfo.Troops[k].Solider = v.Solider
                combatInfo.Troops[k].MaxSolider = v.TotalSoldier
                combatInfo.Troops[k].Level = v.Level
            end
        end
        -- 奖励无
        combatInfo.Awards = nil

        -- 打开布阵
        UIManager.openController(UIManager.ControllerName.PreBattle, combatInfo)
    end
end

function UIController:onDestroy()
    self.View.Bg.onClick:Clear()
    attackSituations = nil
    attckTargetId = nil
    for i, v in ipairs(timer) do
        TimerManager.disposeTimer(v)
    end
    timer = nil
    Event.removeListener(Event.ON_CURRENT_MAP_MILITARY_UPDATED, self.OnSituationUpdate)
    Event.removeListener(Event.ON_CURRENT_MAP_MILITARY_REMOVED, self.OnSituationUpdate)
end

return UIController 