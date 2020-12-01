-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

--    None = - 1,
--    -- 脚底
--    Base = 0,
--    -- 中心
--    Center = 1,
--    -- 头部
--    Head = 2,
--    -- 左手
--    LeftHand = 3,
--    -- 右手
--    RightHand = 4,
--    -- 武器01
--    Weapon01 = 5,
--    -- 武器02
--    Weapon02 = 6,

-- 物体配置文件
GameObjectConfig =
{
    [1] =
    {
        desc = "弓箭手普攻-蓄力效果",
        prefab = "Prefabs/Particle/Eff_Archer_pugongxuli",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [2] =
    {
        desc = "弓箭手普攻-飞行效果",
        prefab = "Prefabs/Particle/Eff_Archer_pugongjian",
        SlotType = 1,
        script = "Actor/FlyObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        velocity = 25,
    },
    [3] =
    {
        desc = "弓箭手普攻-受击效果",
        prefab = "Prefabs/Particle/Eff_Archer_pugongbaodian",
        SlotType = 1,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [4] =
    {
        desc = "弓箭手克制技能-蓄力效果",
        prefab = "Prefabs/Particle/Eff_Archer_kezhixuli",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [5] =
    {
        desc = "弓箭手克制技能-飞行效果",
        prefab = "Prefabs/Particle/Eff_Archer_kezhijian",
        SlotType = 1,
        script = "Actor/FlyObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        velocity = 25,
    },
    [6] =
    {
        desc = "弓箭手克制技能-受击效果",
        prefab = "Prefabs/Particle/Eff_Archer_kezhibaodian",
        SlotType = 1,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [7] =
    {
        desc = "步兵普攻-攻击效果",
        prefab = "Prefabs/Particle/Eff_soldier_pugongdao",
        SlotType = 0,
        script = "Actor/MeleeAttackBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [8] =
    {
        desc = "步兵普攻-受击效果",
        prefab = "Prefabs/Particle/Eff_soldier_pugongbaodian",
        SlotType = 1,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1.5,
    },
    [9] =
    {
        desc = "步兵克制技能-攻击效果",
        prefab = "Prefabs/Particle/Eff_soldier_kezhiqitiaoxiaoguo",
        SlotType = 0,
        script = "Actor/MeleeAttackBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [10] =
    {
        desc = "步兵克制技能-附魔效果",
        prefab = "Prefabs/Particle/Eff_soldier_kezhiwuqixiaoguo",
        SlotType = 5,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = true,

        lifeTime = 2.5,
    },
    [11] =
    {
        desc = "步兵克制技能-受击效果",
        prefab = "Prefabs/Particle/Eff_soldier_kezhibaodian",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1.5,
    },
    [12] =
    {
        desc = "骑兵普攻-攻击效果",
        prefab = "Prefabs/Particle/Eff_Qibing_pugongdaoguang",
        SlotType = 0,
        script = "Actor/MeleeAttackBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [13] =
    {
        desc = "骑兵普攻-受击效果",
        prefab = "Prefabs/Particle/Eff_Qibing_pugongbaodian",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1.5,
    },
    [14] =
    {
        desc = "骑兵克制技能-攻击效果",
        prefab = "Prefabs/Particle/Eff_Qibing_kezhidaoguang",
        SlotType = 0,
        script = "Actor/MeleeAttackBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 3,
    },
    [15] =
    {
        desc = "骑兵克制技能-附魔效果",
        prefab = "Prefabs/Particle/Eff_Qibing_kezhiwuqixiaoguo",
        SlotType = 5,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = true,

        lifeTime = 2.5,
    },
    [16] =
    {
        desc = "骑兵克制技能-受击效果",
        prefab = "Prefabs/Particle/Eff_Qibing_kezhibaodian",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1.5,
    },
    [17] =
    {
        desc = "战车普攻-攻击效果",
        prefab = "Prefabs/Particle/Eff_Zhanche_pugongdaoguang",
        SlotType = 0,
        script = "Actor/MeleeAttackBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [18] =
    {
        desc = "战车普攻-受击效果",
        prefab = "Prefabs/Particle/Eff_Zhanche_pugongbaodian",
        SlotType = 1,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1.5,
    },
    [19] =
    {
        desc = "战车克制技能-攻击效果",
        prefab = "Prefabs/Particle/Eff_Zhanche_kezhidaoguang",
        SlotType = 0,
        script = "Actor/MeleeAttackBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [20] =
    {
        desc = "战车克制技能-附魔效果",
        prefab = "Prefabs/Particle/Eff_Zhanche_kezhiwuqixiaoguo",
        SlotType = 5,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = true,

        lifeTime = 2.5,
    },
    [21] =
    {
        desc = "战车克制技能-受击效果",
        prefab = "Prefabs/Particle/Eff_Zhanche_kezhibaodian",
        SlotType = 1,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1.5,
    },
    [22] =
    {
        desc = "投石车普攻-飞行效果",
        prefab = "Prefabs/Particle/Eff_Toushiche_pugongshitou",
        SlotType = 5,
        script = "Actor/BezierObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        velocity = 10,
    },
    [23] =
    {
        desc = "投石车普攻-受击效果",
        prefab = "Prefabs/Particle/Eff_Toushiche_pugongbaodian",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 1,
    },
    [24] =
    {
        desc = "投石车克制技能-飞行效果",
        prefab = "Prefabs/Particle/Eff_Toushiche_kezhiyunshi",
        SlotType = 5,
        script = "Actor/BezierObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        velocity = 15,
    },
    [25] =
    {
        desc = "投石车克制技能-受击效果",
        prefab = "Prefabs/Particle/Eff_Toushiche_kezhibaodian",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 2,
    },
    [26] =
    {
        desc = "弓箭手克制技飘字",
        prefab = "Prefabs/Particle/Effect_nushegong",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 2,
    },
    [27] =
    {
        desc = "步兵克制技飘字",
        prefab = "Prefabs/Particle/Effect_mengjizhanshi",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 2,
    },
    [28] =
    {
        desc = "骑兵克制技飘字",
        prefab = "Prefabs/Particle/Effect_tuxiqibing",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 2,
    },
    [29] =
    {
        desc = "战车克制技飘字",
        prefab = "Prefabs/Particle/Effect_chongzhuangzhanche",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 2,
    },
    [30] =
    {
        desc = "投石车克制技飘字",
        prefab = "Prefabs/Particle/Effect_baolietoushiche",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = false,

        lifeTime = 2,
    },
    [31] =
    {
        desc = "战前冲刺烟雾",
        prefab = "Prefabs/Particle/Effect_chongciyan",
        SlotType = 0,
        script = "Actor/SpawnerObjectBase",
        OffsetPos = CS.UnityEngine.Vector3(0,0,0),
        OffsetRot = CS.UnityEngine.Vector3(0,0,0),
        attachTarget = true,

        lifeTime = 6,
    },
}

-- 根据Id获取配置
-- <param name="id" type="number"></param>
function GameObjectConfig:getConfigByKey(id)
    return GameObjectConfig[id]
end

-- 规格化
local function normalLize()

    if GameObjectConfig == nil then
        return
    end

    for k, v in ipairs(GameObjectConfig) do
        v.id = k
    end

end

-- 检测配置是否合法
local function check()

end

-- 此文件被加载时立即执行
normalLize()
check()
