

require "autogen.chat_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 13
chat_decoder = {}
chat_decoder.ModuleID = ModuleID
chat_decoder.ModuleName = "chat"

local decoder = {}
local handler = {}

chat_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_world_chat = 1
local c2s_world_chat_pb


chat_decoder.NewC2sWorldChatMsg = function(text)



    if not c2s_world_chat_pb then c2s_world_chat_pb = chat_pb.C2SWorldChatProto() end

    
    c2s_world_chat_pb.text = text
    buffer[4] = char(13)
    buffer[5] = char(1)


    move_offset(5)
    c2s_world_chat_pb:_InternalSerialize(write_to_buffer)
    c2s_world_chat_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_world_chat = 2
chat_decoder.S2C_WORLD_CHAT = 2
local s2c_world_chat_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_world_other_chat = 3
chat_decoder.S2C_WORLD_OTHER_CHAT = 3
local s2c_world_other_chat_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_world_other_chat_pb or chat_pb.S2CWorldOtherChatProto()

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

-- local c2s_guild_chat = 4
local c2s_guild_chat_pb


chat_decoder.NewC2sGuildChatMsg = function(text)



    if not c2s_guild_chat_pb then c2s_guild_chat_pb = chat_pb.C2SGuildChatProto() end

    
    c2s_guild_chat_pb.text = text
    buffer[4] = char(13)
    buffer[5] = char(4)


    move_offset(5)
    c2s_guild_chat_pb:_InternalSerialize(write_to_buffer)
    c2s_guild_chat_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_guild_chat = 5
chat_decoder.S2C_GUILD_CHAT = 5
local s2c_guild_chat_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_guild_chat = 7
chat_decoder.S2C_FAIL_GUILD_CHAT = 7
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_guild_other_chat = 6
chat_decoder.S2C_GUILD_OTHER_CHAT = 6
local s2c_guild_other_chat_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_guild_other_chat_pb or chat_pb.S2CGuildOtherChatProto()

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


chat_decoder.Decoder = decoder

return chat_decoder

