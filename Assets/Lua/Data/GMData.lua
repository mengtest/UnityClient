-- GM命令信息
local GMData = { }
-- GM指令列表
GMData.OrderList = {}

-- GM命令--moduleId = 3, msgId = 2
-- 支持的GM命令列表

-- 资源
-- 加资源：res gold 1000 (gold, food, wood, stone, all【表示所有资源】)
-- 减资源：res gold -1000

-- 邮件（用于测试）
-- 发一封邮件给自己：mail 数字

-- 堆叠道具  goods
-- 装备道具  equipment

-- 每日重置  reset daily
-- 君主升级 level hero 数字（升几级）

-- amount frd 数字（加X点繁荣度，可以是负数）

-- 君主升级 base 数字（数字表示加多少级）

-- result: string
local function S2CGmProto(data)
    print(data.result)
end
gm_decoder.RegisterAction(gm_decoder.S2C_GM, S2CGmProto)

-- datas: bytes[] // shared_proto.GmCmdListProto
local function S2CGMListCMD(data)
    local pages = #data.datas
    local orderInfo = nil

    for i = 1, pages do
        orderInfo = shared_pb.GmCmdListProto()
        orderInfo:ParseFromString(data.datas[i])

        local listInfo = GmCmdListClass()
        listInfo:updateInfo(orderInfo)
        GMData.OrderList[i] = listInfo
    end

    Event.dispatch(Event.GM_REQ_CMD_LIST_SUCCESS)
end
gm_decoder.RegisterAction(gm_decoder.S2C_LIST_CMD, S2CGMListCMD)

return GMData