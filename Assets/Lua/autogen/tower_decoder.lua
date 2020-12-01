

require "autogen.tower_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 14
tower_decoder = {}
tower_decoder.ModuleID = ModuleID
tower_decoder.ModuleName = "tower"

local decoder = {}
local handler = {}

tower_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_challenge = 1
local c2s_challenge_pb


tower_decoder.NewC2sChallengeMsg = function(floor, captain_id)



    if not c2s_challenge_pb then c2s_challenge_pb = tower_pb.C2SChallengeProto() end

    
    c2s_challenge_pb.floor = floor
    for k,v in pairs(captain_id) do table.insert(c2s_challenge_pb.captain_id,v) end
    buffer[4] = char(14)
    buffer[5] = char(1)


    move_offset(5)
    c2s_challenge_pb:_InternalSerialize(write_to_buffer)
    c2s_challenge_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_challenge = 2
tower_decoder.S2C_CHALLENGE = 2
local s2c_challenge_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_challenge_pb or tower_pb.S2CChallengeProto()

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
-- local s2c_failure_challenge = 3
tower_decoder.S2C_FAILURE_CHALLENGE = 3
local s2c_failure_challenge_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_failure_challenge_pb or tower_pb.S2CFailureChallengeProto()

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

-- local s2c_fail_challenge = 4
tower_decoder.S2C_FAIL_CHALLENGE = 4
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_auto_challenge = 5
local c2s_auto_challenge_pb


tower_decoder.NewC2sAutoChallengeMsg = function(captain_id)



    if not c2s_auto_challenge_pb then c2s_auto_challenge_pb = tower_pb.C2SAutoChallengeProto() end

    
    for k,v in pairs(captain_id) do table.insert(c2s_auto_challenge_pb.captain_id,v) end
    buffer[4] = char(14)
    buffer[5] = char(5)


    move_offset(5)
    c2s_auto_challenge_pb:_InternalSerialize(write_to_buffer)
    c2s_auto_challenge_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_auto_challenge = 6
tower_decoder.S2C_AUTO_CHALLENGE = 6
local s2c_auto_challenge_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_auto_challenge_pb or tower_pb.S2CAutoChallengeProto()

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

-- local s2c_fail_auto_challenge = 7
tower_decoder.S2C_FAIL_AUTO_CHALLENGE = 7
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_collect_box = 8
local c2s_collect_box_pb

tower_decoder.C2S_COLLECT_BOX = function()
	if c2s_collect_box_pb then return c2s_collect_box_pb end
    buffer[4] = char(14)
    buffer[5] = char(8)
    c2s_collect_box_pb = concat(buffer, '', 1, 5)    return c2s_collect_box_pb
end

-- local s2c_collect_box = 9
tower_decoder.S2C_COLLECT_BOX = 9
local s2c_collect_box_pb
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_box_pb or tower_pb.S2CCollectBoxProto()

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

-- local s2c_fail_collect_box = 10
tower_decoder.S2C_FAIL_COLLECT_BOX = 10
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_list_pass_replay = 11
local c2s_list_pass_replay_pb


tower_decoder.NewC2sListPassReplayMsg = function(floor)



    if not c2s_list_pass_replay_pb then c2s_list_pass_replay_pb = tower_pb.C2SListPassReplayProto() end

    
    c2s_list_pass_replay_pb.floor = floor
    buffer[4] = char(14)
    buffer[5] = char(11)


    move_offset(5)
    c2s_list_pass_replay_pb:_InternalSerialize(write_to_buffer)
    c2s_list_pass_replay_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_list_pass_replay = 12
tower_decoder.S2C_LIST_PASS_REPLAY = 12
local s2c_list_pass_replay_pb
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_list_pass_replay_pb or tower_pb.S2CListPassReplayProto()

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

-- local s2c_fail_list_pass_replay = 13
tower_decoder.S2C_FAIL_LIST_PASS_REPLAY = 13
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


tower_decoder.Decoder = decoder

return tower_decoder

