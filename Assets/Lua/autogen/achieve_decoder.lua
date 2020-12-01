

require "autogen.achieve_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 28
achieve_decoder = {}
achieve_decoder.ModuleID = ModuleID
achieve_decoder.ModuleName = "achieve"

local decoder = {}
local handler = {}

achieve_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_unlock_and_collect_achieve = 1
local c2s_unlock_and_collect_achieve_pb


achieve_decoder.NewC2sUnlockAndCollectAchieveMsg = function(achieve_type)



    if not c2s_unlock_and_collect_achieve_pb then c2s_unlock_and_collect_achieve_pb = achieve_pb.C2SUnlockAndCollectAchieveProto() end

    
    c2s_unlock_and_collect_achieve_pb.achieve_type = achieve_type
    buffer[4] = char(28)
    buffer[5] = char(1)


    move_offset(5)
    c2s_unlock_and_collect_achieve_pb:_InternalSerialize(write_to_buffer)
    c2s_unlock_and_collect_achieve_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_unlock_and_collect_achieve = 2
achieve_decoder.S2C_UNLOCK_AND_COLLECT_ACHIEVE = 2
local s2c_unlock_and_collect_achieve_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_unlock_and_collect_achieve_pb or achieve_pb.S2CUnlockAndCollectAchieveProto()

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

-- local s2c_fail_unlock_and_collect_achieve = 3
achieve_decoder.S2C_FAIL_UNLOCK_AND_COLLECT_ACHIEVE = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


achieve_decoder.Decoder = decoder

return achieve_decoder

