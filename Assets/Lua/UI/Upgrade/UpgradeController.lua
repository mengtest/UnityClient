local _C = UIManager.Controller(UIManager.ControllerName.Upgrade, UIManager.ViewName.Upgrade)
local view = nil
local upgradeTimer = nil
-- 内政信息
local internalData = DataTrunk.PlayerInfo.InternalAffairsData
-- 建筑队时间戳
local buildingBuildersData = internalData.BuildersTimeoutInfo
-- 玩家建筑实例化信息
local playerBuildingData = internalData.BuildingsInfo
-- 货币信息
local currencyData = internalData.CurrencyCurrInfo
-- 玩家信息
local playerdata = DataTrunk.PlayerInfo.MonarchsData
-- 当前建筑类型
local currbuildingType = nil
-- 建筑升级特效预制件路径
local buildingUpgradeParticlePath = "Prefabs/Particle/Eff_sce_city_shengji"
-- 建筑升级特效名称
local effectName = "BuildingUpgradeEffect"

local GameObject = CS.UnityEngine.GameObject
local Resources = CS.UnityEngine.Resources
local Vector3 = CS.UnityEngine.Vector3
-- 建筑colliders父物体
local collidersObj = GameObject.Find("MainCityColliders")
-- 升级特效
local effect = GameObject.Find(effectName)

-- 队列item
local builderItem = nil
-- 消耗列表里的倒计时文本
local cdLabel = nil
-- 计时完成
local UpgradeTimerComplete = nil

local function UpgradeTimerStart()
    view.CD.visible = true
    view.UpgradeBtn.touchable = false
    view.UpgradeBtn.grayed = true
end

local function UpgradeTimerUpdate(t, p)
    local content = Utils.secondConversion(math.ceil(p))
    view.CD.text = content
    cdLabel.text = content
end


-- 数据更新刷新界面
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    local data = playerBuildingData[currbuildingType]
    -- 清空消耗列表
    view.ConditionList:RemoveChildrenToPool()
    -- 按钮不置灰,打开交互
    view.UpgradeBtn.grayed = false
    view.UpgradeBtn.touchable = true
    view.CD.visible = false
    -- 判断是否满级
    local nextLevData = BuildingConfig.ConfigByTypeAndLevel[data.BuildingType .. "_" ..(data.Level + 1)]
    if nextLevData == nil then
        view.LevelMax_C.selectedIndex = 1
        view.CurrLevel.text = data.Level
        view.CurrDes.text = data.Desc
        return
    else
        view.LevelMax_C.selectedIndex = 0
    end

    view.CurrLevel.text = data.Level
    view.NextLevel.text = nextLevData.Level
    view.CurrDes.text = data.Desc
    view.NextDes.text = nextLevData.Desc


    local item = nil
    local item_C = nil
    -- 主城等级需求
    if nextLevData.BaseLevel ~= 0 then
        item = view.ConditionList:AddItemFromPool(UIConfig.ConditionType.Building)
        item_C = item:GetController("State_C")
        -- 图标
        item:GetChild("Loader_Icon").url = UIConfig.BuildingIcon.MainCity
        -- 建筑名字
        item:GetChild("Text_Name").text = Localization.MainCityLevel
        -- 所需主城的等级
        item:GetChild("Text_Level").text = nextLevData.BaseLevel

        if DataTrunk.PlayerInfo.MonarchsData.BaseLevel < nextLevData.BaseLevel then
            item_C.selectedIndex = 1
            item:GetChild("Button_Skip").visible = false
            -- 按钮置灰,关闭交互
            view.UpgradeBtn.grayed = true
            view.UpgradeBtn.touchable = false
        else
            item_C.selectedIndex = 0
        end
    end

    -- 前提条件，所需的建筑id
    if nextLevData.RequiredBuildingIds ~= { } then
        for k, v in pairs(nextLevData.RequiredBuildingIds) do
            if type(v) ~= "number" then
                break
            end

            -- 所需前置建筑数据
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
                -- 跳转按钮
                local skipBtn = item:GetChild("Button_Skip")
                skipBtn.visible = true
                skipBtn.onClick:Set( function()
                    _C:close()
                    -- 建筑名称
                    local buildingName = nil

                    -- 根据id获取名字
                    for k, v in pairs(BuildingType) do
                        if requireBuildingData.BuildingType == v then
                            buildingName = k
                            break
                        end
                    end

                    CS.LPCFramework.CameraController.SwitchToTargetCamera(buildingName)
                    UIManager.openController(UIManager.ControllerName.Upgrade, playerBuildingData[requireBuildingData.BuildingType])
                end )
                -- 按钮置灰,关闭交互
                view.UpgradeBtn.grayed = true
                view.UpgradeBtn.touchable = false
            else
                item_C.selectedIndex = 0
            end
        end
    end

    -- 建筑队
    -- 是否有空闲的建筑队
    local hasLeisureBuilders = true
    -- CD最快结束的建筑队时间戳
    local nextLeisureBuildersTime = TimerManager.currentTime * 2
    -- 索引
    local currIndex = nil

    for k, v in pairs(buildingBuildersData) do
        if v - math.ceil(TimerManager.currentTime) <= internalData.BuildingWorkerFatigueDuration then
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
        item:GetController("Type_C").selectedIndex = 0
        -- 加速按钮进入加速界面(typeId:0=建筑队,1=科技队;index:索引,从0开始,要-1使用)
        local data = { typeId = 0, index = currIndex }
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

    -- 建资源消耗
    if nextLevData.Cost ~= nil then
        for k, v in pairs(nextLevData.Cost) do
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
    end

    -- 加速时间(秒数)
    local speedUpSecond = nextLevData.BuilderWorkTime - internalData.BuildingWorkerCoef * nextLevData.BuilderWorkTime

    if speedUpSecond > 0 then
        view.Speedup_C.selectedIndex = 0
        -- 向下取整(xx 秒 / xx分钟 / xx天)
        local time = ""

        if speedUpSecond < 60 then
            time = math.floor(speedUpSecond) .. Localization.Second
        elseif speedUpSecond < 3600 then
            time = math.floor(speedUpSecond / 60) .. Localization.Minute
        else
            time = math.floor(speedUpSecond / 3600) .. Localization.Hour
        end

        view.Speedup.text = Localization.AlreadySpeedup .. time
    else
        view.Speedup_C.selectedIndex = 1
    end

    view.UpgradeBtn.onClick:Set( function()
        NetworkManager.C2SUpgradeStableBuildingProto(data.BuildingType, data.Level)
    end )
end

-- 计时结束
UpgradeTimerComplete = function()
    view.CD.visible = false
    -- CD结束
    RefreshUI()
end

-- data 建筑实例化信息
function _C:onOpen(data)
    if data == nil then
        return
    end
    
    -- 以防万一
    internalData = DataTrunk.PlayerInfo.InternalAffairsData
    buildingBuildersData = internalData.BuildersTimeoutInfo
    playerBuildingData = internalData.BuildingsInfo
    currencyData = internalData.CurrencyCurrInfo
    playerdata = DataTrunk.PlayerInfo.MonarchsData

    -- 弹出动效
    view.Effect_T:Play()
    -- 当前建筑类型
    currbuildingType = data.BuildingType
    -- 建筑名字
    view.TitleLabel.title = Localization["BuildingName" .. currbuildingType] .. Localization.Upgrade
    RefreshUI()
end

-- 建筑升级成功
local function BuildingUpgradeSuccess()
    if not _C.IsOpen then
        return
    end

    -- 刷新UI
    RefreshUI()

    if effect == nil then
        local particle = Resources.Load(buildingUpgradeParticlePath)
        effect = GameObject.Instantiate(particle, collidersObj.transform)
        effect.name = effectName
    end

    -- 建筑名称
    local buildingName = ""

    for k, v in pairs(BuildingType) do
        if currbuildingType == v then
            buildingName = k
        end
    end
    -- 设置位置
    effect.transform.position = collidersObj.transform:Find(buildingName).transform.position
    -- 播放
    effect:GetComponent("ParticleSystem"):Play()
end

local function FindObject()
    if not _C.IsOpen then
        return
    end

    collidersObj = GameObject.Find("MainCityColliders")
    effect = GameObject.Find(effectName)
end

-- 返回按钮
local function BackBtnOnClick()
    _C:close()
    CS.UnityEngine.GameObject.Find("BuildingsTag").transform.localScale = CS.UnityEngine.Vector3.one
    CS.LPCFramework.CameraController.ResetCamera()
end

function _C:onCreat()
    view = _C.View

    GameObject = CS.UnityEngine.GameObject
    Resources = CS.UnityEngine.Resources
    Vector3 = CS.UnityEngine.Vector3
    collidersObj = GameObject.Find("MainCityColliders")
    effect = GameObject.Find(effectName)

    -- top left
    view.BackBtn.onClick:Add(BackBtnOnClick)
    -- bottom right
    view.CD.visible = false

    Event.addListener(Event.BUILDING_UPGRADE, BuildingUpgradeSuccess)
    Event.addListener(Event.LOADING_MAINCITY_SUCCESS, FindObject)
    Event.addListener(Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS, RefreshUI)
    Event.addListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, RefreshUI)
end

function _C:onDestroy()
    TimerManager.disposeTimer(upgradeTimer)
    upgradeTimer = nil
    Event.removeListener(Event.BUILDING_UPGRADE, BuildingUpgradeSuccess)
    Event.removeListener(Event.LOADING_MAINCITY_SUCCESS, FindObject)
    Event.removeListener(Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS, RefreshUI)
    Event.removeListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, RefreshUI)
end