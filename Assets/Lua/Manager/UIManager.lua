local UIManager = { }

require("UI.core.FairyGUI")

-- ui定义-
local UIDefine = require "UI.core.uiDefine"
UIManager.NtfMsgType = UIDefine.NtfMsgType
UIManager.ControllerName = UIDefine.ControllerName
UIManager.ViewName = UIDefine.ViewName
UIManager.LocalDataType = UIDefine.LocalDataType
UIManager.ParticlePath = UIDefine.ParticlePath
UIManager.PopupStyle = UIDefine.PopupStyle

-- uiCtrl--
UIManager.Controller = require "UI.core.Controller":extend()
UIManager.SubController = require "UI.core.SubController":extend()

-- uiView--
UIManager.View = require "UI.core.View":extend()

-- facade--
local facade = require "UI.core.facade"

-- tips--
local tips = require(UIManager.ControllerName.Tips)
-- ServerTime
local serverTime = require(UIManager.ControllerName.ServerTime)
-- clickEffect
local clickEffect = nil
-- uiReferenceCount
local uiReferenceCount = nil

-----------------------------------------------------------------
-- 界面管理
-----------------------------------------------------------------

-- 进入登录界面
local function reLogin()
    -- 弹出二级弹框
    UIManager.openController(UIManager.ControllerName.Popup,
    {
        UIManager.PopupStyle.ContentConfirm,
        content = Localization.Reconnect_1,

        btnTitle = Localization.BackToLogin,
        btnFunc = function() LevelManager.loadScene(LevelType.Bootup) end,
        BGCanCancel = false,
    } )
end
Event.addListener(Event.MUST_RELOGIN, reLogin)
-- 尝试重连
local function reConnecting()
    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 关闭菊花
    local closeSync
    -- 定义
    closeSync = function()
        Event.removeListener(Event.CONNECTED, closeSync)
        -- 关闭菊花
        Event.dispatch(Event.SYNC_CLOSE)
    end
    -- 添加监听
    Event.addListener(Event.CONNECTED, closeSync)
end
Event.addListener(Event.MUST_RECONNECTING, reConnecting)
-- 网络重连,成功后进入主城界面
local function reConnect()
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 重新登录
    local toConnect = function()
        -- 如果当前所在bootup场景
        if LevelManager.CurLevelType == LevelType.Bootup then
            -- 切换场景
            LevelManager.loadScene(LevelType.Bootup)
        else
            -- 断开连接
            Event.clear(Event.LOG_READY)
            Event.clear(Event.CONNECTED)
            NetworkManager.onDisconnect()
            -- 清空数据
            DataTrunk.clear()
            -- 打开菊花
            UIManager.openController(UIManager.ControllerName.Sync)
            -- 去主城
            local toMaincity
            -- 定义
            toMaincity = function()
                Event.removeListener(Event.LOG_OK, toMaincity)
                -- 关闭菊花
                Event.dispatch(Event.SYNC_CLOSE)
                -- 切换场景
                LevelManager.loadScene(LevelType.MainCity)
            end
            -- 登录成功
            Event.addListener(Event.LOG_OK, toMaincity)
            -- 重新登录
            NetworkManager.C2SReLoginProto()
        end
    end
    -- 返回登录
    local backToLogin = function()
        -- 去登录界面
        LevelManager.loadScene(LevelType.Bootup)
    end
    -- 弹出二级弹框
    UIManager.openController(UIManager.ControllerName.Popup,
    {
        UIManager.PopupStyle.ContentYesNo,
        content = Localization.Reconnect,
        btnTitle = { Localization.BackToLogin, Localization.Reconnect_1 },
        btnFunc = { backToLogin, toConnect },
        BGCanCancel = false,
    } )
end
Event.addListener(Event.MUST_RECONNECT, reConnect)
-- 舞台事件处理
local function stageEventHandle()
    -- 点击特效
    clickEffect = UIPackage.CreateObjectFromURL(UIConfig.ClickEffect)
    GRoot.inst:AddChild(clickEffect)

    local effect_T = clickEffect:GetTransition("Effect_T")
    clickEffect.fairyBatching = true
    clickEffect.visible = false
    clickEffect.sortingOrder = 99999

    -- 舞台点击
    Stage.inst.onClick:Set( function()
        clickEffect.xy = GRoot.inst:GlobalToLocal(Stage.inst.touchPosition)
        clickEffect.visible = true
        effect_T:Play()

        -- 抛出事件
        Event.dispatch(Event.STAGE_ON_CLICK)
    end )

    -- 抛出事件
    Stage.inst.onTouchBegin:Set( function() Event.dispatch(Event.STAGE_ON_TOUCH_BEGIN) end)
    Stage.inst.onTouchEnd:Set( function() Event.dispatch(Event.STAGE_ON_TOUCH_END) end)
end
-- ui包引用计数
local function uiPkgReferenceAsc(pkgPath)
    -- 界面引用包处理
    local pkg = CS.LPCFramework.ResourceMgr.LoadUI(pkgPath)
    -- 此界面引用包
    local otherPkgId = UIFileReference[pkg.name]
    if nil ~= otherPkgId then
        -- 遍历检测
        for k, v in pairs(otherPkgId) do
            -- 将包引入
            local refPkg = CS.LPCFramework.ResourceMgr.LoadUI(v)
            -- 为空检测
            if nil == uiReferenceCount[refPkg.id] then
                uiReferenceCount[refPkg.id] = 0
            end
            -- 引用个数递增
            uiReferenceCount[refPkg.id] = uiReferenceCount[refPkg.id] + 1
        end
    end
    -- 自身包检测
    if nil == uiReferenceCount[pkg.id] then
        uiReferenceCount[pkg.id] = 0
    end
    -- 自身包引用个数递增
    uiReferenceCount[pkg.id] = uiReferenceCount[pkg.id] + 1

    return pkg
end
-- ui包引用计数
local function uiPkgReferenceDec(pkg)
    -- 遍历检测
    for k, v in pairs(UIFileReference[pkg.name]) do
        -- 引用个数递减
        uiReferenceCount[k] = uiReferenceCount[k] -1
        -- 检测引用个数
        if uiReferenceCount[k] <= 0 then
            uiReferenceCount[k] = 0

            -- 获取id对应UI包
            local pkg = UIPackage.GetById(k)
            -- 执行卸载
            if nil ~= pkg then
                CS.LPCFramework.ResourceMgr.UnLoadUI(k, true)
            end
        end
    end
    -- 自身包引用个数递减
    uiReferenceCount[pkg.id] = uiReferenceCount[pkg.id] -1
    -- 检测引用个数
    if uiReferenceCount[pkg.id] <= 0 then
        uiReferenceCount[pkg.id] = 0

        -- 执行卸载
        if nil ~= UIPackage.GetById(pkg.id) then
            CS.LPCFramework.ResourceMgr.UnLoadUI(pkg.id, true)
        end
    end
end
-- 打开界面--
function UIManager.openController(name, data)
    facade:openController(name, data)
end
-- 移除界面--
function UIManager.removeController(name)
    facade:removeController(name)
end
-- 发送消息--
function UIManager.sendNtfMessage(ntfType, ...)
    facade:sendNtfMessage(ntfType, ...)
end
-- 注册界面--
function UIManager.registerController(windowInfo)
    facade:registerController(windowInfo)
end
-- 界面是否打开--
function UIManager.controllerIsOpen(name)
    local ctrl = facade:getController(name)
    if nil == ctrl then
        return false
    else
        return ctrl.IsOpen
    end
end
-- 界面进栈--
function UIManager.pushingStack(ctrl)
    facade:pushingStack(ctrl)
end
-- 界面出栈--
function UIManager.popingStack(ctrl)
    facade:popingStack(ctrl)
end

-- 显示tip--
-- <param name="msg" type="table">msg = { content = "" , result = true }</param>
-- msg.result 表示显示类型，true为成功，false为警示
-- msg.content 表示显示文本内容
function UIManager.showTip(msg)
    tips.show(msg)
end

-- 显示服务器错误提示
-- moduleId 模块id
-- functionId 功能id
-- errorId 错误id
function UIManager.showNetworkErrorTip(moduleId, functionId, errorId)
    local msg = { content = LocalizitionServerErrorResponse["Error" .. moduleId .. "_" .. functionId .. "_" .. errorId], result = false }
    tips.show(msg)
end

-- 显示服务器时间和ping值
function UIManager.initHelper()
    serverTime.init()
end

-- 显示服务器时间和ping值
function UIManager.showHelper(state)
    serverTime.show(state)
end

-- 生成界面--
-- <param name="path" type="string">路径</param>
-- <param name="fileName" type="string">文件名</param>
-- <param name="panelName" type="string">panel名</param>
-- <param name="isFull" type="boolean">全屏适应</param>
function UIManager.creatView(path, fileName, panelName, isFull)
    -- 引用计数递增
    local pkg = uiPkgReferenceAsc(path)

    -- 创建UI
    local ui = UIPackage.CreateObject(fileName, panelName)
    GRoot.inst:AddChild(ui)
    -- 批处理
    ui.fairyBatching = true
    -- 不可见
    ui.visible = false
    -- 设置全屏适应
    if isFull or nil == isFull then
        ui:MakeFullScreen()
    end

    return ui, pkg
end
-- 销毁界面--
-- <param name="pkg" type="uiPackage">UI包</param>
function UIManager.disposeView(pkg)
    if nil == pkg then
        return
    end
    -- 引用计数递减
    uiPkgReferenceDec(pkg)
end

-- 生成特效--
-- <param name="parent" type="gObject">父对象</param>
-- <param name="path" type="string">特效路径</param>
function UIManager.creatParticle(parent, path)
    local obj = nil
    local prefab = CS.LPCFramework.LogicUtils.LoadResource(path)
    if nil == prefab then
        return
    end
    prefab = CS.UnityEngine.Object.Instantiate(prefab)
    if nil == prefab then
        return
    end
    parent:SetNativeObject(GoWrapper(prefab))
end

-- 初始化--
function UIManager.initialize()
    -- 自适应
    GRoot.inst:SetContentScaleFactor(1920, 1080)
    -- UI公共库
    UIPackage.AddPackage("UI/Library/Library")
    -- 字体库
    -- FUIConfig.defaultFont = "Microsoft YaHei,Droid Sans Fallback,LTHYSZK,Helvetica-Bold,Helvetica-Bold"
    -- 默认按钮声音
    FUIConfig.buttonSound = UIPackage.GetItemAsset("Library", "Sound_Click")
    -- 注册字体 NotoSansHans-Regular
    FontManager.RegisterFont(FontManager.GetFont("Noto Sans S Chinese Regular"), "微软雅黑 Light")
    FontManager.RegisterFont(FontManager.GetFont("Noto Sans S Chinese Regular"), "微软雅黑")
    FontManager.RegisterFont(FontManager.GetFont("Noto Sans S Chinese Regular"), "方正黑体简体")
    FontManager.RegisterFont(FontManager.GetFont("Noto Sans S Chinese Regular"), "")
    FontManager.GetFont("Noto Sans S Chinese Regular").customBold = true

    -- 引用计数
    uiReferenceCount = { }
    -- 舞台事件处理
    stageEventHandle()
    -- 初始化服务器时间
    UIManager.initHelper()

    -- 打开面板
    UIManager.openController(UIManager.ControllerName.LoginMain)
end

-- 更新
function UIManager.update()
    facade:updateAllController()
end
-- 销毁
function UIManager.onDestroy()
    clickEffect:Dispose()
    tips.destroy()
    serverTime.destroy()
    facade:destroyAllController()
    Stage.inst:RemoveEventListeners()
end

return UIManager