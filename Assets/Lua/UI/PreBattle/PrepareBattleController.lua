local _C = UIManager.Controller(UIManager.ControllerName.PreBattle, UIManager.ViewName.PreBattle)
local _CTroop = require(UIManager.ControllerName.TroopsSelect)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CTroop)
table.insert(_C.SubCtrl, _CchatBrief)

-- 战前部署信息（BattleDeploymentInfo类进行实例化操作）
local battleDeploymentInfo = nil
-- 布阵信息
local embattleInfo = { FightAmountShowType = 0, BattleTargetRace = nil }
-- 武将信息
local militaryAffairsData = DataTrunk.PlayerInfo.MilitaryAffairsData
-- view
local view = nil

-- 返回
local function btnToBack()
    -- 保存更改
    _CTroop:c2sTroopsSync( function() _C:close() end)
end
-- 布阵
local function btnToTroopsEmbattle()
    _CTroop:c2sTroopsSync( function()
        -- 打开布阵
        UIManager.openController(UIManager.ControllerName.TroopsEmbattle)
    end )
end
-- 一键补兵
local function btnToAddSolider()
    local captainId = _CTroop:getCurTroopCaptains_1()
    if captainId == nil or #captainId == 0 then
        UIManager.showTip( { content = Localization.TroopCaptainNum_1, result = false })
    else
        NetworkManager.C2SCaptainFullSoldierProto(captainId)
    end
end
-- 出征目标选择
local function btnToExpeditionTarget()
    UIManager.openController(UIManager.ControllerName.ExpeditionTarget)
end
-- 防御方面板选择
local function btnToChangeDefenderPanel()
    if view.ShowStat.selectedIndex == 3 then
        view.ShowStat.selectedIndex = 4
    elseif view.ShowStat.selectedIndex == 4 then
        view.ShowStat.selectedIndex = 3
    elseif view.ShowStat.selectedIndex == 7 then
        view.ShowStat.selectedIndex = 8
    elseif view.ShowStat.selectedIndex == 8 then
        view.ShowStat.selectedIndex = 7
    end
end
-- 开始出征
local function btnToExpedition()
    if _CTroop:IsMobilityNotEnough() then
        UIManager.showTip( { content = Localization.MobilityNotEnough, result = false })
        return
    end
    -- 出征
    local doExpedition = function()
        -- 获取阵上武将
        local count, captainId = _CTroop:getCurTroopCaptains_2()
        -- 武将个数判断
        if count == 0 then
            UIManager.showTip( { content = Localization.TroopCaptainNum_1, result = false })
            return
        end
        -- 带兵数判断(0表示真实战力)
        if battleDeploymentInfo.FightAmountShowType == 0 then
            for k, v in pairs(captainId) do
                if v ~= 0 and militaryAffairsData.Captains[v].Soldier <= 0 then
                    UIManager.showTip( { content = Localization.TroopCaptainNum_2, result = false })
                    return
                end
            end
        end
        -- 回调
        if nil ~= battleDeploymentInfo.ToCombat then
            if battleDeploymentInfo.ToCombat(captainId, count, view.BtnIsGuild.selected, _CTroop:getCurTroopId()) then
                -- 关闭此界面
                btnToBack()
            end
        end
    end
    -- 保存更改
    _CTroop:c2sTroopsSync(doExpedition)
end

-- 更新面板信息
local function updatePanelInfo()
    if nil == battleDeploymentInfo then
        error("出征数据为空！！！")
    end

    -- pvp出征
    if battleDeploymentInfo.Type == BattleDeploymentType.PVP_Invasion or
        -- pvp援助
        battleDeploymentInfo.Type == BattleDeploymentType.PVP_Assist or
        -- pvp自己驱逐
        battleDeploymentInfo.Type == BattleDeploymentType.PVP_Expel_ForSelf or
        -- pvp盟友驱逐
        battleDeploymentInfo.Type == BattleDeploymentType.PVP_Expel_ForFriend
    then
        view.ShowStat.selectedIndex = 1
    end

    -- pve千重楼
    if battleDeploymentInfo.Type == BattleDeploymentType.PVE_ClimbingTower or
        -- pve剧情副本
        battleDeploymentInfo.Type == BattleDeploymentType.PVE_Plot or
        -- pve百战千军
        battleDeploymentInfo.Type == BattleDeploymentType.PVE_Battle100
    then
        view.ShowStat.selectedIndex = 5
    end

    -- pve重楼密室
    if battleDeploymentInfo.Type == BattleDeploymentType.PVE_TowerBackroom
    then
        view.ShowStat.selectedIndex = 9
    end

    -- 奖励显示
    if nil ~= battleDeploymentInfo.Awards then
        view.AwardList.numItems = #battleDeploymentInfo.Awards
    else
        view.AwardList.numItems = 0
    end
    if view.AwardList.numItems > 1 then
        view.AwardListStat.selectedIndex = 1
    else
        view.AwardListStat.selectedIndex = 0
    end

    -- 君主信息
    if nil ~= battleDeploymentInfo.Monarch then
        view.DefenderName_1.text = Localization.TargetName .. battleDeploymentInfo.Monarch.Name
        view.DefenderFinghtAmount.text = Localization.FightAmount .. battleDeploymentInfo.Monarch.FightAmount
        view.DefenderHead.url = battleDeploymentInfo.Monarch.Head.SmallIcon
        view.DefenderName.text = battleDeploymentInfo.Monarch.Name
        view.DefenderGuild.text = Localization.Guild .. battleDeploymentInfo.Monarch.Guild
        view.DefenderLevel.text = Localization.Level .. battleDeploymentInfo.Monarch.Level
        view.DefenderMainCityLevel.text = Localization.MaincityLv .. battleDeploymentInfo.Monarch.MainCityLevel
        view.DefenderTowerFloor.text = Localization.Tower_1 .. battleDeploymentInfo.Monarch.TowerFloor
        view.DefenderRank.text = Localization.Rank .. battleDeploymentInfo.Monarch.Rank
    end

    -- 出征信息
    if nil ~= battleDeploymentInfo.Expedition then
        view.TargetName.text = battleDeploymentInfo.Expedition.Name
        view.TargetPos.text = string.format("%d,%d", battleDeploymentInfo.Expedition.PosX, battleDeploymentInfo.Expedition.PosY)
        view.TargetTime.text = Utils.secondConversion(battleDeploymentInfo.Expedition.Time)
    end

    -- 军队信息
    if nil ~= battleDeploymentInfo.Troops then
        refreshCaptain = function(slot, info, item)
            if nil == info then
                item.SlotStat.selectedIndex = 1
                embattleInfo.BattleTargetRace[slot] = 0
            else
                embattleInfo.BattleTargetRace[slot] = info.Race
                item.SlotStat.selectedIndex = 0

                -- 刷新
                item.Head.url = info.Head
                item.Name.text = info.Name
                item.Level.text = string.format(Localization.Level_1, info.Level)
                item.SoliderBar.max = info.MaxSolider
                item.SoliderBar.value = info.Solider
                item.SoliderType.url = UIConfig.Race[info.Race]
            end
        end
        embattleInfo.BattleTargetRace = { }
        refreshCaptain(1, battleDeploymentInfo.Troops[1], view.DefenderSlot_1)
        refreshCaptain(2, battleDeploymentInfo.Troops[2], view.DefenderSlot_2)
        refreshCaptain(3, battleDeploymentInfo.Troops[3], view.DefenderSlot_3)
        refreshCaptain(4, battleDeploymentInfo.Troops[4], view.DefenderSlot_4)
        refreshCaptain(5, battleDeploymentInfo.Troops[5], view.DefenderSlot_5)
    else
        embattleInfo.BattleTargetRace = nil
    end

    -- 重楼密室
    if nil ~= battleDeploymentInfo.Backroom then
        view.BtnIsGuild.selected = false
        view.BtnIsGuild.visible = battleDeploymentInfo.Backroom.IsCreatTroop
        view.BackroomId.text = string.format(Localization.BackroomFloorId, battleDeploymentInfo.Backroom.FloorId)
        view.BackroomPlayerNum.text = string.format(Localization.BackroomPlayerNum, battleDeploymentInfo.Backroom.MinPlayerNum, battleDeploymentInfo.Backroom.MaxPlayerNum)
        view.BackroomTroopsNum.text = string.format(Localization.BackroomDefenderTroopsNum, battleDeploymentInfo.Backroom.TroopsNum)
        view.BackroomContinueWinNum.text = string.format(Localization.BackroomContinueWinNum, battleDeploymentInfo.Backroom.MaxContinueNum)
    end
end

-- 道具点击
local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    -- 弹出道具面板
    UIManager.openController(UIManager.ControllerName.ItemTips, battleDeploymentInfo.Awards[index + 1])
end
-- 道具滚动
local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index)

    local itemInfo = battleDeploymentInfo.Awards[index + 1]
    -- 刷新数据
    obj:GetController("State_C").selectedIndex = 1
    obj:GetController("Count_C").selectedIndex = 1
    obj:GetController("CornerMark_C").selectedIndex = 0

    obj:GetChild("title").text = itemInfo.Amount
    obj:GetChild("icon").url = itemInfo.Config.Icon

    -- 角标
    if itemInfo.CornerType == ItemCornerType.Noraml then
        obj:GetController("CornerMark_C").selectedIndex = 0
    elseif itemInfo.CornerType == ItemCornerType.FirstWin then
        obj:GetController("CornerMark_C").selectedIndex = 1
    elseif itemInfo.CornerType == ItemCornerType.Prob then
        obj:GetController("CornerMark_C").selectedIndex = 2
    end

    -- 品质
    if itemInfo.ClassifyType == ItemClassifyType.Equip then
        obj:GetChild("quality").url = UIConfig.Item.EquipQuality[itemInfo.Config.Quality.Level]
    else
        obj:GetChild("quality").url = UIConfig.Item.DefaultQuality[itemInfo.Config.Quality]
    end
end

function _C:onCreat()
    view = _C.View

    view.BtnBack.onClick:Add(btnToBack)
    view.BtnEmbattle.onClick:Add(btnToTroopsEmbattle)
    view.BtnExpedition.onClick:Add(btnToExpedition)
    view.BtnAddSolider.onClick:Add(btnToAddSolider)
    view.BtnChoseTarget.onClick:Add(btnToExpeditionTarget)
    view.BtnDefenderPanel.onClick:Add(btnToChangeDefenderPanel)

    view.AwardList.itemRenderer = onItemRender
    view.AwardList.onClickItem:Add(onItemClick)
end

function _C:onOpen(data)
    -- 出征对象数据
    battleDeploymentInfo = data
    -- 刷新备战数据
    updatePanelInfo()
end

function _C:onShow()
    -- 0进入布阵
    _CTroop:clear()
    _CTroop.fightAmountShowType = battleDeploymentInfo.FightAmountShowType
    _CTroop:setParent(view.AttackTroopSlot)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnEmbattle.onClick:Clear()
    view.BtnExpedition.onClick:Clear()
    view.BtnAddSolider.onClick:Clear()
    view.BtnChoseTarget.onClick:Clear()
    view.BtnDefenderPanel.onClick:Clear()

    view.AwardList.itemRenderer = nil
    view.AwardList.onClickItem:Clear()
end
