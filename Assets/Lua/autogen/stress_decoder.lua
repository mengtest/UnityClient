

require "autogen.stress_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 10
stress_decoder = {}
stress_decoder.ModuleID = ModuleID
stress_decoder.ModuleName = "stress"

local decoder = {}
local handler = {}

stress_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_robot_ping = 1
local c2s_robot_ping_pb


stress_decoder.NewC2sRobotPingMsg = function(time)



    if not c2s_robot_ping_pb then c2s_robot_ping_pb = stress_pb.C2SRobotPingProto() end

    
    c2s_robot_ping_pb.time = time
    buffer[4] = char(10)
    buffer[5] = char(1)


    move_offset(5)
    c2s_robot_ping_pb:_InternalSerialize(write_to_buffer)
    c2s_robot_ping_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_robot_ping = 2
stress_decoder.S2C_ROBOT_PING = 2
local s2c_robot_ping_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_robot_ping_pb or stress_pb.S2CRobotPingProto()

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


stress_decoder.Decoder = decoder

return stress_decoder

