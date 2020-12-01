local json = require "json"

local _C = UIManager.SubController(UIManager.ControllerName.LoginServer, nil)

local serverListUrl = "https://login.lightpaw.com/list"
local loginInfoUrl = "https://login.lightpaw.com/server/"
local serverConfig = nil

_C.view = nil
-- 登录凭证
_C.loginCredentials = nil

-- 更新选择服务器信息
local function updateServerInfo()
    local serverInfo = serverConfig[tostring(_C.loginCredentials.sid)]
    _C.view.ServerName.text = serverInfo.Name
    _C.view.ServerStat.selectedIndex = serverInfo.Label
end
-- 服务器更改
local function serverChange(id)
    if not _C.IsOpen then
        return
    end

    _C.loginCredentials.sid = id
    updateServerInfo()
end

-- serverList http异常
local function httpError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = string.format("%s%s", Localization.ConnectError, value), result = false })
end
-- serverList回复
local function serverListHttpAck(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)

    serverConfig = json.decode(value)
    -- 切服
    UIManager.openController(UIManager.ControllerName.ServerList, { serverList = serverConfig, serverId = _C.loginCredentials.sid })
end
-- 切服请求
local function btnSwitchServer()
    if nil == serverConfig then
        -- 打开菊花
        UIManager.openController(UIManager.ControllerName.Sync)
        -- http get请求
        CS.LPCFramework.HttpHelper.CreateGetHttpResponse(serverListUrl, serverListHttpAck, loginError)
    else
        UIManager.openController(UIManager.ControllerName.ServerList, { serverList = serverConfig, serverId = _C.loginCredentials.sid })
    end
end
-- loginInfo回复
local function loginInfoHttpAck(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)

    local decode = json.decode(value)
    if decode.status ~= 200 then
        -- UI弹框提示
        UIManager.showTip( { content = Localization[string.format("%s%d", "Server", decode.status)], result = false })

        return
    end

    local address = Utils.stringSplit(decode.address, ":")

    -- 进行网络初始化，和登录操作
    NetworkManager.C2SLoginProto(address[1], tonumber(address[2]), decode.token, decode.key)
end
-- 开始
local function btnStart()
    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 计算from参数
    local params = string.format("e=%s&m=%s&t=%s&v=%s", _C.loginCredentials.e, _C.loginCredentials.m, NetworkManager.version.platform, NetworkManager.version.number)
    -- http post请求
    CS.LPCFramework.HttpHelper.CreatePostHttpResponse(loginInfoUrl .. _C.loginCredentials.sid, params, loginInfoHttpAck, httpError)
end
-- 公告
local function btnNotice()
    UIManager.openController(UIManager.ControllerName.Notice)
end

function _C:onCreat()
    _C.view.BtnNotice.onClick:Add(btnNotice)
    _C.view.BtnSwitchServer.onClick:Add(btnSwitchServer)
    _C.view.BtnStart.onClick:Add(btnStart)

    Event.addListener(Event.LOGIN_SERVER_ID, serverChange)
end
function _C:onOpen(data)
    -- 默认服
    if data ~= nil then
        _C.loginCredentials = data

        _C.view.ServerName.text = data.sname
        _C.view.ServerStat.selectedIndex = data.slabel
    end
end
function _C:onClose()
    serverConfig = nil
end

function _C:onDestroy()
    _C.view.BtnNotice.onClick:Clear()
    _C.view.BtnSwitchServer.onClick:Clear()
    _C.view.BtnStart.onClick:Clear()

    Event.removeListener(Event.LOGIN_SERVER_ID, serverChange)
end

return _C