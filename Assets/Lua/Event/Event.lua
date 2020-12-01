
-------------------------------------------------------------------------
------------------------------EventListener------------------------------
-------------------------------------------------------------------------

local Event = { }
 
------------------------------- 网络状态（不能动） -------------------------------

Event.CONNECTING = 1
Event.CONNECTED = 2
Event.MUST_RELOGIN = 3
Event.MUST_RECONNECT = 4
Event.MUST_RECONNECTING = 6


------------------------------- 辅助模块(1000 - 1999) ---------------------------

-- 1. 加载相关(1000 - 1099)
-- loading中
Event.LOADING_UPDATE = 1000
-- loading结束
Event.LOADING_COMPLETE = 1001
-- 菊花关闭
Event.SYNC_CLOSE = 1002
-- 加载完毕
Event.SCENE_LOADED = 1003

-- 2. 屏幕交互(1100 - 1199)
Event.STAGE_ON_CLICK = 1100
Event.STAGE_ON_TOUCH_BEGIN = 1101
Event.STAGE_ON_TOUCH_MOVE = 1102
Event.STAGE_ON_TOUCH_END = 1103


------------------------------- 内政(2000 - 2999) ------------------------------

-- 1. 君主信息(2000 - 2099)
-- 改名成功
Event.CHANGE_NAME_SUCCESS = 2000
-- 更新战斗力成功
Event.MONARCHS_UPDATE_HERO_FIGHT_AMOUNT = 2001
-- 其他君主改名成功
Event.OTHER_CHANGE_NAME_SUCCESS = 2002
-- 元宝更
Event.YUANBAO_UPDATE = 2003
Event.PLAYER_INFO_UPDATE = 2004
Event.CURRENCY_CURRENT_UPDATE = 2005
Event.CURRENCY_LIMIT_AND_PROTECTED_UPDATE = 2006
Event.PROSPERITY_UPDATE = 2007
-- 更新曾用名列表
Event.OLD_NAME_LIST_UPDATE = 2008

-- 2. 建筑队(2100 - 2199)
-- 秒建筑队CD成功
Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS = 2100

-- 3. 科技队(2200 - 2299)
-- 秒科技队CD成功
Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS = 2200

-- 4. 主城建筑(2300 - 2399)
-- 建筑物信息
Event.BUILDERS_INFO_UPDATE = 2300
-- 建筑物升级
Event.BUILDING_UPGRADE = 2301
Event.TECHNOLOGY_UPGRADE = 2302
Event.CREATE_RESOURCE_POINT = 2303
Event.REBUILD_RESOURCE_POINT = 2304
Event.ALL_RESOURCE_POINT_UPDATE = 2305
Event.RESOURCE_POINT_UPDATE = 2306

-- 5. 主城操作(2400 - 2499)
-- 查看其他玩家
Event.ON_VIEW_OTHER_HERO = 2400
-- 打开、关闭军情界面
Event.ON_OPEN_MILITARY = 2401
Event.ON_CLOSE_MILITARY = 2402
-- 出城、回城
Event.ON_GO_OUTSIDE = 2403
Event.ON_GO_HOME = 2404
Event.LOADING_MAINCITY_SUCCESS = 2405



------------------------------ GM指令(3000 - 3999) ----------------------------
-- 请求GM列表成功
Event.GM_REQ_CMD_LIST_SUCCESS = 3000


------------------------------- 军政(4000 - 4999) -----------------------------

-- 1. 武将(4000 - 4099)
Event.SEEK_CAPTAIN_UPDATE = 4000
Event.RECRUIT_CAPTAIN_SUCCESS = 4001
Event.SOLDIER_INFO_UPDATE = 4002
Event.SELL_SEEK_CAPTAIN_SUCCESS = 4003
-- 解雇或者招募武将
Event.GENERAL_UPDATE = 4004
-- 武将强化成功
Event.GENERAL_INTENSIFY_SUCCESS = 4005
-- 武将强化后升级
Event.GENERAL_INTENSIFY_UPGRADE = 4006
-- 武将状态更新
Event.GENERAL_STATUS_UPDATE = 4007
-- 编队出征状态
Event.TROOP_OUTSIDE_UPDATE = 4008
-- 武将改名成功
Event.GENERAL_RENAME_SUCCESS = 4009
-- 武将转职成功
Event.GENERAL_CHANGE_RACE_SUCCESS = 4010
-- 武将转生成预览数据获取成功
Event.GENERAL_REBIRTH_PREVIEW_SUCCESS = 4011
-- 武将转生成预览数据获取失败
Event.GENERAL_REBIRTH_PREVIEW_FAIL = 4012
-- 武将转生成功
Event.GENERAL_REBIRTH_SUCCESS = 4013
-- 武将转生道具成功
Event.General_USE_GOODS_SUCCESS = 4014
-- 使用元宝加转生经验成功
Event.General_USE_YUANBAO_SUCCESS = 4015
-- 2. 军营(4100 - 4199)
-- 招募成功
Event.BARRACK_RECRUIT_SOLDIER_SUCCESS = 4100
-- 治疗成功
Event.BARRACK_HEAL_SOLDIER_SUCCESS = 4101
-- 升级士兵成功
Event.BARRACK_UPGRADE_SOLDIER_SUCCESS = 4102
-- 获取最大可招募士兵数量成功
Event.BARRACK_GET_MAX_Recruit_SOLDIER_SUCCESS = 4103
-- 获取最大可治疗伤兵数成功
Event.BARRACK_GET_MAX_HEAL_SOLDIER_SUCCESS = 4104

-- 3. 城墙(4200 - 4299)
-- 驻防成功
Event.WALL_DEFENSE_GARRISON_CHANGE = 4200

-- 4. 修炼(4300 - 4399)
-- 升级修炼台成功
Event.PRACTICEHALL_UPGRADE_SUCCESS = 4300
-- 一键领取修炼馆经验成功
Event.PRACTICEHALL_COLLECT_ALL_TRAINING_EXP_SUCCESS = 4301
-- 修炼馆一键修炼成功
Event.PRACTICEHALL_AUTO_SET_TRAINING_CAPTAIN_SUCCESS = 4302
-- 更新修炼馆产出
Event.PRACTICEHALL_UPDATE_TRAINING_OUTPUT = 4303

-- 5. 战斗(4400 - 4499)
-- 战斗回放
Event.BATTLE_REPLAY_ACK = 4400
-- 更新玩家信息
Event.BATTLE_PLAYER_REFRESH = 4401
-- 战斗武将更新
Event.BATTLE_CAPTAIN_REFRESH = 4402
-- 掉血
Event.BATTLE_DROP_OF_BLOOD = 4403
-- 战斗结束
Event.BATTLE_OVER = 4404
-- 布阵回复
Event.TROOP_SYNC_ACK = 4405
-- 布阵失败
Event.TROOP_SYNC_FAILURE = 4406
-- 补兵成功
Event.TROOP_ADD_SOLIDER_SUCCEED = 4407
-- 更新主玩家信息
Event.BATTLE_PLAYER_MAIN_REFRESH = 4408
-- 战场信息刷新
Event.BATTLEFIELD_INFO_REFRESH = 4409
-- 战报刷新
Event.BATTLE_LOG_REFRESH = 4410
-- 战斗进展刷新
Event.BATTLE_PROGRESS_REFRESH = 4411

-- 6.行营
Event.CAMP_SET_DEFENCER = 4412
------------------------------- Misc(5000 - 5999) -----------------------------

-- 1. login(5000 - 5099)
-- 登陆准备
Event.LOG_READY = 5000
-- 登录OK
Event.LOG_OK = 5001
-- 切服
Event.LOGIN_SERVER_ID = 5002
-- 创建角色
Event.CREATE_ROLE = 5003
-- 创建角色成功
Event.CREATE_ROLE_SUCCEED = 5004

-- 2. 时间(5100 - 5199)
-- 服务器时间同步
Event.UPDATE_SERVER_TIME = 5100

-- 3. 重置(5200 - 5299)
-- 每日重置
Event.DAILY_RESET = 5200

---------------------------- 野外(7000 - 7999)----------------------------------
Event.ENTER_MAIN_CITY = 7000
Event.ENTER_OUTSIDE = 7001
Event.HIT_CITY = 7002
Event.HIT_RESOURCE = 7003
Event.HIT_OPEN_SPACE = 7004
Event.UPDATE_NAV_MILES = 7005
Event.CREATE_BASE = 7006
Event.REMOVE_BASE = 7007
Event.UPDATE_BASE = 7008
Event.FAST_MOVE_BASE = 7009
Event.ON_RESOURCE_POINT_CONFLICT = 7010
-- 我的所有军情
Event.ON_ALL_MY_MILITARY_UPDATED = 7011
Event.ON_MY_MILITARY_UPDATED = 7012
Event.ON_MY_MILITARY_REMOVED = 7013
Event.ON_INVASION = 7014
Event.CANCEL_INVASION = 7015
Event.EXPEL_RESULT_UPDATE = 7016
Event.UPGRADE_BASE = 7017
Event.CLOSE_RESOURCE_MENU = 7018
Event.CLOSE_CITY_MENU = 7019
-- 当前地图所有的军情（我可见的，野外的马行军事件）
Event.ON_ALL_CURRENT_MAP_MILITARY_UPDATED = 7020
Event.ON_CURRENT_MAP_MILITARY_UPDATED = 7021
Event.ON_CURRENT_MAP_MILITARY_REMOVED = 7022
-- 当前地图所有城池数据更新
Event.ON_ALL_CURRENT_MAP_BASE_UPDATED = 7023
-- 迁城数据和状态更新
Event.ON_MOVE_CITY_STATUS_UPDATED = 7024
Event.ON_WAR_SITUATION_UPDATE = 7025

Event.HIT_CAMPSITE = 7026

-- 野区行营
Event.PUT_CAMPSITE = 7028
Event.REMOVE_CAMPSITE = 7029
Event.GET_REGION_LIST = 7030
Event.CAMPSITE_REPAIR = 7031
Event.CAMPSITE_UPDATE = 7032
Event.CAMPSITE_PROPERITY = 7033
-- 切换地区
Event.CHANGE_REGION = 7034
-- 防守阵容更新
Event.DEFENSER_UPDATE = 7035
-- 行营入侵
Event.CAMPSITE_INVADE_INFO = 7036
Event.CAMPSITE_INVADE_ADD = 7037
Event.CAMPSITE_INVADE_REMOVE = 7038
-- 行营友军
Event.UPDATE_ASSIST = 7039
Event.REMOVE_ASSIST = 7040
-- 行营加速
Event.CAMP_BUILD_SPEEDUP = 7041
-- 主界面紧急军情
Event.MAINUI_MILITARY_UPDATE = 7042
-- 主城被打流亡
Event.BASE_EXILE = 7043
---------------------------- 邮件(8000 - 8999)----------------------------------
-- 收到一封邮件
Event.MAIL_RECEIVE_A_MAIL = 8000
-- 请求邮件成功
Event.MAIL_REQUEST_MAIL_LIST_SUCCESS = 8001
-- 收藏/取消收藏成功
Event.MAIL_COLLECT_OR_NOT_SUCCESS = 8002
-- 读取邮件成功
Event.MAIL_READ_SUCCESS = 8003
-- 删除邮件成功
Event.MAIL_DELETE_SUCCESS = 8004
-- 领取成功
Event.MAIL_GET_PRIZE_SUCCESS = 8005


---------------------------- 联盟(9000 - 9999) ---------------------------------
-- 更新联盟列表(创建/搜索页面的联盟列表)
Event.ON_UPDATE_GUILD_LIST = 9000
-- 请求我的联盟数据成功
Event.REQ_MY_GUILD_DATA_SUCCESS = 9001
-- 退出联盟
Event.ON_LEAVE_GUILD = 9002
-- 别人退出了联盟
Event.ON_OTHER_LEAVE_GUILD = 9003
-- 踢人出联盟
Event.ON_KICK_OTHER = 9004
-- 更改成员职位成功
Event.ON_CHANGE_MEMBER_POST_SUCCESS = 9005
-- 有新人加入联盟
Event.ON_NEW_MEMBER_JOIN = 9006
-- 我自己加入联盟
Event.ON_JOINED_GUILD = 9007
-- 创建联盟联盟成功
Event.ON_CREATE_GUILD = 9008
-- 捐献成功
Event.ALLIANCE_DONATE_SUCCESS = 9009
-- 请求联盟数据一致
Event.ALLIANCE_SAME_VERSION = 9010
-- 修改联盟阶级称谓
Event.ON_UPDATE_CLASS_NAME = 9011
-- 更新联盟声望目标
Event.ON_UPDATE_GUILD_TARGET = 9013
-- 更新联盟友盟
Event.ALLIANCE_ON_UPDATE_ALLY = 9014
-- 更新联盟敌盟
Event.ALLIANCE_ON_UPDATE_ENEMY = 9015
-- 更新联盟宣言
Event.ON_UPDATE_GUILD_TEXT = 9016
-- 更新联盟公告
Event.ON_UPDATE_GUILD_NOTICE = 9017
-- 更新联盟标签
Event.ON_UPDATE_GUILD_Label = 9018
-- 赠送联盟成功
Event.ON_GIVE_TO_ALLIANCE_SUCCESS = 9019
-- 赠送玩家成功
Event.ON_GIVE_TO_PLAYER_SUCCESS = 9020
-- 申请加入联盟成功
Event.ON_APPLY_TO_JOIN_ALLIANCE_SUCCESS = 9021
-- 联盟升级成功
Event.ALLIANCE_UPGRADE_SUCCESS = 9022
-- 联盟升级加速成功
Event.ALLIANCE_UPGRADE_SPEEDUP_SUCCESS = 9023
-- 联盟审批成功(批准/拒绝)
Event.ALLIANCE_REPLY_SUCCESS = 9024
-- 联盟更新个人贡献币
Event.ALLIANCE_ON_UPDATE_CONTRIBUTION_COIN = 9025
-- 联盟修改名字/旗号成功
Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS = 9026
-- 联盟更新职称成功
Event.ALLIANCE_ON_UPDATE_MEMBER_TITLE_SUCCESS = 9027
-- 联盟修改入盟条件成功
Event.ALLIANCE_MODIFY_JOIN_CONDITION_SUCCESS = 9028
-- 联盟取消禅让倒计时成功
Event.ALLIANCE_CANCEL_DEMISE_SUCCESS = 9029
-- 联盟弹劾成功
Event.ALLIANCE_IMPEACH_SUCCESS = 9030
-- 联盟投票成功
Event.ALLIANCE_VOTE_SUCCESS = 9031
-- 被插上别的联盟的白旗
Event.WHITE_FLAG = 9032
-- 被插上别的联盟的白旗更新
Event.WHITE_FLAG_UPDATE = 9033
-- 被插上别的联盟的白旗更新失败
Event.WHITE_FLAG_FAIL = 9034

-- 联盟雕像更新
Event.ALLIANCE_STATUE_UPDATE = 9034
---------------------------- 道具(11000 - 11999)-------------------------------
-- 道具使用成功
Event.ITEM_USE_SUCCEED = 11000
-- 堆叠道具刷新
Event.ITEM_DEFAULT_UPDATE = 11001
-- 装备道具刷新
Event.ITEM_EQUIP_UPDATE = 11002
-- 宝石道具刷新
Event.ITEM_GEN_UPDATE = 11003
-- 临时背包刷新
Event.ITEM_TEMP_UPDATE = 11004
-- 更新经验类道具
Event.ITEM_EXP_UPDATE = 11005
-- 使用减CD类型道具成功
Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS = 11006
-- 装卸宝石成功
Event.DECORATE_OR_RELEASE_GEM_SUCCESS = 11007


---------------------------- 装备(12000 - 12999)--------------------------------

-- 1. 装备升级(12000 - 12099)
-- 装备升级成功
Event.EQUIP_UPGRADE_SUCCEED = 12000
-- 装备强化成功
Event.EQUIP_REFINE_SUCCEED = 12001
-- 装备替换成功
Event.EQUIP_REPLACE_SUCCEED = 12002
-- 装备数据更新
Event.EQUIP_INFO_UPDATE = 12003
-- 装备数据更新完成
Event.EQUIP_INFO_UPDATE_COMPLETE = 12004

-- 2. 装备熔炼(12100 - 12199)

-- 熔炼回复
Event.SMITHY_SMELT_SUCCEED = 12100
-- 重铸回复
Event.SMITHY_SRBUILD_SUCCEED = 12101
-- 铸造成功
Event.SMITHY_FORGE_SUCCESS = 12102
-- 可合成的套装更新
Event.SMITHY_COMBINE_SUITS_UPDATE = 12103
-- 合成成功
Event.SMITHY_COMBINE_SUIT_SUCCESS = 12104

---------------------------- 聊天(13000 - 13999)---------------------------------
-- 聊天成功
Event.CHAT_MSG_SUCCEED = 13000
-- 聊天消息处理结束
Event.CHAT_MSG_HANDLER_OVER = 13001
-- 联盟聊天失败
Event.CHAT_Guild_FAILURE = 13002
-- 世界聊天失败
Event.CHAT_WORLD_FAILURE = 13003
-- 简要聊天更新
Event.CHAT_BRIEF_UPDATE = 13004


---------------------------- 千重楼(14000 - 14999)-------------------------------
-- 楼层挑战成功
Event.TOWER_CHALLENGE_SUCCEED = 14000
-- 楼层挑战失败
Event.TOWER_CHALLENGE_FAILURE = 14001
-- 扫荡成功
Event.TOWER_AUTO_CHALLENGE_SUCCEED = 14002
-- 扫荡失败
Event.TOWER_AUTO_CHALLENGE_FAILURE = 14003
-- 楼宝箱更新
Event.TOWER_AWARD_BOX_UPDATE = 14004
-- 重楼挑战回放
Event.TOWER_BATTLE_REPLAY_ACK = 14005
-- 攻略回放信息
Event.TOWER_STRATEGY_REPLAY = 14006
-- 重楼重置
Event.TOWER_DAILY_RESET = 14007

---------------------------- 任务(15000 - 15999) -------------------------------
-- 更新任务
Event.UDPATE_TASK = 15000
-- 领取任务奖励成功
Event.COLLECT_TASK_PRIZE_SUCCESS = 15001
-- 新任务通知
Event.NEW_TASK = 15002
-- 领取累积宝箱奖励成功
Event.COLLECT_TASK_BOX_PRIZE_SUCCESS = 15003


---------------------------- 钓鱼(16000 - 16999) -------------------------------


---------------------------- 将魂(17000 - 17999) -------------------------------
-- 将魂附身
Event.CAPTAIN_ATTACH_SOUL_SUCCESS = 17000
-- 激活羁绊
Event.ACTIVATE_FETTER_SUCCESS = 17001
-- 领取羁绊奖励成功
Event.COLLECT_FETTERS_PRIZE_SUCCESS = 17002

---------------------------- 重楼密室(18000 - 18999)-------------------------------
-- 楼层挑战成功
Event.TOWER_BACKROOM_CHALLENGE_SUCCEED = 18000
-- 楼层挑战失败
Event.TOWER_BACKROOM_CHALLENGE_FAILURE = 18001
-- 楼层队伍刷新
Event.TOWER_BACKROOM_TROOPS_REFRESH = 18002
-- 楼层队伍个数刷新
Event.TOWER_BACKROOM_TROOPS_COUNT_REFRESH = 18003
-- 加入队伍成功
Event.TOWER_BACKROOM_JOIN_TROOPS_SUCCEED = 18004
-- 密室基础信息刷新
Event.TOWER_BACKROOM_BASE_INFO_REFRESH = 18005
-- 密室被邀请次数
Event.TOWER_BACKROOM_INVITE_COUNT = 18006
-- 密室队伍详情刷新
Event.TOWER_BACKROOM_TROOPS_DETAIL_REFRESH = 18007
-- 密室离开队伍成功
Event.TOWER_BACKROOM_LEAVE_TROOPS_SUCCEED = 18008
-- 密室邀请回复
Event.TOWER_BACKROOM_INVITE_ACK_RESULT = 18009
-- 密室挑战回放
Event.TOWER_BACKROOM_BATTLE_REPLAY_ACK = 18010

---------------------------- 商店(19000 - 19999) -------------------------------
-- 更新每日限购数据
Event.SHOP_ON_UPDATE_DAILY_SHOP_GOODS = 19000
-- 联盟商店
-- 购买联盟商店道具成功
Event.SHOP_ON_BUY_ALLIANCE_PROP_SUCCESS = 19001

---------------------------- 百战千军(20000 - 20999) -------------------------------
-- 百战主数据刷新
Event.PVP100_MAIN_REFRESH = 20000
-- 百战排行榜刷新
Event.PVP100_RANKINGLIST_REFRESH = 20001
-- 百战挑战回复
Event.PVP100_CHALLENGE_ACK = 20002

---------------------------- 排行榜(21000 - 21999) -------------------------------
Event.GET_RANKING = 21000
Event.GET_RANKING_FAIL = 21001

--------------------------------------------------------------------------------

local eventName = { }

for k, v in pairs(Event) do
    eventName[v] = k
end

function Event.addListener(etype, func)
    print("registering listener", eventName[etype])
    if etype == nil or func == nil then
        return
    end

    local a = Event[etype]
    if not a then
        a = { }
        Event[etype] = a;
    end
    table.insert(a, 1, func)
end  
  
function Event.removeListener(etype, func)
    local a = Event[etype]
    if (a == nil) then
        return
    end
    for k, v in pairs(a) do
        if (v == func) then
            a[k] = nil
        end
    end
end  

function Event.dispatch(etype, ...)
    -- print("dispatching event", eventName[etype], " thread id ", CS.System.Threading.Thread.CurrentThread.ManagedThreadId)
    local a = Event[etype]
    if not a then
        return
    end
    for k, v in pairs(a) do
        v(...)
    end
end

function Event:dispatchFunction(etype)
    return function()
        Event.dispatch(etype)
    end
end

function Event.clear(etype)
    local a = Event[etype]
    if not a then
        return
    end
    Event[etype] = nil
end  

function Event.clearAll()
    for k, v in pairs(Event) do
        Event[k] = nil
    end
end  

return Event
