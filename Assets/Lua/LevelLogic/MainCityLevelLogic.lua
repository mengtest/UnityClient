local levelLogic = require "LevelLogic.LevelLogic"
local MainCityLevelLogic = levelLogic:extend()
local Event = require "Event.Event"

local logic = nil
-- 当场景逻辑处理完毕
local onLogicHandleComplete = nil

-- 加载主城额外的预制件(摄像机,建筑碰撞盒,建筑标签)
local function InitMainCityExtraPrefab()
    CS.UnityEngine.GameObject.Instantiate(CS.UnityEngine.Resources.Load(LevelConfig.MainCity.Extra))
end

-- 加载完毕后收到服务器推送来的数据信息
local function onBootupLoaded()    
    InitMainCityExtraPrefab()
    -- 打开主城界面
    UIManager.openController(UIManager.ControllerName.MainCity)     
    -- 逻辑处理完成
    onLogicHandleComplete()
    -- 进入主城
    Event.dispatch(Event.LOADING_MAINCITY_SUCCESS)

    -- 临时代码，上传用户机器信息
    local info = CS.LPCFramework.SystemInfoUtils.Instance.Info
    if info ~= "" then
        NetworkManager.C2SClientLogProto("[UserSystemInfo]", info)
    end
end
Event.addListener(Event.SCENE_LOADED, onBootupLoaded)

---------------------------------------------------------
-- 场景事件
---------------------------------------------------------
-- 初始化场景地图--
function MainCityLevelLogic:initLevel(levelConfig)
    logic.super.initLevel(logic, levelConfig)
end

-- 进入场景--
function MainCityLevelLogic:onEnterScene(callBack)
    logic = self
    logic:initLevel(LevelManager.CurrLevelConfig)

    -- 请求数据
    if not DataTrunk.SyncComplete then
        onLogicHandleComplete = callBack
        NetworkManager.C2SLoadedProto()
    else
        callBack()
        InitMainCityExtraPrefab()
        Event.dispatch(Event.LOADING_MAINCITY_SUCCESS)
    end
    -- 测试代码，相关逻辑人员自行添加
    AudioManager.PlaySound('BGM_City01', 1)
end

-- 退出场景--
function MainCityLevelLogic:onExitScene()
end

-- 更新
function MainCityLevelLogic:update()

end

return MainCityLevelLogic