---- 通货--
-- CurrencyType = {
--    None = 0,
--    -- 金币--
--    Gold = 1,
--    -- 粮食--
--    Food = 2,
--    -- 木材--
--    Wood = 3,
--    -- 石料--
--    Stone = 4,
--    -- 繁荣度--
--    Prosperity = 5,
--    -- 科技点--
--    SATPoint = 6,
--    -- 经验--
--    CaptainExp = 7,
--    -- 元宝--
--    Money = 8,
-- }
CurrencyConfig =
{
    [1] =
    {
        Name = Localization.Gold,
        Icon = "ui://Library/Image_Gold",
        Desc = Localization.Gold,
        Quality = 1,
    },
    [2] =
    {
        Name = Localization.Food,
        Icon = "ui://Library/Image_Food",
        Desc = Localization.Food,
        Quality = 1,
    },
    [3] =
    {
        Name = Localization.Wood,
        Icon = "ui://Library/Image_Wood",
        Desc = Localization.Wood,
        Quality = 1,
    },
    [4] =
    {
        Name = Localization.Stone,
        Icon = "ui://Library/Image_Stone",
        Desc = Localization.Stone,
        Quality = 1,
    },
    [5] =
    {
        Name = Localization.Prosperity,
        Icon = "",
        Desc = Localization.Prosperity,
        Quality = 1,
    },
    [6] =
    {
        Name = Localization.Technology,
        Icon = "",
        Desc = Localization.Technology,
        Quality = 1,
    },
    [7] =
    {
        Name = Localization.GeneralExp,
        Icon = "ui://Library/item_jingyanw",
        Desc = Localization.GeneralExp,
        Quality = 1,
    },
    [8] =
    {
        Name = Localization.MonarchExp,
        Icon = "ui://Library/item_jingyan",
        Desc = Localization.MonarchExp,
        Quality = 1,
    },
    [9] =
    {
        Name = Localization.YuanBao,
        Icon = "ui://Library/Image_YuanBao01",
        Desc = Localization.YuanBao,
        Quality = 1,
    },
    [10] =
    {
        Icon = "ui://Library/Image_YuanBao01",
        Desc = "联盟贡献值",
        Quality = 1,
    },
}

-- 根据Id获取配置
-- <param name="id" type="number"></param>
function CurrencyConfig:getConfigById(id)
    return CurrencyConfig[id]
end

