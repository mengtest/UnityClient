local json = require "json"

local _C = UIManager.Controller(UIManager.ControllerName.Splash, UIManager.ViewName.Splash)
local view = nil

local loginTry = "https://login.lightpaw.com/user/emlogin"

-- 登录界面
local function toLoginPanel(data)
    UIManager.openController(UIManager.ControllerName.LoginMain, data)
end
-- 登录回复
local function loginAck(value)
    _C:close()
    local decode = json.decode(value)

    -- 保存登录信息
    CS.LPCFramework.LocalDataStorage.Instance:SaveString(UIManager.LocalDataType.LoginE, decode.e)
    CS.LPCFramework.LocalDataStorage.Instance:SaveString(UIManager.LocalDataType.LoginM, decode.m)

    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 登录
    toLoginPanel(decode)
end
-- 登录回复
local function loginError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
    -- 登录
    toLoginPanel(nil)
end
-- 尝试登录
local function tryLogin()
    local e = CS.LPCFramework.LocalDataStorage.Instance:GetString(UIManager.LocalDataType.LoginE)
    local m = CS.LPCFramework.LocalDataStorage.Instance:GetString(UIManager.LocalDataType.LoginM)

    -- 没有本地信息
    if nil == "" or m == "" then
        toLoginPanel(nil)
    else
        -- 打开菊花
        UIManager.openController(UIManager.ControllerName.Sync)
        -- 计算from参数
        local params = "e=" .. e .. "&m=" .. m
        -- http post请求
        CS.LPCFramework.HttpHelper.CreatePostHttpResponse(loginTry, params, loginAck, loginError)
    end
end

function _C:onOpen()
    view = _C.View
    view.Effect:Play(tryLogin)
end
function _C:onDestroy()
    view.Effect:Stop()
    view = nil
end
