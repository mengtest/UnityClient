local _C = UIManager.SubController(UIManager.ControllerName.TroopsSelect, UIManager.ViewName.TroopsSelect)

-- 战力显示方式(0表示真是战力，1战力以最高值显示)
_C.fightAmountShowType = 0
-- 换阵回调
_C.switchTroopCallBack = nil

-- view
local view = nil
-- 同步回调
local syncInvoke = nil
-- 最后点击的阵形Id
local lastClickTroop = 1
-- 武将槽位个数
local captainSlotCount = 5
-- 布阵编辑编队，目前共3支队伍（1-5，6-10，11-15）
local troopsEditList = { }
-- 初始槽位
local initSlotPos = { }
-- 军政实例化数据
local militaryAffairsInsData = DataTrunk.PlayerInfo.MilitaryAffairsData

local isMobilityNotEnough = false

-- 设置初始队伍信息
local function setTroopsCaptainInfo()
    for k, v in pairs(militaryAffairsInsData.Troops) do
        for i = 1, captainSlotCount do
            if v.Captains[i] == 0 then
                troopsEditList[(v.TroopId - 1) * captainSlotCount + i] = nil
            else
                troopsEditList[(v.TroopId - 1) * captainSlotCount + i] = militaryAffairsInsData.Captains[v.Captains[i]]
            end
        end
    end
end
-- 布阵同步结束
local function onTroopCaptainsSyncAck()
    if not _C.IsShow then
        return
    end
    if nil ~= syncInvoke then
        setTroopsCaptainInfo()
        syncInvoke()
        syncInvoke = nil
    end
end

-- 获取当前队伍Id
local function getTroopIndex(slotId)
    return(lastClickTroop - 1) * captainSlotCount + slotId
end
-- 保存槽位武将
local function saveTroopSlotInfo(slot, index)
    troopsEditList[index] = initSlotPos[slot].target.insInfo
end
-- 更新队伍战斗力
local function updateTroopFightAmount()
    local count = 0
    for i = 1, captainSlotCount do
        if initSlotPos[i].target.SlotStat.selectedIndex == 0 and nil ~= initSlotPos[i].target.insInfo then
            if _C.fightAmountShowType == 0 then
                count = count + initSlotPos[i].target.insInfo.FightAmount
            else
                count = count + initSlotPos[i].target.insInfo.FullSoldierFightAmount
            end
        end
    end
    -- 更新
    view.FightAmount.text = Localization.FightAmount .. tostring(count)
end
-- 更新指定槽位武将信息
local function updateTroopSlotInfo(slot, index, info)
    -- 编队保存
    troopsEditList[index] = info
    -- 槽位保存
    initSlotPos[slot].target.insInfo = info
    -- 状态
    local general = initSlotPos[slot].target
    general.SlotStat.selectedIndex = 0

    -- 出征状态
    general.Root.draggable = not militaryAffairsInsData.Troops[lastClickTroop].OutSide

    if info == nil then
        general.SlotStat.selectedIndex = 2
    else
        -- 刷新
        general.Name.text = info.Name
        general.Level.text = tostring(info.Level)
        general.Head.url = info.Head
        general.SoliderType.url = UIConfig.Race[info.Race]
        general.SoliderBar.max = info.MaxSoldier

        -- 兵力显示
        general.SoliderBar.value = info.MaxSoldier
        general.OutSideTip.selectedIndex = 2

        if _C.fightAmountShowType == 0 then
            general.SoliderBar.value = info.Soldier
            -- 出征状态
            if info.Soldier < info.MaxSoldier then
                general.OutSideTip.selectedIndex = 1
                -- 行动力展示
            elseif info.Mobility < info.MobilityNeed then
                general.OutSideTip.selectedIndex = 3
            end
            isMobilityNotEnough = isMobilityNotEnough or info.Mobility < info.MobilityNeed
        end
    end
    -- 更新战斗力
    updateTroopFightAmount()
end
-- 更新所有武将信息
local function updateTroopAllSlotInfo()
    if not _C.IsShow then
        return
    end

    local index =(lastClickTroop - 1) * captainSlotCount
    for i = 1, captainSlotCount do
        updateTroopSlotInfo(i, index + i, troopsEditList[index + i])
        -- 出征状态
        if militaryAffairsInsData.Troops[lastClickTroop].OutSide then
            view.ExpeditionStat.selectedIndex = 1
        else
            view.ExpeditionStat.selectedIndex = 0
        end
    end
end

-- 槽位点击
local function clickItem(slot)
    local target = initSlotPos[slot].target;
    -- 槽位状态（0正常，1不可操作，2可上阵）
    local slotStat = target.SlotStat.selectedIndex
    if slotStat == 2 then
        -- 进入酒馆招募武将
        _C:c2sTroopsSync(
        function()
            -- 打开酒馆
            UIManager.openController(UIManager.ControllerName.Tavern)
        end
        )
    end
end
-- 槽位拖拽
local function startDragItem(target)
    CS.LPCFramework.LogicUtils.SetSortingLayer(target.displayObject.gameObject.transform, SortingLayerId.Layer1)
end
-- 槽位拖拽
local function endDragItem(id)
    local otherId = id
    local pos = initSlotPos[id].target.Root.position
    for i = 1, captainSlotCount do
        if pos.y <= initSlotPos[i].range then
            otherId = i
            break
        end
    end

    -- 渲染顺序
    CS.LPCFramework.LogicUtils.SetSortingLayer(initSlotPos[id].target.Root.displayObject.gameObject.transform, SortingLayerId.Default)
    -- 交互槽位
    if otherId ~= id then
        -- 对象互换
        local target = initSlotPos[otherId].target
        initSlotPos[otherId].target = initSlotPos[id].target
        initSlotPos[id].target = target
        -- 编队互换
        local insInfo = troopsEditList[getTroopIndex(otherId)]
        troopsEditList[getTroopIndex(otherId)] = troopsEditList[getTroopIndex(id)]
        troopsEditList[getTroopIndex(id)] = insInfo
        -- 槽位互换
        initSlotPos[id].target.SlotId = id
        initSlotPos[otherId].target.SlotId = otherId
        -- 位置更改
        initSlotPos[otherId].target.Root.position = initSlotPos[otherId].initPos
    end

    -- 缓动	
    initSlotPos[id].target.Root:TweenMoveY(initSlotPos[id].initPos.y, 0.1);
end
-- 切换队伍
local function btnToSwitchTroop(id)
    -- 切换阵形
    local switchTroop = function()
        print("阵形！！", id)

        -- 更新当前阵形
        lastClickTroop = id
        updateTroopAllSlotInfo()

        -- 换阵回调
        if nil ~= _C.switchTroopCallBack then
            _C.switchTroopCallBack()
        end
    end

    -- 同步上一队伍
    _C:c2sTroopsSync(switchTroop)
end

function _C:onCreat()
    view = _C.View

    -- 信息存储
    lastClickTroop = 1
    initSlotPos = { }

    local heightHalf = view.Captains[1].Root.height * 0.5
    -- 初始槽位目标
    for i = 1, captainSlotCount do
        initSlotPos[i] = { }
        -- 设置槽位目标
        initSlotPos[i].target = view.Captains[i]
        -- 槽位初始位置
        initSlotPos[i].initPos = view.Captains[i].Root.position
        -- 范围计算
        initSlotPos[i].range = initSlotPos[i].initPos.y + heightHalf

        -- 设置槽位id
        view.Captains[i].SlotId = i
        -- 拖拽监听
        view.Captains[i].Root.onDragStart:Add( function() startDragItem(view.Captains[i].Root) end)
        view.Captains[i].Root.onDragEnd:Add( function() endDragItem(view.Captains[i].SlotId) end)
        -- 点击监听
        view.Captains[i].Root.onClick:Add( function() clickItem(view.Captains[i].SlotId) end)
    end

    -- 添加监听	
    view.BtnTroop_1.onClick:Add( function() btnToSwitchTroop(1) end)
    view.BtnTroop_2.onClick:Add( function() btnToSwitchTroop(2) end)
    view.BtnTroop_3.onClick:Add( function() btnToSwitchTroop(3) end)

    Event.addListener(Event.TROOP_SYNC_ACK, onTroopCaptainsSyncAck)
    Event.addListener(Event.TROOP_SYNC_FAILURE, onTroopCaptainsSyncAck)
    Event.addListener(Event.TROOP_ADD_SOLIDER_SUCCEED, updateTroopAllSlotInfo)
    Event.addListener(Event.TROOP_OUTSIDE_UPDATE, updateTroopAllSlotInfo)
end

function _C:onShow()
    local rect = view.UI:TransformRect(CS.UnityEngine.Rect(0, 0, view.UI.width, view.UI.height), GRoot.inst);
    for k, v in pairs(view.Captains) do
        v.Root.dragBounds = rect
    end

    setTroopsCaptainInfo()
    btnToSwitchTroop(lastClickTroop)
end

function _C:onDestroy()
    if nil == view then
        return
    end
    view.BtnTroop_1.onClick:Clear()
    view.BtnTroop_2.onClick:Clear()
    view.BtnTroop_3.onClick:Clear()

    for i = 1, captainSlotCount do
        initSlotPos[i] = { }
        view.Captains[i].Root:RemoveEventListeners()
    end

    Event.removeListener(Event.TROOP_SYNC_ACK, onTroopCaptainsSyncAck)
    Event.removeListener(Event.TROOP_SYNC_FAILURE, onTroopCaptainsSyncAck)
    Event.removeListener(Event.TROOP_ADD_SOLIDER_SUCCEED, updateTroopAllSlotInfo)
    Event.removeListener(Event.TROOP_OUTSIDE_UPDATE, updateTroopAllSlotInfo)
end

-- 清理
function _C:clear()
    _C.fightAmountShowType = 0
    _C.switchTroopCallBack = nil
end

-- 当前队伍Id
function _C:getCurTroopId()
    return lastClickTroop
end
-- 获取当前布阵武将(不含槽位为空情况)
function _C:getCurTroopCaptains_1()
    local generalId = { }
    for i = 1, captainSlotCount do
        if initSlotPos[i].target.insInfo ~= nil then
            table.insert(generalId, initSlotPos[i].target.insInfo.Id)
        end
    end

    return generalId
end
-- 获取当前布阵武将(含槽位为空情况)
function _C:getCurTroopCaptains_2()
    local generalId = { }
    local count = 0
    for i = 1, captainSlotCount do
        if initSlotPos[i].target.insInfo ~= nil then
            count = count + 1
            table.insert(generalId, initSlotPos[i].target.insInfo.Id)
        else
            table.insert(generalId, 0)
        end
    end

    return count, generalId
end
-- 布阵信息同步
function _C:c2sTroopsSync(ackInvoke)
    local isChange = false
    local updateIds = { }
    local troopsIns = militaryAffairsInsData.Troops[lastClickTroop].Captains

    -- 检测是否有更新
    for slotId = 1, captainSlotCount do
        local id = getTroopIndex(slotId)
        local edit = troopsEditList[id]
        if edit == nil then
            if troopsIns[slotId] ~= 0 then
                isChange = true
            end
            updateIds[slotId] = 0
        else
            if troopsIns[slotId] ~= edit.Id then
                isChange = true
            end
            updateIds[slotId] = edit.Id
        end
    end

    -- 如果有更新，则同步
    if isChange then
        print("队形有更新！！")
        -- 同步结束回调
        syncInvoke = ackInvoke

        -- index序号，0表示全改 一队发1，二队发2，3队发3
        NetworkManager.C2SSetMultiCaptainIndexProto(lastClickTroop, updateIds)
    else
        print("队形无更新！！")
        if nil ~= ackInvoke then
            ackInvoke()
        end
    end
end

function _C:IsMobilityNotEnough()
    return isMobilityNotEnough
end
return _C