LevelType = {
    Bootup = "Bootup",
    MainCity = "MainCity",
    WorldMap = "WorldMap",
    Battle = "Battle",
}

WorldMapRegionType =
{
    RegionVillage = 1,
    -- 乡
    RegionCounty = 2,
    -- 县
    RegionProvince = 3,
    -- 郡
    RegionCapital = 4,-- 京都
}

LevelConfig =
{
    ["Bootup"] =
    {
        Type = LevelType.Bootup,
        -- 逻辑脚本--
        LogicScript = "LevelLogic.BootupLevelLogic",
        -- 场景名称--
        SceneName = "Bootup",
    },
    ["MainCity"] =
    {
        Type = LevelType.MainCity,
        -- 逻辑脚本--
        LogicScript = "LevelLogic.MainCityLevelLogic",
        -- 场景名称--
        SceneName = "MainCity",
        Extra = "Prefabs/Camera/CameraControllerMainCity"
    },
    ["WorldMap"] =
    {
        Type = LevelType.WorldMap,
        -- 逻辑脚本--
        LogicScript = "LevelLogic.WorldMapLevelLogic",
        -- 场景名称--
        SceneName = "WorldMap",
    },
    ["Battle_Field_1"] =
    {
        Type = LevelType.Battle,
        -- 逻辑脚本--
        LogicScript = "LevelLogic.Battle1v1LevelLogic",
        -- 场景名称--
        SceneName = "BattleField",
        -- 摄像头动画控制器--
        CameraAnimCtrl = "AnimatorController/Camera_1v1_Effect",
        -- 移动时间，单位为秒--
        MoveStepDuration = 1,
        -- 轮次间隔--
        RoundInterval = 0.6,
        -- 回合间隔--
        BoutInterval = 2,
        -- 地图一个格子宽度
        MapGridWidth = 2.6,
        -- 地图一个格子高度
        MapGridHeight = 2.6,
    },
    ["Battle_3v3_1"] =
    {
        Type = LevelType.Battle,
        -- 逻辑脚本--
        LogicScript = "LevelLogic.BattleMultiplayerLevelLogic",
        -- 场景名称--
        SceneName = "Battle3v3",
        -- 摄像头动画控制器--
        CameraAnimCtrl = "AnimatorController/Camera_1v1_Effect",
        -- 移动时间，单位为秒--
        MoveStepDuration = 1,
        -- 轮次间隔--
        RoundInterval = 0.6,
        -- 回合间隔--
        BoutInterval = 2,
        -- 地图一个格子宽度
        MapGridWidth = 2.6,
        -- 地图一个格子高度
        MapGridHeight = 2.6,
    },
}

-- 根据Id获取配置
-- <param name="id" type="number"></param>
function LevelConfig:getConfigByKey(id)
    return LevelConfig[id]
end

-- 规格化
local function normalLize()

    if LevelConfig == nil then
        return
    end
end

-- 检测配置是否合法
local function check()

end

-- 此文件被加载时立即执行
normalLize()
check()
