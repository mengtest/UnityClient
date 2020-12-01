

require "autogen.misc_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 5
misc_decoder = {}
misc_decoder.ModuleID = ModuleID
misc_decoder.ModuleName = "misc"

local decoder = {}
local handler = {}

misc_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_heart_beat = 1
local c2s_heart_beat_pb


misc_decoder.NewC2sHeartBeatMsg = function(client_time)



    if not c2s_heart_beat_pb then c2s_heart_beat_pb = misc_pb.C2SHeartBeatProto() end

    
    c2s_heart_beat_pb.client_time = client_time
    buffer[4] = char(5)
    buffer[5] = char(1)


    move_offset(5)
    c2s_heart_beat_pb:_InternalSerialize(write_to_buffer)
    c2s_heart_beat_pb:Clear()

    return concat(buffer, '', 1, offset())
end


-- local c2s_config = 3
local c2s_config_pb

misc_decoder.C2S_CONFIG = function()
	if c2s_config_pb then return c2s_config_pb end
    buffer[4] = char(5)
    buffer[5] = char(3)
    c2s_config_pb = concat(buffer, '', 1, 5)    return c2s_config_pb
end

-- local s2c_config = 4
misc_decoder.S2C_CONFIG = 4
local s2c_config_pb
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_config_pb or misc_pb.S2CConfigProto()

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


-- local s2c_fail_disconect_reason = 5
misc_decoder.S2C_FAIL_DISCONECT_REASON = 5
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_reset_daily = 6
misc_decoder.S2C_RESET_DAILY = 6
local s2c_reset_daily_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local c2s_client_log = 7
local c2s_client_log_pb


misc_decoder.NewC2sClientLogMsg = function(level, text)



    if not c2s_client_log_pb then c2s_client_log_pb = misc_pb.C2SClientLogProto() end

    
    c2s_client_log_pb.level = level
    c2s_client_log_pb.text = text
    buffer[4] = char(5)
    buffer[5] = char(7)


    move_offset(5)
    c2s_client_log_pb:_InternalSerialize(write_to_buffer)
    c2s_client_log_pb:Clear()

    return concat(buffer, '', 1, offset())
end


-- local c2s_sync_time = 8
local c2s_sync_time_pb


misc_decoder.NewC2sSyncTimeMsg = function(client_time)



    if not c2s_sync_time_pb then c2s_sync_time_pb = misc_pb.C2SSyncTimeProto() end

    
    c2s_sync_time_pb.client_time = client_time
    buffer[4] = char(5)
    buffer[5] = char(8)


    move_offset(5)
    c2s_sync_time_pb:_InternalSerialize(write_to_buffer)
    c2s_sync_time_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_sync_time = 9
misc_decoder.S2C_SYNC_TIME = 9
local s2c_sync_time_pb
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_sync_time_pb or misc_pb.S2CSyncTimeProto()

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

-- local c2s_block = 10
local c2s_block_pb

misc_decoder.C2S_BLOCK = function()
	if c2s_block_pb then return c2s_block_pb end
    buffer[4] = char(5)
    buffer[5] = char(10)
    c2s_block_pb = concat(buffer, '', 1, 5)    return c2s_block_pb
end

-- local s2c_block = 11
misc_decoder.S2C_BLOCK = 11
local s2c_block_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_block_pb or misc_pb.S2CBlockProto()

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


misc_decoder.Decoder = decoder

return misc_decoder

