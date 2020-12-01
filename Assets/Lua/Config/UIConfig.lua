-- UI配置文件
UIConfig =
{
    -- 库文件位置
    Library = "ui://Library/",
    -- 装备Icon
    EquipIcon = "ui://EquipIcon/",
    -- 道具Icon
    ItemIcon = "ui://ItemIcon/",
    -- 技能Icon
    SkillIcon = "ui://SkillIcon/",
    -- 点击特效
    ClickEffect = "ui://Library/Component_Click",
    -- 长按间隔(秒)
    LongPressInterval = 0.1,
    -- 长按触发时间(秒)
    LongPressTrigger = 1,
    -- 只能输入数字
    OnlyNum = "^[0-9]*$",
    -- 武将小头像
    CaptainSmallHead = "ui://GeneralIconSmall/%s_xiao",
    -- 武将中等头像
    CaptainMiddleHead = "ui://GeneralIconMedium/%s_zhong",
    -- 武将大头像
    CaptainBigHead = "ui://GeneralIconLarge/%s_da",
    -- 世界聊天频道头像
    ChatWorldHead = "ui://Chat/Image_ChannelWorld",
    -- 联盟聊天频道头像
    ChatGuideHead_1 = "ui://Chat/Image_ChannelAlliance",
    -- 联盟聊天频道头像
    ChatGuideHead_2 = "ui://Chat/Image_ChannelAlliance",
    -- 绿色Tips背景图片
    GreenTipsBg = "ui://Library/Image_GreenTips",
    -- 红色Tips背景图片
    RedTipsBg = "ui://Library/Image_RedTips",
    -- 货币Icon
    CurrencyType =
    {
        -- 铜币
        Gold = "ui://Library/Image_Gold",
        -- 粮食
        Food = "ui://Library/Image_Food",
        -- 木材
        Wood = "ui://Library/Image_Wood",
        -- 石料
        Stone = "ui://Library/Image_Stone",
        -- 元宝
        YuanBao = "ui://MainCity/yuanbao",
    },
    -- 兵种Icon
    Race =
    {
        -- 步兵
        [1] = "ui://Library/Image_Bu",
        -- 骑兵
        [2] = "ui://Library/Image_Qi",
        -- 弓兵
        [3] = "ui://Library/Image_Gong",
        -- 车兵
        [4] = "ui://Library/Image_Che",
        -- 械兵
        [5] = "ui://Library/Image_Xie"
    },
    -- 品质颜色
    QualityColor =
    {
        [Quality.White] = CS.UnityEngine.Color.white,
        [Quality.Green] = CS.UnityEngine.Color.green,
        [Quality.Blue] = CS.UnityEngine.Color.blue,
        [Quality.Purple] = CS.UnityEngine.Color(153 / 255,51 / 255,1),
        [Quality.Orange] = CS.UnityEngine.Color(1,102 / 255,0),
        [Quality.Red] = CS.UnityEngine.Color.red,
    },
    -- 品质颜色
    QualityHexColor =
    {
        [Quality.White] = "931529",
        [Quality.Green] = "6d21a1",
        [Quality.Blue] = "925916",
        [Quality.Purple] = "1d4fbb",
        [Quality.Orange] = "1a9568",
        [Quality.Red] = "6e6e6e",
    },
    Item =
    {
        -- 道具品质
        DefaultQuality =
        {
            [Quality.White] = "ui://Library/img_quality1",
            [Quality.Green] = "ui://Library/img_quality2",
            [Quality.Blue] = "ui://Library/img_quality3",
            [Quality.Purple] = "ui://Library/img_quality4",
            [Quality.Orange] = "ui://Library/img_quality5",
            [Quality.Red] = "ui://Library/img_quality6",
        },
        -- 装备品质
        EquipQuality =
        {
            [1] = "ui://Library/img_quality1",
            [2] = "ui://Library/img_quality2",
            [3] = "ui://Library/img_quality3",
            [4] = "ui://Library/img_quality3",
            [5] = "ui://Library/img_quality4",
            [6] = "ui://Library/img_quality4",
            [7] = "ui://Library/img_quality4",
            [8] = "ui://Library/img_quality5",
            [9] = "ui://Library/img_quality5",
            [10] = "ui://Library/img_quality5",
            [11] = "ui://Library/img_quality6",
            [12] = "ui://Library/img_quality6",
            [13] = "ui://Library/img_quality6",
            [14] = "ui://Library/img_quality6",
        },
        -- 堆叠道具item
        DefaultItemUrl = "ui://Library/Button_Prop",
        -- 装备道具item
        EquipItemUrl = "ui://Library/Button_General_Equip",
        -- 空星
        StarEmptyUrl = "ui://s5cy5qnpmlkfz31",
        -- 满星
        StarFullUrl = "ui://s5cy5qnpmlkfz32",
        -- 半星
        StarHalfUrl = "ui://s5cy5qnpmlkfz30",
        -- 小星星尺寸
        StarSmallSize = 20,
        -- 中星星尺寸
        StarMiddleSize = 30,
        -- 大星星尺寸
        StarBigSize = 45,
    },
    -- 武将
    General =
    {
        -- 武将小品质框
        SmallQuality =
        {
            [Quality.White] = "ui://Library/img_line_0",
            [Quality.Green] = "ui://Library/img_line_1",
            [Quality.Blue] = "ui://Library/img_line_2",
            [Quality.Purple] = "ui://Library/img_line_3",
            [Quality.Orange] = "ui://Library/img_line_4",
            [Quality.Red] = "ui://Library/img_line_5",
        },
        -- 品质(酒馆卡牌等)
        BigQuality =
        {
            [Quality.White] = "ui://Library/img_ka_zhuang1",
            [Quality.Green] = "ui://Library/img_ka_zhuang2",
            [Quality.Blue] = "ui://Library/img_ka_zhuang3",
            [Quality.Purple] = "ui://Library/img_ka_zhuang4",
            [Quality.Orange] = "ui://Library/img_ka_zhuang5",
            [Quality.Red] = "ui://Library/img_ka_zhuang6",
        },
        -- 武将背包加号图标(小)
        SmallAddIcon = "ui://General/wjtusu_35"
    },
    -- 君主头像
    MonarchsIcon =
    {
        ["0"] =
        {
            BigIcon = "ui://GeneralIconLarge/wujiang17_da",
            SmallIcon = "ui://GeneralIconSmall/wujiang17_xiao"
        },
        ["1"] =
        {
            BigIcon = "ui://GeneralIconLarge/wujiang16_da",
            SmallIcon = "ui://GeneralIconSmall/wujiang16_xiao"
        },
    },
    -- 建筑物图标(通用升级面板)
    BuildingIcon =
    {
        MainCity = "ui://Library/Image_MainCity",
        [BuildingType.FeudalOfficial] = "官府图标",
        [BuildingType.Warehouse] = "仓库图标",
        [BuildingType.Tavern] = "酒馆图标",
        [BuildingType.Barrack] = "军营图标",
        [BuildingType.Rampart] = "城墙图标",
        [BuildingType.Academy] = "书院图标",
        [BuildingType.Recruitment] = "外使院图标",
        [BuildingType.Smithy] = "铁匠铺图标",
        [BuildingType.PracticeHall] = "修炼馆图标",
        [BuildingType.Farm] = "农场图标",
        [BuildingType.ClimbingTower] = "千重楼图标",
    },
    -- 战斗
    Battle =
    {
        -- 减益字体--
        debuffFont = "ui://whmx5nbdkqdz2y",
        -- 增益字体--
        goodbuffFont = "ui://whmx5nbdkqdz2z",
    },
    -- 战前
    AfterBattle =
    {
        CompleteWin = "ui://AfterBattle/da",
        Victory = "ui://AfterBattle/da",
        Win = "ui://AfterBattle/xiao",
        Squeak = "ui://AfterBattle/xian",
    },
    -- 通用消耗条件类型
    ConditionType =
    {
        -- 建筑
        Building = "ui://Library/Component_RequiredBuildingLevel",
        -- 建筑队
        Builders = "ui://Library/Component_WorkerInfo",
        -- 资源
        Resourse = "ui://Library/Component_RequiredRes",
    },
    -- 书院
    Academy =
    {
        -- 消耗列表科技图标
        TechIcon = "",
        -- 种植术icon
        zzs = "ui://Academy/neizhengicon1",
        -- 挖掘术icon
        wjs = "ui://Academy/neizhengicon2",
        -- 伐木术icon
        fms = "ui://Academy/neizhengicon3",
        -- 冶炼术icon
        yls = "ui://Academy/neizhengicon4",
        -- 建筑术icon
        jzs = "ui://Academy/neizhengicon5",
        -- 步兵科技攻icon
        bbgongji = "ui://Academy/junshiicon1",
        -- 步兵科技防icon
        bbfangyu = "ui://Academy/junshiicon2",
        -- 步兵科技体icon
        bbtili = "ui://Academy/junshiicon3",
        -- 步兵科技敏icon
        bbminjie = "ui://Academy/junshiicon4",
        -- 弓兵科技攻icon
        gbgongji = "ui://Academy/junshiicon1",
        -- 弓兵科技防icon
        gbfangyu = "ui://Academy/junshiicon2",
        -- 弓兵科技体icon
        gbtili = "ui://Academy/junshiicon3",
        -- 弓兵科技敏icon
        gbminjie = "ui://Academy/junshiicon4",
        -- 骑兵科技攻icon
        qbgongji = "ui://Academy/junshiicon1",
        -- 骑兵科技防icon
        qbfangyu = "ui://Academy/junshiicon2",
        -- 骑兵科技体icon
        qbtili = "ui://Academy/junshiicon3",
        -- 骑兵科技敏icon
        qbminjie = "ui://Academy/junshiicon4",
        -- 车兵科技攻icon
        cbgongji = "ui://Academy/junshiicon1",
        -- 车兵科技防icon
        cbfangyu = "ui://Academy/junshiicon2",
        -- 车兵科技体icon
        cbtili = "ui://Academy/junshiicon3",
        -- 车兵科技敏icon
        cbminjie = "ui://Academy/junshiicon4",
        -- 器兵科技攻icon
        qbgongji = "ui://Academy/junshiicon1",
        -- 器兵科技防icon
        qbfangyu = "ui://Academy/junshiicon2",
        -- 器兵科技体icon
        qbtili = "ui://Academy/junshiicon3",
        -- 器兵科技敏icon
        qbminjie = "ui://Academy/junshiicon4",
    },
    -- 按钮菜单图标
    MenuIcon =
    {
        -- 查看
        ChaKan = "ui://ScenePanel/neicheng_chakan",
        -- 城防
        ChengFang = "ui://ScenePanel/neicheng_chengfang",
        -- 科技
        KeJi = "ui://ScenePanel/neicheng_keji",
        -- 联盟
        LianMeng = "ui://ScenePanel/neicheng_lianmeng",
        -- 熔炼
        RongLian = "ui://ScenePanel/neicheng_ronglian",
        -- 升级
        ShengJi = "ui://ScenePanel/neicheng_shengji",
        -- 升阶
        ShengJie = "ui://ScenePanel/neicheng_shengjie",
        -- 详细
        XiangXi = "ui://ScenePanel/neicheng_xiangxi",
        -- 修炼
        XiuLian = "ui://ScenePanel/neicheng_xiulian",
        -- 宴请
        YanQing = "ui://ScenePanel/neicheng_yanqing",
        -- 招募
        ZhaoMu = "ui://ScenePanel/neicheng_zhaomu",
        -- 改建
        GaiJian = "ui://ScenePanel/shijie_gaijian",
        -- 攻击
        GongJi = "ui://ScenePanel/shijie_gongji",
        -- 进城
        JinCheng = "ui://ScenePanel/shijie_jingcheng",
        -- 君主
        JunZhu = "ui://ScenePanel/shijie_junzhu",
        -- 犁地
        LiDi = "ui://ScenePanel/shijie_lidi",
        -- 驱逐
        QuZhu = "ui://ScenePanel/shijie_quzu",
        -- 收获
        ShouHuo = "ui://ScenePanel/shijie_shouhuo",
        -- 移动
        YiDong = "ui://ScenePanel/shijie_yidong",
        -- 援助
        YuanZhu = "ui://ScenePanel/shijie_yuanzu",
    },
    -- 邮件
    Mail =
    {
        -- 系统邮件
        SystemItem = "ui://Mail/Component_SystemMailItem",
        -- 战报邮件
        BattlelogItem = "ui://Mail/Component_BattlelogMailItem",
        -- 附件物品item
        PrizeItem = "ui://Library/Button_Prop",
        -- 收藏Icon
        CollectIcon = "ui://Mail/Image_Collect",
        -- 不收藏Icon
        NotCollectIcon = "ui://Mail/Image_NotCollect",
        -- 系统icon
        [0] = "ui://Mail/Image_System",
        -- 攻城胜利icon
        [1] = "ui://Mail/Image_Attack",
        -- 攻城失败icon
        [2] = "ui://Mail/Image_Attack",
        -- 守城胜利icon
        [3] = "ui://Mail/Image_Defense",
        -- 守城失败icon
        [4] = "ui://Mail/Image_Defense",
    },
    -- 军情
    WarSituation =
    {
        -- 标题item
        TitleItem = "ui://WarSituation/Button_MyWarSituationItem",
        -- 详情item
        InfoItem = "ui://WarSituation/Button_WarSituationItem",
        -- 职业item
        ZhiYeItem = "ui://WarSituation/zhiye",
        -- 武将item
        CaptainItem = "ui://WarSituation/Component_GeneralItem",
        -- 发起者item
        AttackerItem = "ui://WarSituation/Component_EnemyItem",
    },
    -- 兵种Item
    RaceItem = "ui://Library/Component_SoldierType",
    -- 任务Item
    TaskItem = "ui://Task/renwulan",
    -- 第三种类型的icon item
    BtnIcon2Xiao3 = "ui://Library/Button_Prop",

    -- 主界面军情提示图标
    MainUI_MilitaryState_Marching = "ui://MainCity/z",
    MainUI_MilitaryState_Assistance = "ui://MainCity/y",
    MainUI_MilitaryState_Basing = "ui://MainCity/zz",
    MainUI_MilitaryState_Invasion = "ui://MainCity/c",
    MainUI_MilitaryState_Back = "ui://MainCity/ff",

    -- 主界面紧急军情图标
    EmergencyIconUrl =
    {
        -- 与MainCityController中的emergencyType匹配
        -- 组队邀请
        [1] = "",
        -- 敌军
        [2] = "",
        -- 掠夺
        [3] = "",
        -- 援军
        [4] = "",
    },
}