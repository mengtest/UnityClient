local _C = UIManager.Controller(UIManager.ControllerName.UpgradeTechnology, UIManager.ViewName.UpgradeTechnology)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
local upgradeTimer = nil
-- 当前科技(TechnologyDataClass}
local currData = nil
-- 内政信息
local internalData = nil
-- 货币信息
local currencyData = nil
-- 科技队时间戳
local techBuildersData = nil
-- 科技实例化信息
local techData = nil
-- 玩家建筑实例化信息
local playerBuildingData = nil

-- 队列item
local builderItem = nil
-- 消耗列表里的倒计时文本
local cdLabel = nil
-- 计时结束
local UpgradeTimerComplete = nil

local function UpgradeTimerStart()
    view.UpgradeBtn.touchable = false
    view.UpgradeBtn.grayed = true
end

local function UpgradeTimerUpdate(t, p)
    local content = Utils.secondConversion(math.ceil(p))
    view.UpgradeCD.text = content
    cdLabel.text = content
end

-- data:TechnologyDataClass()
local function UpdateConditionList(data)
    -- 按钮不置灰,打开交互
    view.UpgradeBtn.grayed = false
    view.UpgradeBtn.touchable = true
    view.UpgradeCD.text = ""
    local item = nil
    local item_C = nil

    -- 所需前置建筑条件
    for k, v in ipairs(data.RequireBuildingIds) do
        local requireBuildingData = BuildingConfig.Config[v]
        item = view.ConditionList:AddItemFromPool(UIConfig.ConditionType.Building)
        item_C = item:GetController("State_C")
        -- 图标
        -- item:GetChild("Loader_Icon").url = UIConfig.BuildingIcon[requireBuildingData.BuildingType]
        -- 建筑名字
        item:GetChild("Text_Name").text = Localization["BuildingName" .. requireBuildingData.BuildingType] .. Localization.Level_2
        -- 所需等级
        item:GetChild("Text_Level").text = requireBuildingData.Level

        -- 如果建筑不存在或者建筑等级不满足则显示红色
        local myBuildingData = playerBuildingData[requireBuildingData.BuildingType]
        if myBuildingData == nil or myBuildingData.Level < requireBuildingData.Level then
            item_C.selectedIndex = 1
            item:GetChild("Button_Skip").onClick:Set( function()
                _C:close()
                UIManager.openController(UIManager.ControllerName.Upgrade, playerBuildingData[requireBuildingData.BuildingType])
            end )
            -- 按钮置灰,关闭交互
            view.UpgradeBtn.grayed = true
            view.UpgradeBtn.touchable = false
        else
            item_C.selectedIndex = 0
        end
    end

    -- 所需前置科技条件
    for k, v in ipairs(data.RequireTechnologyIds) do
        local requireTechnologyData = TechnologyConfig:getConfigById(v)
        item = view.ConditionList:AddItemFromPool(UIConfig.ConditionType.Building)
        item_C = item:GetController("State_C")
        -- 图标(暂无)
        item:GetChild("Loader_Icon").url = UIConfig.Academy.TechIcon
        -- 科技名字
        item:GetChild("Text_Name").text = requireTechnologyData.Name .. Localization.Level_2
        -- 所需等级
        item:GetChild("Text_Level").text = requireTechnologyData.Level

        -- 如果科技不存在或者建筑等级不满足则显示红色
        local myTechData = nil

        if techData[requireTechnologyData.Type] ~= nil then
            myTechData = techData[requireTechnologyData.Type][requireTechnologyData.Sequence]
        end

        if myTechData == nil or myTechData.Level < requireTechnologyData.Level then
            item_C.selectedIndex = 1
            item:GetChild("Button_Skip").onClick:Set( function()
                _C:close()
                UIManager.openController(UIManager.ControllerName.UpgradeTechnology, { type = requireTechnologyData.Type, sequence = requireTechnologyData.Sequence })
            end )
            -- 按钮置灰,关闭交互
            view.UpgradeBtn.grayed = true
            view.UpgradeBtn.touchable = false
        else
            item_C.selectedIndex = 0
        end
    end

    -- 科技队
    -- 是否有空闲的科技队
    local hasLeisureBuilders = true
    -- CD最快结束的科技队时间戳
    local nextLeisureBuildersTime = TimerManager.currentTime * 2
    -- 索引
    local currIndex = nil

    for k, v in pairs(techBuildersData) do
        if v - math.ceil(TimerManager.currentTime) <= internalData.TechWorkerFatigueDuration then
            hasLeisureBuilders = true
            break
        else
            if nextLeisureBuildersTime > v then
                nextLeisureBuildersTime = v
                currIndex = k
            end

            hasLeisureBuilders = false
        end
    end

    if not hasLeisureBuilders then
        -- 队列item
        item = view.ConditionList:AddItemFromPool(UIConfig.ConditionType.Builders)
        -- 0 建筑队 1 科技队
        item:GetController("Type_C").selectedIndex = 1
        -- 加速按钮进入加速界面(typeId:0=建筑队,1=科技队;index:索引,从0开始,要-1使用)
        local data = { typeId = 1, index = currIndex }
        item:GetChild("btn_u").onClick:Set( function()
            UIManager.openController(UIManager.ControllerName.BuildersSpeedup, data)
        end )
        -- 按钮置灰,关闭交互
        view.UpgradeBtn.grayed = true
        view.UpgradeBtn.touchable = false
        -- 建筑队item
        builderItem = item
        -- 倒计时文本
        cdLabel = item:GetChild("txt_jian")

        -- 开始倒计时
        if upgradeTimer == nil then
            upgradeTimer = TimerManager.newTimer(nextLeisureBuildersTime - TimerManager.currentTime, false, true, UpgradeTimerStart, UpgradeTimerUpdate, UpgradeTimerComplete)
        end

        upgradeTimer:addCd((nextLeisureBuildersTime - TimerManager.currentTime) - upgradeTimer.MaxCd)
        upgradeTimer:reset()
        upgradeTimer:start()
    end

    -- 资源消耗
    for k, v in pairs(data.Cost) do
        while true do
            if type(v) ~= "number" or v == 0 then
                break
            end

            item = view.ConditionList:AddItemFromPool(UIConfig.ConditionType.Resourse)
            item_C = item:GetController("State_C")
            -- 图标
            item:GetChild("Loader_Res").url = UIConfig.CurrencyType[k]
            -- 当前值
            local currValue = 0

            -- 如果是元宝,可能是我多虑了,先写着以防万一,如果不是4种货币/元宝会出错
            if k == "YuanBao" then
                currValue = playerdata.Money
            else
                currValue = currencyData[CurrencyType[k]]
            end

            -- 当前货币值
            item:GetChild("Text_Total").text = currValue
            -- 消耗值
            item:GetChild("Text_Need").text = v

            if currValue < v then
                item_C.selectedIndex = 1
                item:GetChild("Button_Add").onClick:Set( function() print("怕是要干一些增加货币的事情了") end)
                -- 按钮置灰,关闭交互
                view.UpgradeBtn.grayed = true
                view.UpgradeBtn.touchable = false
            else
                item_C.selectedIndex = 0
            end

            break
        end
    end

    -- 加速时间(秒数)
    local speedUpSecond = data.StudyTimeCost - internalData.TechWorkerCoef * data.StudyTimeCost

    if speedUpSecond > 0 then
        view.Speedup_C.selectedIndex = 1
        -- 向下取整(xx 秒 / xx分钟 / xx天)
        local time = ""

        if speedUpSecond < 60 then
            time = math.floor(speedUpSecond) .. Localization.Second
        elseif speedUpSecond < 3600 then
            time = math.floor(speedUpSecond / 60) .. Localization.Minute
        else
            time = math.floor(speedUpSecond / 3600) .. Localization.Hour
        end

        view.SpeedUp.text = Localization.AlreadySpeedup .. time
    else
        view.SpeedUp.text = ""
        view.Speedup_C.selectedIndex = 0
    end

    view.UpgradeBtn.onClick:Set( function()
        NetworkManager.C2SLearnTechnologyProto(data.Group)
    end )
end

-- 科技升级界面信息
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    -- 清空消耗列表
    view.ConditionList:RemoveChildrenToPool()
    -- 玩家拥有科技
    local data = nil

    if techData[currData.Type] == nil then
        data = nil
    else
        data = techData[currData.Type][currData.Sequence]
    end

    -- 0级
    if data == nil then
        -- 科技类型
        data = TechnologyConfig.ConfigByTypeAndSequenceAndLevel[currData.Type][currData.Sequence][1]
        view.Level_C.selectedIndex = 0
        UpdateConditionList(data)
    else
        -- 下一级科技数据
        local nextLevData = TechnologyConfig:getNextLvConfigById(data.Id)
        -- 满级
        if nextLevData == nil then
            view.Level_C.selectedIndex = 2
            -- 未满级
        else
            view.Level_C.selectedIndex = 1
            -- 下一级等级
            view.NextLev.text = string.format(Localization.AcademyLevel, nextLevData.Level)
            -- 下一级描述
            view.NextDesc.text = nextLevData.Desc
            UpdateConditionList(nextLevData)
        end
        -- 等级
        view.Lev.text = data.Level
    end

    -- 消耗标题
    view.ConditionTitle.text = string.format(Localization.TechnologyUpgradeCost, data.Name)
    -- 名称
    view.Title.text = data.Name
    -- 图标
    view.Icon.url = UIConfig.Academy[data.Icon]
    -- 当前等级
    view.CurLev.text = string.format(Localization.AcademyLevel, data.Level)
    -- 当前描述
    view.CurDesc.text = data.Desc
end

-- 计时结束
UpgradeTimerComplete = function()
    view.UpgradeCD.text = ""
    -- CD结束
    RefreshUI()
end

-- data:TechnologyDataClass()
function _C:onOpen(data)
    if data == nil then
        return
    end

    internalData = DataTrunk.PlayerInfo.InternalAffairsData
    currencyData = internalData.CurrencyCurrInfo
    techBuildersData = internalData.TechnicianTimeOutInfo
    techData = internalData.TechnologiesInfo
    playerBuildingData = internalData.BuildingsInfo

    currData = data
    RefreshUI()
end

local function UpgradeSuccess()
    if not _C.IsOpen then
        return
    end

    view.Upgrade_T:Play()
    RefreshUI()
end

function _C:onCreat()
    view = _C.View

    -- top left
    view.BackBtn.onClick:Set( function() _C:close() end)

    Event.addListener(Event.TECHNOLOGY_UPGRADE, UpgradeSuccess)
    Event.addListener(Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS, RefreshUI)
    Event.addListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, RefreshUI)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    TimerManager.disposeTimer(upgradeTimer)
    upgradeTimer = nil
    Event.removeListener(Event.TECHNOLOGY_UPGRADE, UpgradeSuccess)
    Event.removeListener(Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS, RefreshUI)
    Event.removeListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, RefreshUI)
end