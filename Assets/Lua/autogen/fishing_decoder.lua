

require "autogen.fishing_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 16
fishing_decoder = {}
fishing_decoder.ModuleID = ModuleID
fishing_decoder.ModuleName = "fishing"

local decoder = {}
local handler = {}

fishing_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_fishing = 1
local c2s_fishing_pb


fishing_decoder.NewC2sFishingMsg = function(times)



    if not c2s_fishing_pb then c2s_fishing_pb = fishing_pb.C2SFishingProto() end

    
    c2s_fishing_pb.times = times
    buffer[4] = char(16)
    buffer[5] = char(1)


    move_offset(5)
    c2s_fishing_pb:_InternalSerialize(write_to_buffer)
    c2s_fishing_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_fishing = 2
fishing_decoder.S2C_FISHING = 2
local s2c_fishing_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fishing_pb or fishing_pb.S2CFishingProto()

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

-- local s2c_fail_fishing = 3
fishing_decoder.S2C_FAIL_FISHING = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_fishing_broadcast = 5
fishing_decoder.S2C_FISHING_BROADCAST = 5
local s2c_fishing_broadcast_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fishing_broadcast_pb or fishing_pb.S2CFishingBroadcastProto()

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


fishing_decoder.Decoder = decoder

return fishing_decoder

