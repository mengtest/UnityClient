

require "autogen.rank_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 23
rank_decoder = {}
rank_decoder.ModuleID = ModuleID
rank_decoder.ModuleName = "rank"

local decoder = {}
local handler = {}

rank_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_request_rank = 1
local c2s_request_rank_pb


rank_decoder.NewC2sRequestRankMsg = function(rank_type, name, self, start_count, jun_xian_level)



    if not c2s_request_rank_pb then c2s_request_rank_pb = rank_pb.C2SRequestRankProto() end

    
    c2s_request_rank_pb.rank_type = rank_type
    c2s_request_rank_pb.name = name
    c2s_request_rank_pb.self = self
    c2s_request_rank_pb.start_count = start_count
    c2s_request_rank_pb.jun_xian_level = jun_xian_level
    buffer[4] = char(23)
    buffer[5] = char(1)


    move_offset(5)
    c2s_request_rank_pb:_InternalSerialize(write_to_buffer)
    c2s_request_rank_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_request_rank = 2
rank_decoder.S2C_REQUEST_RANK = 2
local s2c_request_rank_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_rank_pb or rank_pb.S2CRequestRankProto()

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

-- local s2c_fail_request_rank = 3
rank_decoder.S2C_FAIL_REQUEST_RANK = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


rank_decoder.Decoder = decoder

return rank_decoder

