local _C = UIManager.Controller(UIManager.ControllerName.ChangeName, UIManager.ViewName.ChangeName)
_C.IsPopupBox = true
local view = nil
local changeNameTimer = nil
-- 玩家数据
local playerData = DataTrunk.PlayerInfo.MonarchsData

local function ChangeBtnOnClick()
    local newName = view.InputName.text

    if not Utils.isSensitiveWordWithTips(newName) then
        if Utils.isLegalName(newName) then
            NetworkManager.C2SChangeHeroNameMsg(newName)
        end
    end
end

local function TimerStart()
    view.ChangeBtn.grayed = true
    view.ChangeBtn.touchable = false
    view.CDTimer.visible = true
end

local function TimerUpdate(t, p)
    view.CDTimer.text = Utils.secondConversion(math.ceil(p))
end

local function TimerComplete()
    view.ChangeBtn.grayed = false
    view.ChangeBtn.touchable = true
    view.CDTimer.visible = false
end

-- 改名成功
local function ChangeNameSuccess()
    if not _C.IsOpen then
        return
    end

    local time = playerData.NextChangeNameTime - TimerManager.currentTime

    if time >= 0 then
        changeNameTimer = TimerManager.newTimer(time, false, true, TimerStart, TimerUpdate, TimerComplete)
        changeNameTimer:start()
    end

    _C:close()
end

-- 改名列表
function _C:onOpen(heroOldNameText)
    -- 如果是第一次显示首次免费
    if heroOldNameText == "" then
        view.CostText.text = Localization.LordsFirstTimeForFree
    else
        view.CostText.text = string.format(Localization.ChangeNameCost, MiscCommonConfig.Config.ChangeHeroNameCost.YuanBao)
    end

    local time = playerData.NextChangeNameTime - TimerManager.currentTime

    if time >= 0 then
        changeNameTimer = TimerManager.newTimer(time, false, true, TimerStart, TimerUpdate, TimerComplete)
        changeNameTimer:start()
    end
end

function _C:onCreat()
    view = _C.View
    view.BG.onClick:Set( function() _C:close() end)
    view.ChangeBtn.onClick:Set(ChangeBtnOnClick)
    view.InputName.text = ""
    -- 临时
    view.CDTimer.visible = false

    Event.addListener(Event.CHANGE_NAME_SUCCESS, ChangeNameSuccess)
end

function _C:onDestroy()
    TimerManager.disposeTimer(changeNameTimer)
    changeNameTimer = nil
    Event.removeListener(Event.CHANGE_NAME_SUCCESS, ChangeNameSuccess)
end