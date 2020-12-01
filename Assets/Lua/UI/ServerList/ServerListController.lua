local _C = UIManager.Controller(UIManager.ControllerName.ServerList, UIManager.ViewName.ServerList)
local view = nil
-- 服务器配置
local serverConfig = nil
-- 服务器分区
local serverSubarea = nil
-- 单个分区个数
local intervalLen = 10
-- 当前分区索引
local curSubareaId = 0
-- 当前服务器索引
local curServerId = 0

-- 返回
local function BtnBack()
    _C:close()
end
-- 分区点击
local function serverSubareaClick(item)
    local index = tonumber(item.data.name)
    curSubareaId = index
    view.ServerDetailList.numItems = 0
    view.ServerDetailList.numItems = serverSubarea[index].length
end
-- 分区滚动
local function renderListServerSubareaItem(index, obj)
    -- 此处临时将“我的服务器”关闭，修改回来，只需将+1去掉
    obj.name = tostring(index + 1)
    obj:GetChild("title").text = serverSubarea[index + 1].desc
    obj:GetController("shuzi").selectedIndex = 1
end
-- 服务器点击
local function serverDetailClick(item)
    local index = tonumber(item.data.name)
    curServerId = tonumber(serverSubarea[curSubareaId].server[index].ID)
    Event.dispatch(Event.LOGIN_SERVER_ID, curServerId)

    BtnBack()
end
-- 服务器滚动
local function renderListServerDetailItem(index, obj)
    obj.name = tostring(index)
    local server = serverSubarea[curSubareaId].server[index]
    obj:GetChild("title").text = server.Name
    obj:GetController("State_C").selectedIndex = server.Label
end
-- 服务器分区
local function serverPartitioning()
    serverSubarea = { }

    -- 服务器个数
    local count = 0
    for k, v in pairs(serverConfig) do
        count = count + 1
    end

    -- 服务器分大区
    local iquo, irem = math.modf(count / intervalLen)
    if irem > 0 then
        count = iquo + 2
    else
        count = iquo + 1
    end

    local id = 0
    for i = 0, count - 1 do
        serverSubarea[i] = { }
        serverSubarea[i].server = { }
        serverSubarea[i].length = 0
        if i == 0 then
            serverSubarea[i].desc = Localization.ServerMy
        else
            -- 类如：1-10区
            id =(i - 1) * intervalLen + 1
            serverSubarea[i].desc = string.format(Localization.ServerSubarea, id, id + intervalLen - 1)
        end
    end

    -- 分区内服务器设置
    id = 0
    for k, v in pairs(serverConfig) do
        iquo, irem = math.modf(id / intervalLen)
        irem = irem * intervalLen

        serverSubarea[iquo + 1].server[irem] = v
        serverSubarea[iquo + 1].length = serverSubarea[iquo + 1].length + 1
        id = id + 1
    end
    -- 此处临时将“我的服务器”关闭，修改回来，只需将-1去掉
    view.ServerList.numItems = count - 1
end

function _C:onCreat()
    view = _C.View

    view.ServerList.itemRenderer = renderListServerSubareaItem
    view.ServerDetailList.itemRenderer = renderListServerDetailItem
    view.ServerList.onClickItem:Add(serverSubareaClick)
    view.ServerDetailList.onClickItem:Add(serverDetailClick)
    view.BtnBack.onClick:Add(BtnBack)
end

function _C:onOpen(data)
    if nil == serverConfig then
        serverConfig = data.serverList
        curServerId = data.serverId
        serverPartitioning()
    end
    if view.ServerList.numItems > 1 then
        view.ServerList:GetChildAt(1).onClick:Call()
    else
        view.ServerList:GetChildAt(0).onClick:Call()
    end
end

function _C:onDestroy()
    view.ServerList.itemRenderer = nil
    view.ServerDetailList.itemRenderer = nil
    view.ServerList.onClickItem:Clear()
    view.ServerDetailList.onClickItem:Clear()
    view.BtnBack.onClick:Clear()

    serverConfig = nil
    serverSubarea = nil
end
