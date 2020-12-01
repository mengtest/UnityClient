local UIController = UIManager.Controller(UIManager.ControllerName.WarSituationActorAssistance, UIManager.ViewName.WarSituationActorAssistance)

local assistSituations = nil
local assistTargetId = nil
local timer = nil

function UIController:onCreat()
    self.View.Bg.onClick:Set(self.OnBgClick)
    Event.addListener(Event.ON_CURRENT_MAP_MILITARY_UPDATED, self.OnSituationUpdate)
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
    assistTargetId = targetId
    self:refreshWarSituation(targetId)
    self:refreshListItem()
end

function UIController:refreshWarSituation()
    assistSituations = { }
    local militaryInfo = DataTrunk.PlayerInfo.MilitaryInfoData.CurrMapMilitaryInfoList
    for k, v in pairs(militaryInfo) do
        if v ~= nil and v.Target ~= nil and v.Target.Id == assistTargetId 
            and v.Action == MilitaryActionType.Assist and v.MoveType == MilitaryMoveType.Arrived then
            table.insert(assistSituations, v)
        end
    end
end

function UIController:refreshListItem()
    self.View.List:RemoveChildrenToPool()
    if #assistSituations == 0 then
        self:OnBgClick()
        return
    end
    
    for i, v in ipairs(assistSituations) do
        local item = self.View.List:AddItemFromPool()
        local playerNameCom = item:GetChild("com_title")
        if v.Self.GuildId == 0 then
            playerNameCom:GetChild("title").text = v.Target.Name
        else
            playerNameCom:GetChild("title").text = "[" .. v.Self.GuildFlagName .. "]" .. v.Self.Name
        end

        playerNameCom.onClick:Set( function()
            UIManager.openController(UIManager.ControllerName.Lords, assistSituations[i].Self)
            end )
        local troopsList = item:GetChild("list_zhenying")
        troopsList:RemoveChildrenToPool()
        local fightAmount = 0
        local totalTroops = 0
        local currentTroops = 0
        for k, v in pairs(v.CaptainInfoList) do
            if v ~= nil then
                fightAmount = fightAmount + v.FightAmount
                totalTroops = totalTroops + v.Soldier
                currentTroops = currentTroops + v.TotalSoldier
                if v.RaceType ~= nil then
                    local item = troopsList:AddItemFromPool()
                    item.icon = UIConfig.Race[v.RaceType]
                end
            end
        end
        item:GetChild("txt_zhanli").text = fightAmount
        local troopsPower = item:GetChild("progress_bingli")
        troopsPower.max = totalTroops
        troopsPower.value = currentTroops

        local timerIcon = item:GetChild("image_time")
        local timerText = item:GetChild("txt_jishi")
        if timer == nil then
            timer = { }
        end
        if timer[i + 1] ~= nil then
            TimerManager.disposeTimer(timer[i + 1])
        end
        local remainSeconds = math.abs(TimerManager.currentTime - assistSituations[i].MoveArrivedTime)
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

        local VisibleCtr = item:GetController("Visible_C")
        local DescCtr = item:GetController("Desc_C")
        if DataTrunk.PlayerInfo.MonarchsData.Id == assistTargetId then
            DescCtr.selectedIndex = 0
            VisibleCtr.selectedIndex = 0
            -- 遣返
            item:GetChild("btn_zhuzha").onClick:Set( function()
                NetworkManager.C2SRepatriateProto(assistSituations[i].CombineId, assistSituations[i].TargetIsCamp)
            end)
        elseif DataTrunk.PlayerInfo.MonarchsData.Id == assistSituations[i].Self.Id then
            DescCtr.selectedIndex = 1
            VisibleCtr.selectedIndex = 0
            -- 召回
            item:GetChild("btn_zhuzha").onClick:Set( function() 
                NetworkManager.C2SCancelInvasionProto(assistSituations[i].CombineId)
            end)
        else
            -- 隐藏
            VisibleCtr.selectedIndex = 1
        end
        
        local defeatCtr = item:GetController("jitui")
        if assistSituations[i].KillEnemies ~= nil then
            defeatCtr.selectedIndex = 0
            local record1 = item:GetChild("txt_wanjiaming1")
            local record2 = item:GetChild("txt_wanjiaming2")
            local record3 = item:GetChild("txt_wanjiaming3")
            if assistSituations[i].KillEnemies[1] ~= nil then
                record1.visible = true
                record1.text = assistSituations[i].KillEnemies[1]
            else
                record1.visible = false
            end
            if assistSituations[i].KillEnemies[2] ~= nil then
                record2.visible = true
                record2.text = assistSituations[i].KillEnemies[2]
            else
                record2.visible = false
            end
            if assistSituations[i].KillEnemies[3] ~= nil then
                record3.visible = true
                record3.text = assistSituations[i].KillEnemies[3]
            else
                record3.visible = false
            end

        else
            defeatCtr.selectedIndex = 1
        end
    end
end

function UIController:onDestroy()
    self.View.Bg.onClick:Clear()
    assistSituations = nil
    assistTargetId = nil
    for i, v in ipairs(timer) do
        TimerManager.disposeTimer(v)
    end
    timer = nil
    Event.removeListener(Event.ON_CURRENT_MAP_MILITARY_UPDATED, self.OnSituationUpdate)
end

return UIController 