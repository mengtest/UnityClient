---------------------------------------------------------------
--- 战斗信息----------------------------------------------------
---------------------------------------------------------------
-- 战斗信息--
local BattleData = { }
BattleData.BattleHistoricalInfo = { }

-- 清除--
function BattleData:clear()
    self.BattleHistoricalInfo = { }
end

-- 更新战斗信息--
function BattleData:updateBattleReplayInfo(data)
    local newBattle = BattleReplayInfo()
    newBattle:updateInfo(data)
    table.insert(self.BattleHistoricalInfo, 1, newBattle)

    -- 战斗回放--
    Event.dispatch(Event.BATTLE_REPLAY_ACK)
end

-- 战斗回放--moduleId = 4, msgId = 13
-- bytes replay = 1; // battle.BattleReplayProto
local function S2CFightProto(data)
    local battle = shared_pb.CombatProto()
    battle:ParseFromString(data.replay)

    local newBattle = BattleReplayInfo()
    newBattle:updateInfo(battle)

    LevelManager.loadScene(newBattle.MapRes, newBattle)
end
military_decoder.RegisterAction(military_decoder.S2C_FIGHT, S2CFightProto)

-- 多人战斗回放--moduleId = 4, msgId = 102
-- bytes replay = 1; // battle.MultiCombatProto
local function S2CMultiFightProto(data)
    local battle = shared_pb.MultiCombatProto()
    battle:ParseFromString(data.replay)

    local newBattle = MultiBattleReplayInfo()
    newBattle:updateInfo(battle)

    LevelManager.loadScene(newBattle.MapRes, newBattle)
end
military_decoder.RegisterAction(military_decoder.S2C_MULTI_FIGHT, S2CMultiFightProto)

return BattleData