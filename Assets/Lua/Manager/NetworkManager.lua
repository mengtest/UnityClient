----------------------------------------------------------------
-- 模块下的局部函数和变量等定义在此
----------------------------------------------------------------
local NetworkManager = { }

local decode = require "autogen.autogen_modules".Decode
local event = require "Event.Event"
-- 登录凭证
local loginCredentials = { address = "", port = 0, token = "", key = "" }
-- 版本信息
NetworkManager.version = { platform = "dev", number = 0, }

-- 验证客户端版本号
local function verifyClientVersion()

end

-- 下载更新包
local function downloadUpdatePack()

end

-- 解压缩更新包
local function unpackDownloadedPack()

end

-- 更新完毕，判断是否要重启游戏
local function onUpdated()

end

-- 初始化
function NetworkManager.initialize()
    
end

-- 收到网络消息
-- <param name="msg" type="string">消息包体</param>
function NetworkManager.onReceiveMsg(t, msg)
    -- print("msg received. length", length)
    local length = msg:len()
    if length == 1 then
        event.dispatch(msg:byte(1, 1))
    else
        decode(msg, length)
    end
end

-- 发送消息
-- <param name="msg" type="string">消息包体</param>
function NetworkManager.sendMsg(msg)
    CS.LPCFramework.NetworkManager.Instance:SendMessage(msg)
end

-- 主动断开连接
function NetworkManager.onDisconnect()
    CS.LPCFramework.NetworkManager.Instance:OnDisconnect()
end

-- 请求认证登陆--
-- <param name="ip" type="string">ip地址</param>
-- <param name="port" type="number">端口</param>
-- <param name="msg" type="string">认证登陆信息</param>
function NetworkManager.connect(ip, port, token, key)
    CS.LPCFramework.NetworkManager.Instance:Connect(ip, port, token, key)
end

----------------------------------------------------------------------------------------
--------------------------------------消息请求-------------------------------------------
----------------------------------------------------------------------------------------

-- 客户端日志--
-- level: string // 日志级别
-- text: string // 日志内容
function NetworkManager.C2SClientLogProto(level, text)
    local msg = misc_decoder.NewC2sClientLogMsg(level, text)
    NetworkManager.sendMsg(msg)
end

-- 内部登陆--
-- <param name="accountId" type="string">账户</param>
function NetworkManager.C2SInternalLoginProto(ipAddress, port, token, key, accountId)
    local connectCallback = function()
        NetworkManager.sendMsg(misc_decoder.C2S_CONFIG())
        NetworkManager.sendMsg(login_decoder.NewC2sInternalLoginMsg(accountId))
        event.removeListener(event.CONNECTED, connectCallback)
    end
    event.addListener(event.CONNECTED, connectCallback)
    NetworkManager.connect(ipAddress, port, token, key)
end

-- 正式登陆--
-- <param name="token" type="string">字符串命令</param>
-- <param name="key" type="string">字符串命令</param>
function NetworkManager.C2SLoginProto(ipAddress, port, token, key)
    -- 保存登录凭证
    loginCredentials.address = ipAddress
    loginCredentials.port = port
    loginCredentials.token = token
    loginCredentials.key = key

    local c2sLogin = function()
        NetworkManager.sendMsg(login_decoder.C2S_LOGIN())
        event.removeListener(event.LOG_READY, c2sLogin)
    end
    local c2sConfig = function()
        NetworkManager.sendMsg(misc_decoder.C2S_CONFIG())
        event.removeListener(event.CONNECTED, c2sConfig)
    end
    event.addListener(event.LOG_READY, c2sLogin)
    event.addListener(event.CONNECTED, c2sConfig)
    NetworkManager.connect(ipAddress, port, token, key)
end
-- 重新登陆--
function NetworkManager.C2SReLoginProto()
    -- 重新登录，不再获取配置
    local c2sLogin = function()
        NetworkManager.sendMsg(login_decoder.C2S_LOGIN())
        event.removeListener(event.CONNECTED, c2sLogin)
    end
    event.addListener(event.CONNECTED, c2sLogin)
    NetworkManager.connect(loginCredentials.address, loginCredentials.port, loginCredentials.token, loginCredentials.key)
end

-- 创建角色--
-- <param name="name" type="string">角色名</param>
-- <param name="male" type="bool">是否为男性</param>
function NetworkManager.C2SCreateHeroProto(name, male)
    local msg = login_decoder.NewC2sCreateHeroMsg(name, male)
    NetworkManager.sendMsg(msg)
end
-- 加载完毕--
function NetworkManager.C2SLoadedProto()
    local msg = login_decoder.C2S_LOADED()
    NetworkManager.sendMsg(msg)
end

-- 管理员指令--
-- <param name="cmd" type="string">字符串命令</param>
function NetworkManager.C2SGmProto(cmd)
    local msg = gm_decoder.NewC2sGmMsg(cmd)
    print("gm指令：", cmd)

    NetworkManager.sendMsg(msg)
end

-- 请求GM指令列表
function NetworkManager.C2SGMListCMD()
    local msg = gm_decoder.C2S_LIST_CMD()
    NetworkManager.sendMsg(msg)
end

-- 心跳检测--
-- 客户端定时发送心跳. 第一次进入场景之后10秒后开始发送 (客户端第一次发送加载完成消息后的10秒后发送第一次)
-- 每10秒发送一次 (开始发送之后, 不管风吹雨打都要发. 每10秒一次, 不多不少). 服务器判断外挂用
function NetworkManager.C2SHeartBeatProto(clientTime)
    local msg = misc_decoder.NewC2sHeartBeatMsg(clientTime)
    NetworkManager.sendMsg(msg)
end

-- 同步时间
-- <param name="cmd" type="string">字符串命令</param>
function NetworkManager.C2SSyncTimeProto(clientTime)
    local msg = misc_decoder.NewC2sSyncTimeMsg(clientTime)
    NetworkManager.sendMsg(msg)
end


-- ***************************************************************************
-- 内政
-- ***************************************************************************

-- 创建资源点--
-- <param name="layoutId" type="number">布局Id</param>
-- <param name="buildingType" type="BuildingType">建筑类型</param>
function NetworkManager.C2SCreateBuildingProto(layoutId, buildingType)
    local msg = domestic_decoder.NewC2sCreateBuildingMsg(layoutId, buildingType)
    NetworkManager.sendMsg(msg)
end

-- 资源点升级--
-- <param name="layoutId" type="number">布局Id</param>
function NetworkManager.C2SUpgradeBuildingProto(layoutId)
    local msg = domestic_decoder.NewC2sUpgradeBuildingMsg(layoutId)
    NetworkManager.sendMsg(msg)
end

-- 获取资源点信息--
function NetworkManager.C2SResourceBuildingProto()
    local msg = domestic_decoder.C2S_RESOURCE_BUILDING_INFO()
    NetworkManager.sendMsg(msg)
end

-- 重建资源点--
-- <param name="layoutId" type="number">布局Id</param>
-- <param name="buildingType" type="BuildingType">建筑类型</param>
function NetworkManager.C2SRebuildResourceBuildingProto(layoutId, buildingType)
    local msg = domestic_decoder.NewC2sRebuildResourceBuildingMsg(layoutId, buildingType)
    NetworkManager.sendMsg(msg)
end

-- 收集资源点资源--
-- <param name="layoutId" type="number">布局Id</param>
function NetworkManager.C2SCollectResourceProto(layoutId)
    local msg = domestic_decoder.NewC2sCollectResourceMsg(layoutId)
    NetworkManager.sendMsg(msg)
end

-- 学习科技点--
-- <param name="id" type="number">科技点Id</param>
function NetworkManager.C2SLearnTechnologyProto(id)
    print("发送学习科技点请求,科技点id:", id)
    local msg = domestic_decoder.NewC2sLearnTechnologyMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 升级城内建筑
-- <param name="buildingType" type="ConfigData.BuildingType">建筑类型</param>
-- <param name="level" type="ConfigData.BuildingType">建筑等级</param>
function NetworkManager.C2SUpgradeStableBuildingProto(buildingType, level)
    local msg = domestic_decoder.NewC2sUpgradeStableBuildingMsg(buildingType, level)
    NetworkManager.sendMsg(msg)
end

-- 请求曾用名列表
-- id: string // 玩家id
function NetworkManager.C2SListOldNameProto(id)
    local msg = domestic_decoder.NewC2sListOldNameMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 君主改名
-- <param name="name" type="string">新名字</param>
function NetworkManager.C2SChangeHeroNameMsg(name)
    local msg = domestic_decoder.NewC2sChangeHeroNameMsg(name)
    NetworkManager.sendMsg(msg)
end
-- 查看其他玩家消息
function NetworkManager.C2SViewOtherHero(heroId)
    local msg = domestic_decoder.NewC2sViewOtherHeroMsg(heroId)
    NetworkManager.sendMsg(msg)
end

-- 秒建筑队CD
-- index // 建筑队序号，从0开始
function NetworkManager.C2SMiaoBuildingWorderCdMsg(index)
    print("秒建筑队CD,index:", index)
    local msg = domestic_decoder.NewC2sMiaoBuildingWorkerCdMsg(index)
    NetworkManager.sendMsg(msg)
end

-- 秒科研队CD
-- index // 科研队序号，从0开始
function NetworkManager.C2SMiaoTechWorderCdMsg(index)
    print("秒科研队CD,index:", index)
    local msg = domestic_decoder.NewC2sMiaoTechWorkerCdMsg(index)
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 军政
-- ***************************************************************************

-- 招募士兵--
-- <param name="count" type="number">个数</param>
function NetworkManager.C2SRecruitSoldierProto(count)
    local msg = military_decoder.NewC2sRecruitSoldierMsg(count)
    NetworkManager.sendMsg(msg)
end

-- 治疗伤兵--
-- <param name="count" type="number">个数</param>
function NetworkManager.C2SHealWoundedSoldierProto(count)
    local msg = military_decoder.NewC2sHealWoundedSoldierMsg(count)
    NetworkManager.sendMsg(msg)
end

-- 武将补兵--
-- <param name="captainId" type="number">武将Id</param>
-- <param name="count" type="number">个数</param>
function NetworkManager.C2SCaptainChangeSoldierProto(captainId, count)
    local msg = military_decoder.NewC2sCaptainChangeSoldierMsg(captainId, count)
    NetworkManager.sendMsg(msg)
end

-- 武将一键补兵--
-- <param name="captainId" type="table">武将Id</param>
function NetworkManager.C2SCaptainFullSoldierProto(captainId)
    local msg = military_decoder.NewC2sCaptainFullSoldierMsg(captainId)
    NetworkManager.sendMsg(msg)
end

-- 士兵升级--
function NetworkManager.C2SUpdateSoldierLevelProto()
    local msg = military_decoder.C2S_UPGRADE_SOLDIER_LEVEL()
    NetworkManager.sendMsg(msg)
end

-- 武将寻访--
function NetworkManager.C2SSeekCaptainProto()
    local msg = military_decoder.C2S_SEEK_CAPTAIN()
    NetworkManager.sendMsg(msg)
end

-- 招募寻访武将--
-- <param name="index" type="number">寻访武将序号，从1开始</param>
function NetworkManager.C2SRecruitCaptainProto(index)
    local msg = military_decoder.NewC2sRecruitCaptainMsg(index)
    NetworkManager.sendMsg(msg)
end

-- 将寻访武将转换成强化符--
-- <param name="index" type="number">寻访武将序号，从1开始，0表示将所有的武将全部转换成强化符</param>
function NetworkManager.C2SSellSeekCaptainProto(index)
    local msg = military_decoder.NewC2sSellSeekCaptainMsg(index)
    NetworkManager.sendMsg(msg)
end

-- 设置防守阵容--
-- <param name="is_tent" type="bool">rue表示设置行营防守队伍，false表示设置主城防守队伍</param>
-- <param name="troop_index" type="number">0表示撤防，1表示1队 2表示2队</param>
function NetworkManager.C2SSetDefenseTroopProto(is_tent, troop_index)
    local msg = military_decoder.NewC2sSetDefenseTroopMsg(is_tent, troop_index)
    NetworkManager.sendMsg(msg)
end

-- 编队--
-- 目前可以设置3个编队，每个编队5人
-- index序号，一队发0，二队发5，3队发10
-- <param name="index" type="number">序号，从0开始</param>
-- <param name="id" type="number"> 武将id，0表示这个位置没有武将</param>
function NetworkManager.C2SSetMultiCaptainIndexProto(index, ids)
    local msg = military_decoder.NewC2sSetMultiCaptainIndexMsg(index, ids)
    NetworkManager.sendMsg(msg)
end

-- 武将解雇--
-- <param name="id" type="number">武将id</param>
function NetworkManager.C2SFireCaptainProto(id)
    local msg = military_decoder.NewC2sFireCaptainMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 使用武将强化符（武将强化）
-- captainId: int // 武将id
-- goodsId: int[] // 强化符id（有多种强化符，具体要用哪种）
-- count: int[] // 使用个数
function NetworkManager.NewC2sCaptainRefinedMsg(captainId, goodsId, count)
    local msg = military_decoder.NewC2sCaptainRefinedMsg(captainId, goodsId, count)
    NetworkManager.sendMsg(msg)
end

-- 修炼馆设置武将槽位
-- index: int // 武将修炼馆槽位，从0开始
-- captain: int // 武将id
function NetworkManager.C2SSetTrainingCaptainProto(index, captain)
    print("修炼馆设置武将槽位", index, captain)
    local msg = military_decoder.NewC2sSetTrainingCaptainMsg(index, captain)
    NetworkManager.sendMsg(msg)
end

-- 修炼馆交换武将槽位
-- 交换后，客户端将槽位的可领取经验设为0（服务器会给武将加经验）
-- index: int // 武将修炼馆槽位，从0开始
-- swap: int // 交换的武将槽位
function NetworkManager.C2SSwapTrainingCaptainProto(index, swap)
    print("修炼馆交换武将槽位", index, swap)
    local msg = military_decoder.NewC2sSwapTrainingCaptainMsg(index, swap)
    NetworkManager.sendMsg(msg)
end

-- 领取修炼馆经验
-- 客户端将这个槽位的可领取经验设为0（服务器会给武将加经验）
-- index: int // 武将修炼馆槽位，从0开始
function NetworkManager.C2SCollectTrainingExpProto(index)
    print("领取修炼馆经验", index)
    local msg = military_decoder.NewC2sCollectTrainingExpMsg(index)
    NetworkManager.sendMsg(msg)
end

-- 升级修炼馆槽位
-- 升级成功，客户端将这个槽位的可领取经验设为0（服务器会给武将加经验）
-- index: int // 武将修炼馆槽位，从0开始
-- level: int // 升级到什么等级
function NetworkManager.C2SUpgradeTrainingProto(index, level)
    print("升级修炼馆槽位", index, level)
    local msg = military_decoder.NewC2sUpgradeTrainingMsg(index, level)
    NetworkManager.sendMsg(msg)
end

-- 一键领取修炼馆经验
-- 客户端将所有槽位的可领取经验设为0（服务器会给武将加经验）
function NetworkManager.C2SCollectAllTrainingExp()
    print("一键领取修炼馆经验")
    local msg = military_decoder.C2S_COLLECT_ALL_TRAINING_EXP()
    NetworkManager.sendMsg(msg)
end

-- 修炼馆一键修炼
-- 对应的位置设置对应的武将
function NetworkManager.S2CAutoSetTrainingCaptain()
    print("修炼馆一键修炼")
    local msg = military_decoder.C2S_AUTO_SET_TRAINING_CAPTAIN()
    NetworkManager.sendMsg(msg)
end

-- 获取最大可招募士兵数量
function NetworkManager.C2SGetMaxRecruitSoldier()
    print("获取最大可招募士兵数量")
    local msg = military_decoder.C2S_GET_MAX_RECRUIT_SOLDIER()
    NetworkManager.sendMsg(msg)
end

-- 获取最大可治疗伤兵数
function NetworkManager.C2SGetMaxHealSoldier()
    print("获取最大可治疗伤兵数")
    local msg = military_decoder.C2S_GET_MAX_HEAL_SOLDIER()
    NetworkManager.sendMsg(msg)
end
-- ***************************************************************************
-- 战斗
-- ***************************************************************************

-- 请求战斗--
function NetworkManager.C2SFightProto()
    local msg = military_decoder.C2S_FIGHT()
    NetworkManager.sendMsg(msg)
end

-- 请求多人战斗--
function NetworkManager.C2SMultiFightProto()
    local msg = military_decoder.C2S_MULTI_FIGHT()
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 大地图区域
-- ***************************************************************************

-- 升级主城--
-- config.base_level 里面带有主城升级所需繁荣度
-- 繁荣度达到升级条件时候，可以升级
function NetworkManager.C2SUpgradeMainCityProto()
    local msg = region_decoder.C2S_UPGRADE_BASE()
    NetworkManager.sendMsg(msg)
end

-- 打开军情界面
-- 服务器主动推送以下消息
-- military_info 军情信息
--
-- 以上消息会在本消息的s2c消息返回之前先发送，
--
-- 关闭军情面板，发送关闭消息
-- <param name="open" type="bool">打开还是关闭</param>
function NetworkManager.C2SSwitchActionProto(open)
    local msg = region_decoder.NewC2sSwitchActionMsg(open)
    NetworkManager.sendMsg(msg)
end

-- 进出城外，服务器每次推送最新的数据，客户端回城后就可以清掉野外的数据了
--
-- 出城
-- 服务器主动推送以下消息
-- base_info 野外地图中的主城信息
-- map_military_info 野外地图中持续掠夺的军情，用于展示一匹马在打那个主城
--
-- 以上消息会在本消息的s2c消息返回之前先发送，
--
-- 回城
-- 客户端回城后，发送回城消息
-- <param name="mapId" type="number">地图id</param>
function NetworkManager.C2SSwitchMapProto(mapId)
    local msg = region_decoder.NewC2sSwitchMapMsg(mapId)
    NetworkManager.sendMsg(msg)
end

-- 创建主城（流亡状态）--
-- <param name="mapId" type="number">地图id，可以从MonarchsData.BaseMapId获取</param>
-- <param name="newX" type="number">x坐标 x坐标和y坐标都发0，表示随机建城</param>
-- <param name="newY" type="number">y坐标</param>
function NetworkManager.C2SCreateBaseProto(mapId, newX, newY)
    local msg = region_decoder.NewC2sCreateBaseMsg(mapId, newX, newY)
    NetworkManager.sendMsg(msg)
end

-- 迁城令_迁移主城--
-- <param name="mapId" type="number">地图id，可以从MonarchsData.BaseMapId获取</param>
-- <param name="newX" type="number">x坐标 x坐标和y坐标都发0，表示随机建城</param>
-- <param name="newY" type="number">y坐标</param>
-- <param name="isCampsite" type="bool">标识是否为迁徙行营</param>
function NetworkManager.C2SFastMoveBaseProto(mapId, newX, newY, isCampsite)
    local goodsId = nil
    if isCampsite then
        if GoodsCommonConfig.Config.MoveCampsiteGoods ~= nil then
            goodsId = GoodsCommonConfig.Config.MoveCampsiteGoods.Id
        end
    else
        if GoodsCommonConfig.Config.AdvancedMoveBaseGoods ~= nil then
            goodsId = GoodsCommonConfig.Config.AdvancedMoveBaseGoods.Id
        end
    end
    if goodsId == nil then
        return
    end
    local msg = region_decoder.NewC2sFastMoveBaseMsg(mapId, newX, newY, goodsId, isCampsite)
    NetworkManager.sendMsg(msg)
end

-- 出征--
-- <param name="invation" type="bool">true表示出去打人，false表示出去救援</param>
-- <param name="target" type="string">目的地主城对应的玩家id</param>
-- <param name="mapId" type="number">出征的地图id</param>
-- <param name="troopId" type="number">出征的部队id</param>
function NetworkManager.C2SInvasionProto(invation, target, mapId, troopId)
    local msg = region_decoder.NewC2sInvasionMsg(invation, target, mapId, troopId)
    NetworkManager.sendMsg(msg)
end

-- 召回--
-- <param name="id" type="string">军情id</param>
function NetworkManager.C2SCancelInvasionProto(id)
    local msg = region_decoder.NewC2sCancelInvasionMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 驱逐--
-- <param name="id" type="string">军情id</param>
-- <param name="mapId" type="number">地图id</param>
-- <param name="troopId" type="number">出征的部队Id</param>
function NetworkManager.C2SExpelProto(id, mapId, troopId)
    local msg = region_decoder.NewC2sExpelMsg(id, mapId, troopId)
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 邮件
-- ***************************************************************************

-- 请求邮件
-- config.MiscConfig.MailBatchCount 一次推送多少个邮件（当打开邮件界面时，邮件数少于这个值，则请求邮件数）
-- 返回的邮件列表id是从高到低，客户端一直往上拖，逐批加载
-- 当返回的邮件列表小于config.MiscConfig.MailBatchCount，说明已经没有新邮件了
-- 收到的全部邮件分类可以填充到其他分类中，但是其他分类获取的邮件不要放到全部分类中
-- read: int // 0-全部 1-未读 2-已读
-- keep: int // 0-全部 1-未收藏 2-已收藏
-- report: int // 战报 0-全部 1-无 2-有
-- has_prize: int // 奖励 0-全部 1-无 2-有
-- collected: int // 0-全部 1-未领取 2-已领取
-- min_id: string // 最小的邮件的id，服务器返回比这个id小的一批邮件(客户端当前没有邮件时候，不发)
-- count: int // 请求邮件个数
function NetworkManager.C2SListMailProto(read, keep, report, has_prize, collected, min_id, count)
    local msg = mail_decoder.NewC2sListMailMsg(read, keep, report, has_prize, collected, min_id, count)
    NetworkManager.sendMsg(msg)
end

-- 删除邮件
-- <param name="id" type="string">邮件id</param>
function NetworkManager.C2SDeleteMailProto(id)
    local msg = mail_decoder.NewC2sDeleteMailMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 收藏邮件
-- <param name="id" type="string">邮件id</param>
-- <param name="keep" type="string">true表示收藏，false表示取消收藏</param>
function NetworkManager.C2SKeepMailProto(id, keep)
    local msg = mail_decoder.NewC2sKeepMailMsg(id, keep)
    NetworkManager.sendMsg(msg)
end

-- 领取邮件奖励
-- <param name="id" type="string">邮件id</param>
function NetworkManager.C2SCollectMailPrizeProto(id)
    local msg = mail_decoder.NewC2sCollectMailPrizeMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 读取邮件
-- <param name="id" type="string">邮件id</param>
function NetworkManager.C2SReadMailProto(id)
    local msg = mail_decoder.NewC2sReadMailMsg(id)
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 道具
-- ***************************************************************************

-- 使用物品
-- <param name="id" type="number">道具id</param>
-- <param name="count" type="number">道具个数</param>
function NetworkManager.NewC2sUseGoodsMsg(id, count)
    local msg = depot_decoder.NewC2sUseGoodsMsg(id, count)
    NetworkManager.sendMsg(msg)
end

-- 使用减cd道具--
-- <param name="id" type="number">道具id</param>
-- <param name="count" type="number">道具个数</param>
-- <param name="cdrType" type="number">减cd类型，0-建筑 1-科技</param>
-- <param name="index" type="number">索引</param>
function NetworkManager.NewC2sUseCdrGoodsMsg(id, count, cdrType, index)
    local msg = depot_decoder.NewC2sUseCdrGoodsMsg(id, count, cdrType, index)
    NetworkManager.sendMsg(msg)
end
-- ***************************************************************************
-- 装备
-- ***************************************************************************

-- 换装备
-- <param name="captainId" type="number">武将id</param>
-- <param name="equipId" type="number">操作的装备id</param>
-- <param name="isDown" type="boolean">true表示脱装备，否则表示穿装备</param>
function NetworkManager.C2SWearEquipmentProto(captainId, equipId, isDown)
    local msg = equipment_decoder.NewC2sWearEquipmentMsg(captainId, equipId, isDown)
    NetworkManager.sendMsg(msg)
end

-- 升级装备
-- <param name="captainId" type="number">武将id</param>
-- <param name="equipId" type="number">操作的装备id</param>
-- <param name="count" type="number">填10表示升级10次</param>
function NetworkManager.C2SUpgradeEquipmentProto(captainId, equipId, count)
    local msg = equipment_decoder.NewC2sUpgradeEquipmentMsg(captainId, equipId, count)
    NetworkManager.sendMsg(msg)
end

-- 武将装备全部升级1次
-- <param name="captainId" type="number">武将id</param>
function NetworkManager.C2SUpgradeEquipmentAllProto(captainId)
    local msg = equipment_decoder.NewC2sUpgradeEquipmentAllMsg(captainId)
    NetworkManager.sendMsg(msg)
end
-- 强化装备
-- <param name="captainId" type="number">武将id</param>
-- <param name="equipId" type="number">操作的装备id</param>
function NetworkManager.C2SRefinedEquipmentProto(captainId, equipId)
    local msg = equipment_decoder.NewC2sRefinedEquipmentMsg(captainId, equipId)
    NetworkManager.sendMsg(msg)
end

-- 熔炼装备
-- <param name="equipId" type="table">操作的装备id</param>
function NetworkManager.C2SSmeltEquipmentProto(equipIds)
    local msg = equipment_decoder.NewC2sSmeltEquipmentMsg(equipIds)
    NetworkManager.sendMsg(msg)
end

-- 重铸装备
-- <param name="equipId" type="table">操作的装备id</param>
function NetworkManager.C2SRebuildEquipmentProto(equipIds)
    local msg = equipment_decoder.NewC2sRebuildEquipmentMsg(equipIds)
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 千重楼
-- ***************************************************************************

-- 挑战
-- <param name="floor" type="number">楼层</param>
-- <param name="captainId" type="number[]">武将Id</param>
function NetworkManager.C2SChallengeProto(floor, captainId)
    local msg = tower_decoder.NewC2sChallengeMsg(floor, captainId)
    NetworkManager.sendMsg(msg)
end

-- 扫荡
-- <param name="captainId" type="number">武将Id</param>
function NetworkManager.C2SAutoChallengeProto(captainId)
    local msg = tower_decoder.NewC2sAutoChallengeMsg(captainId)
    NetworkManager.sendMsg(msg)
end

-- 领取宝箱
function NetworkManager.C2SCollectBox()
    local msg = tower_decoder.C2S_COLLECT_BOX()
    NetworkManager.sendMsg(msg)
end

-- 获取楼层攻略
-- <param name="floor" type="number">楼层</param>
function NetworkManager.C2SListPassReplayProto(floor)
    local msg = tower_decoder.NewC2sListPassReplayMsg(floor)
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 社交
-- ***************************************************************************

-- 世界聊天内容
-- <param name="contents" type="string">内容</param>
function NetworkManager.C2SWorldChatProto(contents)
    local msg = chat_decoder.NewC2sWorldChatMsg(contents)
    NetworkManager.sendMsg(msg)
end

-- 部落聊天内容
-- <param name="contents" type="string">内容</param>
function NetworkManager.C2SGuildChatProto(contents)
    local msg = chat_decoder.NewC2sGuildChatMsg(contents)
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 任务
-- ***************************************************************************

-- 领取任务奖励
-- <param name="taskId" type="number">任务Id</param>
function NetworkManager.C2SCollectTaskPrize(taskId)
    local msg = task_decoder.NewC2sCollectTaskPrizeMsg(taskId)
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 联盟 (made by Garden)
-- ***************************************************************************

-- 获取联盟列表
-- num: int // 页数，从0开始，0表示第一页
function NetworkManager.C2SListGuildProto(num)
    local msg = guild_decoder.NewC2sListGuildMsg(num)
    NetworkManager.sendMsg(msg)
end

-- 搜索联盟
-- name: string // 搜索名字
-- num: int // 页数，从0开始，0表示第一页
function NetworkManager.C2SSearchGuildProto(name, num)
    local msg = guild_decoder.NewC2sSearchGuildMsg(name, num)
    NetworkManager.sendMsg(msg)
end

-- 创建联盟
-- name: string // 联盟名字
-- flag_name: string // 联盟旗号
function NetworkManager.C2SCreateGuildProto(name, flag_name)
    local msg = guild_decoder.NewC2sCreateGuildMsg(name, flag_name)
    NetworkManager.sendMsg(msg)
end

-- 请求自己的联盟数据（已加入联盟）
-- 玩家打开联盟面板时候，请求这条数据，获取联盟详细数据
-- 此消息会根据情况返回2条消息，
-- 1、如果服务器的版本跟客户端不一致，则返回本条消息的s2c消息，客户端更新version以及刷新联盟面板数据
-- 2、如果服务器的版本号跟客户端的一致，则返回 self_guild_same_version的s2c消息
-- 客户端的联盟面板一致持续打开的情况下(关掉就不要请求了)，每5秒请求一次帮派自己的数据，刷新帮派面板展示
-- version: int // 联盟数据版本号，第一次发0
function NetworkManager.C2SGetSelfGuildProto(version)
    local msg = guild_decoder.NewC2sSelfGuildMsg(version)
    NetworkManager.sendMsg(msg)
end

-- 退出联盟
function NetworkManager.C2SLeaveGuildProto()
    local msg = guild_decoder.C2S_LEAVE_GUILD()
    NetworkManager.sendMsg(msg)
end

-- 踢出联盟（组织上的大哥干的事情）
-- GuildProto
--   int32 kick_member_count = 32; // 踢人数，限制每日最多踢几个
-- config.GuildConfig.DailyMaxKickCount = 1; // 每日最多可以踢多少人，联盟满员时候不受这个限制
-- GuildClassLevelProto.kick_lower_member = true 表示允许踢人（低阶级盟友）
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
-- id: string // 目标id
function NetworkManager.C2SKickOtherProto(id)
    local msg = guild_decoder.NewC2sKickOtherMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 组织上的老头干的事情, 修改友盟
-- text: string // 联盟友盟
function NetworkManager.C2SUpdateFriendGuildProto(text)
    local msg = guild_decoder.NewC2sUpdateFriendGuildMsg(text)
    NetworkManager.sendMsg(msg)
end

-- 组织上的老头干的事情, 联盟敌盟
-- text: string // 联盟敌盟
function NetworkManager.C2SUpdateEnemyGuildProto(text)
    local msg = guild_decoder.NewC2sUpdateEnemyGuildMsg(text)
    NetworkManager.sendMsg(msg)
end

-- 组织上的老头干的事情, 修改联盟宣言
-- text: string // 联盟宣言
function NetworkManager.C2SUpdateTextProto(text)
    local msg = guild_decoder.NewC2sUpdateTextMsg(text)
    NetworkManager.sendMsg(msg)
end

-- 组织上的老头干的事情, 联盟内部公告
-- text: string // 联盟内部公告
function NetworkManager.C2SUpdateInternalTextProto(text)
    local msg = guild_decoder.NewC2sUpdateInternalTextMsg(text)
    NetworkManager.sendMsg(msg)
end

-- 修改联盟阶级称谓
-- name: string[] // 联盟阶级称谓
function NetworkManager.C2SUpdateClassNamesProto(name)
    local msg = guild_decoder.NewC2sUpdateClassNamesMsg(name)
    NetworkManager.sendMsg(msg)
end

-- 更新职称
-- proto: bytes // shared_proto.GuildClassTitleProto
function NetworkManager.C2SUpdateClassTitleProto(proto)
    local msg = guild_decoder.NewC2sUpdateClassTitleMsg(proto)
    NetworkManager.sendMsg(msg)
end

-- 修改组织联盟旗帜(就是旗号的底图)
-- flag_type: int // 旗帜类型，从0开始
function NetworkManager.C2SUpdateFlagTypeProto(flag_type)
    local msg = guild_decoder.NewC2sUpdateFlagTypeMsg(flag_type)
    NetworkManager.sendMsg(msg)
end

-- 修改成员职位
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
-- 帮主禅让也是使用这条消息
-- id: string // 目标id
-- class_level: int // 新的阶级
function NetworkManager.C2SUpdateMemberClassLevelProto(id, class_level)
    local msg = guild_decoder.NewC2sUpdateMemberClassLevelMsg(id, class_level)
    NetworkManager.sendMsg(msg)
end

-- 组织上的老头干的事情
-- 修改声望目标
-- GuildPermissionProto.update_prestige_target = 25; // true表示允许修改声望目标
-- target: int // 配置 DefaultCountryProto中的id
function NetworkManager.C2SUpdateGuildPrestigeProto(target)
    local msg = guild_decoder.NewC2sUpdateGuildPrestigeMsg(target)
    NetworkManager.sendMsg(msg)
end

-- 盟主取消禅让倒计时
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
function NetworkManager.C2SCancelChangeLeaderProto()
    local msg = guild_decoder.C2S_CANCEL_CHANGE_LEADER()
    NetworkManager.sendMsg(msg)
end

-- 加入联盟（v01版本做的，不需要审核，一点就加入）
-- id: int // 帮派id
function NetworkManager.C2SJoinGuildV01Proto(id)
    local msg = guild_decoder.NewC2sJoinGuildV01Msg(id)
    NetworkManager.sendMsg(msg)
end

-- 修改入盟条件
-- reject_auto_join: bool // false表示达到条件直接入盟，true表示需要申请才能加入
-- required_hero_level: int // 君主等级，0表示不限
-- required_jun_xian_level: int // 百战军衔等级，0表示不限
-- required_jun_xian_level: int // 需要的千重楼最大层数，0表示不限
function NetworkManager.C2SUpdateJoinConditionProto(reject_auto_join, required_hero_level, required_jun_xian_level, required_tower_max_floor)
    local msg = guild_decoder.NewC2sUpdateJoinConditionMsg(reject_auto_join, required_hero_level, required_jun_xian_level, required_tower_max_floor)
    NetworkManager.sendMsg(msg)
end

-- 联盟改名改旗号
-- name: string // 联盟名字
-- flag_name: string // 联盟旗号
function NetworkManager.C2SUpdateGuildNameProto(name, flag_name)
    local msg = guild_decoder.NewC2sUpdateGuildNameMsg(name, flag_name)
    NetworkManager.sendMsg(msg)
end

-- 修改联盟标签
-- 联盟标签字符个数限制（1个汉字算1个字符，2个英文算1个字符）：config.GuildConfig.GuildLabelLimitChar
-- 联盟标签个数上限：config.GuildConfig.GuildLabelLimitCount
-- 职位 GuildClassLevelData.UpdateLabel = true表示有权限修改联盟标签
-- label: string[] // 标签
function NetworkManager.C2SUpdateGuildLabelProto(label)
    local msg = guild_decoder.NewC2sUpdateGuildLabelMsg(label)
    NetworkManager.sendMsg(msg)
end

-- 联盟捐献
-- 获取联盟捐献数据，GuildDonateProto，里面包含每个位置每次捐献的数据
-- 登陆时，从HeroProto中获取英雄自己的捐献次数
--     repeated int32 guild_donate_times = 33 [packed = false]; // 联盟已捐献次数
-- 根据已捐献次数来显示捐献项目的内容，如已捐献次数=0，那么显示捐献1次的数据
-- 当收到每日重置消息，misc.S2C_DAILY_RESET 时，将联盟已捐献次数设置为0，刷新面板
-- sequence: int
function NetworkManager.C2SDonateProto(sequence)
    local msg = guild_decoder.NewC2sDonateMsg(sequence)
    NetworkManager.sendMsg(msg)
end

-- 帮派升级
-- 职位 GuildClassLevelData.UpgradeLevel = true表示有权限修改联盟标签
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
function NetworkManager.C2SUpgradeLevelProto()
    local msg = guild_decoder.C2S_UPGRADE_LEVEL()
    NetworkManager.sendMsg(msg)
end

-- 帮派升级加速
-- 升级加速数据（包含每一级每次加速次数对应的数据）：GuildLevelCdrProto
-- GuildProto
--    int32 upgrade_end_time = 42; // 升级结束时间（0表示当前没有在升级），unix时间戳，秒
--    int32 cdr_times = 43; // 联盟升级已加速次数
-- 成功之后会推送一条帮派变化消息 self_guild_changed，收到此消息，重新获取一次帮派数据，刷新面板
-- times: int // 当前已加速次数（防止2个人同时加速）
function NetworkManager.C2SReduceUpgradeLevelCdProto(times)
    local msg = guild_decoder.NewC2sReduceUpgradeLevelCdMsg(times)
    NetworkManager.sendMsg(msg)
end

-- 发起弹劾盟主
-- GuildImpeachProto.impeach_end_time = 26; // 0表示当前没有弹劾，否则表示当前正在弹劾盟主
--
-- 职位 GuildClassLevelData
--     bool impeach_npc_leader = 15; // true表示允许弹劾NPC盟主
--     int32 vote_score = 20; // 弹劾NPC盟主，这个职位的票数
--
-- ConfigProto.GuildConfigProto
--     int32 impeach_required_member_count = 22; // 需要联盟内存在多少玩家数量才能弹劾
--     int32 impeach_leader_offline_duration = 23; // 玩家盟主多长时间不在线可以弹劾，单位秒
--     int32 impeach_npc_leader_hour = 24; // 弹劾npc盟主小时数，如23
--     int32 impeach_npc_leader_minute = 25; // 弹劾npc盟主分钟数，如40 表示每天23点40分之前可以发起NPC弹劾
--
-- 服务器会主动推送帮派更新消息，根据消息刷新帮派面板
function NetworkManager.C2SImpeachLeaderProto()
    local msg = guild_decoder.C2S_IMPEACH_LEADER()
    NetworkManager.sendMsg(msg)
end

-- 弹劾盟主投票
-- 投票后会推送帮派更新消息，根据消息刷新帮派面板
-- target: string // 你要投票给谁
function NetworkManager.C2SImpeachLeaderVoteProto(target)
    local msg = guild_decoder.NewC2sImpeachLeaderVoteMsg(target)
    NetworkManager.sendMsg(msg)
end

-- （玩家消息）获取帮派列表（通过id查询帮派列表）
-- 以下功能使用这个消息，查询帮派列表数据
-- 玩家获取自己的申请加入帮派列表
-- 玩家获取自己的被邀请加入帮派列表
-- 每次最多请求id数 config.GuildConfig.guild_num_per_page = 14; // 每页多少个帮派数
-- ids: int[] // 帮派id
function NetworkManager.C2SListGuildByIdsProto(ids)
    local msg = guild_decoder.C2SListGuildByIdsProto(ids)
    NetworkManager.sendMsg(msg)
end

-- 申请加入联盟 --------------
-- （玩家消息）玩家申请加入联盟（申请加入哪个联盟）
-- HeroProto.joinGuildIds 表示当前已申请的联盟id 列表
-- config.GuildCofnig.user_max_join_request_count = 26; // 用户最大申请加入联盟数量（默认5条）
-- 申请加入的联盟如果是允许自动加入，则会收到user_joined，不会收到s2c消息
-- 申请成功(收到s2c消息)，将这个联盟id加入到已申请联盟id 列表
-- id: int // 申请联盟id
function NetworkManager.C2SUserRequestJoinProto(id)
    local msg = guild_decoder.NewC2sUserRequestJoinMsg(id)
    NetworkManager.sendMsg(msg)
end

-- （玩家消息）玩家取消申请加入帮派
-- 取消成功，将这个联盟id从已申请联盟id 列表中移除
-- id: int // 取消加入帮派id
function NetworkManager.C2SUserCancelJoinRequestProto(id)
    local msg = guild_decoder.NewC2sUserCancelJoinRequestMsg(id)
    NetworkManager.sendMsg(msg)
end

-- （联盟消息）审批加入联盟申请
-- GuildProto中可以获取到申请加入联盟的列表
--     GuildJoinRequestProto join_request = 27; // 申请加入/邀请加入的玩家信息
-- 审批加入联盟(有允许同意申请入盟权限的操作)
-- GuildClassLevelData
--    bool agree_join = 5; // true表示允许同意申请入盟
-- id: string // 玩家id
-- agree: bool // true表示同意加入联盟，否则表示拒绝加入
function NetworkManager.C2SGuildReplyJoinRequestProto(id, agree)
    local msg = guild_decoder.NewC2sGuildReplyJoinRequestMsg(id, agree)
    NetworkManager.sendMsg(msg)
end

-- 邀请加入联盟 --------------------
-- （联盟消息）邀请加入联盟
-- GuildProto中可以获取到邀请加入联盟的列表
--     GuildJoinRequestProto join_request = 27; // 申请加入/邀请加入
-- 审批加入联盟(有允许同意申请入盟权限的操作)
-- GuildClassLevelData
--    bool invate_other = 4; // true表示允许邀请他人入盟
-- 邀请成功，服务会主动推送帮派数据变更消息
-- id: string // 邀请的玩家id
function NetworkManager.C2SGuildInvateOtherProto(id)
    local msg = guild_decoder.NewC2sGuildInvateOtherMsg(id)
    NetworkManager.sendMsg(msg)
end

-- （联盟消息）取消邀请加入联盟
-- GuildProto中可以获取到邀请加入联盟的列表
--     GuildJoinRequestProto join_request = 27; // 申请加入/邀请加入
-- 审批加入联盟(有允许同意申请入盟权限的操作)
-- GuildClassLevelData
--    bool invate_other = 4; // true表示允许邀请他人入盟
-- 将邀请加入玩家删掉
-- id: string // 取消邀请的玩家id
function NetworkManager.C2SGuildCancelInvateOtherProto(id)
    local msg = guild_decoder.NewC2sGuildCancelInvateOtherMsg(id)
    NetworkManager.sendMsg(msg)
end

-- （玩家消息）玩家回复邀请加入帮派
-- HeroProto.beenInvateGuildIds 表示当前已申请的联盟id 列表
-- 操作成功，将这个邀请帮派删除
-- id: int // 邀请的帮派id
-- agree: bool // true表示同意加入帮派
function NetworkManager.C2SUserReplyInvateRequesProto(id, agree)
    local msg = guild_decoder.NewC2sUserReplyInvateRequestMsg(id, agree)
    NetworkManager.sendMsg(msg)
end

-- 购买联盟商店物品
-- ShopProto 存放着每个商店的数据，目前只有帮派商店，以后会慢慢增加
--    int32 type = 1; // 商店类型, 1表示帮派商店
--    repeated ShopGoodsProto goods = 2; // 商品
--
-- 购买成功，如果是限购物品，服务器会主动推送更新每日限购数据消息 update_daily_shop_goods
-- id: int // 商品id，对应ShopGoodsProto.id
-- count: int // 购买个数
function NetworkManager.C2SBuyGoodsProto(id, count)
    local msg = shop_decoder.NewC2sBuyGoodsMsg(id, count)
    NetworkManager.sendMsg(msg)
end
--------------------------------------------------------------------------------
-- 装备锻造
-- <param name="index" type="num">锻造的装备编号</param>
-- <param name="count" type="num">锻造的装备次数</param>
function NetworkManager.C2SForgingEquip(index, count)
    local msg = domestic_decoder.NewC2sForgingEquipMsg(index, count)
    NetworkManager.sendMsg(msg)
end
-- add by theo
-- 武将改名
-- id: int // 武将id
-- name: string // 武将名字
function NetworkManager.C2SChangeCaptanNameProto(id, name)
    local msg = military_decoder.NewC2sChangeCaptainNameMsg(id, name)
    NetworkManager.sendMsg(msg)
end

-- 碎片合成装备
-- <param name="id" type="num">合成的装备编号</param>
-- <param name="count" type="num">合成的装备件数</param>
function NetworkManager.C2SGoodsCombineProto(id, count)
    local msg = depot_decoder.NewC2sGoodsCombineMsg(id, count)
    NetworkManager.sendMsg(msg)
end

-- 武将转职
-- id: int // 武将id
-- race: int // 武将职业 shared_proto.Race
-- yuanbao: bool // true表示使用元宝改名
function NetworkManager.C2SChangeCaptainRaceProto(id, raceType, isUseYuanBao)
    local msg = military_decoder.NewC2sChangeCaptainRaceMsg(id, raceType, isUseYuanBao)
    NetworkManager.sendMsg(msg)
end

-- 武将转生预览
-- id: int // 武将id
function NetworkManager.C2SCaptainRebirthPreviewProto(id)
    print("==========send to server rebirth===========")
    local msg = military_decoder.NewC2sCaptainRebirthPreviewMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 武将转生
-- id: int // 武将id
function NetworkManager.C2SCaptainRebirthProto(id)
    local msg = military_decoder.NewC2sCaptainRebirthMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 使用道具获得经验
-- id: int // 武将id
-- goods: int // 物品id
-- count: int // 使用个数
function NetworkManager.C2SUseCaptainRebirthGoods(captainid, goodsid, count)
    local msg = military_decoder.NewC2sCaptainRebirthGoodsMsg(captainid, goodsid, count)
    NetworkManager.sendMsg(msg)
end

-- 使用元宝加转生经验
-- id: int // 武将id
function NetworkManager.C2SCaptainRebirthYuanbao(id)
    local msg = military_decoder.NewC2sCaptainRebirthYuanbaoMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 将魂附身
-- captain: int // 武将id
-- up: bool // true附身,false不附身
-- soul_id: int // 如果是附身，需要带将魂id，不是附身可以发0
function NetworkManager.C2SAttachSoulProto(captainId, isUp, soulId)
    local msg = captain_soul_decoder.NewC2sFuShenMsg(captainId, isUp, soulId)
    NetworkManager.sendMsg(msg)
end

-- 激活羁绊
-- id: int // 羁绊id
function NetworkManager.C2SActivateFettersProto(fetterId)
    local msg = captain_soul_decoder.NewC2sActivateFettersMsg(fetterId)
    NetworkManager.sendMsg(msg)
end

-- 领取羁绊奖励
-- id: int // 羁绊id
function NetworkManager.C2SCollectFettersPrizeProto(fetterId)
    local msg = captain_soul_decoder.NewC2sCollectFettersPrizeMsg(fetterId)
    NetworkManager.sendMsg(msg)
end

-- 镶嵌/卸下宝石
-- captain_id: int // 武将id
-- slot_idx: int // 卸下哪个槽位的宝石或者给哪个槽位加上宝石，即：GemSlotDataProto.slot_idx
-- down: bool // true表示给武将卸下宝石，否则表示给武将加上宝石，加宝石必须带上要镶嵌的宝石的id
-- gem_id: int // 操作的宝石id，如果是卸下，不用发
function NetworkManager.C2SUseGemProto(captainId, gemId, down, slotIndex)
    local msg = gem_decoder.NewC2sUseGemMsg(captainId, slotIndex, down, gemId)
    NetworkManager.sendMsg(msg)
end

-- 合成宝石
-- captain_id: int // 武将id
-- slot_idx: int // 合成到哪个槽位的宝石上，即：GemSlotDataProto.slot_idx
-- gem_id: int[] // 使用的背包中的宝石的id
function NetworkManager.C2SCombineGemProto(captainId, slotIndex)
    local msg = gem_decoder.NewC2sOneKeyCombineGemMsg(captainId, slotIndex)
    NetworkManager.sendMsg(msg)
end

-- 一键镶嵌/卸下宝石
-- captain_id: int // 武将id
-- down_all: bool // 卸下所有(true)/自动镶嵌(false)
function NetworkManager.C2SOneKeyUseGemProto(captainId, down)
    local msg = gem_decoder.NewC2sOneKeyUseGemMsg(captainId, down)
    NetworkManager.sendMsg(msg)
end

-- 请求一键合成消耗
-- captain_id: int // 武将id
--  slot_idx: int // 合成到哪个槽位的宝石上，即：GemSlotDataProto.slot_idx
function NetworkManager.C2SRequestOneKeyCombineCostProto(captainId, slotIndex)
    local msg = gem_decoder.NewC2sRequestOneKeyCombineCostMsg(captainId, slotIndex)
    NetworkManager.sendMsg(msg)
end
-- END theo

--------------------------------------------------------------------------------

-- 开始挑战
function NetworkManager.C2SStartChallenge()
    local msg = secret_tower_decoder.C2S_START_CHALLENGE()
    NetworkManager.sendMsg(msg)
end

-- 获取密室楼层队伍个数
function NetworkManager.C2SRequestFloorTeamCountProto()
    local msg = secret_tower_decoder.C2S_REQUEST_TEAM_COUNT()
    NetworkManager.sendMsg(msg)
end

-- 获取密室队伍列表
-- <param name="floorId" type="number">楼层Id</param>
function NetworkManager.C2SRequestTeamListProto(floorId)
    local msg = secret_tower_decoder.NewC2sRequestTeamListMsg(floorId)
    NetworkManager.sendMsg(msg)
end

-- 创建队伍
-- <param name="floorId" type="number">楼层Id</param>
-- <param name="captains" type="table">上阵武将</param>
-- <param name="isGuild" type="boolean">帮派密室(true)/普通密室(false)</param>
function NetworkManager.C2SCreateTeamProto(floorId, captains, isGuild)
    local msg = secret_tower_decoder.NewC2sCreateTeamMsg(floorId, captains, isGuild)
    NetworkManager.sendMsg(msg)
end

-- 加入队伍
-- <param name="team_id" type="number">队伍Id</param>
-- <param name="captains" type="table">上阵武将</param>
function NetworkManager.C2SJoinTeamProto(team_id, captains)
    local msg = secret_tower_decoder.NewC2sJoinTeamMsg(team_id, captains)
    NetworkManager.sendMsg(msg)
end

-- 离开队伍
function NetworkManager.C2SLeaveTeamProto()
    local msg = secret_tower_decoder.C2S_LEAVE_TEAM()
    NetworkManager.sendMsg(msg)
end

-- 更新队伍
function NetworkManager.C2SRequestTeamDetailProto()
    local msg = secret_tower_decoder.C2S_REQUEST_TEAM_DETAIL()
    NetworkManager.sendMsg(msg)
end

-- 踢出队伍
-- <param name="id" type="number">要踢出的人的id</param>
function NetworkManager.C2SKickMemberProto(id)
    local msg = secret_tower_decoder.NewC2sKickMemberMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 移动成员
-- <param name="id" type="number">要移动的人的id</param>
-- <param name="isUp" type="boolean">true(上移)/false(下移)</param>
function NetworkManager.C2SMoveMemberProto(id, isUp)
    local msg = secret_tower_decoder.NewC2sMoveMemberMsg(id, isUp)
    NetworkManager.sendMsg(msg)
end

-- 更改模式
-- <param name="mode" type="number">模式类型</param>
function NetworkManager.C2SChangeModeProto(mode)
    local msg = secret_tower_decoder.NewC2sChangeModeMsg(mode)
    NetworkManager.sendMsg(msg)
end

-- 邀请玩家
-- <param name="id" type="number">邀请的玩家id</param>
function NetworkManager.C2SInviteProto(id)
    local msg = secret_tower_decoder.NewC2sInviteMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 密室邀请列表
function NetworkManager.C2SRequestInviteLisProto()
    local msg = secret_tower_decoder.C2S_REQUEST_INVITE_LIST()
    NetworkManager.sendMsg(msg)
end
-- 缓慢迁城
-- map_id: int; // 自己主城所在的地图id
-- new_x: int
-- new_y: int
function NetworkManager.C2SSlowlyMoveBaseProto(mapId, newOddQ, newOddY)
    local msg = region_decoder.NewC2sSlowlyMoveBaseMsg(mapId, newOddQ, newOddY)
    NetworkManager.sendMsg(msg)
end

-- 建造行营
-- map_id: int; // 地图id
-- new_x: int; // 坐标X
-- new_y: int; // 坐标Y
function NetworkManager.C2SNewTentProto(mapId, newOddQX, newOddQY)
    local msg = region_decoder.NewC2sNewTentMsg(mapId, newOddQX, newOddQY)
    NetworkManager.sendMsg(msg)
end

-- 获取所有开放地区的数量
function NetworkManager.C2SRegionLevelCount()
    local msg = region_decoder.C2S_REGION_LEVEL_COUNT()
    NetworkManager.sendMsg(msg)
end
-- 行营返回主城
-- 无参数
function NetworkManager.C2SRemoveTentProto()
    local msg = region_decoder.C2S_REMOVE_TENT()
    NetworkManager.sendMsg(msg)
end

-- 修复行营
-- 无参数
function NetworkManager.C2SRepairTend()
    local msg = region_decoder.C2S_REPAIR_TENT()
    NetworkManager.sendMsg(msg)
end

-- 遣返盟友部队
-- id: string // 军情id
-- is_tent: bool // true表示遣返行营的盟友，false表示遣返主城的盟友
function NetworkManager.C2SRepatriateProto(combineId, isCamp)
    local msg = region_decoder.NewC2sRepatriateMsg(combineId, isCamp)
    NetworkManager.sendMsg(msg)
end

-- 设置联盟雕像
-- mapId: int   //地图id
-- x: int       /x坐标
-- y: int       /y坐标
-- 注意: 现在的设计不需要发送x和y
function NetworkManager.C2SPlaceGuildStatueProto(mapId, x, y)
    local msg = guild_decoder.NewC2sPlaceGuildStatueMsg(mapId, x, y)
    NetworkManager.sendMsg(msg)
end

-- 收回雕像
function NetworkManager.C2STakeBackGuildStatue()
    local msg = guild_decoder.C2S_TAKE_BACK_GUILD_STATUE()
    NetworkManager.sendMsg(msg)
end

-- 行营建造加速
function NetworkManager.CMiaoTentBuildingCd()
    local msg = region_decoder.C2S_MIAO_TENT_BUILDING_CD()
    NetworkManager.sendMsg(msg)
end

-- 请求白旗详情
-- id: string // 请求谁的信息
function NetworkManager.C2SWhiteFlagDetailProto(id)
    local msg = region_decoder.NewC2sWhiteFlagDetailMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 请求大地图上的不可建城点
function NetworkManager.C2SRegionBlock()
    local msg = misc_decoder.C2S_BLOCK()
    NetworkManager.sendMsg(msg)
end

-- ***************************************************************************
-- 百战千军
-- ***************************************************************************

-- 请求百战数据
function NetworkManager.C2SQueryBaiZhanInfoProto()
    local msg = bai_zhan_decoder.C2S_QUERY_BAI_ZHAN_INFO()
    NetworkManager.sendMsg(msg)
end

-- 百战挑战
-- <param name="captains" type="table">参与挑战的武将id, 武将人数必须 < HeroLevelProto.bai_zhan_captain_limit</param>
function NetworkManager.C2SBaiZhanChallengeProto(captains)
    local msg = bai_zhan_decoder.NewC2sBaiZhanChallengeMsg(captains)
    NetworkManager.sendMsg(msg)
end

-- 领取俸禄
function NetworkManager.C2SCollectSalaryProto()
    local msg = bai_zhan_decoder.C2S_COLLECT_SALARY()
    NetworkManager.sendMsg(msg)
end

-- 领取军衔奖励
-- <param name="id" type="int">要领取奖励的id</param>
function NetworkManager.C2SCollectJunXianPrizeProto(id)
    local msg = bai_zhan_decoder.NewC2sCollectJunXianPrizeMsg(id)
    NetworkManager.sendMsg(msg)
end

-- 获取百战回放
function NetworkManager.C2SSelfRecord()
    local msg = bai_zhan_decoder.NewC2sSelfChallengeRecordMsg(NetworkManager.version.number)
    NetworkManager.sendMsg(msg)
end

-- 获取百战排行榜
-- <param name="isSelf" type="boolen">请求自己，如果请求自己，start_rank请发0</param>
-- <param name="startRankId" type="int">开始的排名</param>
function NetworkManager.C2SRequestRankProto(isSelf, startRankId)
    local msg = bai_zhan_decoder.NewC2sRequestRankMsg(isSelf, startRankId)
    NetworkManager.sendMsg(msg)
end

-- 获取自己百战排行
-- 先请求C2SRequestRankProto，如果列表里没有自己，则发送此请求
function NetworkManager.C2SRequestSelfRankProto()
    local msg = bai_zhan_decoder.C2S_REQUEST_SELF_RANK()
    NetworkManager.sendMsg(msg)
end

-- 请求拉去排行榜
-- rankType: int // 排行榜类型，即 RankType
-- searchName: string // 名字，为空表示不是精确查找
-- isSelf: bool // 查询自己(true)，如果是查询自己，start_count 就不需要发了，如果不是查自己，根据当前显示的第一个是第几个来请求
-- startIndex: int // 从第几个开始取
function NetworkManager.C2SRequestRankProto(rankType, searchName, isSelf, startIndex, hundredsWarLevel)
    local msg = rank_decoder.NewC2sRequestRankMsg(rankType, searchName, isSelf, startIndex, hundredsWarLevel)
    NetworkManager.sendMsg(msg)
end

return NetworkManager
