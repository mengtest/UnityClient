

require "autogen.country_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 27
country_decoder = {}
country_decoder.ModuleID = ModuleID
country_decoder.ModuleName = "country"

local decoder = {}
local handler = {}

country_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_request_country = 1
local c2s_request_country_pb


country_decoder.NewC2sRequestCountryMsg = function(vsn)



    if not c2s_request_country_pb then c2s_request_country_pb = country_pb.C2SRequestCountryProto() end

    
    c2s_request_country_pb.vsn = vsn
    buffer[4] = char(27)
    buffer[5] = char(1)


    move_offset(5)
    c2s_request_country_pb:_InternalSerialize(write_to_buffer)
    c2s_request_country_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_request_country = 2
country_decoder.S2C_REQUEST_COUNTRY = 2
local s2c_request_country_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_country_pb or country_pb.S2CRequestCountryProto()

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
-- local s2c_no_change_request_country = 3
country_decoder.S2C_NO_CHANGE_REQUEST_COUNTRY = 3
local s2c_no_change_request_country_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_request_country = 4
country_decoder.S2C_FAIL_REQUEST_COUNTRY = 4
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_request_self_country = 5
local c2s_request_self_country_pb


country_decoder.NewC2sRequestSelfCountryMsg = function(vsn)



    if not c2s_request_self_country_pb then c2s_request_self_country_pb = country_pb.C2SRequestSelfCountryProto() end

    
    c2s_request_self_country_pb.vsn = vsn
    buffer[4] = char(27)
    buffer[5] = char(5)


    move_offset(5)
    c2s_request_self_country_pb:_InternalSerialize(write_to_buffer)
    c2s_request_self_country_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_request_self_country = 6
country_decoder.S2C_REQUEST_SELF_COUNTRY = 6
local s2c_request_self_country_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_self_country_pb or country_pb.S2CRequestSelfCountryProto()

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
-- local s2c_no_change_request_self_country = 7
country_decoder.S2C_NO_CHANGE_REQUEST_SELF_COUNTRY = 7
local s2c_no_change_request_self_country_pb
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_request_self_country = 8
country_decoder.S2C_FAIL_REQUEST_SELF_COUNTRY = 8
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_create_country = 9
local c2s_create_country_pb


country_decoder.NewC2sCreateCountryMsg = function(name, color_index)



    if not c2s_create_country_pb then c2s_create_country_pb = country_pb.C2SCreateCountryProto() end

    
    c2s_create_country_pb.name = name
    c2s_create_country_pb.color_index = color_index
    buffer[4] = char(27)
    buffer[5] = char(9)


    move_offset(5)
    c2s_create_country_pb:_InternalSerialize(write_to_buffer)
    c2s_create_country_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_create_country = 10
country_decoder.S2C_CREATE_COUNTRY = 10
local s2c_create_country_pb
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_create_country = 11
country_decoder.S2C_FAIL_CREATE_COUNTRY = 11
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_create_country_broadcast = 12
country_decoder.S2C_CREATE_COUNTRY_BROADCAST = 12
local s2c_create_country_broadcast_pb
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_create_country_broadcast_pb or country_pb.S2CCreateCountryBroadcastProto()

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

-- local c2s_change_country_name = 13
local c2s_change_country_name_pb


country_decoder.NewC2sChangeCountryNameMsg = function(name, color_index)



    if not c2s_change_country_name_pb then c2s_change_country_name_pb = country_pb.C2SChangeCountryNameProto() end

    
    c2s_change_country_name_pb.name = name
    c2s_change_country_name_pb.color_index = color_index
    buffer[4] = char(27)
    buffer[5] = char(13)


    move_offset(5)
    c2s_change_country_name_pb:_InternalSerialize(write_to_buffer)
    c2s_change_country_name_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_change_country_name = 14
country_decoder.S2C_CHANGE_COUNTRY_NAME = 14
local s2c_change_country_name_pb
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_change_country_name_pb or country_pb.S2CChangeCountryNameProto()

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

-- local s2c_fail_change_country_name = 15
country_decoder.S2C_FAIL_CHANGE_COUNTRY_NAME = 15
decoder[15] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


country_decoder.Decoder = decoder

return country_decoder

