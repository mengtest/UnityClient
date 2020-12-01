

require "autogen.military_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 4
military_decoder = {}
military_decoder.ModuleID = ModuleID
military_decoder.ModuleName = "military"

local decoder = {}
local handler = {}

military_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local s2c_update_soldier_capcity = 1
military_decoder.S2C_UPDATE_SOLDIER_CAPCITY = 1
local s2c_update_soldier_capcity_pb
decoder[1] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_soldier_capcity_pb or military_pb.S2CUpdateSoldierCapcityProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_recruit_soldier = 2
local c2s_recruit_soldier_pb


military_decoder.NewC2sRecruitSoldierMsg = function(count)



    if not c2s_recruit_soldier_pb then c2s_recruit_soldier_pb = military_pb.C2SRecruitSoldierProto() end

    
    c2s_recruit_soldier_pb.count = count
    buffer[4] = char(4)
    buffer[5] = char(2)


    move_offset(5)
    c2s_recruit_soldier_pb:_InternalSerialize(write_to_buffer)
    c2s_recruit_soldier_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_recruit_soldier = 3
military_decoder.S2C_RECRUIT_SOLDIER = 3
local s2c_recruit_soldier_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_recruit_soldier_pb or military_pb.S2CRecruitSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_recruit_soldier = 4
military_decoder.S2C_FAIL_RECRUIT_SOLDIER = 4
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_add_wounded_soldier = 5
military_decoder.S2C_ADD_WOUNDED_SOLDIER = 5
local s2c_add_wounded_soldier_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_add_wounded_soldier_pb or military_pb.S2CAddWoundedSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_heal_wounded_soldier = 6
local c2s_heal_wounded_soldier_pb


military_decoder.NewC2sHealWoundedSoldierMsg = function(count)



    if not c2s_heal_wounded_soldier_pb then c2s_heal_wounded_soldier_pb = military_pb.C2SHealWoundedSoldierProto() end

    
    c2s_heal_wounded_soldier_pb.count = count
    buffer[4] = char(4)
    buffer[5] = char(6)


    move_offset(5)
    c2s_heal_wounded_soldier_pb:_InternalSerialize(write_to_buffer)
    c2s_heal_wounded_soldier_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_heal_wounded_soldier = 7
military_decoder.S2C_HEAL_WOUNDED_SOLDIER = 7
local s2c_heal_wounded_soldier_pb
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_heal_wounded_soldier_pb or military_pb.S2CHealWoundedSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_heal_wounded_soldier = 8
military_decoder.S2C_FAIL_HEAL_WOUNDED_SOLDIER = 8
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_captain_change_soldier = 9
local c2s_captain_change_soldier_pb


military_decoder.NewC2sCaptainChangeSoldierMsg = function(id, count)



    if not c2s_captain_change_soldier_pb then c2s_captain_change_soldier_pb = military_pb.C2SCaptainChangeSoldierProto() end

    
    c2s_captain_change_soldier_pb.id = id
    c2s_captain_change_soldier_pb.count = count
    buffer[4] = char(4)
    buffer[5] = char(9)


    move_offset(5)
    c2s_captain_change_soldier_pb:_InternalSerialize(write_to_buffer)
    c2s_captain_change_soldier_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_captain_change_soldier = 10
military_decoder.S2C_CAPTAIN_CHANGE_SOLDIER = 10
local s2c_captain_change_soldier_pb
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_change_soldier_pb or military_pb.S2CCaptainChangeSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_captain_change_soldier = 14
military_decoder.S2C_FAIL_CAPTAIN_CHANGE_SOLDIER = 14
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_captain_full_soldier = 66
local c2s_captain_full_soldier_pb


military_decoder.NewC2sCaptainFullSoldierMsg = function(id)



    if not c2s_captain_full_soldier_pb then c2s_captain_full_soldier_pb = military_pb.C2SCaptainFullSoldierProto() end

    
    for k,v in pairs(id) do table.insert(c2s_captain_full_soldier_pb.id,v) end
    buffer[4] = char(4)
    buffer[5] = char(66)


    move_offset(5)
    c2s_captain_full_soldier_pb:_InternalSerialize(write_to_buffer)
    c2s_captain_full_soldier_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_captain_full_soldier = 67
military_decoder.S2C_CAPTAIN_FULL_SOLDIER = 67
local s2c_captain_full_soldier_pb
decoder[67] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_full_soldier_pb or military_pb.S2CCaptainFullSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_captain_full_soldier = 68
military_decoder.S2C_FAIL_CAPTAIN_FULL_SOLDIER = 68
decoder[68] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_free_soldier = 80
military_decoder.S2C_UPDATE_FREE_SOLDIER = 80
local s2c_update_free_soldier_pb
decoder[80] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_free_soldier_pb or military_pb.S2CUpdateFreeSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_captain_change_data = 11
military_decoder.S2C_CAPTAIN_CHANGE_DATA = 11
local s2c_captain_change_data_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_change_data_pb or military_pb.S2CCaptainChangeDataProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_fight = 12
local c2s_fight_pb

military_decoder.C2S_FIGHT = function()
	if c2s_fight_pb then return c2s_fight_pb end
    buffer[4] = char(4)
    buffer[5] = char(12)
    c2s_fight_pb = concat(buffer, '', 1, 5)    return c2s_fight_pb
end

-- local s2c_fight = 13
military_decoder.S2C_FIGHT = 13
local s2c_fight_pb
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fight_pb or military_pb.S2CFightProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_multi_fight = 101
local c2s_multi_fight_pb

military_decoder.C2S_MULTI_FIGHT = function()
	if c2s_multi_fight_pb then return c2s_multi_fight_pb end
    buffer[4] = char(4)
    buffer[5] = char(101)
    c2s_multi_fight_pb = concat(buffer, '', 1, 5)    return c2s_multi_fight_pb
end

-- local s2c_multi_fight = 102
military_decoder.S2C_MULTI_FIGHT = 102
local s2c_multi_fight_pb
decoder[102] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_multi_fight_pb or military_pb.S2CMultiFightProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_upgrade_soldier_level = 15
local c2s_upgrade_soldier_level_pb

military_decoder.C2S_UPGRADE_SOLDIER_LEVEL = function()
	if c2s_upgrade_soldier_level_pb then return c2s_upgrade_soldier_level_pb end
    buffer[4] = char(4)
    buffer[5] = char(15)
    c2s_upgrade_soldier_level_pb = concat(buffer, '', 1, 5)    return c2s_upgrade_soldier_level_pb
end

-- local s2c_upgrade_soldier_level = 16
military_decoder.S2C_UPGRADE_SOLDIER_LEVEL = 16
local s2c_upgrade_soldier_level_pb
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_upgrade_soldier_level_pb or military_pb.S2CUpgradeSoldierLevelProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_upgrade_soldier_level = 17
military_decoder.S2C_FAIL_UPGRADE_SOLDIER_LEVEL = 17
decoder[17] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_seek_captain = 20
local c2s_seek_captain_pb

military_decoder.C2S_SEEK_CAPTAIN = function()
	if c2s_seek_captain_pb then return c2s_seek_captain_pb end
    buffer[4] = char(4)
    buffer[5] = char(20)
    c2s_seek_captain_pb = concat(buffer, '', 1, 5)    return c2s_seek_captain_pb
end

-- local s2c_seek_captain = 21
military_decoder.S2C_SEEK_CAPTAIN = 21
local s2c_seek_captain_pb
decoder[21] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_seek_captain_pb or military_pb.S2CSeekCaptainProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_seek_captain = 33
military_decoder.S2C_FAIL_SEEK_CAPTAIN = 33
decoder[33] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_recruit_captain = 22
local c2s_recruit_captain_pb


military_decoder.NewC2sRecruitCaptainMsg = function(index)



    if not c2s_recruit_captain_pb then c2s_recruit_captain_pb = military_pb.C2SRecruitCaptainProto() end

    
    c2s_recruit_captain_pb.index = index
    buffer[4] = char(4)
    buffer[5] = char(22)


    move_offset(5)
    c2s_recruit_captain_pb:_InternalSerialize(write_to_buffer)
    c2s_recruit_captain_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_recruit_captain = 23
military_decoder.S2C_RECRUIT_CAPTAIN = 23
local s2c_recruit_captain_pb
decoder[23] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_recruit_captain_pb or military_pb.S2CRecruitCaptainProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_recruit_captain = 36
military_decoder.S2C_FAIL_RECRUIT_CAPTAIN = 36
decoder[36] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_set_defense_troop = 106
local c2s_set_defense_troop_pb


military_decoder.NewC2sSetDefenseTroopMsg = function(is_tent, troop_index)



    if not c2s_set_defense_troop_pb then c2s_set_defense_troop_pb = military_pb.C2SSetDefenseTroopProto() end

    
    c2s_set_defense_troop_pb.is_tent = is_tent
    c2s_set_defense_troop_pb.troop_index = troop_index
    buffer[4] = char(4)
    buffer[5] = char(106)


    move_offset(5)
    c2s_set_defense_troop_pb:_InternalSerialize(write_to_buffer)
    c2s_set_defense_troop_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_set_defense_troop = 107
military_decoder.S2C_SET_DEFENSE_TROOP = 107
local s2c_set_defense_troop_pb
decoder[107] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_set_defense_troop_pb or military_pb.S2CSetDefenseTroopProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_set_defense_troop = 108
military_decoder.S2C_FAIL_SET_DEFENSE_TROOP = 108
decoder[108] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_sell_seek_captain = 34
local c2s_sell_seek_captain_pb


military_decoder.NewC2sSellSeekCaptainMsg = function(index)



    if not c2s_sell_seek_captain_pb then c2s_sell_seek_captain_pb = military_pb.C2SSellSeekCaptainProto() end

    
    c2s_sell_seek_captain_pb.index = index
    buffer[4] = char(4)
    buffer[5] = char(34)


    move_offset(5)
    c2s_sell_seek_captain_pb:_InternalSerialize(write_to_buffer)
    c2s_sell_seek_captain_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_sell_seek_captain = 35
military_decoder.S2C_SELL_SEEK_CAPTAIN = 35
local s2c_sell_seek_captain_pb
decoder[35] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_sell_seek_captain_pb or military_pb.S2CSellSeekCaptainProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_sell_seek_captain = 37
military_decoder.S2C_FAIL_SELL_SEEK_CAPTAIN = 37
decoder[37] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_set_multi_captain_index = 45
local c2s_set_multi_captain_index_pb


military_decoder.NewC2sSetMultiCaptainIndexMsg = function(index, id)



    if not c2s_set_multi_captain_index_pb then c2s_set_multi_captain_index_pb = military_pb.C2SSetMultiCaptainIndexProto() end

    
    c2s_set_multi_captain_index_pb.index = index
    for k,v in pairs(id) do table.insert(c2s_set_multi_captain_index_pb.id,v) end
    buffer[4] = char(4)
    buffer[5] = char(45)


    move_offset(5)
    c2s_set_multi_captain_index_pb:_InternalSerialize(write_to_buffer)
    c2s_set_multi_captain_index_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_set_multi_captain_index = 46
military_decoder.S2C_SET_MULTI_CAPTAIN_INDEX = 46
local s2c_set_multi_captain_index_pb
decoder[46] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_set_multi_captain_index_pb or military_pb.S2CSetMultiCaptainIndexProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_set_multi_captain_index = 47
military_decoder.S2C_FAIL_SET_MULTI_CAPTAIN_INDEX = 47
decoder[47] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_fire_captain = 38
local c2s_fire_captain_pb


military_decoder.NewC2sFireCaptainMsg = function(id)



    if not c2s_fire_captain_pb then c2s_fire_captain_pb = military_pb.C2SFireCaptainProto() end

    
    c2s_fire_captain_pb.id = id
    buffer[4] = char(4)
    buffer[5] = char(38)


    move_offset(5)
    c2s_fire_captain_pb:_InternalSerialize(write_to_buffer)
    c2s_fire_captain_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_fire_captain = 39
military_decoder.S2C_FIRE_CAPTAIN = 39
local s2c_fire_captain_pb
decoder[39] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fire_captain_pb or military_pb.S2CFireCaptainProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_fire_captain = 40
military_decoder.S2C_FAIL_FIRE_CAPTAIN = 40
decoder[40] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_captain_refined = 48
local c2s_captain_refined_pb


military_decoder.NewC2sCaptainRefinedMsg = function(captain, goods_id, count)



    if not c2s_captain_refined_pb then c2s_captain_refined_pb = military_pb.C2SCaptainRefinedProto() end

    
    c2s_captain_refined_pb.captain = captain
    for k,v in pairs(goods_id) do table.insert(c2s_captain_refined_pb.goods_id,v) end
    for k,v in pairs(count) do table.insert(c2s_captain_refined_pb.count,v) end
    buffer[4] = char(4)
    buffer[5] = char(48)


    move_offset(5)
    c2s_captain_refined_pb:_InternalSerialize(write_to_buffer)
    c2s_captain_refined_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_captain_refined = 49
military_decoder.S2C_CAPTAIN_REFINED = 49
local s2c_captain_refined_pb
decoder[49] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_refined_pb or military_pb.S2CCaptainRefinedProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_captain_refined = 50
military_decoder.S2C_FAIL_CAPTAIN_REFINED = 50
decoder[50] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_captain_refined_upgrade = 51
military_decoder.S2C_CAPTAIN_REFINED_UPGRADE = 51
local s2c_captain_refined_upgrade_pb
decoder[51] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_refined_upgrade_pb or military_pb.S2CCaptainRefinedUpgradeProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_update_captain_exp = 52
military_decoder.S2C_UPDATE_CAPTAIN_EXP = 52
local s2c_update_captain_exp_pb
decoder[52] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_captain_exp_pb or military_pb.S2CUpdateCaptainExpProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_update_captain_level = 53
military_decoder.S2C_UPDATE_CAPTAIN_LEVEL = 53
local s2c_update_captain_level_pb
decoder[53] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_captain_level_pb or military_pb.S2CUpdateCaptainLevelProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_update_captain_stat = 69
military_decoder.S2C_UPDATE_CAPTAIN_STAT = 69
local s2c_update_captain_stat_pb
decoder[69] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_captain_stat_pb or military_pb.S2CUpdateCaptainStatProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_change_captain_name = 82
local c2s_change_captain_name_pb


military_decoder.NewC2sChangeCaptainNameMsg = function(id, name)



    if not c2s_change_captain_name_pb then c2s_change_captain_name_pb = military_pb.C2SChangeCaptainNameProto() end

    
    c2s_change_captain_name_pb.id = id
    c2s_change_captain_name_pb.name = name
    buffer[4] = char(4)
    buffer[5] = char(82)


    move_offset(5)
    c2s_change_captain_name_pb:_InternalSerialize(write_to_buffer)
    c2s_change_captain_name_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_change_captain_name = 83
military_decoder.S2C_CHANGE_CAPTAIN_NAME = 83
local s2c_change_captain_name_pb
decoder[83] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_change_captain_name_pb or military_pb.S2CChangeCaptainNameProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_change_captain_name = 84
military_decoder.S2C_FAIL_CHANGE_CAPTAIN_NAME = 84
decoder[84] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_change_captain_race = 85
local c2s_change_captain_race_pb


military_decoder.NewC2sChangeCaptainRaceMsg = function(id, race, yuanbao)



    if not c2s_change_captain_race_pb then c2s_change_captain_race_pb = military_pb.C2SChangeCaptainRaceProto() end

    
    c2s_change_captain_race_pb.id = id
    c2s_change_captain_race_pb.race = race
    c2s_change_captain_race_pb.yuanbao = yuanbao
    buffer[4] = char(4)
    buffer[5] = char(85)


    move_offset(5)
    c2s_change_captain_race_pb:_InternalSerialize(write_to_buffer)
    c2s_change_captain_race_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_change_captain_race = 86
military_decoder.S2C_CHANGE_CAPTAIN_RACE = 86
local s2c_change_captain_race_pb
decoder[86] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_change_captain_race_pb or military_pb.S2CChangeCaptainRaceProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_change_captain_race = 87
military_decoder.S2C_FAIL_CHANGE_CAPTAIN_RACE = 87
decoder[87] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_captain_rebirth_preview = 89
local c2s_captain_rebirth_preview_pb


military_decoder.NewC2sCaptainRebirthPreviewMsg = function(id)



    if not c2s_captain_rebirth_preview_pb then c2s_captain_rebirth_preview_pb = military_pb.C2SCaptainRebirthPreviewProto() end

    
    c2s_captain_rebirth_preview_pb.id = id
    buffer[4] = char(4)
    buffer[5] = char(89)


    move_offset(5)
    c2s_captain_rebirth_preview_pb:_InternalSerialize(write_to_buffer)
    c2s_captain_rebirth_preview_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_captain_rebirth_preview = 90
military_decoder.S2C_CAPTAIN_REBIRTH_PREVIEW = 90
local s2c_captain_rebirth_preview_pb
decoder[90] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_rebirth_preview_pb or military_pb.S2CCaptainRebirthPreviewProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_captain_rebirth_preview = 91
military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_PREVIEW = 91
decoder[91] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_captain_rebirth = 92
local c2s_captain_rebirth_pb


military_decoder.NewC2sCaptainRebirthMsg = function(id)



    if not c2s_captain_rebirth_pb then c2s_captain_rebirth_pb = military_pb.C2SCaptainRebirthProto() end

    
    c2s_captain_rebirth_pb.id = id
    buffer[4] = char(4)
    buffer[5] = char(92)


    move_offset(5)
    c2s_captain_rebirth_pb:_InternalSerialize(write_to_buffer)
    c2s_captain_rebirth_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_captain_rebirth = 93
military_decoder.S2C_CAPTAIN_REBIRTH = 93
local s2c_captain_rebirth_pb
decoder[93] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_rebirth_pb or military_pb.S2CCaptainRebirthProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_captain_rebirth = 94
military_decoder.S2C_FAIL_CAPTAIN_REBIRTH = 94
decoder[94] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_captain_rebirth_goods = 95
local c2s_captain_rebirth_goods_pb


military_decoder.NewC2sCaptainRebirthGoodsMsg = function(id, goods, count)



    if not c2s_captain_rebirth_goods_pb then c2s_captain_rebirth_goods_pb = military_pb.C2SCaptainRebirthGoodsProto() end

    
    c2s_captain_rebirth_goods_pb.id = id
    c2s_captain_rebirth_goods_pb.goods = goods
    c2s_captain_rebirth_goods_pb.count = count
    buffer[4] = char(4)
    buffer[5] = char(95)


    move_offset(5)
    c2s_captain_rebirth_goods_pb:_InternalSerialize(write_to_buffer)
    c2s_captain_rebirth_goods_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_captain_rebirth_goods = 96
military_decoder.S2C_CAPTAIN_REBIRTH_GOODS = 96
local s2c_captain_rebirth_goods_pb
decoder[96] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_rebirth_goods_pb or military_pb.S2CCaptainRebirthGoodsProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_captain_rebirth_goods = 97
military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_GOODS = 97
decoder[97] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_captain_rebirth_yuanbao = 98
local c2s_captain_rebirth_yuanbao_pb


military_decoder.NewC2sCaptainRebirthYuanbaoMsg = function(id)



    if not c2s_captain_rebirth_yuanbao_pb then c2s_captain_rebirth_yuanbao_pb = military_pb.C2SCaptainRebirthYuanbaoProto() end

    
    c2s_captain_rebirth_yuanbao_pb.id = id
    buffer[4] = char(4)
    buffer[5] = char(98)


    move_offset(5)
    c2s_captain_rebirth_yuanbao_pb:_InternalSerialize(write_to_buffer)
    c2s_captain_rebirth_yuanbao_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_captain_rebirth_yuanbao = 99
military_decoder.S2C_CAPTAIN_REBIRTH_YUANBAO = 99
local s2c_captain_rebirth_yuanbao_pb
decoder[99] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_captain_rebirth_yuanbao_pb or military_pb.S2CCaptainRebirthYuanbaoProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_captain_rebirth_yuanbao = 100
military_decoder.S2C_FAIL_CAPTAIN_REBIRTH_YUANBAO = 100
decoder[100] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_captain_rebirth_exp = 88
military_decoder.S2C_UPDATE_CAPTAIN_REBIRTH_EXP = 88
local s2c_update_captain_rebirth_exp_pb
decoder[88] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_captain_rebirth_exp_pb or military_pb.S2CUpdateCaptainRebirthExpProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_set_training_captain = 57
local c2s_set_training_captain_pb


military_decoder.NewC2sSetTrainingCaptainMsg = function(index, captain)



    if not c2s_set_training_captain_pb then c2s_set_training_captain_pb = military_pb.C2SSetTrainingCaptainProto() end

    
    c2s_set_training_captain_pb.index = index
    c2s_set_training_captain_pb.captain = captain
    buffer[4] = char(4)
    buffer[5] = char(57)


    move_offset(5)
    c2s_set_training_captain_pb:_InternalSerialize(write_to_buffer)
    c2s_set_training_captain_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_set_training_captain = 58
military_decoder.S2C_SET_TRAINING_CAPTAIN = 58
local s2c_set_training_captain_pb
decoder[58] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_set_training_captain_pb or military_pb.S2CSetTrainingCaptainProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_set_training_captain = 59
military_decoder.S2C_FAIL_SET_TRAINING_CAPTAIN = 59
decoder[59] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_swap_training_captain = 60
local c2s_swap_training_captain_pb


military_decoder.NewC2sSwapTrainingCaptainMsg = function(index, swap)



    if not c2s_swap_training_captain_pb then c2s_swap_training_captain_pb = military_pb.C2SSwapTrainingCaptainProto() end

    
    c2s_swap_training_captain_pb.index = index
    c2s_swap_training_captain_pb.swap = swap
    buffer[4] = char(4)
    buffer[5] = char(60)


    move_offset(5)
    c2s_swap_training_captain_pb:_InternalSerialize(write_to_buffer)
    c2s_swap_training_captain_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_swap_training_captain = 61
military_decoder.S2C_SWAP_TRAINING_CAPTAIN = 61
local s2c_swap_training_captain_pb
decoder[61] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_swap_training_captain_pb or military_pb.S2CSwapTrainingCaptainProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_swap_training_captain = 65
military_decoder.S2C_FAIL_SWAP_TRAINING_CAPTAIN = 65
decoder[65] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_collect_training_exp = 62
local c2s_collect_training_exp_pb


military_decoder.NewC2sCollectTrainingExpMsg = function(index)



    if not c2s_collect_training_exp_pb then c2s_collect_training_exp_pb = military_pb.C2SCollectTrainingExpProto() end

    
    c2s_collect_training_exp_pb.index = index
    buffer[4] = char(4)
    buffer[5] = char(62)


    move_offset(5)
    c2s_collect_training_exp_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_training_exp_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_training_exp = 63
military_decoder.S2C_COLLECT_TRAINING_EXP = 63
local s2c_collect_training_exp_pb
decoder[63] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_training_exp_pb or military_pb.S2CCollectTrainingExpProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_collect_training_exp = 64
military_decoder.S2C_FAIL_COLLECT_TRAINING_EXP = 64
decoder[64] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade_training = 54
local c2s_upgrade_training_pb


military_decoder.NewC2sUpgradeTrainingMsg = function(index, level)



    if not c2s_upgrade_training_pb then c2s_upgrade_training_pb = military_pb.C2SUpgradeTrainingProto() end

    
    c2s_upgrade_training_pb.index = index
    c2s_upgrade_training_pb.level = level
    buffer[4] = char(4)
    buffer[5] = char(54)


    move_offset(5)
    c2s_upgrade_training_pb:_InternalSerialize(write_to_buffer)
    c2s_upgrade_training_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_upgrade_training = 55
military_decoder.S2C_UPGRADE_TRAINING = 55
local s2c_upgrade_training_pb
decoder[55] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_upgrade_training_pb or military_pb.S2CUpgradeTrainingProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local s2c_fail_upgrade_training = 56
military_decoder.S2C_FAIL_UPGRADE_TRAINING = 56
decoder[56] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_training_output = 81
military_decoder.S2C_UPDATE_TRAINING_OUTPUT = 81
local s2c_update_training_output_pb
decoder[81] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_training_output_pb or military_pb.S2CUpdateTrainingOutputProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_collect_all_training_exp = 70
local c2s_collect_all_training_exp_pb

military_decoder.C2S_COLLECT_ALL_TRAINING_EXP = function()
	if c2s_collect_all_training_exp_pb then return c2s_collect_all_training_exp_pb end
    buffer[4] = char(4)
    buffer[5] = char(70)
    c2s_collect_all_training_exp_pb = concat(buffer, '', 1, 5)    return c2s_collect_all_training_exp_pb
end

-- local s2c_collect_all_training_exp = 71
military_decoder.S2C_COLLECT_ALL_TRAINING_EXP = 71
local s2c_collect_all_training_exp_pb
decoder[71] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local c2s_auto_set_training_captain = 72
local c2s_auto_set_training_captain_pb

military_decoder.C2S_AUTO_SET_TRAINING_CAPTAIN = function()
	if c2s_auto_set_training_captain_pb then return c2s_auto_set_training_captain_pb end
    buffer[4] = char(4)
    buffer[5] = char(72)
    c2s_auto_set_training_captain_pb = concat(buffer, '', 1, 5)    return c2s_auto_set_training_captain_pb
end

-- local s2c_auto_set_training_captain = 73
military_decoder.S2C_AUTO_SET_TRAINING_CAPTAIN = 73
local s2c_auto_set_training_captain_pb
decoder[73] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_auto_set_training_captain_pb or military_pb.S2CAutoSetTrainingCaptainProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_get_max_recruit_soldier = 74
local c2s_get_max_recruit_soldier_pb

military_decoder.C2S_GET_MAX_RECRUIT_SOLDIER = function()
	if c2s_get_max_recruit_soldier_pb then return c2s_get_max_recruit_soldier_pb end
    buffer[4] = char(4)
    buffer[5] = char(74)
    c2s_get_max_recruit_soldier_pb = concat(buffer, '', 1, 5)    return c2s_get_max_recruit_soldier_pb
end

-- local s2c_get_max_recruit_soldier = 75
military_decoder.S2C_GET_MAX_RECRUIT_SOLDIER = 75
local s2c_get_max_recruit_soldier_pb
decoder[75] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_get_max_recruit_soldier_pb or military_pb.S2CGetMaxRecruitSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end

-- local c2s_get_max_heal_soldier = 76
local c2s_get_max_heal_soldier_pb

military_decoder.C2S_GET_MAX_HEAL_SOLDIER = function()
	if c2s_get_max_heal_soldier_pb then return c2s_get_max_heal_soldier_pb end
    buffer[4] = char(4)
    buffer[5] = char(76)
    c2s_get_max_heal_soldier_pb = concat(buffer, '', 1, 5)    return c2s_get_max_heal_soldier_pb
end

-- local s2c_get_max_heal_soldier = 77
military_decoder.S2C_GET_MAX_HEAL_SOLDIER = 77
local s2c_get_max_heal_soldier_pb
decoder[77] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_get_max_heal_soldier_pb or military_pb.S2CGetMaxHealSoldierProto()

    local ok, msg = pcall(pb._InternalParse, pb, data, offset, length)
    if not ok or msg ~= length then
    	pb:Clear()
    	print("消息pb解析出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    else
        ok, msg = pcall(handler, pb)
        pb:Clear()
        if not ok then
        	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
        end
    end
end


military_decoder.Decoder = decoder

return military_decoder

