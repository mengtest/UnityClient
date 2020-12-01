

require "autogen.gm_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 3
gm_decoder = {}
gm_decoder.ModuleID = ModuleID
gm_decoder.ModuleName = "gm"

local decoder = {}
local handler = {}

gm_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_list_cmd = 5
local c2s_list_cmd_pb

gm_decoder.C2S_LIST_CMD = function()
	if c2s_list_cmd_pb then return c2s_list_cmd_pb end
    buffer[4] = char(3)
    buffer[5] = char(5)
    c2s_list_cmd_pb = concat(buffer, '', 1, 5)    return c2s_list_cmd_pb
end

-- local s2c_list_cmd = 6
gm_decoder.S2C_LIST_CMD = 6
local s2c_list_cmd_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_list_cmd_pb or gm_pb.S2CListCmdProto()

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

-- local c2s_gm = 1
local c2s_gm_pb


gm_decoder.NewC2sGmMsg = function(cmd)



    if not c2s_gm_pb then c2s_gm_pb = gm_pb.C2SGmProto() end

    
    c2s_gm_pb.cmd = cmd
    buffer[4] = char(3)
    buffer[5] = char(1)


    move_offset(5)
    c2s_gm_pb:_InternalSerialize(write_to_buffer)
    c2s_gm_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_gm = 2
gm_decoder.S2C_GM = 2
local s2c_gm_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_gm_pb or gm_pb.S2CGmProto()

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


gm_decoder.Decoder = decoder

return gm_decoder

