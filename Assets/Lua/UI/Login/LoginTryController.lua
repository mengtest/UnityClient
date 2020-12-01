local json = require "json"

local _C = UIManager.SubController(UIManager.ControllerName.LoginTry, UIManager.ViewName.LoginTry)
_C.view = nil
_C.server = nil

local loginTry = "https://login.lightpaw.com/user/emlogin"

-- 登录回复
local function loginAck(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)

    local decode = json.decode(value)
    if decode.status ~= 200 then
        -- UI弹框提示
        UIManager.showTip( { content = Localization[string.format("%s%d", "Login", decode.status)], result = false })

        return
    end

    -- 保存登录信息
    CS.LPCFramework.LocalDataStorage.Instance:SaveString(UIManager.LocalDataType.LoginE, decode.e)
    CS.LPCFramework.LocalDataStorage.Instance:SaveString(UIManager.LocalDataType.LoginM, decode.m)


    -- 登录凭证
    _C.server.loginCredentials = decode
    _C.view.ServerName.text = decode.sname
    _C.view.ServerStat.selectedIndex = decode.slabel

    _C.view.LoginStat.selectedIndex = 1
end
-- 登录回复
local function loginError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
    -- 登录
    _C.view.LoginStat.selectedIndex = 0
end
-- 尝试登录
local function tryLogin()
    local e = CS.LPCFramework.LocalDataStorage.Instance:GetString(UIManager.LocalDataType.LoginE)
    local m = CS.LPCFramework.LocalDataStorage.Instance:GetString(UIManager.LocalDataType.LoginM)

    -- 没有本地信息
    if nil == "" or m == "" then
        _C.view.LoginStat.selectedIndex = 0
    else
        -- 打开菊花
        UIManager.openController(UIManager.ControllerName.Sync)
        -- 计算from参数
        local params = string.format("e=%s&m=%s&t=%s&v=%s", e, m, NetworkManager.version.platform, NetworkManager.version.number)
        -- http post请求
        CS.LPCFramework.HttpHelper.CreatePostHttpResponse(loginTry, params, loginAck, loginError)
    end
end

function _C:onOpen(data)
    tryLogin()
end

return _C