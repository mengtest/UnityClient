local levelLogic = require "LevelLogic.LevelLogic"
local WorldMapLevelLogic = levelLogic:extend()
local Event = require "Event.Event"
local WorldMapConfig = require "Config.WorldMapConfig"
local RegionWarSituationShow = require "Region.RegionWarSituation"


-- 本脚本实例
local logic = nil
-- 场景加载完毕后的回调
local sceneLoadedCallback = nil

-- 势力范围显示半径
local INFLUENCE_RANGE = 25

-- 所有城池的Id列表
local allCityIdList = nil

-- 我的城池Id
local myCityId = -1
-- 我的势力Id
local myInflenceId = ""
-- 我的城池模型信息
local myCityModelInfo = nil
-- 当前地图是否有我的行营
local isMyCampsiteRegion = nil
-- 我的资源点模型信息
local myResourceModelInfoList = nil
-- 我的军情相关物体信息
local myMilitaryObjInfoList = nil

local moveBuidingType = nil

-- 当前点击到的区域信息，详情见TerrainGroundCoordinate.GroundItemInfo
local currClickedAreaInfo = nil
local currMapId = 0 

local moveCityData = nil
-- 我感觉迁城模式下的点击事件还是正常传给lua比较合适，这样如果未来做什么需求似乎更灵活一点。
-- 这里设一个in move city mode来判断鼠标点击事件是否处理
local inMoveCityMode = false


-- 插白旗计时器
local whiteFlagTimer = nil
-- 检查间隔
local WHITE_FLAG_DURATION = 8
-- **********************************************************************************************

-- 根据城池等级获取其模型等级
local function getCityModelLevel(cityLevel)
    return math.floor(cityLevel / 5) + 1
end
-- 根据产量和最高容量计算资源模型等级
local function getResourcePointModelLevel(amount, capacity)
    -- 状态，[0, 5%)空的，[5%, 60%]一点点, (60%, 100%]满的
    local state = amount / capacity * 100
    if state >= 0 and state < 5 then
        state = 1
    elseif state >= 5 and state <= 60 then
        state = 2
    elseif state > 60 and state <= 100 then
        state = 3
    end

    return state
end

-- 更新我的城池信息
local function updateMyCityModelInfo()
    if isMyCampsiteRegion then
        myCityModelInfo = CS.LPCFramework.TerrainLuaDelegates.GetCityInfoById(myCityId)
    else
        myCityModelInfo = CS.LPCFramework.TerrainLuaDelegates.GetCityInfoById(myCityId)
    end
end
-- 更新我的资源点信息
-- <param name="id" type="int">资源点LayoutId</param>
local function updateMyResourceModelInfo(id)
    local RPModelInfo = CS.LPCFramework.TerrainLuaDelegates.GetGroundInfoPosById(id)
    if RPModelInfo ~= nil then
        myResourceModelInfoList[id] = RPModelInfo
    end
end

-- 生成一个模型
local function genACity(info)
    local cityModelLevel = getCityModelLevel(info.BaseLevel)
    local isMainPlayer = false

    -- 玩家自己
    if info.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
        isMainPlayer = true
        myInflenceId = info.Id
        isMyCampsiteRegion = false
    end

    local cityId = CS.LPCFramework.TerrainLuaDelegates.SpawnGroundCity(info.Id, info.Name, 0, info.BaseX, info.BaseY, info.BaseLevel,
        cityModelLevel, info.GuildId, info.GuildFlagName, info.FlagGuildFlagName, isMainPlayer, BuildingType.MainCity)
    if cityId > -1 then
        -- 以君主Id为key，cityId为value存入allCityIdList
        allCityIdList[info.Id] = cityId

        -- 更新我的城池在地图上的信息
        if isMainPlayer then
            myCityId = cityId
            updateMyCityModelInfo()
        end
    end
end

-- 生成一个资源点模型
local function genAResourcePoint(info)
    if info == nil or info.LayoutConfig == nil then
        return
    end
    
    local myMonarchsData = DataTrunk.PlayerInfo.MonarchsData
    local x = myMonarchsData.BaseX + info.LayoutConfig.RegionOffsetX
    local y = myMonarchsData.BaseY - info.LayoutConfig.RegionOffsetY
    -- 此处相当于ResourceMenuController的91行开始的逆运算,将坐标转换为大地图的对应正确坐标.
    if info.LayoutConfig.RegionOffsetX % 2 ~= 0 and myMonarchsData.BaseX % 2 == 0 then
        y = myMonarchsData.BaseY - info.LayoutConfig.RegionOffsetY - 1
    end

    local state = getResourcePointModelLevel(info.Amount, info.Capacity)
    -- 生成模型
    if CS.LPCFramework.TerrainLuaDelegates.SpawnGroundItem(info.LayoutConfig.Id, myInflenceId, x, y, info.BuildingConfig.BuildingType, state) then
        -- 更新本地保存的资源点模型信息
        updateMyResourceModelInfo(info.LayoutConfig.Id)
    end
end

-- 生成一个行营模型
local function genACampsite(info)
    local cityModelLevel = getCityModelLevel(info.BaseLevel)
    local isMainPlayer = false

    -- 玩家自己
    if info.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
        isMainPlayer = true
        myInflenceId = info.Id
        isMyCampsiteRegion = true
    end

    local campsiteId = CS.LPCFramework.TerrainLuaDelegates.SpawnGroundCity(info.Id,  info.Name, 0, info.BaseX, info.BaseY, info.BaseLevel,
        cityModelLevel, info.GuildId, info.GuildFlagName, info.FlagGuildFlagName, isMainPlayer, BuildingType.Campsite)
    if campsiteId > -1 then
        -- 以君主Id为key，cityId为value存入allCityIdList
        allCityIdList[info.Id] = campsiteId
        -- 更新我的城池在地图上的信息
        if isMainPlayer then
            myCityId = campsiteId
            updateMyCityModelInfo()
        end
    end
end

-- 生成所有城池模型
local function genAllCityModels()
    local selectRegionId = DataTrunk.PlayerInfo.MonarchsData.BaseMapId
    if  DataTrunk.PlayerInfo.RegionData:getSelectRegion() ~= nil then
        selectRegionId = DataTrunk.PlayerInfo.RegionData:getSelectRegion()
    end
    
    local baseInfos = DataTrunk.PlayerInfo.RegionBaseData:getRegionInfo(selectRegionId)
    if baseInfos ~= nil then
        for k, v in pairs(baseInfos) do
            -- BaseLevel > 0的才显示，0级表示主城已经流亡
            if v ~= nil and v.BaseLevel > 0 then
                if not v.IsCampsite then
                    genACity(v)
                end
            end
        end
    end
end

-- 移除所有城池模型
local function removeAllCityModels()
    if allCityIdList == nil then
        return
    end

    for k, v in pairs(allCityIdList) do
        CS.LPCFramework.TerrainLuaDelegates.RemoveCity(v)
    end
    allCityIdList = { }
end

-- 生成所有行营模型
local function genAllCampsiteModels()
    local selectRegionId = DataTrunk.PlayerInfo.MonarchsData.BaseMapId
    if  DataTrunk.PlayerInfo.RegionData:getSelectRegion() ~= nil then
        selectRegionId = DataTrunk.PlayerInfo.RegionData:getSelectRegion()
    end

    local campInfos = DataTrunk.PlayerInfo.RegionBaseData:getRegionInfo(selectRegionId)
    if campInfos ~= nil then
        for k, v in pairs(campInfos) do
            if v ~= nil and v.BaseLevel > 0 then
                if v.IsCampsite then
                    genACampsite(v)
                end
            end
        end
    end
end

-- 生成资源点模型
local function genAllResourceModels()
    if logic:getCurrentMapId() ~= DataTrunk.PlayerInfo.MonarchsData.BaseMapId then
        return
    end
    
    local RPInfoList = DataTrunk.PlayerInfo.InternalAffairsData.ResourcePointInfo

    for k, v in pairs(RPInfoList) do
        if v ~= nil then
            -- 只有不冲突的才显示
            --print("~!!!!!!!", v.Conflict, v.LayoutConfig.Id)
            if v.Conflict == false then
                genAResourcePoint(v)
            end
        end
    end
end
-- 清除所有资源点
local function removeAllResourceModels()
    if myResourceModelInfoList == nil then
        return
    end

    for k, v in pairs(myResourceModelInfoList) do
        if v ~= nil then
            CS.LPCFramework.TerrainLuaDelegates.RemoveResource(k)
        end
    end

    myResourceModelInfoList = {}
end

-- 清除所有军情
local function removeAllMilitaryInfo()
    for k, v in pairs(myMilitaryObjInfoList) do
        RegionWarSituationShow:HideLine(v.LineId)
        RegionWarSituationShow:ClearHorseRun(v.RunningHorse, k)
        RegionWarSituationShow:ClearHorseStay(v.StayingHorse, k)
    end
end

-- 生成一条军情的表现，画行军路线，骑兵跑马等
local function genAMilitaryShow(info)
    if info ~= nil then
        local myInfo = DataTrunk.PlayerInfo.MonarchsData
        local fromWho = DataTrunk.PlayerInfo.RegionBaseData:getBaseInfo(logic:getCurrentMapId(), info.Self.Id)
        local toWho = DataTrunk.PlayerInfo.RegionBaseData:getBaseInfo(logic:getCurrentMapId(), info.Target.Id)
        if toWho == nil then
            toWho = info.Target
        end
        if fromWho ~= nil and toWho ~= nil then
            local color = CS.UnityEngine.Color.blue
            if Utils.IsTheSameGuild(info.Target.GuildId, myInfo.GuildId) then
                color = CS.UnityEngine.Color.red
            end

            if myMilitaryObjInfoList[info.CombineId] ~= nil then
                RegionWarSituationShow:HideLine(myMilitaryObjInfoList[info.CombineId].LineId)
                RegionWarSituationShow:ClearHorseRun(myMilitaryObjInfoList[info.CombineId].RunningHorse, info.CombineId)
                RegionWarSituationShow:ClearHorseStay(myMilitaryObjInfoList[info.CombineId].StayingHorse, info.CombineId)
            end
            local regionWarSituation = RegionWarSituationShow:NewWarSituationObj()
            if info.MoveType == MilitaryMoveType.Forward then
                regionWarSituation.LineId = RegionWarSituationShow:ShowLine(fromWho.BaseX, fromWho.BaseY, toWho.BaseX, toWho.BaseY, color)
                regionWarSituation.RunningHorse = RegionWarSituationShow:ShowHorseRun(info.CombineId, fromWho.BaseX, fromWho.BaseY, toWho.BaseX, toWho.BaseY, info.MoveStartTime, info.MoveArrivedTime)
            elseif info.MoveType == MilitaryMoveType.Back then
                regionWarSituation.LineId = RegionWarSituationShow:ShowLine(info.TargetBaseX, info.TargetBaseY, fromWho.BaseX, fromWho.BaseY, color)
                regionWarSituation.RunningHorse = RegionWarSituationShow:ShowHorseRun(info.CombineId, info.TargetBaseX, info.TargetBaseY, fromWho.BaseX, fromWho.BaseY, info.MoveStartTime, info.MoveArrivedTime)
            elseif info.MoveType == MilitaryMoveType.Arrived then
                regionWarSituation.StayingHorse = RegionWarSituationShow:ShowHorseStay(info.CombineId, toWho.Id, fromWho.BaseX, fromWho.BaseY, toWho.BaseX, toWho.BaseY, info.Action)
            end
            myMilitaryObjInfoList[info.CombineId] = regionWarSituation
        end
    end
end

-- **********************************************************************************************
-- 网络交互事件
-- **********************************************************************************************
-- 创建资源点
local function onCreateResourcePoint(data)
    if logic == nil or data == nil then
        return
    end

    -- 生成资源点
    genAResourcePoint(data)
end

-- 改建资源点
local function onRebuildResourcePoint(data)
    if logic == nil or data == nil then
        return
    end

    -- 是否存在
    if myResourceModelInfoList[data.LayoutConfig.Id] ~= nil then
        -- 删除旧的
        CS.LPCFramework.TerrainLuaDelegates.RemoveResource(data.LayoutConfig.Id)
        -- 生成新的
        genAResourcePoint(data)
    end
end

-- 更新资源点
local function onResourcePointUpdate(data)
    if logic == nil or data == nil then
        return
    end

    -- 是否存在
    if myResourceModelInfoList[data.LayoutConfig.Id] ~= nil then
        -- 更新模型等级
        local state = getResourcePointModelLevel(info.Amount, info.Capacity)
        CS.LPCFramework.TerrainLuaDelegates.SetResourceModelGrade(data.LayoutConfig.Id, state)
    end
end

-- 资源点冲突
local function onResourcePointConflict()
    if logic == nil then
        return
    end

    local RPInfoList = DataTrunk.PlayerInfo.InternalAffairsData.ResourcePointInfo

    for k, v in pairs(RPInfoList) do
        if v ~= nil then

            -- 是否存在
            if myResourceModelInfoList[v.LayoutConfig.Id] ~= nil then
                if v.Conflict then
                    -- 删除冲突的
                    CS.LPCFramework.TerrainLuaDelegates.RemoveResource(v.LayoutConfig.Id)
                end
            else
                if v.Conflict == false then
                    -- 生成不冲突的
                    genAResourcePoint(v)
                end
            end
        end
    end
end

-- 创建一个城池(只有玩家自己会触发此消息)
local function onCreateBase(data)
    if logic == nil or data == nil then
        return
    end

    -- 生成我的主城
    genACity(data)
    -- 移动camera到我的城池上方
    if myCityModelInfo ~= nil then
        logic:moveCameraTo(myCityModelInfo.m_iOddQX, myCityModelInfo.m_iOddQY)
    end
end

-- 移除一个城池
local function onRemoveBase(data)
    if logic == nil or data == nil or allCityIdList == nil then
        return
    end

    -- 删除模型和表中记录
    if allCityIdList[data.Id] ~= nil then
        CS.LPCFramework.TerrainLuaDelegates.RemoveCity(allCityIdList[data.Id])
        allCityIdList[data.Id] = nil

        -- 如果是玩家自己的主城
        if data.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
            myCityModelInfo = nil
            myCityId = -1
            myInflenceId = ""
            myCityModelInfo = nil

            -- 删除资源点
            if myResourceModelInfoList ~= nil then
                for k, v in pairs(myResourceModelInfoList) do
                    if v ~= nil then
                        CS.LPCFramework.TerrainLuaDelegates.RemoveResource(k)
                    end
                end
                -- 清空表中记录
                myResourceModelInfoList = {}
            end

            if isMyCampsiteRegion then
                isMyCampsiteRegion = nil
            end
        end
    end
end

-- 更新一个城池
local function onUpdateBase(data)
    if logic == nil or data == nil or allCityIdList == nil then
        return
    end

    local cityModelLevel = getCityModelLevel(data.BaseLevel)
    local isMainPlayer = false

    if data.Id == myMonarchId then
        isMainPlayer = true
    end

    -- 如果有，更新信息
    if allCityIdList[data.Id] ~= nil then
        CS.LPCFramework.TerrainLuaDelegates.UpdateCityInfo(allCityIdList[data.Id], data.BaseLevel, cityModelLevel, data.Name, 0, data.GuildId, data.GuildFlagName, data.BaseX, data.BaseY)

        -- 更新我的主城模型信息
        if isMainPlayer then
            updateMyCityModelInfo()
        end
    -- 如果没有，创建一个
    else
        if data.IsCampsite then
            genACampsite(data)
        else
            genACity(data)
        end
    end

end

-- 升级自己的城池
local function onUpgradeBase(data)
    if logic == nil or data == nil or allCityIdList == nil then
        return
    end

    -- 如果有，更新信息
    if allCityIdList[data.Id] ~= nil then
        local cityModelLevel = getCityModelLevel(data.Level)
        CS.LPCFramework.TerrainLuaDelegates.UpdateCityGradeAndModelGrade(allCityIdList[data.Id], data.Level, cityModelLevel)

        -- 更新我的主城模型信息
        updateMyCityModelInfo()
    end

end

-- 获取所有军情
local function onGetAllMilitary()
    if logic == nil then
        return
    end

    local militaryInfo = DataTrunk.PlayerInfo.MilitaryInfoData.CurrMapMilitaryInfoList

    for k, v in pairs(militaryInfo) do
        if v ~= nil then
            genAMilitaryShow(v)
        end
    end
end

-- 军情更新
local function onMilitaryUpdate(data)
    print("准备画军情咯")
    if logic == nil or data == nil then
        return
    end

    genAMilitaryShow(data)
end

-- 军情移除
local function onMilitaryRemoved(id)
    if logic == nil then
        return
    end

    if myMilitaryObjInfoList[id] ~= nil then
        RegionWarSituationShow:HideLine(myMilitaryObjInfoList[id].LineId)
        RegionWarSituationShow:ClearHorseRun(myMilitaryObjInfoList[id].RunningHorse, id)
        RegionWarSituationShow:ClearHorseStay(myMilitaryObjInfoList[id].StayingHorse, id)
    end
    myMilitaryObjInfoList[id] = nil
end

-- 更新所有城池
local function onUpdateAllBase()
    logic:enterBigMap()
end

-- 成功从服务器获取到野外消息
local function onGetOutsideInfo(data)
    print("我进地图咯~~~~~地图id", data)
    if data == nil then
        return
    else
        currMapId = data
    end

    if sceneLoadedCallback ~= nil then
        print("隐藏loading界面~~~~~~")
        sceneLoadedCallback()
    end
end

-- 迁城
local function onFastMoveBase(data)
    if logic == nil or data == nil or allCityIdList == nil then
        return
    end

    -- 删除所有资源点
    removeAllResourceModels()
    if allCityIdList[data.Id] == nil then --说明切换了地图,地图上没有主城或者行营,新建一个
        if data.IsCampsite then
            genACampsite(data)
        else
            genACity(data)
        end
    else
        CS.LPCFramework.TerrainLuaDelegates.ChangeCityPosition(allCityIdList[data.Id], data.BaseX, data.BaseY)
    end
    genAllResourceModels()
    onGetAllMilitary()
end

local function onRename(data)
    CS.LPCFramework.TerrainLuaDelegates.ChangeCityPlayerName(allCityIdList[data.id], data.name)
end

local function onCampsiteUpdate(data)
    if isMyCampsiteRegion then
        CS.LPCFramework.TerrainLuaDelegates.ChangeCityPosition(allCityIdList[data.Id], data.BaseX, data.BaseY)
    else
        isMyCampsiteRegion = true
        genACampsite(data)
        logic:moveCameraTo(myCityModelInfo.m_iOddQX, myCityModelInfo.m_iOddQY)
    end
end

local function onWhiteFlagUpdate(data)
    if logic == nil or data == nil or allCityIdList == nil then
        return
    end

    CS.LPCFramework.TerrainLuaDelegates.ChangeCityWhiteFlag(allCityIdList[data.hero_id], data.white_flag_flag_name)
end

local function AddEventListener()
    Event.addListener(Event.CREATE_RESOURCE_POINT, onCreateResourcePoint)
    Event.addListener(Event.REBUILD_RESOURCE_POINT, onRebuildResourcePoint)
    Event.addListener(Event.RESOURCE_POINT_UPDATE, onResourcePointUpdate)
    Event.addListener(Event.ON_RESOURCE_POINT_CONFLICT, onResourcePointConflict)
    Event.addListener(Event.CREATE_BASE, onCreateBase)
    Event.addListener(Event.REMOVE_BASE, onRemoveBase)
    Event.addListener(Event.UPDATE_BASE, onUpdateBase)
    Event.addListener(Event.UPGRADE_BASE, onUpgradeBase)
    Event.addListener(Event.ON_ALL_CURRENT_MAP_MILITARY_UPDATED, onGetAllMilitary)
    Event.addListener(Event.ON_CURRENT_MAP_MILITARY_UPDATED, onMilitaryUpdate)
    Event.addListener(Event.ON_CURRENT_MAP_MILITARY_REMOVED, onMilitaryRemoved)
    Event.addListener(Event.ON_ALL_CURRENT_MAP_BASE_UPDATED, onUpdateAllBase)
    Event.addListener(Event.ON_GO_OUTSIDE, onGetOutsideInfo)
    Event.addListener(Event.FAST_MOVE_BASE, onFastMoveBase)
    Event.addListener(Event.OTHER_CHANGE_NAME_SUCCESS, onRename)
    Event.addListener(Event.PUT_CAMPSITE, onCampsiteUpdate)
    Event.addListener(Event.WHITE_FLAG_UPDATE, onWhiteFlagUpdate)
end

local function RemoveEventListener()
    Event.removeListener(Event.CREATE_RESOURCE_POINT, onCreateResourcePoint)
    Event.removeListener(Event.REBUILD_RESOURCE_POINT, onRebuildResourcePoint)
    Event.removeListener(Event.RESOURCE_POINT_UPDATE, onResourcePointUpdate)
    Event.removeListener(Event.ON_RESOURCE_POINT_CONFLICT, onResourcePointConflict)
    Event.removeListener(Event.CREATE_BASE, onCreateBase)
    Event.removeListener(Event.REMOVE_BASE, onRemoveBase)
    Event.removeListener(Event.UPDATE_BASE, onUpdateBase)
    Event.removeListener(Event.UPGRADE_BASE, onUpgradeBase)
    Event.removeListener(Event.ON_ALL_CURRENT_MAP_MILITARY_UPDATED, onGetAllMilitary)
    Event.removeListener(Event.ON_CURRENT_MAP_MILITARY_UPDATED, onMilitaryUpdate)
    Event.removeListener(Event.ON_CURRENT_MAP_MILITARY_REMOVED, onMilitaryRemoved)
    Event.removeListener(Event.ON_ALL_CURRENT_MAP_BASE_UPDATED, onUpdateAllBase)
    Event.removeListener(Event.ON_GO_OUTSIDE, onGetOutsideInfo)
    Event.removeListener(Event.FAST_MOVE_BASE, onFastMoveBase)
    Event.removeListener(Event.OTHER_CHANGE_NAME_SUCCESS, onRename)
    Event.removeListener(Event.PUT_CAMPSITE, onCampsiteUpdate)
    Event.removeListener(Event.WHITE_FLAG_UPDATE, onWhiteFlagUpdate)
end

local function checkWhiteFlagTime()
    local baseInfos = DataTrunk.PlayerInfo.RegionBaseData:getRegionInfo(currMapId)
    if baseInfos == nil then
        return
    end
    for k, v in pairs(baseInfos) do
        if TimerManager.currentTime > v.FlagExpire and v.FlagGuildFlagName ~= "" then
            v:updateWhiteFlag(v.FlagGuildId, "", v.FlagExpire)
            local data = { }
            data.hero_id = k
            data.white_flag_flag_name = ""
            onWhiteFlagUpdate(data)
        end
    end
end
-- **********************************************************************************************
-- 场景事件
-- **********************************************************************************************

-- 初始化场景地图--
function WorldMapLevelLogic:initLevel(levelConfig)
    logic.super.initLevel(logic, levelConfig)

    if allCityIdList == nil then
        allCityIdList = { }
    end

    myCityId = -1
    myCityModelInfo = nil
    if myResourceModelInfoList == nil then
        myResourceModelInfoList = { }
    end

    if myMilitaryObjInfoList == nil then
        myMilitaryObjInfoList = { }
    end

    if moveCityData == nil then
        moveCityData = { }
    end

    -- 初始化游戏对象管理器
    GameObjectManager.initialize()

    -- 初始化游戏对象池
    GameObjectManager.initPool(RegionWarSituationShow.ACTOR_WAR_SITUATION_ID, 
        RegionWarSituationShow.ACTOR_INIT_POOL_SIZE, RegionWarSituationShow.ACTOR_MAX_POOL_SIZE, true)
    GameObjectManager.initPool(RegionWarSituationShow.ACTOR_ATTACKING_ID, 
        RegionWarSituationShow.ACTOR_INIT_POOL_SIZE, RegionWarSituationShow.ACTOR_MAX_POOL_SIZE, true)
    -- 获取所有已开放野区
    NetworkManager.C2SRegionLevelCount()
    -- 获取野外信息, 获取资源点信息
    NetworkManager.C2SResourceBuildingProto()
    -- 进入选择的地区, 如果没有选择 则进入主城所在的地区
    if DataTrunk.PlayerInfo.RegionData:getSelectRegion() == nil then
        NetworkManager.C2SSwitchMapProto(DataTrunk.PlayerInfo.MonarchsData.BaseMapId)
    else
        NetworkManager.C2SSwitchMapProto(DataTrunk.PlayerInfo.RegionData:getSelectRegion())
    end
end

-- 进入场景--
function WorldMapLevelLogic:onEnterScene(callBack)
    logic = self
    WorldMapConfig()
    logic:initLevel(LevelManager.CurrLevelConfig)

    -- 逻辑处理完成
    sceneLoadedCallback = callBack

    AudioManager.PlaySound('BGM_Field01', 1)
    whiteFlagTimer = TimerManager.newTimer(WHITE_FLAG_DURATION, true, true, nil, nil, checkWhiteFlagTime, this, false)
    whiteFlagTimer:start(WHITE_FLAG_DURATION)
    AddEventListener()
end

-- 退出场景--
function WorldMapLevelLogic:onExitScene()
    -- 通知服务器我离开了大地图
    NetworkManager.C2SSwitchMapProto(0)

    logic:leaveBigMap()

    removeAllCityModels() 
    removeAllResourceModels()
    removeAllMilitaryInfo()
    -- 销毁GameObjectManager里的所有对象--
    GameObjectManager.onDestroy()

    moveCityData = nil
    allCityIdList = nil
    myCityId = -1
    myCityModelInfo = nil
    isMyCampsiteRegion = nil 
    myResourceModelInfoList = nil
    myMilitaryObjInfoList = nil
    currClickedAreaInfo = nil
    currMapId = -1

    sceneLoadedCallback = nil
    logic = nil
    RegionWarSituationShow:Clear()
    TimerManager.disposeTimer(whiteFlagTimer)
    RemoveEventListener()
end

-- **********************************************************************************************

-- 进入大地图
function WorldMapLevelLogic:enterBigMap()
    -- 告诉地面现在Lua来管事了
    if not CS.LPCFramework.TerrainLuaDelegates.GoBigMap() then
        -- print("地面没在?")
    else
        -- 	m_iGridWidth = CS.LPCFramework.TerrainLuaDelegates.GetGridWidth()
        -- 	m_iGridHeight = CS.LPCFramework.TerrainLuaDelegates.GetGridHeight()
        -- 	m_fCurveRadius = CS.LPCFramework.TerrainLuaDelegates.GetMapCurveRadius()
        -- 	m_fCurveDegree = CS.LPCFramework.TerrainLuaDelegates.GetMapCurveDegree()

        --        print("地面QddQ Width = "..m_iGridWidth)

        -- 摆放测试城市和树林
        -- 	for i = 0, 200 do
        -- 		CS.LPCFramework.TerrainLuaDelegates.SpawnGroundCityRandomPos("a")
        -- 	end
        -- 	for i = 0, 500 do
        -- 		CS.LPCFramework.TerrainLuaDelegates.SpawnGroundItemRandomPos(i, "a")
        -- 	end

        -- 生成城池模型
        genAllCityModels()
        -- 生成行营模型
        genAllCampsiteModels() 
        -- 生成资源模型
        genAllResourceModels()
        -- 设置camera参数（不再设置了，由美术配置）
        CS.LPCFramework.TerrainLuaDelegates.SetCameraParameters(0.02, 5.0, 15.0)
        -- 移动camera到我的城池上方或者指定的位置
        if DataTrunk.PlayerInfo.RegionData.SpecifiedPosInfo == nil then
            if myCityModelInfo ~= nil then
                logic:moveCameraTo(myCityModelInfo.m_iOddQX, myCityModelInfo.m_iOddQY)            
            else
                logic:moveCameraToCenter()
            end
        else
            logic:moveCameraTo(DataTrunk.PlayerInfo.RegionData.SpecifiedPosInfo.PosX, DataTrunk.PlayerInfo.RegionData.SpecifiedPosInfo.PosY)
            DataTrunk.PlayerInfo.RegionData.SpecifiedPosInfo = nil
        end
        -- 设置“附近”这个参数值
        -- CalculateNearByCities不再有了,
        CS.LPCFramework.TerrainLuaDelegates.SetDefaultRadius(INFLUENCE_RANGE)
        -- 设置点触地面回调
        CS.LPCFramework.TerrainLuaDelegates.SetClickGroundCallBack("OnClickBigMapGround")
        -- 设置摄像机移动回调
        CS.LPCFramework.TerrainLuaDelegates.SetOnCameraFaceToCallback("OnCameraFaceToChanged")
        CS.LPCFramework.TerrainLuaDelegates.SetMoveCityCallbackFunction("OnMoveCityCallBack")
        CS.LPCFramework.TerrainLuaDelegates.SetMoveCityModeCameraScrollParam(
        CS.UnityEngine.Vector4(0.15, 0.85, 0.15, 0.85),
        CS.UnityEngine.Vector3(0.5, 0.1, 0.15))
    end
end

-- 离开大地图
function WorldMapLevelLogic:leaveBigMap()
    -- 告诉地面现在Lua撒手不管了
    if not CS.LPCFramework.TerrainLuaDelegates.LeaveBigMap() then
        -- print("地面没在?")
    else

    end
end

-- 将摄像机设置回到我的主城
function WorldMapLevelLogic:backCameraToMyCity()
    if myCityModelInfo ~= nil then
        logic:moveCameraTo(myCityModelInfo.m_iOddQX, myCityModelInfo.m_iOddQY)
    end
end

-- 摄像机回到自己城池上方
-- <param name="baseX" type="int">城池OddQ坐标X</param>
-- <param name="baseZ" type="int">城池OddQ坐标Z</param>
function WorldMapLevelLogic:moveCameraTo(baseX, baseZ)
    CS.LPCFramework.TerrainLuaDelegates.CameraMoveToOddQ(baseX, baseZ, "OnCameraMoveStop", "PressGround", 0.1)
end

-- 当切换到其它地区时 摄像机移到中心点
function WorldMapLevelLogic:moveCameraToCenter()
    CS.LPCFramework.TerrainLuaDelegates.CameraMoveTo(CS.UnityEngine.Vector2(0.5, 0.5))
end

-- 以当前camera中心与地面的交点为圆心，显示指定半径内的所有城池势力范围，包括冲突
function WorldMapLevelLogic:showCityInfluenceInRange()
    -- 点击按钮时，hideCityInfluenceInRange会马上接下来就执行的样子
    -- 如果只需要显示一下，可以用SelectCityAndNearByCamera
    CS.LPCFramework.TerrainLuaDelegates.TurnCameraSelectMode(true)
end

-- 关闭范围内的势力范围显示，当然自己的城池范围是默认显示的，不会关闭的
function WorldMapLevelLogic:hideCityInfluenceInRange()
    CS.LPCFramework.TerrainLuaDelegates.TurnCameraSelectMode(false)
end


-- 高级迁城(包括迁行营, 放置雕像)
function WorldMapLevelLogic:advancedMoveBase(buildingType)
    moveBuidingType = buildingType
    local monarchsData = DataTrunk.PlayerInfo.MonarchsData
    if buildingType == BuildingType.MainCity then
        local inmovecitymode = CS.LPCFramework.TerrainLuaDelegates.EnterMoveMainCityModeWithOddQ(0.01, currClickedAreaInfo.m_iOddQX, currClickedAreaInfo.m_iOddQY, monarchsData.BaseLevel, getCityModelLevel(monarchsData.BaseLevel), monarchsData.FlagGuildFlagName, monarchsData.Name)
        -- 有3种情况EnterMoveMainCityModeWithOddQ会返回false
        -- 没有地面，没有玩家主城，或者已经在迁城模式。
        -- 对于最后一种情况，不能简单地将inMoveCityMode = inmovecitymode而应该是一个or
        inMoveCityMode = inMoveCityMode or inmovecitymode
        return inmovecitymode
    elseif buildingType == BuildingType.Campsite then
        local moveCampsite = CS.LPCFramework.TerrainLuaDelegates.EnterMoveCampsiteModeWithOddQ(0.01, currClickedAreaInfo.m_iOddQX, currClickedAreaInfo.m_iOddQY, monarchsData.CampLvl, getCityModelLevel(monarchsData.CampLvl), monarchsData.FlagGuildFlagName, monarchsData.Name);
        inMoveCityMode = inMoveCityMode or moveCampsite
        return moveCampsite
    end
end

-- 以当前camera中心与地面的交点为圆心，显示指定半径内的所有城池势力范围，包括冲突
function WorldMapLevelLogic:showCityInfluenceInRange()
    -- 点击按钮时，hideCityInfluenceInRange会马上接下来就执行的样子
    -- 如果只需要显示一下，可以用SelectCityAndNearByCamera
    CS.LPCFramework.TerrainLuaDelegates.TurnCameraSelectMode(true)
end

-- 关闭范围内的势力范围显示，当然自己的城池范围是默认显示的，不会关闭的
function WorldMapLevelLogic:hideCityInfluenceInRange()
    CS.LPCFramework.TerrainLuaDelegates.TurnCameraSelectMode(false)
end

-- <param name="iOddQX" type="number(int)"></param>
-- <param name="iOddQY" type="number(int)"></param>
-- <param name="bCanPut" type="bool"></param>
-- <param name="vPosition" type="Vector3"></param>
-- <param name="vNormal" type="Vector3"></param>
function WorldMapLevelLogic:OnMoveCityCallBack(iOddQX, iOddQY, bCanPut, vPosition, vNormal)
    print("迁城回调", iOddQX, iOddQY, bCanPut, vPosition, vNormal)

    moveCityData.OddQX = iOddQX
    moveCityData.OddQY = iOddQY
    moveCityData.CanPut = bCanPut
    moveCityData.Position = vPosition
    if UIManager.controllerIsOpen(UIManager.ControllerName.MoveCityConfirm, moveBuidingType) == false then
        UIManager.openController(UIManager.ControllerName.MoveCityConfirm, moveBuidingType)
    end

    Event.dispatch(Event.ON_MOVE_CITY_STATUS_UPDATED)
end
-- 退出高级迁城模式
function WorldMapLevelLogic:leaveAdvancedMoveBase()
    CS.LPCFramework.TerrainLuaDelegates.LeaveMoveCityMode()
	inMoveCityMode = false
    moveBuidingType = nil
end


-- 获取当前点击到的区域信息
function WorldMapLevelLogic:getCurrentClickedAreaInfo()
    return currClickedAreaInfo
end

-- 获取当前的地图Id
function WorldMapLevelLogic:getCurrentMapId()
    return currMapId
end

-- 获取我的城池模型信息
function WorldMapLevelLogic:getMyCityModelInfo()
    return myCityModelInfo
end
-- 获取迁城数据
function WorldMapLevelLogic:getMoveCityData()
    return moveCityData
end

local hitOpenSpace = false
-- 点击了大地图地面回调
-- 如果groundInfo = nil，就是一般的空地
-- 根据groundInfo的m_byType来判断是什么。0:从属于某个城的空地，1:城市，21-24资源点
-- v3Position是iOddQX,iOddQY对应的位置，注意，不是点击的位置，点击可能不在格子中心
-- v3Normal是v3Position处的法线
function WorldMapLevelLogic:OnClickBigMapGround(v2UV, iOddQX, iOddQY, v3Position, v3Normal, groundInfo)
    -- 如果是迁城模式，不处理
	if inMoveCityMode then
		return
	end

    currClickedAreaInfo = groundInfo
    -- 点中空地了
    if groundInfo == nil then
        hitOpenSpace = true
    else
        -- 点中城市了
        if groundInfo.m_byGroundItemType == BuildingType.MainCity then

            print("戳到城池了 x:" .. iOddQX .. " y:" .. iOddQY .. " hit city:" .. groundInfo.m_iGroundItemId)
            hitOpenSpace = false
            CS.LPCFramework.TerrainLuaDelegates.SelectCityAndNearBy(groundInfo.m_iGroundItemId)

            -- 发送事件
            Event.dispatch(Event.HIT_CITY)
        -- 点中了行营
        elseif groundInfo.m_byGroundItemType == BuildingType.Campsite then
            print("戳到行营了 x:" .. iOddQX .. " y:" .. iOddQY .. " hit city:" .. groundInfo.m_iGroundItemId)
            hitOpenSpace = false
            CS.LPCFramework.TerrainLuaDelegates.SelectCityAndNearBy(groundInfo.m_iGroundItemId)
            Event.dispatch(Event.HIT_CAMPSITE)
        -- 点到资源点了
        elseif groundInfo.m_byGroundItemType == BuildingType.None or
            (groundInfo.m_byGroundItemType >= BuildingType.GoldMine and groundInfo.m_byGroundItemType <= BuildingType.StonePit) then

            -- 只可以点自己的资源点, 并且不能是行营(此处没有标识是不是行营 所以使用是不是主城所在地区判断).
            if groundInfo.m_bIsPlayerMainCity and DataTrunk.PlayerInfo.MonarchsData.BaseMapId == DataTrunk.PlayerInfo.RegionData:getSelectRegion() then
                print("戳到资源点了 x:" .. iOddQX .. " y:" .. iOddQY .. " hit resource:" .. groundInfo.m_iGroundItemId)

                -- 冲突的资源不可操作
                if groundInfo.m_bPenetrate == true then
                    return
                end

                hitOpenSpace = false

                -- 发送事件
                Event.dispatch(Event.HIT_RESOURCE)
            else
                hitOpenSpace = true
            end
        end
    end

    if hitOpenSpace == true then
        local targetId, actionType = RegionWarSituationShow:GetClickedWarSituation(v3Position.x, v3Position.z)
        if targetId ~= nil then
            if actionType == MilitaryActionType.Invasion then
                UIManager.openController(UIManager.ControllerName.WarSituationActorAttack, targetId)
            else
                UIManager.openController(UIManager.ControllerName.WarSituationActorAssistance, targetId)
            end
            print("戳到了一只马")
            return
        end
        print("戳到空地了 x:" .. iOddQX .. " y:" .. iOddQY)

        currClickedAreaInfo = { }
        currClickedAreaInfo.m_iOddQX = iOddQX
        currClickedAreaInfo.m_iOddQY = iOddQY
        currClickedAreaInfo.m_vGroundItemPos = v3Position

        -- 点击到其它空地时关闭显示城市边界
        CS.LPCFramework.TerrainLuaDelegates.UnSelectAll()
        -- 发送事件，通知UI处理事情
        Event.dispatch(Event.HIT_OPEN_SPACE)
    end
end

-- <param name="keyword" type="string">君主Id</param>
-- <param name="finished" type="bool">true完成移动，false完成这次移动前又一次调用了camera move to</param>
function WorldMapLevelLogic:OnCameraMoveStop(keyword, finished)
    print("有代码刚刚晃了摄像机?" .. keyword)
end

-- 玩家动了摄像机
function WorldMapLevelLogic:OnCameraFaceToChanged(iOddQX, iOddQY, fDistance)
    -- 如果为nan
    if fDistance ~= fDistance then
        fDistance = 0
    end
    Event.dispatch(Event.UPDATE_NAV_MILES, fDistance)
end

function OnMoveCityCallBack(iOddQX, iOddQY, bCanPut, vPosition, vNormal)
    WorldMapLevelLogic:OnMoveCityCallBack(iOddQX, iOddQY, bCanPut, vPosition, vNormal)
end

function OnClickBigMapGround(v2UV, iOddQX, iOddQY, v3Position, v3Normal, groundInfo)
    WorldMapLevelLogic:OnClickBigMapGround(v2UV, iOddQX, iOddQY, v3Position, v3Normal, groundInfo)
end

function OnCameraMoveStop(keyword, finished)
    WorldMapLevelLogic:OnCameraMoveStop(keyword, finished)
end

function OnCameraFaceToChanged(iOddQX, iOddQY, fDistance)
    WorldMapLevelLogic:OnCameraFaceToChanged(iOddQX, iOddQY, fDistance)
end

return WorldMapLevelLogic