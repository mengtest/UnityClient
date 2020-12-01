local _C = UIManager.Controller(UIManager.ControllerName.AllianceDemiseDetailsWindow, UIManager.ViewName.AllianceDemiseDetailsWindow)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil
-- 我的数据
local myData = nil
-- 禅让计时器
local timer = nil
-- 禅让玩家名字
local demisePlayerName = ""

-- 点击关闭/确认按钮
local function CloseBtnOnClick()
    _C:destroy()
end

-- 点击中止按钮
local function CancelBtnOnClick()
    NetworkManager.C2SCancelChangeLeaderProto()
end

local function TimerUpdate(t, p)
    -- 盟主名,时间,玩家名(暂无)
    view.ContentText.text = string.format(Localization.AllianceDemiseCD, allianceData.Leader.Hero.Name, Utils.secondConversion(math.ceil(p)), demisePlayerName)
end

function _C:onCreat()
    view = _C.View
    view.BG.onClick:Set(CloseBtnOnClick)
    view.CloseBtn.onClick:Set(CloseBtnOnClick)
    view.CancelBtn.onClick:Set(CancelBtnOnClick)
    view.ConfirmBtn.onClick:Set(CloseBtnOnClick)
    Event.addListener(Event.ALLIANCE_CANCEL_DEMISE_SUCCESS, CloseBtnOnClick)
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData.MyAlliance
    myData = DataTrunk.PlayerInfo.AllianceData.MyData

    -- 判断是不是盟主(0:其他人 1:盟主)
    if myData == allianceData.Leader then
        view.Type_C.selectedIndex = 1
    else
        view.Type_C.selectedIndex = 0
    end

    -- 禅让玩家名(这里肯定不是盟主,就不去遍历自己构造的list了)
    for k, v in pairs(allianceData.Members) do
        if v.Hero.Id == allianceData.ChangeLeaderId then
            demisePlayerName = v.Hero.Name
            break
        end
    end

    -- cd
    local cd = allianceData.ChangeLeaderTime - TimerManager.currentTime
    timer = TimerManager.newTimer(cd, false, true, nil, TimerUpdate, CloseBtnOnClick)
    timer:addCd(cd - timer.MaxCd)
    timer:reset()
    timer:start()
end

function _C:onDestroy()
    TimerManager.disposeTimer(timer)
    timer = nil
    Event.removeListener(Event.ALLIANCE_CANCEL_DEMISE_SUCCESS, CloseBtnOnClick)
end
