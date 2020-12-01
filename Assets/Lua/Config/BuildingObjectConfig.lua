-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

-- 建筑物配置文件
BuildingObjectConfig =
{
    -- 铜矿
    [BuildingType.GoldMine] =
    {
        prefabPath = "Prefabs/Scene/DynamicData/GoldMine",
    },
    -- 农田
    [BuildingType.Cropland] =
    {
        prefabPath = "Prefabs/Scene/DynamicData/Cropland",
    },
    -- 伐木场
    [BuildingType.Sawmill] =
    {
        prefabPath = "Prefabs/Scene/DynamicData/Sawmill",
    },
    -- 采石场
    [BuildingType.StonePit] =
    {
        prefabPath = "Prefabs/Scene/DynamicData/StonePit",
    },
}

-- 根据Id获取配置
-- <param name="id" type="number"></param>
function BuildingObjectConfig:getConfigByKey(id)
    return BuildingObjectConfig[id]
end

-- 规格化
local function normalLize()

    if BuildingObjectConfig == nil then
        return
    end

    for k, v in ipairs(BuildingObjectConfig) do
        v.id = k
    end

end

-- 检测配置是否合法
local function check()

end

-- 此文件被加载时立即执行
normalLize()
check()
