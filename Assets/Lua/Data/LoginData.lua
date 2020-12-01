local event = require "Event.Event"
local miscData = require "Data.MiscData"
local monarchsData = require "Data.MonarchsData"
local itemsData = require "Data.ItemsData"
local internalAffairsData = require "Data.InternalAffairsData"
local militaryAffairsData = require "Data.MilitaryAffairsData"
local towerData = require "Data.TowerData"
local towerBackroom = require "Data.TowerBackroomData"
local taskData = require "Data.TaskData"
local regionData = require "Data.RegionData"
local regionMilitaryInfoData = require "Data.RegionMilitaryInfoData"
local captainSoulData = require "Data.CaptainSoulData"

-- 登陆信息
local LoginData = { }

-- ****************************************************************
-- 注册服务器消息监听--
-- ****************************************************************

-- 内部登陆--moduleId = 1, msgId = 2
-- bytes heroProto = 1; // shared_proto.HeroProto
local function S2CInternalLoginProto(data)
    local login = shared_pb.HeroProto()
    login:ParseFromString(data.heroProto)

    monarchsData:updateInfo(login)
    internalAffairsData:updateInfo(login.domestic)
    militaryAffairsData:updateInfo(login.military)

    -- 开始心跳检测
    miscData.HeartBeatTimer:start()
    -- 登录完成
    event.dispatch(event.LOG_OK)
end
login_decoder.RegisterAction(login_decoder.S2C_INTERNAL_LOGIN, S2CInternalLoginProto)

-- 内部登陆失败--moduleId = 1, msgId = 5
local function S2CFailInternalLoginProto(code)
    print("S2CFailInternalLoginProto!!!! " .. tostring(code))
end
login_decoder.RegisterAction(login_decoder.S2C_FAIL_INTERNAL_LOGIN, S2CFailInternalLoginProto)

-- ****************************************************************
-- 正式登陆--moduleId = 1, msgId = 8
-- created: bool // 返回true表示已经创建角色了
-- male: bool // true表示男人
-- head: string // 头像
-- building: int[] // 建筑id
local function S2CLoginProto(data)
    if data.created == false then
        event.dispatch(event.CREATE_ROLE)
    else
        monarchsData.Male = data.male
        monarchsData.Head = data.head
        internalAffairsData:updateBuildingInfo(data.building)
        event.dispatch(event.LOG_OK)
    end
end
login_decoder.RegisterAction(login_decoder.S2C_LOGIN, S2CLoginProto)

-- 正式登陆失败--moduleId = 1, msgId = 9
local function S2CFailLoginProto(code)
    print("S2CFailLoginProto!!!! " .. tostring(code))
end
login_decoder.RegisterAction(login_decoder.S2C_FAIL_LOGIN, S2CFailLoginProto)

-- ****************************************************************
-- 创建角色成功--moduleId = 1, msgId = 4
-- 空消息，只表示创建成功
local function S2CCreateHeroProto()
    event.dispatch(event.CREATE_ROLE_SUCCEED)
end
login_decoder.RegisterAction(login_decoder.S2C_CREATE_HERO, S2CCreateHeroProto)

-- 创建角色失败--moduleId = 1, msgId = 6
local function S2CFailCreateHeroProto(code)
    print("S2CFailCreateHeroProto!!!! " .. tostring(code))
end
login_decoder.RegisterAction(login_decoder.S2C_FAIL_CREATE_HERO, S2CFailCreateHeroProto)

-- ****************************************************************
-- 进入场景（加载完资源发这条消息）--moduleId = 1, msgId = 11
-- heroProto: bytes // shared_proto.HeroProto
local function S2CLoaded(data)
    local login = shared_pb.HeroProto()
    login:ParseFromString(data.heroProto)

    monarchsData:updateInfo(login)
    itemsData:updateInfo(login.depot)
    towerData:updateInfo(login.tower)
    towerBackroom:updateInfo(login.secret_tower)
    internalAffairsData:updateInfo(login.domestic)
    militaryAffairsData:updateInfo(login.military)
    taskData:updateInfo(login.task)
    regionMilitaryInfoData:updateMilitaryUIInfo(login.region.self_military_info)
    monarchsData:updateRegionAllBaseInfo(login.region)
    itemsData:updateCombineSuit(login.open_combine_equip)
    captainSoulData:updateInfo(login.captain_soul)
    Event.dispatch(Event.UPDATE_SERVER_TIME, login.ctime, 0)
    -- 完成数据同步
    DataTrunk.SyncComplete = true
    -- 开始心跳检测
    miscData.HeartBeatTimer:start()
    -- 开始同步服务器时间
    miscData.SyncTimeTimer:start()

    -- Loading完成
    event.dispatch(event.SCENE_LOADED)

    print("登录成功！！")

    -- 登陆成功后请求野区不可建城的点信息
    NetworkManager.C2SRegionBlock()
end
login_decoder.RegisterAction(login_decoder.S2C_LOADED, S2CLoaded)

-- 进入场景失败--moduleId = 1, msgId = 12
local function S2CFailLoaded(code)
    print("S2CFailLoaded!!!! " .. tostring(code))
end
login_decoder.RegisterAction(login_decoder.S2C_FAIL_LOADED, S2CFailLoaded)



return LoginData