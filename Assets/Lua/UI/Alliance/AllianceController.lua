local _C = UIManager.Controller(UIManager.ControllerName.Alliance, UIManager.ViewName.Alliance)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
local _CHomePage = require(UIManager.ControllerName.AllianceHomePage)
local _CContribution = require(UIManager.ControllerName.AllianceContribution)
local _CManage = require(UIManager.ControllerName.AllianceManage)

-- local _CTalents = require(UIManager.ControllerName.AllianceTalents)
-- local _CTech = require(UIManager.ControllerName.AllianceTech)
local _CShop = require(UIManager.ControllerName.AllianceShop)
local _CSilver = require(UIManager.ControllerName.AllianceSilver)
-- local _CBase = require(UIManager.ControllerName.AllianceBase)
-- local _CCity = require(UIManager.ControllerName.AllianceCity)

table.insert(_C.SubCtrl, _CchatBrief)
table.insert(_C.SubCtrl, _CHomePage)
table.insert(_C.SubCtrl, _CContribution)
table.insert(_C.SubCtrl, _CManage)
-- table.insert(_C.SubCtrl, _CTalents)
-- table.insert(_C.SubCtrl, _CTech)
table.insert(_C.SubCtrl, _CShop)
table.insert(_C.SubCtrl, _CSilver)
-- table.insert(_C.SubCtrl, _CBase)
-- table.insert(_C.SubCtrl, _CCity)

local view = nil
-- 数据请求计时器
local dataTimer = nil
-- 数据请求间隔(秒)
local interval = 5

local function BackBtnOnClick()
    _C:close()
end

-- 请求我的联盟信息
local function OnRequestMyAllianceData()
    NetworkManager.C2SGetSelfGuildProto(DataTrunk.PlayerInfo.AllianceData.Version)
end

-- 刷新UI
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    _CHomePage.RefreshUI()
    _CContribution.RefreshUI()
    _CManage.RefreshUI()
    _CShop.RefreshUI()
    _CSilver.RefreshUI()
end

-- 退出联盟成功
local function PullOutOfTheAllianceSuccess()
    _C:destroy(true)
end

function _C:onCreat()
    view = _C.View
    _CchatBrief.view = view
    _CHomePage.view = view
    _CContribution.view = view
    _CManage.view = view
    --    _CTalents.view = view
    --    _CTech.view = view
    _CShop.view = view
    _CSilver.view = view
    --    _CBase.view = view
    --    _CCity.view = view
    dataTimer = TimerManager.newTimer(interval, true, true, nil, nil, OnRequestMyAllianceData)
    view.BackBtn.onClick:Set(BackBtnOnClick)

    DataTrunk.PlayerInfo.AllianceData.Version = 0
    OnRequestMyAllianceData()

    Event.addListener(Event.REQ_MY_GUILD_DATA_SUCCESS, RefreshUI)
    Event.addListener(Event.ON_LEAVE_GUILD, PullOutOfTheAllianceSuccess)
end

function _C:onOpen()
    dataTimer:start()
end

function _C:onClose()
    dataTimer:pause()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    TimerManager.disposeTimer(dataTimer)
    dataTimer = nil
    Event.removeListener(Event.REQ_MY_GUILD_DATA_SUCCESS, RefreshUI)
    Event.removeListener(Event.ON_LEAVE_GUILD, PullOutOfTheAllianceSuccess)
end