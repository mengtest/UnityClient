local _C = UIManager.Controller(UIManager.ControllerName.LoginMain, UIManager.ViewName.LoginMain)
local _CTry = require(UIManager.ControllerName.LoginTry)
local _CServer = require(UIManager.ControllerName.LoginServer)
local _CLogin = require(UIManager.ControllerName.Login2Register)
table.insert(_C.SubCtrl, _CTry)
table.insert(_C.SubCtrl, _CLogin)
table.insert(_C.SubCtrl, _CServer)

local view = nil

-- 创建角色
local function creatRole()
    if not _C.IsOpen then
        return
    end

    -- 无角色
    _C:close()
    UIManager.openController(UIManager.ControllerName.CreatRole)
end
-- 登录成功
local function loginOk()
    if not _C.IsOpen then
        return
    end

    -- 有角色
    _C:close()
    LevelManager.loadScene(LevelType.MainCity)
end

-- 切换帐号
local function btnSwitchAccount()
    view.LoginStat.selectedIndex = 0
end

-- 打开工具界面
local function OnToolsBtnClicked()
    UIManager.openController(UIManager.ControllerName.ToolsMainPage)
end

-- 登录特效
local function loadLoginParticle()
    UIManager.creatParticle(view.EffectBg, UIManager.ParticlePath.Login_Bg)
end

function _C:onCreat()
    view = _C.View
    _CServer.view = view
    _CLogin.view = view
    _CLogin.server = _CServer
    _CTry.view = view
    _CTry.server = _CServer

    view.BtnSwitchAccount.onClick:Add(btnSwitchAccount)
    view.BtnTools.onClick:Set(OnToolsBtnClicked)

    Event.addListener(Event.CREATE_ROLE, creatRole)
    Event.addListener(Event.LOG_OK, loginOk)

    -- 特效
    loadLoginParticle()
end

function _C:onOpen(data)
    -- 解析manifest文件
    local manifest = CS.UnityEngine.Resources.Load("UnityCloudBuildManifest.json", typeof(CS.UnityEngine.TextAsset))
    if manifest ~= nil then
        local decodedInfo = json.decode(manifest.text)
        if decodedInfo ~= nil then
            NetworkManager.version.platform = decodedInfo.cloudBuildTargetName
            NetworkManager.version.number = decodedInfo.buildNumber
        end
    end
    -- 版本号
    view.Version.text = string.format("%s%s%s", Localization.Version, NetworkManager.version.platform, NetworkManager.version.number)

    -- 断开连接
    Event.clear(Event.LOG_READY)
    Event.clear(Event.CONNECTED)
    NetworkManager.onDisconnect()

    -- 清空数据
    DataTrunk.clear()
    DataTrunk.clearConfig()
end
function _C:onDestroy()
    view.BtnSwitchAccount.onClick:Clear()

    Event.removeListener(Event.CREATE_ROLE, creatRole)
    Event.removeListener(Event.LOG_OK, loginOk)
end
