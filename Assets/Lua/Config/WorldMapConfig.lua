local function WorldMapConfig()
    -- 多点触控参数
    local CONST_MAX_TOUCH_COUNT = 5
    local CONST_INVALID_TOUCH_ID = -99
    local CONST_MOUSE_TOUCH_ID = 99
    local CONST_TOUCH_STAT = 0.1
    local CONST_HOLD_TIME_CHECK = 0.8
    local CONST_MOVE_DISTANCE_CHECK = 0.015
    -- 滑动移动速度参数
    local CONST_CAMERA_TOUCH_MOVE_MIN_SPEED = 0.04
    local CONST_CAMERA_TOUCH_MOVE_MAX_SPEED = 0.15
    local CONST_CAMERA_TOUCH_MOVE_DELTA_SPEED = 15
    -- 连线object池大小
    local CONST_LINE_POOL_MIN = 3
    local CONST_LINE_POOL_MAX = 10
    -- 主城object池大小
    local CONST_MAINCITY_POOL_MIN = 50
    local CONST_MAINCITY_POOL_MAX = 100
    -- 金矿object池大小
    local CONST_GOLDMINE_POOL_MIN = 1
    local CONST_GOLDMINE_POOL_MAX = 4
    -- 农田object池大小
    local CONST_CROPLAND_POOL_MIN = 1
    local CONST_CROPLAND_POOL_MAX = 4
    -- 伐木场object池大小
    local CONST_SAWMILL_POOL_MIN = 1
    local CONST_SAWMILL_POOL_MAX = 4
    -- 采石场object池大小
    local CONST_STONEPIT_POOL_MIN = 1
    local CONST_STONEPIT_POOL_MAX = 4
    -- 行营object池大小
    local CONST_CAMPSITE_POOL_MIN = 5
    local CONST_CAMPSITE_POOL_MAX = 15
    -- 陡坡的系数
    local CONST_SLOPE_RATIO1 = 0.85
    local CONST_SLOPE_RATIO2 =  0.96
    -- GoundCityModelIndex
    local CONST_CITY_MODEL_MIN_INDEX = 1
    local CONST_CITY_MODEL_MAX_INDEX = 3
    -- Color
    local CONST_PLAYR_CITY_PROJECTOR_COLOR = CS.UnityEngine.Color.green
    local CONST_PLAYR_UNION_PROJECTOR_COLOR = CS.UnityEngine.Color.blue
    local CONST_NO_UNION_PROJECTOR_COLOR = CS.UnityEngine.Color.yellow
    local CONST_ENEMY_UNION_PROJECTOR_COLOR = CS.UnityEngine.Color.red
    local CONST_PENETRATION_COLOR = CS.UnityEngine.Color(212.0 / 255.0, 100.0 / 255.0, 100.0 / 255.0, 1.0)
    local CONST_CAN_PUT_CITY_COLOR = CS.UnityEngine.Color(1.0, 1.0, 1.0, 0.3)
    local CONST_CAN_NOT_PUT_CITY_COLOR = CS.UnityEngine.Color(1.0, 0.0, 0.0, 0.5)
    local CONST_CAN_PUT_CITY_GI_COLOR = CS.UnityEngine.Color(0.0, 1.0, 0.0, 0.5)
    local CONST_CAN_NOT_PUT_CITY_GUI_COLOR = CS.UnityEngine.Color(0.5, 0.3, 0.3, 0.5)
    local CONST_PUT_CITY_SHADER_PARAM = CS.UnityEngine.Vector4(200.0, 0.5, 0.0, 0.0)

    CS.LPCFramework.TerrainLuaDelegates.SetTerrainParam(
        CONST_MAX_TOUCH_COUNT,
        CONST_INVALID_TOUCH_ID,
        CONST_MOUSE_TOUCH_ID,
        CONST_TOUCH_STAT,
        CONST_HOLD_TIME_CHECK,
        CONST_MOVE_DISTANCE_CHECK,
        CONST_CAMERA_TOUCH_MOVE_MIN_SPEED,
        CONST_CAMERA_TOUCH_MOVE_MAX_SPEED,
        CONST_CAMERA_TOUCH_MOVE_DELTA_SPEED,
        CONST_LINE_POOL_MIN,
        CONST_LINE_POOL_MAX,
        CONST_MAINCITY_POOL_MIN,
        CONST_MAINCITY_POOL_MAX,
        CONST_GOLDMINE_POOL_MIN,
        CONST_GOLDMINE_POOL_MAX,
        CONST_CROPLAND_POOL_MIN,
        CONST_CROPLAND_POOL_MAX,
        CONST_SAWMILL_POOL_MIN,
        CONST_SAWMILL_POOL_MAX,
        CONST_STONEPIT_POOL_MIN,
        CONST_STONEPIT_POOL_MAX,
        CONST_CAMPSITE_POOL_MIN,
        CONST_CAMPSITE_POOL_MAX,
        CONST_SLOPE_RATIO1,
        CONST_SLOPE_RATIO2,
        CONST_CITY_MODEL_MIN_INDEX,
        CONST_CITY_MODEL_MAX_INDEX,
        CONST_PLAYR_CITY_PROJECTOR_COLOR,
        CONST_PLAYR_UNION_PROJECTOR_COLOR,
        CONST_NO_UNION_PROJECTOR_COLOR,
        CONST_ENEMY_UNION_PROJECTOR_COLOR,
        CONST_PENETRATION_COLOR,
        CONST_CAN_PUT_CITY_COLOR,
        CONST_CAN_NOT_PUT_CITY_COLOR,
        CONST_CAN_PUT_CITY_GI_COLOR,
        CONST_CAN_NOT_PUT_CITY_GUI_COLOR,
        CONST_PUT_CITY_SHADER_PARAM,
        DataTrunk.PlayerInfo.RegionData.BlockPointInfo
    )
end

return WorldMapConfig