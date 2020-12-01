-- *********************************************************************
-- 将魂信息
-- *********************************************************************

local CaptainSoulData = { }
-- 已解锁的全部将魂
CaptainSoulData.UnlockCaptainSouls = { }
-- 已领取奖励的全部羁绊
CaptainSoulData.CollectPrizeFetters = { }
-- 已激活的羁绊
CaptainSoulData.ActivatedFetters = { }

-- 更新方法
function CaptainSoulData:updateInfo(data)
    -- 已解锁
    if data.all_unlock_captain_souls ~= nil then
        for k, v in ipairs(data.all_unlock_captain_souls) do
            table.insert(CaptainSoulData.UnlockCaptainSouls, v)
        end
    end
    -- 已领取
    if data.all_collect_prize_fetters ~= nil then
        for k, v in ipairs(data.all_collect_prize_fetters) do
            table.insert(CaptainSoulData.CollectPrizeFetters, v)
        end
    end
    -- 已激活
    if data.all_activated_fetters ~= nil then
        for k, v in ipairs(data.all_activated_fetters) do
            table.insert(CaptainSoulData.ActivatedFetters, v)
        end
    end
end

function CaptainSoulData:clear()
    CaptainSoulData.UnlockCaptainSouls = { }
    CaptainSoulData.CollectPrizeFetters = { }
    CaptainSoulData.ActivatedFetters = { }
end


-- 武将附身成功
-- captain: int // 武将id
-- up_soul_id: int // 附身的将魂id(0表示将附身的将魂取下来了，非0表示附身了新的将魂，如果是非0且此前有附身的将魂的话，处理此前的将魂没有附身任何武将)
local function S2CCaptainAttachSoulSucc(data)
    DataTrunk.PlayerInfo.MilitaryAffairsData:updataCaptainSoul(data.captain, data.up_soul_id)
    Event.dispatch(Event.CAPTAIN_ATTACH_SOUL_SUCCESS, data)
end
captain_soul_decoder.RegisterAction(captain_soul_decoder.S2C_FU_SHEN, S2CCaptainAttachSoulSucc)

-- 武将附身失败
-- 使用元宝加转生经验失败
local function S2CFailCaptainRebirthYuanbao(data)
    UIManager.showNetworkErrorTip(captain_soul_decoder.ModuleID, captain_soul_decoder.S2C_FAIL_FU_SHEN, data)
end
captain_soul_decoder.RegisterAction(captain_soul_decoder.S2C_FAIL_FU_SHEN, S2CFailCaptainRebirthYuanbao)

-- 激活羁绊成功
-- id: int // 羁绊id
local function S2CActivateFetters(data)
    table.insert(CaptainSoulData.ActivatedFetters, data.id)
    Event.dispatch(Event.ACTIVATE_FETTER_SUCCESS, data)
end
captain_soul_decoder.RegisterAction(captain_soul_decoder.S2C_ACTIVATE_FETTERS, S2CActivateFetters)

-- 激活羁绊失败
local function S2CFailActivateFetters(data)
    UIManager.showNetworkErrorTip(captain_soul_decoder.ModuleID, captain_soul_decoder.S2C_FAIL_ACTIVATE_FETTERS, data)
end
captain_soul_decoder.RegisterAction(captain_soul_decoder.S2C_FAIL_ACTIVATE_FETTERS, S2CFailActivateFetters)

-- 领取奖励成功
-- id: int // 领取羁绊奖励成功
local function S2CCollectFettersPrize(data)
    table.insert(CaptainSoulData.CollectPrizeFetters, data.id)
    Event.dispatch(Event.COLLECT_FETTERS_PRIZE_SUCCESS, data)
end
captain_soul_decoder.RegisterAction(captain_soul_decoder.S2C_COLLECT_FETTERS_PRIZE, S2CCollectFettersPrize)

local function S2CFailCollectFettersPrize(data)
    UIManager.showNetworkErrorTip(captain_soul_decoder.ModuleID, captain_soul_decoder.S2C_FAIL_COLLECT_FETTERS_PRIZE, data)
end
captain_soul_decoder.RegisterAction(captain_soul_decoder.S2C_FAIL_COLLECT_FETTERS_PRIZE, S2CFailCollectFettersPrize)

return CaptainSoulData