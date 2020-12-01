local _C = UIManager.Controller(UIManager.ControllerName.Pvp100Matching, UIManager.ViewName.Pvp100Matching)
local _CTroop = require(UIManager.ControllerName.TroopsSelect)
local _CRankingList = require(UIManager.ControllerName.Pvp100RankingList)
table.insert(_C.SubCtrl, _CTroop)
table.insert(_C.SubCtrl, _CRankingList)

local view = nil
-- 玩家数据
local pvp100Data = DataTrunk.PlayerInfo.Pvp100Data

-- 返回
local function btnBack()
    -- 保存更改
    _CTroop:c2sTroopsSync( function() _C:close() end)
end
-- 布阵
local function btnToEmbattle()
    _CTroop:c2sTroopsSync( function()
        -- 打开布阵
        UIManager.openController(UIManager.ControllerName.TroopsEmbattle)
    end )
end
-- 挑战
local function btnToChallenge()
    local doChallenge = function()
        -- 获取阵上武将
        local count, captainId = _CTroop:getCurTroopCaptains_2()
        -- 武将个数判断
        if count == 0 then
            UIManager.showTip( { content = Localization.TroopCaptainNum_1, result = false })
            return
        end
        -- 请求挑战
        NetworkManager.C2SBaiZhanChallengeProto(captainId)
    end
    -- 保存更改
    _CTroop:c2sTroopsSync(doChallenge)
end

-- 刷新面板
local function updatePanelInfo()
    view.WinPoint.text = Pvp100CommonConfig.Config.WinPoint
    view.FailPoint.text = Pvp100CommonConfig.Config.FailPoint

    local rankConfig = Pvp100RankLevelConfig:getConfigByLevel(pvp100Data.RankLv)
    view.RankIcon.url = rankConfig.Icon
end

-- 挑战回复
local function onChallengeAck()
    UIManager.openController(UIManager.ControllerName.Pvp100VsShow)
end

function _C:onCreat()
    view = _C.View
    _CRankingList.view = _C.View

    view.BtnBack.onClick:Add(btnBack)
    view.BtnEmbattle.onClick:Add(btnToEmbattle)
    view.BtnStart.onClick:Add(btnToChallenge)

    Event.addListener(Event.PVP100_CHALLENGE_ACK, onChallengeAck)
end

function _C:onOpen(data)
    updatePanelInfo()
end

function _C:onShow()
    -- 0进入布阵
    _CTroop:clear()
    _CTroop.fightAmountShowType = 1
    _CTroop:setParent(view.AttackTroopSlot)
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnEmbattle.onClick:Clear()
    view.BtnStart.onClick:Clear()

    Event.removeListener(Event.PVP100_CHALLENGE_ACK, onChallengeAck)
end
