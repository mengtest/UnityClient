local json = require "json"

local _C = UIManager.SubController(UIManager.ControllerName.Login2Register, nil)
_C.view = nil
_C.server = nil

-- 登录地址
local registerServerUrl = "https://login.lightpaw.com/user/register"
local loginServerUrl = "https://login.lightpaw.com/user/login"

local accountId = nil
local password = nil

-- 保存账号
local function saveAccount()
    local id = ""
    local passW = ""
    if _C.view.RememberStat.selectedIndex == 1 then
        id = accountId
        passW = password
    end

    CS.LPCFramework.LocalDataStorage.Instance:SaveString(UIManager.LocalDataType.AccountId, id)
    CS.LPCFramework.LocalDataStorage.Instance:SaveString(UIManager.LocalDataType.Password, passW)
end
-- 检测输入合法性
local function checkLegal()
    accountId = _C.view.AcountId.text
    password = _C.view.Password.text

    local accountLen = string.len(accountId)
    -- 此处约定，帐号长度在3-16个字符之间
    if accountLen < 3 then
        UIManager.showTip( { content = Localization.AccountIdLenShort, result = false })
        return
    end
    if accountLen > 16 then
        UIManager.showTip( { content = Localization.AccountIdLenLong, result = false })
        return
    end
    if password == "" then
        UIManager.showTip( { content = Localization.PasswardError, result = false })
        return
    end
    -- 保存账号
    saveAccount()
    return true
end
-- post回复
local function httpAck(value)
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
-- post回复
local function httpError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
end
-- post请求
local function httpPost(url)
    -- 检测合法
    if not checkLegal() then
        return
    end
    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 计算from参数
    local params = string.format("u=%s&p=%s&t=%s&v=%s", accountId, CS.LPCFramework.HttpHelper.GetSha1(accountId .. password), NetworkManager.version.platform, NetworkManager.version.number)
    -- http post请求
    CS.LPCFramework.HttpHelper.CreatePostHttpResponse(url, params, httpAck, httpError)
end
-- 记住账号
local function btnRememberAccount()
    if _C.view.RememberStat.selectedIndex == 0 then
        _C.view.RememberStat.selectedIndex = 1
    else
        _C.view.RememberStat.selectedIndex = 0
    end
end

function _C:onCreat()
    _C.view.BtnRegister.onClick:Add( function() httpPost(registerServerUrl) end)
    _C.view.BtnLogin.onClick:Add( function() httpPost(loginServerUrl) end)
    _C.view.BtnRemember.onClick:Add(btnRememberAccount)
end

function _C:onOpen(data)
    -- 获取账户信息
    accountId = CS.LPCFramework.LocalDataStorage.Instance:GetString(UIManager.LocalDataType.AccountId)
    password = CS.LPCFramework.LocalDataStorage.Instance:GetString(UIManager.LocalDataType.Password)

    if accountId ~= "" then
        _C.view.AcountId.text = accountId
    end
    if password ~= "" then
        _C.view.Password.text = password
    end
end
function _C:onDestroy()
    _C.view.BtnRegister.onClick:Clear()
    _C.view.BtnLogin.onClick:Clear()
    _C.view.BtnRemember.onClick:Clear()

    password = nil
    accountId = nil
end

return _C
