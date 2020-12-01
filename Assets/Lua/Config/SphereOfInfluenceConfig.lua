-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

-- 随等级开放的势力范围配置文件，遵循六边形Odd-q排列
-- 此处配置的是基于主城坐标的偏移
SphereOfInfluenceConfig = 
{
    -- 奇数列
    [true] = 
    {
        -- 一级开放
        [0] = 
        {
            -- 基于主城坐标的偏移
            {1, 1},
            {0, 1},
            {-1, 1},
            {-1, 0},
            {0, -1},
            {1, 0},
        },
        -- 二级开放
        [1] = 
        {
            {2, 0},
            {0, 2},
            {-2, 0},
            {0, -2},
        },
    },
    -- 偶数列
    [false] = 
    {
        [0] = 
        {
            {1, 0},
            {0, 1},
            {-1, 0},
            {-1, -1},
            {0, -1},
            {1, -1},
        },
        [1] = 
        {
            {2, 0},
            {0, 2},
            {-2, 0},
            {0, -2},
        },
    }
}

-- 根据Id获取配置
-- <param name="id" type="number"></param>
function SphereOfInfluenceConfig:getConfigByKey(id)
    return SphereOfInfluenceConfig[id]
end

-- 规格化
local function normalLize()
    
end

-- 检测配置是否合法
local function check()
    
end

-- 此文件被加载时立即执行
normalLize()
check()