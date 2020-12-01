

require "autogen.dungeon_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 26
dungeon_decoder = {}
dungeon_decoder.ModuleID = ModuleID
dungeon_decoder.ModuleName = "dungeon"

local decoder = {}
local handler = {}

dungeon_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_challenge = 1
local c2s_challenge_pb


dungeon_decoder.NewC2sChallengeMsg = function(id, captain_id)



    if not c2s_challenge_pb then c2s_challenge_pb = dungeon_pb.C2SChallengeProto() end

    
    c2s_challenge_pb.id = id
    for k,v in pairs(captain_id) do table.insert(c2s_challenge_pb.captain_id,v) end
    buffer[4] = char(26)
    buffer[5] = char(1)


    move_offset(5)
    c2s_challenge_pb:_InternalSerialize(write_to_buffer)
    c2s_challenge_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_challenge = 2
dungeon_decoder.S2C_CHALLENGE = 2
local s2c_challenge_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_challenge_pb or dungeon_pb.S2CChallengeProto()

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

-- local s2c_fail_challenge = 3
dungeon_decoder.S2C_FAIL_CHALLENGE = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_collect_chapter_prize = 4
local c2s_collect_chapter_prize_pb


dungeon_decoder.NewC2sCollectChapterPrizeMsg = function(id)



    if not c2s_collect_chapter_prize_pb then c2s_collect_chapter_prize_pb = dungeon_pb.C2SCollectChapterPrizeProto() end

    
    c2s_collect_chapter_prize_pb.id = id
    buffer[4] = char(26)
    buffer[5] = char(4)


    move_offset(5)
    c2s_collect_chapter_prize_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_chapter_prize_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_chapter_prize = 5
dungeon_decoder.S2C_COLLECT_CHAPTER_PRIZE = 5
local s2c_collect_chapter_prize_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_chapter_prize_pb or dungeon_pb.S2CCollectChapterPrizeProto()

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

-- local s2c_fail_collect_chapter_prize = 6
dungeon_decoder.S2C_FAIL_COLLECT_CHAPTER_PRIZE = 6
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_auto_challenge = 7
local c2s_auto_challenge_pb


dungeon_decoder.NewC2sAutoChallengeMsg = function(id, times)



    if not c2s_auto_challenge_pb then c2s_auto_challenge_pb = dungeon_pb.C2SAutoChallengeProto() end

    
    c2s_auto_challenge_pb.id = id
    c2s_auto_challenge_pb.times = times
    buffer[4] = char(26)
    buffer[5] = char(7)


    move_offset(5)
    c2s_auto_challenge_pb:_InternalSerialize(write_to_buffer)
    c2s_auto_challenge_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_auto_challenge = 8
dungeon_decoder.S2C_AUTO_CHALLENGE = 8
local s2c_auto_challenge_pb
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_auto_challenge_pb or dungeon_pb.S2CAutoChallengeProto()

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

-- local s2c_fail_auto_challenge = 9
dungeon_decoder.S2C_FAIL_AUTO_CHALLENGE = 9
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_collect_auto_times = 10
local c2s_collect_auto_times_pb

dungeon_decoder.C2S_COLLECT_AUTO_TIMES = function()
	if c2s_collect_auto_times_pb then return c2s_collect_auto_times_pb end
    buffer[4] = char(26)
    buffer[5] = char(10)
    c2s_collect_auto_times_pb = concat(buffer, '', 1, 5)    return c2s_collect_auto_times_pb
end

-- local s2c_collect_auto_times = 11
dungeon_decoder.S2C_COLLECT_AUTO_TIMES = 11
local s2c_collect_auto_times_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_auto_times_pb or dungeon_pb.S2CCollectAutoTimesProto()

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

-- local s2c_fail_collect_auto_times = 12
dungeon_decoder.S2C_FAIL_COLLECT_AUTO_TIMES = 12
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


dungeon_decoder.Decoder = decoder

return dungeon_decoder

