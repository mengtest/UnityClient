

require "autogen.captain_soul_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 17
captain_soul_decoder = {}
captain_soul_decoder.ModuleID = ModuleID
captain_soul_decoder.ModuleName = "captain_soul"

local decoder = {}
local handler = {}

captain_soul_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local s2c_soul_activated = 1
captain_soul_decoder.S2C_SOUL_ACTIVATED = 1
local s2c_soul_activated_pb
decoder[1] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_soul_activated_pb or captain_soul_pb.S2CSoulActivatedProto()

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

-- local c2s_collect_fetters_prize = 3
local c2s_collect_fetters_prize_pb


captain_soul_decoder.NewC2sCollectFettersPrizeMsg = function(id)



    if not c2s_collect_fetters_prize_pb then c2s_collect_fetters_prize_pb = captain_soul_pb.C2SCollectFettersPrizeProto() end

    
    c2s_collect_fetters_prize_pb.id = id
    buffer[4] = char(17)
    buffer[5] = char(3)


    move_offset(5)
    c2s_collect_fetters_prize_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_fetters_prize_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_fetters_prize = 4
captain_soul_decoder.S2C_COLLECT_FETTERS_PRIZE = 4
local s2c_collect_fetters_prize_pb
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_fetters_prize_pb or captain_soul_pb.S2CCollectFettersPrizeProto()

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

-- local s2c_fail_collect_fetters_prize = 5
captain_soul_decoder.S2C_FAIL_COLLECT_FETTERS_PRIZE = 5
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_activate_fetters = 6
local c2s_activate_fetters_pb


captain_soul_decoder.NewC2sActivateFettersMsg = function(id)



    if not c2s_activate_fetters_pb then c2s_activate_fetters_pb = captain_soul_pb.C2SActivateFettersProto() end

    
    c2s_activate_fetters_pb.id = id
    buffer[4] = char(17)
    buffer[5] = char(6)


    move_offset(5)
    c2s_activate_fetters_pb:_InternalSerialize(write_to_buffer)
    c2s_activate_fetters_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_activate_fetters = 7
captain_soul_decoder.S2C_ACTIVATE_FETTERS = 7
local s2c_activate_fetters_pb
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_activate_fetters_pb or captain_soul_pb.S2CActivateFettersProto()

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

-- local s2c_fail_activate_fetters = 8
captain_soul_decoder.S2C_FAIL_ACTIVATE_FETTERS = 8
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_fu_shen = 9
local c2s_fu_shen_pb


captain_soul_decoder.NewC2sFuShenMsg = function(captain, up, soul_id)



    if not c2s_fu_shen_pb then c2s_fu_shen_pb = captain_soul_pb.C2SFuShenProto() end

    
    c2s_fu_shen_pb.captain = captain
    c2s_fu_shen_pb.up = up
    c2s_fu_shen_pb.soul_id = soul_id
    buffer[4] = char(17)
    buffer[5] = char(9)


    move_offset(5)
    c2s_fu_shen_pb:_InternalSerialize(write_to_buffer)
    c2s_fu_shen_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_fu_shen = 10
captain_soul_decoder.S2C_FU_SHEN = 10
local s2c_fu_shen_pb
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fu_shen_pb or captain_soul_pb.S2CFuShenProto()

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

-- local s2c_fail_fu_shen = 11
captain_soul_decoder.S2C_FAIL_FU_SHEN = 11
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade = 12
local c2s_upgrade_pb


captain_soul_decoder.NewC2sUpgradeMsg = function(captain_soul_id)



    if not c2s_upgrade_pb then c2s_upgrade_pb = captain_soul_pb.C2SUpgradeProto() end

    
    c2s_upgrade_pb.captain_soul_id = captain_soul_id
    buffer[4] = char(17)
    buffer[5] = char(12)


    move_offset(5)
    c2s_upgrade_pb:_InternalSerialize(write_to_buffer)
    c2s_upgrade_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_upgrade = 13
captain_soul_decoder.S2C_UPGRADE = 13
local s2c_upgrade_pb
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_upgrade_pb or captain_soul_pb.S2CUpgradeProto()

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

-- local s2c_fail_upgrade = 14
captain_soul_decoder.S2C_FAIL_UPGRADE = 14
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


captain_soul_decoder.Decoder = decoder

return captain_soul_decoder

