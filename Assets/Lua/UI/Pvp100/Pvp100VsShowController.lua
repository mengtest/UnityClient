local _C = UIManager.Controller(UIManager.ControllerName.Pvp100VsShow, UIManager.ViewName.Pvp100VsShow)
local view = nil

-- 玩家数据
local pvp100Data = DataTrunk.PlayerInfo.Pvp100Data
-- 刷新计时器
local refreshTimer = nil

function _C:onCreat()
    view = _C.View

    refreshTimer = TimerManager.newTimer(2, false, true, nil, nil,
    function()
        -- 打开战斗
        LevelManager.loadScene(pvp100Data.ChallengeReplay.MapRes, pvp100Data.ChallengeReplay)
        _C:close()
    end ,
    nil)
end

function _C:onOpen(data)
    refreshTimer:start()
end

function _C:onDestroy()
    TimerManager.disposeTimer(refreshTimer)
end
