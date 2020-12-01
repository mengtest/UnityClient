local LevelManager = { }

-- 之前关卡类型
LevelManager.PreLevelType = nil
-- 当前关卡类型
LevelManager.CurLevelType = nil
-- 当前关卡配置
LevelManager.CurrLevelConfig = nil
-- 当前关卡逻辑
LevelManager.CurrLevelLogic = nil
-- 外部传入数据
LevelManager.IncomingInfo = nil

-- 进入场景--
local function onEnterScene(callBack)
    if LevelManager.CurrLevelLogic ~= nil then
        LevelManager.CurrLevelLogic:onEnterScene(callBack)
    else
        callBack()
    end
end

-- 退出场景--
local function onExitScene()
    if LevelManager.CurrLevelLogic ~= nil then
        LevelManager.CurrLevelLogic:onExitScene()
    end

    LevelManager.CurrLevelConfig = nil
    LevelManager.CurrLevelLogic = nil
end

-- 所有加载完成--
local function onLoadComplete()
    -- 通知ui--
    Event.dispatch(Event.LOADING_COMPLETE)
end

-- 开始scene load--
local function onSceneLoadStart()
    -- 打开加载界面--
    UIManager.openController(UIManager.ControllerName.Loading)
end

-- 进行scene load--
local function onSceneLoadUpdate(p)
    -- 通知ui--
    Event.dispatch(Event.LOADING_UPDATE, p)
end

-- 完成scene load--
local function onSceneLoadComplete()
    onEnterScene(onLoadComplete)
end
-- load 出错--
local function onLoadError(errorMsg)
    NetworkManager.C2SClientLogProto("error", errorMsg)
end

-- 初始化
function LevelManager.initialize()
    -- 初始场景为Bootup，执行其脚本
    LevelManager.CurrLevelConfig = LevelConfig:getConfigByKey(LevelType.Bootup)
    LevelManager.CurLevelType = LevelManager.CurrLevelConfig.Type
end

-- 加载指定场景
-- <param name="id" type="number">场景id</param>
-- <param name="info" type="table">外部传入的参数</param>
function LevelManager.loadScene(id, info)
    LevelManager.IncomingInfo = info

    if LevelManager.CurrLevelConfig ~= nil then
        LevelManager.PreLevelType = LevelManager.CurrLevelConfig.Type
        onExitScene()
    end

    LevelManager.CurrLevelConfig = LevelConfig:getConfigByKey(id)
    if LevelManager.CurrLevelConfig == nil then
        return
    end
    LevelManager.CurLevelType = LevelManager.CurrLevelConfig.Type
    if LevelManager.CurrLevelConfig.LogicScript ~= nil then
        LevelManager.CurrLevelLogic = require(LevelManager.CurrLevelConfig.LogicScript)
    end

    if LevelManager.CurrLevelConfig.SceneName ~= nil and LevelManager.PreLevelType ~= LevelManager.CurLevelType then
        CS.LPCFramework.SceneLoader.Instance:LoadScene(LevelManager.CurrLevelConfig.SceneName, onSceneLoadStart, onSceneLoadUpdate, onSceneLoadComplete, onLoadError)
    else
        -- 使用同一个场景，直接切换LevelLogic
        onSceneLoadComplete()
    end
end

-- 加载指定场景，调试用
-- <param name="id" type="number">场景id</param>
-- <param name="logicScript" type="string">场景逻辑脚本</param>
function LevelManager.loadSceneForDebug(id, logicScript)
    if LevelManager.CurrLevelConfig ~= nil then
        LevelManager.PreLevelType = LevelManager.CurrLevelConfig.Type
        onExitScene()
    end

    LevelManager.CurrLevelConfig = LevelConfig:getConfigByKey(id)
    if LevelManager.CurrLevelConfig == nil then
        return
    end
    LevelManager.CurLevelType = LevelManager.CurrLevelConfig.Type
    
    if logicScript ~= nil then
        LevelManager.CurrLevelLogic = require(logicScript)
    end

    if LevelManager.CurrLevelConfig.SceneName ~= nil and LevelManager.PreLevelType ~= LevelManager.CurLevelType then
        CS.LPCFramework.SceneLoader.Instance:LoadScene(LevelManager.CurrLevelConfig.SceneName, onSceneLoadStart, onSceneLoadUpdate, onSceneLoadComplete, onLoadError)
    else
        -- 使用同一个场景，直接切换LevelLogic
        onSceneLoadComplete()
    end
end

-- 更新--
function LevelManager.update()
    if LevelManager.CurrLevelLogic ~= nil then
        LevelManager.CurrLevelLogic:update()
    end
end

return LevelManager