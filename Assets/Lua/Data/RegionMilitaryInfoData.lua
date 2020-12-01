RegionMilitaryInfoData = { }
-- 玩家自己的军情信息
RegionMilitaryInfoData.MyMilitaryInfoList = { }
-- 当前地图上的军情信息
RegionMilitaryInfoData.CurrMapMilitaryInfoList = { }
-- 自己主界面上显示的三条军情
RegionMilitaryInfoData.MyMilitaryInfoListForUI = { }
-- 自己行营界面的驻守部队, 如果还没进入过大地图时使用
RegionMilitaryInfoData.MyAssistTroopsForCampsite = { }


function RegionMilitaryInfoData:clear()
    self.MyMilitaryInfoList = { }
    self.CurrMapMilitaryInfoList = { }
    self.MyMilitaryInfoListForUI = { }
    self.MyAssistTroopsForCampsite = { }
end

-- 更新我的军情
function RegionMilitaryInfoData:updateMyMilitaryInfo(data)
    if self.MyMilitaryInfoList[data.combine_id] == nil then
        self.MyMilitaryInfoList[data.combine_id] = MilitaryInfoClass()
    end

    self.MyMilitaryInfoList[data.combine_id]:updateInfo(data)
    print("~~~~~~~更新一条我的军情~~~~~", data.combine_id)
end

-- 移除一条我的军情
function RegionMilitaryInfoData:removeMyMilitaryInfo(id)
    if self.MyMilitaryInfoList[id] ~= nil then
        -- 置空
        self.MyMilitaryInfoList[id] = nil
    end
    print("~~~~~~~移除一条我的军情~~~~~", id)
end

-- 移除所有的我的军情
function RegionMilitaryInfoData:removeAllMyMilitaryInfo()
    self.MyMilitaryInfoList = { }
end

-- 更新当前地图上的军情
function RegionMilitaryInfoData:updateCurrMapMilitaryInfo(data)
    if self.CurrMapMilitaryInfoList[data.combine_id] == nil then
        self.CurrMapMilitaryInfoList[data.combine_id] = MilitaryInfoClass()
    end

    self.CurrMapMilitaryInfoList[data.combine_id]:updateInfo(data)

    print("~~~~~~~更新一条当前地图上的军情~~~~~", data.combine_id)
end

-- 移除一条当前地图上的军情
function RegionMilitaryInfoData:removeCurrMapMilitaryInfo(id)
    self.CurrMapMilitaryInfoList[id] = nil

    print("~~~~~~~移除一条当前地图上的军情~~~~~", id)
end

-- 移除所有当前地图上的军情
function RegionMilitaryInfoData:removeAllCurrMapMilitaryInfo()
    self.CurrMapMilitaryInfoList = { }
    self.MyMilitaryInfoListForUI = { }
end

-- 解析主界面的军情
function RegionMilitaryInfoData:ParseMilitaryUIData(data)
    if data == nil or self.MyMilitaryInfoListForUI.Datas == nil then
        return
    end
 
    local Data = { }
    Data.CombineID = data.combine_id
    Data.Action = data.action
    Data.MoveType = data.move_type
    Data.StartTime = data.move_start_time
    Data.ArrivedTime = data.move_arrived_time

    self.MyMilitaryInfoListForUI.Datas[data.combine_id] = Data
    Event.dispatch(Event.ON_WAR_SITUATION_UPDATE)
end

-- 登陆时更新所有主界面上的军情
function RegionMilitaryInfoData:updateMilitaryUIInfo(data)
    if data == nil then
        return
    end

    if self.MyMilitaryInfoListForUI.Datas == nil then
        self.MyMilitaryInfoListForUI.Datas = { }
    end

    for k, v in ipairs(data) do
        if v ~= nil then
            self:ParseMilitaryUIData(v)
        end
    end
end

-- 更新一条主界面上的军情
function RegionMilitaryInfoData:UpdateSelfMilitaryMarchingUIInfo(data)
    if data == nil then
        return
    end
    if self.MyMilitaryInfoListForUI.Datas == nil then
        self.MyMilitaryInfoListForUI.Datas = { }
    end
    local militaryInfo = shared_pb.MilitaryInfoProto()
    militaryInfo:ParseFromString(data)
    self:ParseMilitaryUIData(militaryInfo)
end

-- 移除一条主界面军情
function RegionMilitaryInfoData:RemoveSelfMilitaryMarchingUIInfo(data)
    if data == nil or self.MyMilitaryInfoListForUI.Datas == nil then
        return
    end

    if self.MyMilitaryInfoListForUI.Datas[data.id] ~= nil then
        self.MyMilitaryInfoListForUI.Datas[data.id] = nil
    end
    print("~~~~~~~移除一条主界面上的军情~~~~~", data.id)
    Event.dispatch(Event.ON_WAR_SITUATION_UPDATE)
end

-- 获取主界面所有军情
function RegionMilitaryInfoData:GetMyMilitaryUIData()
    return self.MyMilitaryInfoListForUI.Datas
end

-- **************协议处理 *******************************************************
-- 进出军情界面
-- 自己的军情通知，只给军情界面用，此消息在打开我的军情界面时通知
-- moduleId = 7, msgId = 21
-- datas: bytes[] // MilitaryInfoProto
local function S2CMilitaryInfoProto(data)
    if data == nil or data.datas == nil then
        return
    end
    print("我的军情来了！！！！！")
    for k, v in ipairs(data.datas) do
        local military = shared_pb.MilitaryInfoProto()
        military:ParseFromString(v)
        RegionMilitaryInfoData:updateMyMilitaryInfo(military)
    end

    -- 发出事件
    Event.dispatch(Event.ON_ALL_MY_MILITARY_UPDATED)
end
region_decoder.RegisterAction(region_decoder.S2C_MILITARY_INFO, S2CMilitaryInfoProto)

-- 打开、关闭自己的军情界面回复
-- 服务器主动推送以下消息
-- military_info 军情信息
-- 以上消息会在本消息的s2c消息返回之前先发送，
-- 关闭军情面板，发送关闭消息
-- moduleId = 7, msgId = 47
-- open: bool // true表示打开，false表示关闭
local function S2CSwitchActionProto(data)
    if data == nil or data.open == nil then
        return
    end
    print("是否接收军情", data.open)
    if data.open == true then
        Event.dispatch(Event.ON_OPEN_MILITARY)
    else
        -- 移除所有我的军情
        RegionMilitaryInfoData:removeAllMyMilitaryInfo()
        Event.dispatch(Event.ON_CLOSE_MILITARY)
    end
end
region_decoder.RegisterAction(region_decoder.S2C_SWITCH_ACTION, S2CSwitchActionProto)


-- 野外马（我可见的野外发生的事情）
-- moduleId = 7, msgId = 45
-- map_id: int // 野外地图id
-- datas: bytes[] // MilitaryInfoProto
local function S2CMapMilitaryInfoProto(data)
    if data == nil or data.datas == nil then
        return
    end
    print("通知野外军情咯")
    for k, v in ipairs(data.datas) do
        local military = shared_pb.MilitaryInfoProto()
        military:ParseFromString(v)
        RegionMilitaryInfoData:updateCurrMapMilitaryInfo(military)
    end

    -- 发出事件
    Event.dispatch(Event.ON_ALL_CURRENT_MAP_MILITARY_UPDATED)
end
region_decoder.RegisterAction(region_decoder.S2C_MAP_MILITARY_INFO, S2CMapMilitaryInfoProto)

-- 移除一条军情
-- moduleId = 7, msgId = 23
-- id: string // 军情id
-- region: bool // true表示移除野外的马
-- ma: bool // true表示移除军情
local function S2CRemoveMilitaryInfoProto(data)
    if data == nil or data.id == nil then
        return
    end

    print("删除一条军情", data.region, data.ma)

    -- 移除一条我的军情
    if data.ma == true then
        if RegionMilitaryInfoData.MyMilitaryInfoList[data.id] ~= nil then
            RegionMilitaryInfoData:removeMyMilitaryInfo(data.id)

            -- 发出事件
            Event.dispatch(Event.ON_MY_MILITARY_REMOVED, data.id)
            Event.dispatch(Event.REMOVE_ASSIST, data.id)
        end
    end

    -- 移除一条当前地图军情（野外的马）
    if data.region == true then
        if RegionMilitaryInfoData.CurrMapMilitaryInfoList[data.id] ~= nil then
            RegionMilitaryInfoData:removeCurrMapMilitaryInfo(data.id)

            -- 发出事件
            Event.dispatch(Event.ON_CURRENT_MAP_MILITARY_REMOVED, data.id)
        end
    end
end
region_decoder.RegisterAction(region_decoder.S2C_REMOVE_MILITARY_INFO, S2CRemoveMilitaryInfoProto)

-- 更新一条军情（如果当前没有这条军情，就当成新增军情）
-- moduleId = 7, msgId = 22
-- data: bytes // MilitaryInfoProto
-- region: bool // true表示更新野外的马
-- ma: bool // true表示更新军情
local function S2CUpdateMilitaryInfoProto(data)
    if data == nil or data.data == nil then
        return
    end

    local military = shared_pb.MilitaryInfoProto()
    military:ParseFromString(data.data)

    -- 更新我的军情
    if data.ma == true then
        print("更新一条我自己的军情", military.combine_id)
        RegionMilitaryInfoData:updateMyMilitaryInfo(military)

        -- 发出事件
        Event.dispatch(Event.ON_MY_MILITARY_UPDATED, military.combine_id)
    end

    -- 更新当前地图军情（野外的马）
    if data.region == true then
        print("更新一条野外的军情", military.combine_id)
        RegionMilitaryInfoData:updateCurrMapMilitaryInfo(military)

        -- 发出事件
        Event.dispatch(Event.ON_CURRENT_MAP_MILITARY_UPDATED, RegionMilitaryInfoData.CurrMapMilitaryInfoList[military.combine_id])
        Event.dispatch(Event.UPDATE_ASSIST, RegionMilitaryInfoData.CurrMapMilitaryInfoList[military.combine_id].Target.Id, RegionMilitaryInfoData.CurrMapMilitaryInfoList[military.combine_id])
    end
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_MILITARY_INFO, S2CUpdateMilitaryInfoProto)

-- 更新自己的军情（主界面上的）
-- moduleId = 7, msgId = 50
-- data: bytes // MilitaryInfoProto
local function S2CUpdateSelfMilitaryInfo(data)
    RegionMilitaryInfoData:UpdateSelfMilitaryMarchingUIInfo(data.data)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_SELF_MILITARY_INFO, S2CUpdateSelfMilitaryInfo)

-- 移除自己的军情（主界面上的）
-- moduleId = 7, msgId = 51
-- id: string // 军情id
local function S2CRemoveSelfMilitaryInfo(data)
    RegionMilitaryInfoData:RemoveSelfMilitaryMarchingUIInfo(data)
end
region_decoder.RegisterAction(region_decoder.S2C_REMOVE_SELF_MILITARY_INFO, S2CRemoveSelfMilitaryInfo)

-- 更新自己的驻守军情（行营界面上的）
-- moduleId = 7, msgId = 78
-- data: bytes // MilitaryInfoProto
local function S2CUpdateDefendingMilitaryInfoProto(data)
    if data == nil then
        return
    end
    local militaryInfo = shared_pb.MilitaryInfoProto()
    militaryInfo:ParseFromString(data.data)
    local military = MilitaryInfoClass()
    military:updateInfo(militaryInfo)
    table.insert(RegionMilitaryInfoData.MyAssistTroopsForCampsite, military)
    Event.dispatch(Event.UPDATE_ASSIST, DataTrunk.PlayerInfo.MonarchsData.Id, military)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_DEFENDING_MILITARY_INFO, S2CUpdateDefendingMilitaryInfoProto)

-- 移除自己的军情（行营界面上的）
-- moduleId = 7, msgId = 79
-- id: string // 军情id
local function S2CRemoveDefendingMilitaryInfoProto(data)
    if data == nil then
        return
    end
    Event.dispatch(Event.REMOVE_ASSIST, DataTrunk.PlayerInfo.MonarchsData.Id, data.id)
end
region_decoder.RegisterAction(region_decoder.S2C_REMOVE_DEFENDING_MILITARY_INFO, S2CRemoveDefendingMilitaryInfoProto)

-- 更新主界面提示军情
-- moduleId = 7, msgId = 89
-- invate_troop_count: int // 出征中的敌军数量
-- robbing_troop_count: int // 掠夺中的敌军数量
-- assist_troop_count: int // 援助中的敌军数量
local function S2CUpdateMilitaryTipsProto(data)
    if data == nil then
        return
    end
    Event.dispatch(Event.MAINUI_MILITARY_UPDATE, data.invate_troop_count, data.robbing_troop_count, data.assist_troop_count)
end
region_decoder.RegisterAction(region_decoder.S2C_UPDATE_MILITARY_TIPS, S2CUpdateMilitaryTipsProto)

return RegionMilitaryInfoData
