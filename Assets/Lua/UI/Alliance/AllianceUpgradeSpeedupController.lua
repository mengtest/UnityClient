local _C = UIManager.Controller(UIManager.ControllerName.AllianceUpgradeSpeedup, UIManager.ViewName.AllianceUpgradeSpeedup)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil
-- 我的数据
local myData = nil
-- 加速最大次数
local maxTimes = 2
-- 加速消耗贡献值
local cost = 2000
-- 加速秒数
local second = 54841

-- 点击关闭按钮
local function CloseBtnOnClick()
    _C:destroy()
end

-- 点击确认按钮
local function ConfirmBtnOnClick()
    -- 发消息

    CloseBtnOnClick()
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set(CloseBtnOnClick)
    view.CloseBtn.onClick:Set(CloseBtnOnClick)
    view.ConfirmBtn.onClick:Set(ConfirmBtnOnClick)
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData.MyAlliance
    myData = DataTrunk.PlayerInfo.AllianceData.MyData
    view.SpeedupTimesText.text = string.format("%d/%d", allianceData.CdrTimes, maxTimes)
    view.CostText.text = string.format("%d/%d", cost, myData.ContributionTotalAmount)
    view.TimeText.text = math.floor(second / 60) .. Localization.Minute

    -- 0:足够 1:不足
    if cost > myData.ContributionTotalAmount then
        view.State_C.selectedIndex = 1
        view.ConfirmBtn.grayed = true
        view.ConfirmBtn.touchable = not view.ConfirmBtn.grayed
    else
        view.State_C.selectedIndex = 0
        view.ConfirmBtn.grayed = false
        view.ConfirmBtn.touchable = not view.ConfirmBtn.grayed
    end
end

function _C:onDestroy()

end