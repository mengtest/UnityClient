

require "autogen.bai_zhan_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 24
bai_zhan_decoder = {}
bai_zhan_decoder.ModuleID = ModuleID
bai_zhan_decoder.ModuleName = "bai_zhan"

local decoder = {}
local handler = {}

bai_zhan_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_query_bai_zhan_info = 1
local c2s_query_bai_zhan_info_pb

bai_zhan_decoder.C2S_QUERY_BAI_ZHAN_INFO = function()
	if c2s_query_bai_zhan_info_pb then return c2s_query_bai_zhan_info_pb end
    buffer[4] = char(24)
    buffer[5] = char(1)
    c2s_query_bai_zhan_info_pb = concat(buffer, '', 1, 5)    return c2s_query_bai_zhan_info_pb
end

-- local s2c_query_bai_zhan_info = 2
bai_zhan_decoder.S2C_QUERY_BAI_ZHAN_INFO = 2
local s2c_query_bai_zhan_info_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_query_bai_zhan_info_pb or bai_zhan_pb.S2CQueryBaiZhanInfoProto()

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

-- local s2c_fail_query_bai_zhan_info = 3
bai_zhan_decoder.S2C_FAIL_QUERY_BAI_ZHAN_INFO = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_bai_zhan_challenge = 4
local c2s_bai_zhan_challenge_pb


bai_zhan_decoder.NewC2sBaiZhanChallengeMsg = function(captain_id)



    if not c2s_bai_zhan_challenge_pb then c2s_bai_zhan_challenge_pb = bai_zhan_pb.C2SBaiZhanChallengeProto() end

    
    for k,v in pairs(captain_id) do table.insert(c2s_bai_zhan_challenge_pb.captain_id,v) end
    buffer[4] = char(24)
    buffer[5] = char(4)


    move_offset(5)
    c2s_bai_zhan_challenge_pb:_InternalSerialize(write_to_buffer)
    c2s_bai_zhan_challenge_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_bai_zhan_challenge = 5
bai_zhan_decoder.S2C_BAI_ZHAN_CHALLENGE = 5
local s2c_bai_zhan_challenge_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_bai_zhan_challenge_pb or bai_zhan_pb.S2CBaiZhanChallengeProto()

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

-- local s2c_fail_bai_zhan_challenge = 6
bai_zhan_decoder.S2C_FAIL_BAI_ZHAN_CHALLENGE = 6
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_collect_salary = 7
local c2s_collect_salary_pb

bai_zhan_decoder.C2S_COLLECT_SALARY = function()
	if c2s_collect_salary_pb then return c2s_collect_salary_pb end
    buffer[4] = char(24)
    buffer[5] = char(7)
    c2s_collect_salary_pb = concat(buffer, '', 1, 5)    return c2s_collect_salary_pb
end

-- local s2c_collect_salary = 8
bai_zhan_decoder.S2C_COLLECT_SALARY = 8
local s2c_collect_salary_pb
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_collect_salary = 9
bai_zhan_decoder.S2C_FAIL_COLLECT_SALARY = 9
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_collect_jun_xian_prize = 10
local c2s_collect_jun_xian_prize_pb


bai_zhan_decoder.NewC2sCollectJunXianPrizeMsg = function(id)



    if not c2s_collect_jun_xian_prize_pb then c2s_collect_jun_xian_prize_pb = bai_zhan_pb.C2SCollectJunXianPrizeProto() end

    
    c2s_collect_jun_xian_prize_pb.id = id
    buffer[4] = char(24)
    buffer[5] = char(10)


    move_offset(5)
    c2s_collect_jun_xian_prize_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_jun_xian_prize_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_jun_xian_prize = 11
bai_zhan_decoder.S2C_COLLECT_JUN_XIAN_PRIZE = 11
local s2c_collect_jun_xian_prize_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_jun_xian_prize_pb or bai_zhan_pb.S2CCollectJunXianPrizeProto()

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

-- local s2c_fail_collect_jun_xian_prize = 12
bai_zhan_decoder.S2C_FAIL_COLLECT_JUN_XIAN_PRIZE = 12
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_reset = 13
bai_zhan_decoder.S2C_RESET = 13
local s2c_reset_pb
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local c2s_self_record = 29
local c2s_self_record_pb


bai_zhan_decoder.NewC2sSelfRecordMsg = function(version)



    if not c2s_self_record_pb then c2s_self_record_pb = bai_zhan_pb.C2SSelfRecordProto() end

    
    c2s_self_record_pb.version = version
    buffer[4] = char(24)
    buffer[5] = char(29)


    move_offset(5)
    c2s_self_record_pb:_InternalSerialize(write_to_buffer)
    c2s_self_record_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_self_record = 30
bai_zhan_decoder.S2C_SELF_RECORD = 30
local s2c_self_record_pb
decoder[30] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_self_record_pb or bai_zhan_pb.S2CSelfRecordProto()

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
-- local s2c_no_change_self_record = 31
bai_zhan_decoder.S2C_NO_CHANGE_SELF_RECORD = 31
local s2c_no_change_self_record_pb
decoder[31] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_self_record = 32
bai_zhan_decoder.S2C_FAIL_SELF_RECORD = 32
decoder[32] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_self_defence_record_changed = 22
bai_zhan_decoder.S2C_SELF_DEFENCE_RECORD_CHANGED = 22
local s2c_self_defence_record_changed_pb
decoder[22] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local c2s_request_rank = 23
local c2s_request_rank_pb


bai_zhan_decoder.NewC2sRequestRankMsg = function(self, start_rank)



    if not c2s_request_rank_pb then c2s_request_rank_pb = bai_zhan_pb.C2SRequestRankProto() end

    
    c2s_request_rank_pb.self = self
    c2s_request_rank_pb.start_rank = start_rank
    buffer[4] = char(24)
    buffer[5] = char(23)


    move_offset(5)
    c2s_request_rank_pb:_InternalSerialize(write_to_buffer)
    c2s_request_rank_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_request_rank = 24
bai_zhan_decoder.S2C_REQUEST_RANK = 24
local s2c_request_rank_pb
decoder[24] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_rank_pb or bai_zhan_pb.S2CRequestRankProto()

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

-- local s2c_fail_request_rank = 28
bai_zhan_decoder.S2C_FAIL_REQUEST_RANK = 28
decoder[28] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_request_self_rank = 26
local c2s_request_self_rank_pb

bai_zhan_decoder.C2S_REQUEST_SELF_RANK = function()
	if c2s_request_self_rank_pb then return c2s_request_self_rank_pb end
    buffer[4] = char(24)
    buffer[5] = char(26)
    c2s_request_self_rank_pb = concat(buffer, '', 1, 5)    return c2s_request_self_rank_pb
end

-- local s2c_request_self_rank = 27
bai_zhan_decoder.S2C_REQUEST_SELF_RANK = 27
local s2c_request_self_rank_pb
decoder[27] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_self_rank_pb or bai_zhan_pb.S2CRequestSelfRankProto()

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


bai_zhan_decoder.Decoder = decoder

return bai_zhan_decoder

