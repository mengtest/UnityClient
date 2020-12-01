-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

-- 角色配置文件，以兵种类型做id
ActorConfig =
{
    [1] =
    {
        desc = "步兵1",
        prefab = "Prefabs/Monster/Cha_soldier",
        script = "Actor/ActorFighter",
        icon = "",
        raceType = 1,
        -- skillConfig索引Id
        normalAttackId = 1001,
    },
    [2] =
    {
        desc = "骑兵1",
        prefab = "Prefabs/Monster/Cha_cavalry",
        script = "Actor/ActorFighter",
        icon = "",
        raceType = 2,
        normalAttackId = 1002,
    },
    [3] =
    {
        desc = "弓兵1",
        prefab = "Prefabs/Monster/Cha_archer",
        script = "Actor/ActorFighter",
        icon = "",
        raceType = 3,
        normalAttackId = 1003,
    },
    [4] =
    {
        desc = "车兵1",
        prefab = "Prefabs/Monster/Cha_chariot",
        script = "Actor/ActorFighter",
        icon = "",
        raceType = 4,
        normalAttackId = 1004,
    },
    [5] =
    {
        desc = "械兵1",
        prefab = "Prefabs/Monster/Cha_demolisher",
        script = "Actor/ActorFighter",
        icon = "",
        raceType = 5,
        normalAttackId = 1005,
    },
    [11] =
    {
        desc = "骑兵.军情展示",
        prefab = "Prefabs/Monster/Cha_cavalry_low",
        script = "Actor/ActorWarSituation",
        icon = "",
        raceType = nil,
    },
    [12] =
    {
        desc = "骑兵.攻击城堡",
        prefab = "Prefabs/Monster/Cha_cavalry_low",
        script = "Actor/ActorAttackOrAssist",
        icon = "",
        raceType = nil,
    }
}

-- 根据Id获取配置
-- <param name="id" type="number"></param>
function ActorConfig:getConfigByKey(id)
    return ActorConfig[id]
end

-- 规格化
local function normalLize()

    if ActorConfig == nil then
        return
    end

    for k, v in ipairs(ActorConfig) do
        v.id = k
    end

end

-- 检测配置是否合法
local function check()

end

-- 此文件被加载时立即执行
normalLize()
check()
