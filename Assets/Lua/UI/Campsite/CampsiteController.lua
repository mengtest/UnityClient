
local UIController = UIManager.Controller(UIManager.ControllerName.Campsite, UIManager.ViewName.Campsite)
local monarchData = nil
local milityData = nil
local regionData = nil
local regionBaseData = nil
local regionMilitaryInfoData = nil
local regionConfig = nil
local FRIEND_COUNT = 4
UIController.id = nil
UIController.moveTimer = nil
UIController.recoveryTimer = nil
UIController.moveComplate = nil
UIController.friendsData = nil

function UIController:onCreat()
    self.View.CloseButton.onClick:Set(self.OnCloseButtonClick)
    self.View.RecoveryButton.onClick:Set(self.OnRecoveryButtonClick)
    self.View.CampsiteMoveButton.onClick:Set(self.OnMoveButtonClick)
    self.View.AddMilitary.onClick:Set(self.OnAddMilitaryClick)
    self.View.AddWarrior.onClick:Set(self.OnAddWarriorClick)

    Event.addListener(Event.CAMPSITE_REPAIR, self.OnCampRepair)
    Event.addListener(Event.CAMPSITE_UPDATE, self.SetData)
    Event.addListener(Event.CAMPSITE_PROPERITY, self.SetProsperity)
    Event.addListener(Event.DEFENSER_UPDATE, self.SetDefenceTroop)
    Event.addListener(Event.UPDATE_ASSIST, self.UpdateFriendTroops)
    Event.addListener(Event.REMOVE_ASSIST, self.RemoveFriendTroops)
    Event.addListener(Event.CAMP_BUILD_SPEEDUP, self.SetProsperity)
    Event.addListener(Event.WALL_DEFENSE_GARRISON_CHANGE, self.SetDefenceTroop)
    Event.addListener(Event.TROOP_ADD_SOLIDER_SUCCEED, self.SetDefenceTroop)
end

function UIController.OnCloseButtonClick()
    UIController:close()
end

function UIController.OnRecoveryButtonClick()
    NetworkManager.C2SRepairTend()
end

function UIController.OnTransportButtonClick()
    UIManager.openController(UIManager.ControllerName.TransportSoldiers)
end

function UIController.OnMoveButtonClick()
    if UIController.View.LBStateCtr.selectedIndex == 1 then --finish
        if monarchData.CampMap == 0 then
            -- 随机迁往同等级地区的非主城所在区
            local currentRegionType = regionData:getRegionTypeById(monarchData.BaseMapId)
            local regionSort = regionData:getRegionSort()
            local availableRegion = { }
            for i, v in ipairs(regionSort) do
                if currentRegionType == regionData:getRegionTypeById(v) then
                    if  v ~= monarchData.BaseMapId then
                        table.insert(availableRegion, v)
                    end
                end
            end
            local randomRegionIndex = math.random(1, #availableRegion)
            regionData:setSelectRegion(availableRegion[randomRegionIndex])
            Event.dispatch(Event.ENTER_OUTSIDE)
            UIController:close()
        else
            if regionData:getSelectRegion() == nil then
                regionData:setSelectRegion(monarchData.CampMap)
                Event.dispatch(Event.ENTER_OUTSIDE)
                UIController:close()
            else
                UIController:close()
            end
        end
    elseif UIController.View.LBStateCtr.selectedIndex == 0 then
        if UIController.id == monarchData.Id then
            -- 加速
            NetworkManager.CMiaoTentBuildingCd()
        else
            -- 显示迁徙完成才能攻打
            UIManager.showTip( { result = false, content = Localization.CampMoveNotComplate } )
        end
    else
        -- 显示迁徙完成可以出兵
        UIManager.showTip( { result = true, content = Localization.CampMoveComplate } )
    end
end

function UIController.OnAddMilitaryClick()
    local captainId = { }
    for k, v in pairs(milityData.Troops[monarchData.TentDefenseTroopId].Captains) do
        if v ~= 0 then
            table.insert(captainId, v)
        end
    end
    if #captainId <= 0 then
        UIManager.showTip( { content = Localization.TroopCaptainNum_1, result = false })
    else
        NetworkManager.C2SCaptainFullSoldierProto(captainId)
    end
end

function UIController.OnAddWarriorClick()
    -- 未配置防守队伍
    if milityData.CampDefencerList == nil or #milityData.CampDefencerList == 0 then
        UIManager.openController(UIManager.ControllerName.WallDefense)
    end
end

function UIController.OnCampRepair(id)
    if not UIController.IsOpen or UIController.id ~= id then
        return
    end
    -- 说明抢修材料足够修复行营
    if monarchData.CampProsperity == monarchData.CampProsperityMax then
        UIManager.showTip({ result = false, content = Localization.CampRepairMaterialNotEnough })
    else
        UIManager.showTip({ result = true, content = Localization.CampRepairFullProsperity })
    end
    UIController.SetProsperity(id)
end

function UIController:onOpen(id)
    self.id = id
    monarchData = DataTrunk.PlayerInfo.MonarchsData
    milityData = DataTrunk.PlayerInfo.MilitaryAffairsData
    regionData = DataTrunk.PlayerInfo.RegionData
    regionBaseData = DataTrunk.PlayerInfo.RegionBaseData
    regionMilitaryInfoData = DataTrunk.PlayerInfo.MilitaryInfoData
    regionConfig = RegionCommonConfig.Config
    
    self.SetData(id)
end

function UIController.SetData(id)
    if not UIController.IsOpen or UIController.id ~= id then
        return
    end
    UIController.InitFriendsData()
    UIController.SetProsperity(id)
    UIController.SetMoveInfo(id)
    UIController.SetDefenceTroop(id)
    UIController.SetFriendTroops(id)
end

function UIController.InitFriendsData()
    UIController.friendsData = { }
    local allWarSituationData = regionMilitaryInfoData.CurrMapMilitaryInfoList
    if Utils.GetTableLength(allWarSituationData) == 0 then
        allWarSituationData = regionMilitaryInfoData.MyAssistTroopsForCampsite
    end

    for k, v in pairs(allWarSituationData) do
        if v.Action == MilitaryActionType.Assist 
        and v.MoveType == MilitaryMoveType.Arrived
        and v.Target.Id == UIController.id then
            UIController.friendsData[v.CombineId] = v
        end
    end
end

function UIController.SetProsperity(id)
    if not UIController.IsOpen or UIController.id ~= id then
        return
    end
    if UIController.id == monarchData.Id then
        UIController.View.CampsiteFragment.visible = true
        UIController.View.RecoveryButton.visible = true
        -- 在主城打开的UI
        if regionData:getSelectRegion() == nil then
            -- 繁荣度没损失 不显示修复时间
            if monarchData.CampProsperity >= monarchData.CampProsperityMax then
                UIController.View.LBSwitchCtl.selectedIndex = 1
            else
                if recoveryTimer ~= nil then
                    TimerManager.disposeTimer(UIController.recoveryTimer)
                end
                if monarchData.CampRecoveryTime == 0 or TimerManager.currentTime - monarchData.CampRecoveryTime > 0 then
                    UIController.View.LBSwitchCtl.selectedIndex = 1
                else
                    UIController.View.LBSwitchCtl.selectedIndex = 0
                    local remainTime = math.abs(TimerManager.currentTime - monarchData.CampRecoveryTime)
                    remainTime = math.floor(remainTime + 0.5)
                    UIController.recoveryTimer = TimerManager.newTimer(remainTime, false, true, nil,
                        function(t, f)
                            UIController.View.FlourishTips.visible = true
                            UIController.View.FlourishTips.text = string.format(Localization.CampRecoveryDesc, tostring(Utils.secondConversion(math.floor(f))))
                        end,
                        function()
                            seUIControllerlf.View.FlourishTips.visible = false
                        end,
                        UIController, false)
                    UIController.recoveryTimer:start(remainTime) 
                end
            end
        else
            UIController.View.LBSwitchCtl.selectedIndex = 1
        end

        UIController.View.FlourishProgressBar.max = monarchData.CampProsperityMax
        UIController.View.FlourishProgressBar.value = monarchData.CampProsperity
        UIController.View.CampsiteFragment.text = string.format(Localization.CampRecoveryMaterial, monarchData.CampRepairAmount, monarchData.CampRepairTotal)
    else
        UIController.View.LBSwitchCtl.selectedIndex = 1
        UIController.View.CampsiteFragment.visible = false
        UIController.View.RecoveryButton.visible = false
        local currentRegion = nil
        if regionData:getSelectRegion() == nil then
            currentRegion = monarchData.BaseMapId
        else
            currentRegion = regionData:getSelectRegion()
        end
        local campData = regionBaseData:getBaseInfo(currentRegion, UIController.id)
        UIController.View.FlourishProgressBar.max = campData.ProsperityMax
        UIController.View.FlourishProgressBar.value = campData.Prosperity
    end
end

function UIController.SetMoveInfo(id)
    if not UIController.IsOpen or UIController.id ~= id then
        return
    end
    if UIController.id == monarchData.Id then
        -- 迁徙完成
        if monarchData.CampMoveTime == 0 or TimerManager.currentTime > monarchData.CampMoveTime then
            UIController.View.LBStateCtr.selectedIndex = 1
        else
            UIController.View.LBStateCtr.selectedIndex = 0
            if UIController.moveTimer ~= nil then
                TimerManager.disposeTimer(UIController.moveTimer)
            end
            local remainTime = math.abs(TimerManager.currentTime - monarchData.CampMoveTime)
            remainTime = math.floor(remainTime + 0.5)
            UIController.moveTimer = TimerManager.newTimer(remainTime, false, true, nil,
                function(t, f)
                    UIController.View.CampsiteMoveTimer.visible = true
                    UIController.View.CampsiteMoveTimer.text = Utils.secondConversion(math.floor(f))
                end,
                function()
                    UIController.View.CampsiteMoveTimer.visible = false
                    UIController.View.LBStateCtr.selectedIndex = 1
                end,
                UIController, false)
            UIController.moveTimer:start(remainTime)
        end
    else
        local currentRegion = nil
        if regionData:getSelectRegion() == nil then
            currentRegion = monarchData.BaseMapId
        else
            currentRegion = regionData:getSelectRegion()
        end
        local campData = regionBaseData:getBaseInfo(currentRegion, UIController.id)
        if campData.CampsiteValidTime == 0 or TimerManager.currentTime > campData.CampsiteValidTime then
            UIController.View.LBStateCtr.selectedIndex = 2
        else
            UIController.View.LBStateCtr.selectedIndex = 0
            if UIController.moveTimer ~= nil then
                TimerManager.disposeTimer(UIController.moveTimer)
            end
            local remainTime = math.abs(TimerManager.currentTime - campData.CampsiteValidTime)
            remainTime = math.floor(remainTime + 0.5)
            UIController.moveTimer = TimerManager.newTimer(remainTime, false, true, nil,
                function(t, f)
                    UIController.View.CampsiteMoveTimer.visible = true
                    UIController.View.CampsiteMoveTimer.text = Utils.secondConversion(math.floor(f))
                end,
                function()
                    UIController.View.CampsiteMoveTimer.visible = false
                    UIController.View.LBStateCtr.selectedIndex = 2
                end,
                UIController, false)
            UIController.moveTimer:start(remainTime)
        end
    end
end

function UIController.SetDefenceTroop(id)
    if not UIController.IsOpen or UIController.id ~= id then
        return
    end
    UIController.View.MyTroopsList:RemoveChildrenToPool()
    if UIController.id == monarchData.Id then
        UIController.View.AddMilitary.visible = true
        local power, troop = 0, 0
        if monarchData.TentDefenseTroopId == 0 then
            UIController.View.LTStateCtr.selectedIndex = 1
        else
            UIController.View.LTStateCtr.selectedIndex = 0
            for i, v in ipairs(milityData.Troops[monarchData.TentDefenseTroopId].Captains) do
                local captainData = milityData.Captains[v]
                if captainData ~= nil then
                    power = power + captainData.FightAmount
                    troop = troop + captainData.Soldier
                    local item = UIController.View.MyTroopsList:AddItemFromPool()
                    item.icon = UIConfig.Race[captainData.Race]
                end
            end

            UIController.View.Power.text = Localization.FightAmount .. power
            UIController.View.Troop.text = Localization.MilitaryAmount .. troop
        end
    else
        UIController.View.AddMilitary.visible = false
        local currentRegion = nil
        if regionData:getSelectRegion() == nil then
            currentRegion = monarchData.BaseMapId
        else
            currentRegion = regionData:getSelectRegion()
        end
        local campData = regionBaseData:getBaseInfo(currentRegion, UIController.id)
        if campData.Defenser == nil or campData.Defenser.captains == nil then
            UIController.View.LTStateCtr.selectedIndex = 2
        else
            local count, power, troop = 0, 0, 0
            UIController.View.LTStateCtr.selectedIndex = 0
            for i, v in ipairs(campData.Defenser.captains) do
                count = count + 1
                power = power + v.fight_amount
                troop = troop + v.soldier
                local item = UIController.View.MyTroopsList:AddItemFromPool()
                item.icon = UIConfig.Race[v.race]
            end

            UIController.View.Power.text = Localization.FightAmount .. power
            UIController.View.Troop.text = Localization.MilitaryAmount .. troop
            if count == 0 then
                UIController.View.LTStateCtr.selectedIndex = 2
            end
        end 
    end
end

function UIController.SetFriendTroops(id)
    UIController.View.FriendList:RemoveChildrenToPool()
    local friendCount = 0
    if UIController.friendsData ~= nil then
        for k, v in pairs(UIController.friendsData) do
            if v ~= nil then
                friendCount = friendCount + 1
                local item = UIController.View.FriendList:AddItemFromPool()
                item:GetChild("TextField_LordName").text = v.Self.Name
                local troopList = item:GetChild("List_Race")
                local fightAmount = 0
                local totalTroops = 0
                troopList:RemoveChildrenToPool()
                for k1, v1 in pairs(v.CaptainInfoList) do
                    if v1 ~= nil then
                        fightAmount = fightAmount + v1.FightAmount
                        totalTroops = totalTroops + v1.Soldier
                        if v1.RaceType ~= nil then
                            local troopItem = troopList:AddItemFromPool()
                            troopItem.icon = UIConfig.Race[v1.RaceType]
                        end
                    end
                end
                item:GetChild("TextField_Sword").text = Localization.FightAmount .. fightAmount
                item:GetChild("TextField_Troops").text = Localization.MilitaryAmount .. totalTroops
                if v.Target.Id == monarchData.Id then
                    item:GetController("Type_C").selectedIndex = 0
                    item:GetController("State_C").selectedIndex = 0
                    -- 遣返
                    item:GetChild("Button_Back").onClick:Set(function()
                        NetworkManager.C2SRepatriateProto(v.CombineId, true)
                    end)
                elseif v.Self.Id == monarchData.Id then
                    item:GetController("Type_C").selectedIndex = 0
                    item:GetController("State_C").selectedIndex = 1
                    -- 召回
                    item:GetChild("Button_Back").onClick:Set(function()
                        NetworkManager.C2SCancelInvasionProto(v.CombineId)
                    end)
                else
                    item:GetController("Type_C").selectedIndex = 2
                end
            end
        end
    end

    for i = friendCount + 1, FRIEND_COUNT do
        local item = UIController.View.FriendList:AddItemFromPool()
        item:GetController("Type_C").selectedIndex = 1
    end
end

function UIController.UpdateFriendTroops(id, data)
    if not UIController.IsOpen then
        return
    end

    if id == UIController.id and data.Action == MilitaryActionType.Assist and data.MoveType == MilitaryMoveType.Arrived then
        UIController.friendsData[data.CombineId] = data
    else
        UIController.friendsData[data.CombineId] = nil
    end
    UIController.SetFriendTroops(id)
end

function UIController.RemoveFriendTroops(id, combineId)
    if not UIController.IsOpen or UIController.id ~= id then
        return
    end
    UIController.friendsData[combineId] = nil
    UIController.SetFriendTroops(id)
end

function UIController:onClose()
    TimerManager.disposeTimer(UIController.moveTimer)
end

function UIController:onDestroy()
    self.View.CloseButton.onClick:Clear()
    self.View.RecoveryButton.onClick:Clear()
    self.View.CampsiteMoveButton.onClick:Clear()
    self.View.AddMilitary.onClick:Clear()
    self.View.AddWarrior.onClick:Clear()

    Event.removeListener(Event.CAMPSITE_REPAIR, self.OnCampRepair)
    Event.removeListener(Event.CAMPSITE_UPDATE, self.SetData)
    Event.removeListener(Event.CAMPSITE_PROPERITY, self.SetProsperity)
    Event.removeListener(Event.DEFENSER_UPDATE, self.SetDefenceTroop)
    Event.removeListener(Event.UPDATE_ASSIST, self.UpdateFriendTroops)
    Event.removeListener(Event.REMOVE_ASSIST, self.RemoveFriendTroops)
    Event.removeListener(Event.CAMP_BUILD_SPEEDUP, self.SetProsperity)
    Event.removeListener(Event.WALL_DEFENSE_GARRISON_CHANGE, self.SetDefenceTroop)
    Event.removeListener(Event.TROOP_ADD_SOLIDER_SUCCEED, self.SetDefenceTroop)
end