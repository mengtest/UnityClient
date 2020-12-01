local _C = UIManager.Controller(UIManager.ControllerName.TroopsEmbattle, UIManager.ViewName.TroopsEmbattle)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 同步回调
local syncInvoke = nil
-- 最后点击的阵形Id
local lastClickTroop = 1
-- 布阵编辑编队，目前共3支队伍（1-5，6-10，11-15）
local troopsEditList = { }
-- 初始槽位,目前共3支队伍（1-5，6-10，11-15）
local initSlotPos = { }
-- 军政实例化数据
local militaryAffairsInsData = DataTrunk.PlayerInfo.MilitaryAffairsData
-- 武将槽位个数
local captainSlotCount = 15
-- 每支队伍武将个数
local captainEachTroop = 5
-- 队伍个数
local theNumTroops = 3
-- 同步结束回掉
local syncCallBack = nil

-- 依据槽位获取编队id
local function getTroopIdBySlotId(slotId)
    return 1 + math.floor((slotId - 1) / captainEachTroop)
end

-- 同步结束回掉
local function syncTroopsFinish()
    if not _C.IsOpen then
        return
    end
    if nil ~= syncCallBack then
        syncCallBack()
        syncCallBack = nil
    end
end
-- 检测布阵更新
local function checkTroopsSync(syncCb)
    local isChange = false
    local updateIds = { }
    for i = 1, theNumTroops do
        for m = 1, captainEachTroop do
            local edit = troopsEditList[(i - 1) * captainEachTroop + m]
            if edit == nil then
                if militaryAffairsInsData.Troops[i].Captains[m] ~= 0 then
                    isChange = true
                end
                updateIds[(i - 1) * captainEachTroop + m] = 0
            else
                if militaryAffairsInsData.Troops[i].Captains[m] ~= edit.Id then
                    isChange = true
                end
                updateIds[(i - 1) * captainEachTroop + m] = edit.Id
            end
        end
    end
    -- 如果有更新，则同步
    if isChange then
        print("队形有更新！！!!!")
        syncCallBack = syncCb
        NetworkManager.C2SSetMultiCaptainIndexProto(0, updateIds)
    end

    return isChange
end
-- 返回
local function btnBack()
    local isChange = checkTroopsSync( function()
        if not _C.IsOpen then
            return
        end

        _C:close()
    end )

    -- 如果有更新，则同步
    if not isChange then
        print("队形无更新！！!!!")
        _C:close()
    end
end

-- 一键补兵
local function btnAddSolider(troopId)
    local slotId = 0
    local captainId = { }
    for i = 1, captainEachTroop do
        slotId =(troopId - 1) * captainEachTroop + i

        captainInfo = initSlotPos[slotId].target.insInfo
        if nil ~= captainInfo then
            table.insert(captainId, captainInfo.Id)
        end
    end
    if #captainId <= 0 then
        UIManager.showTip( { content = Localization.TroopCaptainNum_1, result = false })
    else
        NetworkManager.C2SCaptainFullSoldierProto(captainId)
    end
end

-- 槽位点击
local function clickItem(slot)
    local target = initSlotPos[slot].target;
    -- 槽位状态（0正常，1不可操作，2可上阵）
    if target.SlotStat.selectedIndex == 2 then
        -- 打开酒馆
        UIManager.openController(UIManager.ControllerName.Tavern)

        local isChange = checkTroopsSync(
        function()
            -- 打开酒馆
            UIManager.openController(UIManager.ControllerName.Tavern)
        end )

        -- 如果有更新，则同步
        if not isChange then
            print("队形无更新！！!!!")
            UIManager.openController(UIManager.ControllerName.Tavern)
        end
    end
end
-- 更新槽位信息信息
local function updateSlotCaptainInfo(slotId, info)
    -- 槽位保存
    initSlotPos[slotId].target.insInfo = info
    -- 获取槽位对象
    local general = initSlotPos[slotId].target
    general.SlotStat.selectedIndex = 0

    -- 出征状态
    general.Root.draggable = not(militaryAffairsInsData.Troops[getTroopIdBySlotId(slotId)].OutSide)
    if info == nil then
        general.SlotStat.selectedIndex = 2
    else
        -- 刷新
        general.Name.text = info.Name
        general.Level.text = tostring(info.Level)
        general.Head.url = info.Head
        general.SoliderType.url = UIConfig.Race[info.Race]

        -- 兵力和出征状态显示
        general.SoliderBar.max = info.MaxSoldier
        general.SoliderBar.value = info.Soldier
        general.OutSideTip.selectedIndex = 2

        -- 兵力判断和行动力展示
        if info.Soldier < info.MaxSoldier then
            general.OutSideTip.selectedIndex = 1
        elseif info.Mobility < info.MobilityNeed then
            general.OutSideTip.selectedIndex = 3
        end
    end
end

-- 更新队伍战斗力
local function updateTroopFight(troopId)
    local slotId = 0
    local totalFight = 0
    local captainInfo = nil
    for i = 1, captainEachTroop do
        slotId =(troopId - 1) * captainEachTroop + i

        captainInfo = initSlotPos[slotId].target.insInfo
        if nil ~= captainInfo then
            -- 获取战斗力
            totalFight = totalFight + captainInfo.FightAmount
        end
    end

    -- 战斗力
    view.Troops[troopId].Fight.text = Localization.FightAmount .. totalFight
end
-- 更新队伍出征状态
local function updateTroopExpeditionStat(troopId)
    -- 出征状态
    if militaryAffairsInsData.Troops[troopId].OutSide then
        view.Troops[troopId].ExpeditionStat.selectedIndex = 1
    else
        view.Troops[troopId].ExpeditionStat.selectedIndex = 0
    end
end
-- 更新队伍信息
local function updateAllTroopInfo()
    if not _C.IsOpen then
        return
    end
    -- 更新15个武将
    for i = 1, captainSlotCount do
        updateSlotCaptainInfo(i, troopsEditList[i])
    end
    -- 更新三支队伍战斗力和出征状态
    for i = 1, theNumTroops do
        updateTroopFight(i)
        updateTroopExpeditionStat(i)
    end
end
-- 是否为出征队伍
local function checkIsOutSideTroop(slotId)

end
-- 检测是否在此范围
local function checkItemInRange(slotId)
    local otherId = slotId
    local pos = initSlotPos[slotId].target.Root.position
    for i = 1, captainSlotCount do
        if i ~= slotId and pos.x >= initSlotPos[i].range.x and pos.x <= initSlotPos[i].range.y and pos.y >= initSlotPos[i].range.z and pos.y <= initSlotPos[i].range.w then
            otherId = i
            break
        end
    end

    -- 是否为出征队伍
    if view.Troops[getTroopIdBySlotId(otherId)].ExpeditionStat.selectedIndex == 1 then
        otherId = slotId
    end

    return otherId
end
-- 槽位拖拽
local function startDragItem(target)
    CS.LPCFramework.LogicUtils.SetSortingLayer(target.displayObject.gameObject.transform, SortingLayerId.Layer1)
end
-- 槽位拖拽
local function endDragItem(id)
    -- 渲染顺序
    CS.LPCFramework.LogicUtils.SetSortingLayer(initSlotPos[id].target.Root.displayObject.gameObject.transform, SortingLayerId.Default)
    local otherId = checkItemInRange(id)
    -- 交互槽位
    if otherId ~= id then
        -- 对象互换
        local target = initSlotPos[otherId].target
        initSlotPos[otherId].target = initSlotPos[id].target
        initSlotPos[id].target = target
        -- 编队互换
        local insInfo = troopsEditList[otherId]
        troopsEditList[otherId] = troopsEditList[id]
        troopsEditList[id] = insInfo
        -- 槽位互换
        initSlotPos[id].target.SlotId = id
        initSlotPos[otherId].target.SlotId = otherId
        -- 位置更改
        initSlotPos[otherId].target.Root:TweenMoveX(initSlotPos[otherId].initPos.x, 0.1);
        initSlotPos[otherId].target.Root:TweenMoveY(initSlotPos[otherId].initPos.y, 0.1);
        -- 更新战斗力
        local troopId1, troopId2 = getTroopIdBySlotId(id), getTroopIdBySlotId(otherId)
        if troopId1 ~= troopId2 then
            updateTroopFight(troopId1)
            updateTroopFight(troopId2)
        end
    end

    -- 缓动	
    initSlotPos[id].target.Root:TweenMoveX(initSlotPos[id].initPos.x, 0.1);
    initSlotPos[id].target.Root:TweenMoveY(initSlotPos[id].initPos.y, 0.1);
end

-- 获取队伍武将信息
local function getTroopsCaptainInfo()
    -- 获取队伍武将信息
    for k, v in pairs(militaryAffairsInsData.Troops) do
        for i = 1, captainEachTroop do
            if v.Captains[i] == 0 then
                troopsEditList[(v.TroopId - 1) * captainEachTroop + i] = nil
            else
                troopsEditList[(v.TroopId - 1) * captainEachTroop + i] = militaryAffairsInsData.Captains[v.Captains[i]]
            end
        end
    end
end

function _C:onCreat()
    view = _C.View

    -- 长度
    local heightHalf = view.Captains[1].Root.height * 0.5
    local widthHalf = view.Captains[1].Root.width * 0.5

    for i = 1, captainSlotCount do
        -- 初始槽位目标
        view.Captains[i].SlotId = i

        initSlotPos[i] = { }
        -- 初始目标
        initSlotPos[i].target = view.Captains[i]
        -- 初始位置
        initSlotPos[i].initPos = view.Captains[i].Root.position
        -- 范围计算
        initSlotPos[i].range = CS.UnityEngine.Vector4(initSlotPos[i].initPos.x - widthHalf, initSlotPos[i].initPos.x + widthHalf, initSlotPos[i].initPos.y - heightHalf, initSlotPos[i].initPos.y + heightHalf)
        -- 拖拽监听
        view.Captains[i].Root.onDragStart:Add( function() startDragItem(view.Captains[i].Root) end)
        view.Captains[i].Root.onDragEnd:Add( function() endDragItem(view.Captains[i].SlotId) end)
        -- 点击监听
        view.Captains[i].Root.onClick:Add( function() clickItem(view.Captains[i].SlotId) end)
    end

    for i = 1, 3 do
        view.Troops[i].BtnAddSolider.onClick:Add( function() btnAddSolider(i) end)
    end

    view.BtnBack.onClick:Add(btnBack)

    Event.addListener(Event.TROOP_ADD_SOLIDER_SUCCEED, updateAllTroopInfo)
    Event.addListener(Event.TROOP_OUTSIDE_UPDATE, updateAllTroopInfo)
    Event.addListener(Event.TROOP_SYNC_ACK, syncTroopsFinish)
    Event.addListener(Event.TROOP_SYNC_FAILURE, syncTroopsFinish)
end

function _C:onShow()
    getTroopsCaptainInfo()
    updateAllTroopInfo()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    for i = 1, captainSlotCount do
        view.Captains[i].Root.onDragStart:Clear()
        view.Captains[i].Root.onDragEnd:Clear()
    end

    Event.removeListener(Event.TROOP_ADD_SOLIDER_SUCCEED, updateAllTroopInfo)
    Event.removeListener(Event.TROOP_OUTSIDE_UPDATE, updateAllTroopInfo)
    Event.removeListener(Event.TROOP_SYNC_ACK, close)
    Event.removeListener(Event.TROOP_SYNC_FAILURE, close)
end
