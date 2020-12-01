

require "autogen.client_config_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 21
client_config_decoder = {}
client_config_decoder.ModuleID = ModuleID
client_config_decoder.ModuleName = "client_config"

local decoder = {}
local handler = {}

client_config_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_config = 1
local c2s_config_pb


client_config_decoder.NewC2sConfigMsg = function(path)



    if not c2s_config_pb then c2s_config_pb = client_config_pb.C2SConfigProto() end

    
    c2s_config_pb.path = path
    buffer[4] = char(21)
    buffer[5] = char(1)


    move_offset(5)
    c2s_config_pb:_InternalSerialize(write_to_buffer)
    c2s_config_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_config = 2
client_config_decoder.S2C_CONFIG = 2
local s2c_config_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_config_pb or client_config_pb.S2CConfigProto()

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

-- local s2c_fail_config = 3
client_config_decoder.S2C_FAIL_CONFIG = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


client_config_decoder.Decoder = decoder

return client_config_decoder

