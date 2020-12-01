  
-- 技能延时事件类型
SkillDelayEventType = {
    None = - 1,
    -- 动作
    Animation = 0,
    -- 近战物体
    MeleeObject = 1,
    -- 飞行物体
    FlyObject = 2,
    -- 音效
    Sound = 3,
    -- 特效
    Particle = 4,
    -- 结算
    Damage = 5,
    -- 摄像头效果
    CameraEff = 6,
}

-- 物体配置文件
SkillConfig =
{
    [1] =
    {
        id = 1,
        desc = "步兵技能1",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                -- eventType = SkillDelayEventType.Animation, args:动作Id
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 5, },
                -- eventType = SkillDelayEventType.MeleeObject, args:生成近战物id
                [1] = { eventType = SkillDelayEventType.MeleeObject, delayTime = 0, args = 9, },
                -- eventType = SkillDelayEventType.Particle, arg[1]:目标对象0表示自身1表示对方,arg[2]:特效Id
                [2] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 10 }, },
                [3] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 27 }, },
                [4] = { eventType = SkillDelayEventType.Particle, delayTime = 0.9, args = { 1, 11 }, },
                [5] = { eventType = SkillDelayEventType.Damage, delayTime = 0.9, args = nil, },
                [6] = { eventType = SkillDelayEventType.CameraEff, delayTime = 0.9, args = 2, },
            },
        }
    },
    [2] =
    {
        id = 2,
        desc = "骑兵技能1",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 5, },
                [1] = { eventType = SkillDelayEventType.MeleeObject, delayTime = 0, args = 14, },
                [2] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 15 }, },
                [3] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 28 }, },
                [4] = { eventType = SkillDelayEventType.Particle, delayTime = 1.4, args = { 1, 16 }, },
                [5] = { eventType = SkillDelayEventType.Damage, delayTime = 1.4, args = nil, },
                [6] = { eventType = SkillDelayEventType.CameraEff, delayTime = 1.4, args = 2, },
            },
        }
    },
    [4] =
    {
        id = 4,
        desc = "弓箭手克制技能1",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 5, },
                [1] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 4 }, },
                [2] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 26 }, },
                -- eventType = SkillDelayEventType.FlyObject, args[1]:生成飞行物id,args[2]:碰撞后特效Id,args[3]:碰撞后摄像头效果
                [3] = { eventType = SkillDelayEventType.FlyObject, delayTime = 1, args = { 5, 6, 2 }, },
            },
        }
    },
    [3] =
    {
        id = 3,
        desc = "战车技能1",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 5, },
                [1] = { eventType = SkillDelayEventType.MeleeObject, delayTime = 0, args = 19, },
                [2] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 20 }, },
                [3] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 29 }, },
                [4] = { eventType = SkillDelayEventType.Particle, delayTime = 0.45, args = { 1, 21 }, },
                [5] = { eventType = SkillDelayEventType.Damage, delayTime = 0.75, args = nil, },
                [6] = { eventType = SkillDelayEventType.CameraEff, delayTime = 0.75, args = 2, },
            },
        }
    },
    [5] =
    {
        id = 5,
        desc = "投石车技能1",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 5, },
                [1] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 30 }, },
                [2] = { eventType = SkillDelayEventType.FlyObject, delayTime = 0.7, args = { 24, 25, 2 }, },
            },
        }
    },
    [6] =
    {
        id = 6,
        desc = "步兵普攻",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 4, },
                [1] = { eventType = SkillDelayEventType.MeleeObject, delayTime = 0, args = 7, },
                [2] = { eventType = SkillDelayEventType.Particle, delayTime = 0.6, args = { 1, 8 }, },
                [3] = { eventType = SkillDelayEventType.Damage, delayTime = 0.6, args = nil, },
            },
        }
    },
    [7] =
    {
        id = 7,
        desc = "骑兵普攻",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 4, },
                [1] = { eventType = SkillDelayEventType.MeleeObject, delayTime = 0, args = 12, },
                [2] = { eventType = SkillDelayEventType.Particle, delayTime = 0.6, args = { 1, 13 }, },
                [3] = { eventType = SkillDelayEventType.Damage, delayTime = 0.6, args = nil, },
            },
        }
    },
    [9] =
    {
        -- id
        id = 9,
        -- 描述
        desc = "弓箭手普攻",
        -- 脚本
        script = "Skill/NormalAttackLogic",
        -- 技能时间线
        timeLine =
        {
            -- 第一条时间线
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 4, },
                [1] = { eventType = SkillDelayEventType.Particle, delayTime = 0, args = { 0, 1 }, },
                [2] = { eventType = SkillDelayEventType.FlyObject, delayTime = 0.6, args = { 2, 3 }, },
            },
        }
    },
    [8] =
    {
        id = 8,
        desc = "战车普攻",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 4, },
                [1] = { eventType = SkillDelayEventType.MeleeObject, delayTime = 0, args = 17, },
                [3] = { eventType = SkillDelayEventType.Particle, delayTime = 0.35, args = { 1, 18 }, },
                [2] = { eventType = SkillDelayEventType.Damage, delayTime = 0.35, args = nil, },
            },
        }
    },
    [10] =
    {
        id = 10,
        desc = "投石车普攻",
        script = "Skill/NormalAttackLogic",
        timeLine =
        {
            [0] =
            {
                [0] = { eventType = SkillDelayEventType.Animation, delayTime = 0, args = 4, },
                [1] = { eventType = SkillDelayEventType.FlyObject, delayTime = 0.4, args = { 22, 23 }, },
            },
        }
    },
}


-- 根据Id获取配置
-- <param name="id" type="number"></param>
function SkillConfig:getConfigByKey(id)
    return SkillConfig[id]
end

