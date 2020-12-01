local _C = UIManager.SubController(UIManager.ControllerName.MainCityBuilders, nil)
_C.view = nil

local view = nil
-- 内政数据
local internalData = DataTrunk.PlayerInfo.InternalAffairsData

-- 计时结束
local BuildersTimerComplete = nil

-- 工人计时器(building_1/tech_1)
local buildersTimer = { }

-- builderType:0 建筑队 1 科技队
local function UpdateData(builderType)
    local buildersData = nil

    if builderType == 0 then
        buildersData = internalData.BuildersTimeoutInfo
    else
        buildersData = internalData.TechnicianTimeOutInfo
    end

    for i = 1, #buildersData do
        local item = nil
        local state_C = nil
        local timeText = nil
        local timeBar = nil
        local timer = nil
        local timerKey = ""
        local cdLimit = 0

        if builderType == 0 then
            item = view.BuilderList:GetChildAt(i - 1)
            timerKey = "building_" .. tostring(i)
            cdLimit = internalData.BuildingWorkerFatigueDuration
        else
            item = view.BuilderList:GetChildAt(i - 1 + #internalData.BuildersTimeoutInfo)
            timerKey = "tech_" .. tostring(i)
            cdLimit = internalData.TechWorkerFatigueDuration
        end

        timer = buildersTimer[timerKey]
        item:GetController("Type_C").selectedIndex = builderType
        -- 状态 0 空闲 1 未达疲劳上限 2 已达疲劳上限
        state_C = item:GetController("State_C")
        timeText = item:GetChild("Text_Time")
        timeBar = item:GetChild("Loader_TimeBar")

        -- 判断是否为空闲中
        if buildersData[i] > math.ceil(TimerManager.currentTime) then
            local function BuildersTimerUpdate(t, p)
                -- 时间倒计时
                timeText.text = Utils.secondConversion(math.ceil(p))
                -- 时间进度条
                timeBar.fillAmount = p / cdLimit
            end

            local cd = buildersData[i] - TimerManager.currentTime

            -- 判断是否超出疲劳上限
            if cd >= cdLimit then
                state_C.selectedIndex = 2
            else
                state_C.selectedIndex = 1
            end

            -- 点击进入加速面板
            local data = { typeId = builderType, index = i }
            item.onClick:Set( function()
                UIManager.openController(UIManager.ControllerName.BuildersSpeedup, data)
            end )

            -- 计时器
            if timer == nil then
                buildersTimer[timerKey] = TimerManager.newTimer(cd, false, true, nil, BuildersTimerUpdate, BuildersTimerComplete)
                timer = buildersTimer[timerKey]
            end

            timer:addCd(cd - timer.MaxCd)
            timer:reset()
            timer:start()
        else
            -- 暂停计时器顺便切换控制器状态
            if timer ~= nil then
                timer:pause()
            end

            state_C.selectedIndex = 0
            item.onClick:Clear()
        end
    end
end

-- 更新建筑队/科技队信息
local function UpdateBuildersInfo()
    UpdateData(0)
    UpdateData(1)
end

-- 建筑队&科技队初始化
local function InitBuildersList()
    view.BuilderList:RemoveChildrenToPool()

    -- 建筑队
    for i = 1, #internalData.BuildersTimeoutInfo do
        local item = view.BuilderList:AddItemFromPool(view.BuilderList.defaultItem)
    end

    -- 科技队
    for i = 1, #internalData.TechnicianTimeOutInfo do
        local item = view.BuilderList:AddItemFromPool(view.BuilderList.defaultItem)
    end
end

-- 完成计时回调
BuildersTimerComplete = function()
    UpdateBuildersInfo()
end

function _C:onCreat()
    view = _C.view
    -- 初始化建筑队科技队列表
    InitBuildersList()

    Event.addListener(Event.BUILDING_UPGRADE, UpdateBuildersInfo)
    Event.addListener(Event.TECHNOLOGY_UPGRADE, UpdateBuildersInfo)
    Event.addListener(Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS, UpdateBuildersInfo)
    Event.addListener(Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS, UpdateBuildersInfo)
    Event.addListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, UpdateBuildersInfo)

end

function _C:onOpen()
    UpdateBuildersInfo()
end

function _C:onDestroy()
    for k, v in pairs(buildersTimer) do
        TimerManager.disposeTimer(v)
        v = nil
    end

    Event.removeListener(Event.BUILDING_UPGRADE, UpdateBuildersInfo)
    Event.removeListener(Event.TECHNOLOGY_UPGRADE, UpdateBuildersInfo)
    Event.removeListener(Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS, UpdateBuildersInfo)
    Event.removeListener(Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS, UpdateBuildersInfo)
    Event.removeListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, UpdateBuildersInfo)
end

return _C