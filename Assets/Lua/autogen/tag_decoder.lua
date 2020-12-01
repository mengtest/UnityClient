

require "autogen.tag_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 29
tag_decoder = {}
tag_decoder.ModuleID = ModuleID
tag_decoder.ModuleName = "tag"

local decoder = {}
local handler = {}

tag_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_add_or_update_tag = 1
local c2s_add_or_update_tag_pb


tag_decoder.NewC2sAddOrUpdateTagMsg = function(id, tag)



    if not c2s_add_or_update_tag_pb then c2s_add_or_update_tag_pb = tag_pb.C2SAddOrUpdateTagProto() end

    
    c2s_add_or_update_tag_pb.id = id
    c2s_add_or_update_tag_pb.tag = tag
    buffer[4] = char(29)
    buffer[5] = char(1)


    move_offset(5)
    c2s_add_or_update_tag_pb:_InternalSerialize(write_to_buffer)
    c2s_add_or_update_tag_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_add_or_update_tag = 2
tag_decoder.S2C_ADD_OR_UPDATE_TAG = 2
local s2c_add_or_update_tag_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_add_or_update_tag_pb or tag_pb.S2CAddOrUpdateTagProto()

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

-- local s2c_fail_add_or_update_tag = 3
tag_decoder.S2C_FAIL_ADD_OR_UPDATE_TAG = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_other_tag_me = 4
tag_decoder.S2C_OTHER_TAG_ME = 4
local s2c_other_tag_me_pb
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_other_tag_me_pb or tag_pb.S2COtherTagMeProto()

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

-- local c2s_delete_tag = 5
local c2s_delete_tag_pb


tag_decoder.NewC2sDeleteTagMsg = function(tag)



    if not c2s_delete_tag_pb then c2s_delete_tag_pb = tag_pb.C2SDeleteTagProto() end

    
    c2s_delete_tag_pb.tag = tag
    buffer[4] = char(29)
    buffer[5] = char(5)


    move_offset(5)
    c2s_delete_tag_pb:_InternalSerialize(write_to_buffer)
    c2s_delete_tag_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_delete_tag = 6
tag_decoder.S2C_DELETE_TAG = 6
local s2c_delete_tag_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_delete_tag_pb or tag_pb.S2CDeleteTagProto()

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

-- local s2c_fail_delete_tag = 7
tag_decoder.S2C_FAIL_DELETE_TAG = 7
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


tag_decoder.Decoder = decoder

return tag_decoder

