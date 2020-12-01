-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local GameObjectManager = { }

-- 池的根节点
local poolRootObj = nil
-- 角色对象池
local gameObjectPools = nil
-- 场景中的物体列表（除角色外）
local gameObjectList = nil
-- 场景中的角色列表
local actorList = nil

local ACTOR_POOL_PREFIX = 'Actor'
local GAME_OBJECT_POOL_PREFIX = 'GameObject'

local isInitialized = false

-- 初始化数据
local function initData()
    -- 创建一个对象池根节点
    if (poolRootObj == nil) then
        poolRootObj = CS.UnityEngine.GameObject('GameObjectPool')
    end

    -- 建立弱引用表
    gameObjectPools = setmetatable( { }, { __mode = 'k' })
    gameObjectList = setmetatable( { }, { __mode = 'k' })
    actorList = setmetatable( { }, { __mode = 'k' })
end

-- 加载prefab，需要实例化才可使用
-- <param name="config" type="table"></param>
local function loadAssetByConfig(config)
    if config ~= nil then
        return CS.LPCFramework.LogicUtils.LoadResource(config.prefab)
    else
        return nil
    end
end

-- 加载prefab，需要实例化才可使用
-- <param name="id" type="number"></param>
-- <param name="isActor" type="boolen">是否为Actor类型</param>
local function loadAssetById(id, isActor)
    isActor = isActor or false

    -- 获取配置
    local config = nil
    if isActor == true then
        config = ActorConfig:getConfigByKey(id)
    else
        config = GameObjectConfig:getConfigByKey(id)
    end

    return loadAssetByConfig(config)
end
-- 获取实例化脚本
-- <param name="insId" type="numble">实例化Id</param>
-- <param name="scriptName" type="string">脚本name</param>
-- <param name="isActor" type="boolen">是否为Actor类型</param>
local function getScriptInstance(insId, scriptName, isActor)
    if scriptName == nil then return nil, nil end

    -- 获取实例化脚本
    local scriptInstance = require(scriptName)()
    -- 分别放入不同对象列表
    if isActor == true then
        actorList[insId] = scriptInstance
    else
        gameObjectList[insId] = scriptInstance
    end

    return scriptInstance
end
-- 获取池中对象
-- <param name="poolName" type="string">池名字</param>
-- <param name="insId" type="string">实例化Id</param>
-- <param name="configId" type="number">配置Id</param>
-- <param name="isActor" type="boolen">是否为Actor类型</param>
local function getPoolObject(poolName, insId, configId, isActor)
    -- 如果在活跃状态
    if nil ~= insId then
        -- 角色
        if isActor and nil ~= actorList[insId] then
            return actorList[insId].gameObject
        end
        if not isActor and nil ~= gameObjectList[insId] then
            return gameObjectList[insId].gameObject
        end
    end
    -- 如果没有缓存，则生成一个
    if gameObjectPools[poolName] == nil then
        GameObjectManager.initPool(configId, 1, 3, isActor)
    end
    return gameObjectPools[poolName]:NextAvailableObject()
end
-- 获取对象池名称
local function getPoolName(postfix, isActor)
    local poolName = nil
    if isActor == true then
        poolName = ACTOR_POOL_PREFIX .. postfix
    else
        poolName = GAME_OBJECT_POOL_PREFIX .. postfix
    end

    return poolName
end

-- 构造函数
function GameObjectManager.initialize()
    initData()

    isInitialized = true
end
-- 更新
function GameObjectManager.update()
    if isInitialized == false then
        return
    end

    -- 无对象，不更新
    if gameObjectList == nil and actorList == nil then
        return
    end

    -- GameObject
    for k, v in pairs(gameObjectList) do
        if v ~= nil then
            v:update()
        end
    end
    -- Actor
    for k, v in pairs(actorList) do
        if v ~= nil then
            v:update()
        end
    end
end
-- 析构
function GameObjectManager.onDestroy()

    -- 无对象，不析构
    if gameObjectList == nil and actorList == nil and gameObjectPools == nil then
        return
    end

    -- GameObject
    for k, v in pairs(gameObjectList) do
        if v ~= nil then
            v:onDestroy()
        end
    end
    -- Actor
    for k, v in pairs(actorList) do
        if v ~= nil then
            v:onDestroy()
        end
    end
    -- Pool
    for k, v in pairs(gameObjectPools) do
        if v ~= nil then
            v:OnDestroy()
        end
    end

    CS.UnityEngine.GameObject.Destroy(poolRootObj)
    gameObjectPools = nil
    gameObjectList = nil
    poolRootObj = nil
    actorList = nil
end

-------------------------------------------------------------------------

-- 初始化一个对象池
-- <param name="configId" type="number">配置id</param>
-- <param name="initMin" type="number">初始个数</param>
-- <param name="max" type="number">最大个数</param>
-- <param name="isActor" type="boolen">是否为Actor类型</param>
function GameObjectManager.initPool(configId, initMin, max, isActor)
    isActor = isActor or false

    assert(type(configId) == 'number', '[error] configId is not a number')
    assert(type(initMin) == 'number', '[error] initMin is not a number')
    assert(type(max) == 'number', '[error] max is not a number')
    assert(initMin >= 0, '[error] initMin is an invalid value')
    assert(max >= 0, '[error] max is an invalid value')

    local reason = ''
    local poolName = getPoolName(configId, isActor)
    local config = nil
    if isActor == true then
        config = ActorConfig:getConfigByKey(configId)
    else
        config = GameObjectConfig:getConfigByKey(configId)
    end

    if config ~= nil then
        -- 载入一个prefab
        local objPrefab = loadAssetByConfig(config)
        -- 创建一个对象池
        if objPrefab ~= nil then
            local objPool = CS.LPCFramework.GameObjectPool(poolName, objPrefab, initMin, max, poolRootObj.transform)
            if objPool ~= nil then
                gameObjectPools[poolName] = objPool
                return
            else
                reason = 'please check parameters'
            end
        else
            reason = 'cant load ' .. config.prefab
        end
    else
        reason = 'invalid actor config Id'
    end

    print('[warning] create pool failed, ' .. reason)

end
-- 将对象返还给对象池
function GameObjectManager.returnObjectToPool(objInstance, instanceId, configId, isActor)
    assert(objInstance ~= nil, "[error GameObjectManager.returnObjectToPool] ObjInstance should not be null!")

    -- 删除类引用
    if isActor == true then
        if actorList ~= nil then
            if actorList[instanceId] ~= nil then
                actorList[instanceId] = nil
            end
        end
    else
        if gameObjectList ~= nil then
            if gameObjectList[instanceId] ~= nil then
                gameObjectList[instanceId] = nil
            end
        end
    end

    -- 返回对象池或者销毁
    local poolName = getPoolName(configId, isActor)
    if gameObjectPools ~= nil and poolName ~= nil then
        if gameObjectPools[poolName] ~= nil then
            gameObjectPools[poolName]:ReturnObjectToPool(poolName, objInstance)
        else
            CS.UnityEngine.GameObject.Destroy(objInstance)
        end
    end
end
-- 生成对象
-- <param name="configId" type="number">configId</param>
-- <param name="speedRate" type="number">速率</param>
-- <param name="position" type="Vector3">位置</param>
-- <param name="rotation" type="Quaternion">旋转</param>
-- <param name="parent" type="transform">父对象的tranform</param>
function GameObjectManager.spawnObject(configId, speedRate, position, rotation, parent)
    -- 配置信息为空
    if nil == configId then return nil end
    -- 获取配置
    local config = GameObjectConfig:getConfigByKey(configId)
    -- 配置为空
    if config == nil then return nil end
    -- 获取对象
    local gameObject = getPoolObject(getPoolName(configId, false), nil, configId, false)
    -- 对象为空
    if nil == gameObject then return nil end
    -- 设置父对象
    parent = parent or poolRootObj.transform
    gameObject.transform.parent = parent;
    -- 设置位置信息
    gameObject.transform.localPosition = config.OffsetPos
    gameObject.transform.localRotation = CS.UnityEngine.Quaternion.Euler(config.OffsetRot)
    -- 设置世界位置
    if nil ~= position then
        gameObject.transform.position = position
    end
    if nil ~= rotation then
        gameObject.transform.rotation = rotation
    end
    -- 不吸附槽位
    if not config.attachTarget then
        gameObject.transform.parent = poolRootObj.transform;
    end
    -- 生成脚本
    local insInfo = { InsId = gameObject:GetInstanceID() }
    local scriptInstance = getScriptInstance(insInfo.InsId, config.script, false)
    -- 初始化
    if nil ~= scriptInstance then
        scriptInstance:initialize(gameObject, insInfo, config, speedRate)
    end
    return scriptInstance
end
-- 生成角色
-- <param name="insInfo" type="table">实例化数据</param>
-- <param name="configId" type="number">configId</param>
-- <param name="speedRate" type="number">速率</param>
-- <param name="position" type="Vector3">位置</param>
-- <param name="rotation" type="Quaternion">旋转</param>
-- <param name="parent" type="transform">父对象的tranform</param>
-- <return class script>
function GameObjectManager.spawnActor(insInfo, configId, speedRate, position, rotation, parent)
    -- 实例化信息为空
    if nil == insInfo or nil == configId then return end
    -- 获取配置
    local config = ActorConfig:getConfigByKey(configId)
    -- 配置为空
    if config == nil then return nil end
    -- 获取对象
    local gameObject = getPoolObject(getPoolName(configId, true), insInfo.InsId, configId, true)
    -- 对象为空
    if nil == gameObject then return nil end
    -- 设置父对象
    parent = parent or poolRootObj.transform
    gameObject.transform.parent = parent
    -- 设置位置信息
    position = position or CS.UnityEngine.Vector3.zero
    rotation = rotation or CS.UnityEngine.Quaternion.identity
    gameObject.transform.position = position
    gameObject.transform.rotation = rotation
    -- 生成脚本
    local scriptInstance = getScriptInstance(insInfo.InsId, config.script, true)
    -- 初始化
    if nil ~= scriptInstance then
        scriptInstance:initialize(gameObject, insInfo, config, speedRate)
    end
    return scriptInstance
end
-- 设置位置和旋转
-- <param name="insId" type="number">角色实例化Id</param>
-- <param name="direction" type="Vector3">目标方向</param>
function GameObjectManager.setPosAndRot(insId, position, rotation, isActor)
    if isActor == true then
        if actorList[insId] ~= nil then
            actorList[insId]:setPosAndRot(position, rotation)
        end
    else
        if gameObjectList[insId] ~= nil then
            gameObjectList[insId]:setPosAndRot(position, rotation)
        end
    end
end
-- 角色向指定位置移动
-- <param name="insId" type="number">角色实例化Id</param>
-- <param name="point" type="Vector3">目标位置</param>
-- <param name="moveTime" type="Vector3">移动时间</param>
function GameObjectManager.onActorMovePoint(insId, point, moveTime, moveType)
    if actorList[insId] ~= nil then
        actorList[insId]:movePoint(point, moveTime, moveType)
    end
end
-- 角色向指定位置移动
-- <param name="insId" type="number">角色实例化Id</param>
-- <param name="points" type="Vector3">目标位置</param>
-- <param name="moveTime" type="Vector3">移动时间</param>
function GameObjectManager.onActorMovePoints(insId, points, moveTime, moveType)
    if actorList[insId] ~= nil then
        actorList[insId]:movePoints(points, moveTime)
    end
end
-- 角色攻击指定角色
-- <param name="insId" type="number">角色实例化Id</param>
-- <param name="targetInsId" type="number">目标实例化Id</param>
-- <param name="skillId" type="number">技能Id</param>
function GameObjectManager.onActorAttck(insId, targetInsId, skillId, damage, hurtType)
    if actorList[insId] ~= nil and actorList[targetInsId] ~= nil then
        actorList[insId]:onAttack(actorList[targetInsId], skillId, damage, hurtType)
    end
end
-- 通知角色受伤
-- <param name="insId" type="number">角色实例化Id</param>
-- <param name="damage" type="number">受伤点数</param>
function GameObjectManager.onActorDamage(insId, delayTime, damage)
    if actorList[insId] ~= nil then
        actorList[insId]:onDamage(delayTime, damage)
    end
end
-- 设置可见
-- <param name="insId" type="number">角色实例化Id</param>
-- <param name="active" type="boolean">可见</param>
function GameObjectManager.setActorActive(insId, active)
    if actorList[insId] ~= nil then
        actorList[insId]:setActive(active)
    end
end
-- 设置播放速度
-- <param name="speed" type="number">速度</param>
function GameObjectManager.setPlaybackSpeed(speed)
    -- 无对象，不处理
    if gameObjectList == nil then
        return
    end

    -- Actor
    for k, v in pairs(actorList) do
        if v ~= nil then
            v:setPlaybackSpeed(speed)
        end
    end
    -- GameObject
    for k, v in pairs(gameObjectList) do
        if v ~= nil then
            v:setPlaybackSpeed(speed)
        end
    end
end

-- 查找是否已经从对象池获得了一个对象
function GameObjectManager.IsGameObjectUsing(insInfo, isActor)
    local classInstance = nil
    if nil ~= insInfo then
        if isActor then
            classInstance = actorList[insInfo.InsId]
        else
            classInstance = gameObjectList[insInfo.InsId]
        end
    end

    return classInstance ~= nil
end 

-- 设定军情马展示时的位置采样点
function GameObjectManager.SetGameObjectMovePath(insInfo, pathData, startTime, endTime, isActor)
    if not isActor then
        return
    end

    if nil ~= insInfo then
        local classInstance = actorList[insInfo.InsId]
        if classInstance ~= nil then
            classInstance:SetMovePath(pathData, startTime, endTime)
        end
    end
end

return GameObjectManager

