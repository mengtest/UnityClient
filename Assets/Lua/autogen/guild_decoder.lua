

require "autogen.guild_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 9
guild_decoder = {}
guild_decoder.ModuleID = ModuleID
guild_decoder.ModuleName = "guild"

local decoder = {}
local handler = {}

guild_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_list_guild = 1
local c2s_list_guild_pb


guild_decoder.NewC2sListGuildMsg = function(num)



    if not c2s_list_guild_pb then c2s_list_guild_pb = guild_pb.C2SListGuildProto() end

    
    c2s_list_guild_pb.num = num
    buffer[4] = char(9)
    buffer[5] = char(1)


    move_offset(5)
    c2s_list_guild_pb:_InternalSerialize(write_to_buffer)
    c2s_list_guild_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_list_guild = 2
guild_decoder.S2C_LIST_GUILD = 2
local s2c_list_guild_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_list_guild_pb or guild_pb.S2CListGuildProto()

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

-- local s2c_fail_list_guild = 3
guild_decoder.S2C_FAIL_LIST_GUILD = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_search_guild = 4
local c2s_search_guild_pb


guild_decoder.NewC2sSearchGuildMsg = function(name, num)



    if not c2s_search_guild_pb then c2s_search_guild_pb = guild_pb.C2SSearchGuildProto() end

    
    c2s_search_guild_pb.name = name
    c2s_search_guild_pb.num = num
    buffer[4] = char(9)
    buffer[5] = char(4)


    move_offset(5)
    c2s_search_guild_pb:_InternalSerialize(write_to_buffer)
    c2s_search_guild_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_search_guild = 5
guild_decoder.S2C_SEARCH_GUILD = 5
local s2c_search_guild_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_search_guild_pb or guild_pb.S2CSearchGuildProto()

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

-- local s2c_fail_search_guild = 6
guild_decoder.S2C_FAIL_SEARCH_GUILD = 6
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_create_guild = 7
local c2s_create_guild_pb


guild_decoder.NewC2sCreateGuildMsg = function(name, flag_name)



    if not c2s_create_guild_pb then c2s_create_guild_pb = guild_pb.C2SCreateGuildProto() end

    
    c2s_create_guild_pb.name = name
    c2s_create_guild_pb.flag_name = flag_name
    buffer[4] = char(9)
    buffer[5] = char(7)


    move_offset(5)
    c2s_create_guild_pb:_InternalSerialize(write_to_buffer)
    c2s_create_guild_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_create_guild = 8
guild_decoder.S2C_CREATE_GUILD = 8
local s2c_create_guild_pb
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_create_guild_pb or guild_pb.S2CCreateGuildProto()

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

-- local s2c_fail_create_guild = 9
guild_decoder.S2C_FAIL_CREATE_GUILD = 9
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_self_guild = 10
local c2s_self_guild_pb


guild_decoder.NewC2sSelfGuildMsg = function(version)



    if not c2s_self_guild_pb then c2s_self_guild_pb = guild_pb.C2SSelfGuildProto() end

    
    c2s_self_guild_pb.version = version
    buffer[4] = char(9)
    buffer[5] = char(10)


    move_offset(5)
    c2s_self_guild_pb:_InternalSerialize(write_to_buffer)
    c2s_self_guild_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_self_guild = 11
guild_decoder.S2C_SELF_GUILD = 11
local s2c_self_guild_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_self_guild_pb or guild_pb.S2CSelfGuildProto()

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

-- local s2c_fail_self_guild = 12
guild_decoder.S2C_FAIL_SELF_GUILD = 12
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_self_guild_same_version = 87
guild_decoder.S2C_SELF_GUILD_SAME_VERSION = 87
local s2c_self_guild_same_version_pb
decoder[87] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_self_guild_changed = 88
guild_decoder.S2C_SELF_GUILD_CHANGED = 88
local s2c_self_guild_changed_pb
decoder[88] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local c2s_leave_guild = 13
local c2s_leave_guild_pb

guild_decoder.C2S_LEAVE_GUILD = function()
	if c2s_leave_guild_pb then return c2s_leave_guild_pb end
    buffer[4] = char(9)
    buffer[5] = char(13)
    c2s_leave_guild_pb = concat(buffer, '', 1, 5)    return c2s_leave_guild_pb
end

-- local s2c_leave_guild = 14
guild_decoder.S2C_LEAVE_GUILD = 14
local s2c_leave_guild_pb
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_leave_guild = 15
guild_decoder.S2C_FAIL_LEAVE_GUILD = 15
decoder[15] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_leave_guild_for_other = 16
guild_decoder.S2C_LEAVE_GUILD_FOR_OTHER = 16
local s2c_leave_guild_for_other_pb
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_leave_guild_for_other_pb or guild_pb.S2CLeaveGuildForOtherProto()

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

-- local c2s_kick_other = 17
local c2s_kick_other_pb


guild_decoder.NewC2sKickOtherMsg = function(id)



    if not c2s_kick_other_pb then c2s_kick_other_pb = guild_pb.C2SKickOtherProto() end

    
    c2s_kick_other_pb.id = id
    buffer[4] = char(9)
    buffer[5] = char(17)


    move_offset(5)
    c2s_kick_other_pb:_InternalSerialize(write_to_buffer)
    c2s_kick_other_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_kick_other = 18
guild_decoder.S2C_KICK_OTHER = 18
local s2c_kick_other_pb
decoder[18] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_kick_other_pb or guild_pb.S2CKickOtherProto()

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

-- local s2c_fail_kick_other = 19
guild_decoder.S2C_FAIL_KICK_OTHER = 19
decoder[19] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_self_been_kicked = 89
guild_decoder.S2C_SELF_BEEN_KICKED = 89
local s2c_self_been_kicked_pb
decoder[89] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local c2s_update_text = 20
local c2s_update_text_pb


guild_decoder.NewC2sUpdateTextMsg = function(text)



    if not c2s_update_text_pb then c2s_update_text_pb = guild_pb.C2SUpdateTextProto() end

    
    c2s_update_text_pb.text = text
    buffer[4] = char(9)
    buffer[5] = char(20)


    move_offset(5)
    c2s_update_text_pb:_InternalSerialize(write_to_buffer)
    c2s_update_text_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_text = 21
guild_decoder.S2C_UPDATE_TEXT = 21
local s2c_update_text_pb
decoder[21] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_text_pb or guild_pb.S2CUpdateTextProto()

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

-- local s2c_fail_update_text = 22
guild_decoder.S2C_FAIL_UPDATE_TEXT = 22
decoder[22] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_internal_text = 65
local c2s_update_internal_text_pb


guild_decoder.NewC2sUpdateInternalTextMsg = function(text)



    if not c2s_update_internal_text_pb then c2s_update_internal_text_pb = guild_pb.C2SUpdateInternalTextProto() end

    
    c2s_update_internal_text_pb.text = text
    buffer[4] = char(9)
    buffer[5] = char(65)


    move_offset(5)
    c2s_update_internal_text_pb:_InternalSerialize(write_to_buffer)
    c2s_update_internal_text_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_internal_text = 66
guild_decoder.S2C_UPDATE_INTERNAL_TEXT = 66
local s2c_update_internal_text_pb
decoder[66] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_internal_text_pb or guild_pb.S2CUpdateInternalTextProto()

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

-- local s2c_fail_update_internal_text = 67
guild_decoder.S2C_FAIL_UPDATE_INTERNAL_TEXT = 67
decoder[67] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_class_names = 23
local c2s_update_class_names_pb


guild_decoder.NewC2sUpdateClassNamesMsg = function(name)



    if not c2s_update_class_names_pb then c2s_update_class_names_pb = guild_pb.C2SUpdateClassNamesProto() end

    
    for k,v in pairs(name) do table.insert(c2s_update_class_names_pb.name,v) end
    buffer[4] = char(9)
    buffer[5] = char(23)


    move_offset(5)
    c2s_update_class_names_pb:_InternalSerialize(write_to_buffer)
    c2s_update_class_names_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_class_names = 24
guild_decoder.S2C_UPDATE_CLASS_NAMES = 24
local s2c_update_class_names_pb
decoder[24] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_class_names_pb or guild_pb.S2CUpdateClassNamesProto()

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

-- local s2c_fail_update_class_names = 25
guild_decoder.S2C_FAIL_UPDATE_CLASS_NAMES = 25
decoder[25] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_class_title = 122
local c2s_update_class_title_pb


guild_decoder.NewC2sUpdateClassTitleMsg = function(proto)



    if not c2s_update_class_title_pb then c2s_update_class_title_pb = guild_pb.C2SUpdateClassTitleProto() end

    
    c2s_update_class_title_pb.proto = proto
    buffer[4] = char(9)
    buffer[5] = char(122)


    move_offset(5)
    c2s_update_class_title_pb:_InternalSerialize(write_to_buffer)
    c2s_update_class_title_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_class_title = 123
guild_decoder.S2C_UPDATE_CLASS_TITLE = 123
local s2c_update_class_title_pb
decoder[123] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_update_class_title = 124
guild_decoder.S2C_FAIL_UPDATE_CLASS_TITLE = 124
decoder[124] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_flag_type = 26
local c2s_update_flag_type_pb


guild_decoder.NewC2sUpdateFlagTypeMsg = function(flag_type)



    if not c2s_update_flag_type_pb then c2s_update_flag_type_pb = guild_pb.C2SUpdateFlagTypeProto() end

    
    c2s_update_flag_type_pb.flag_type = flag_type
    buffer[4] = char(9)
    buffer[5] = char(26)


    move_offset(5)
    c2s_update_flag_type_pb:_InternalSerialize(write_to_buffer)
    c2s_update_flag_type_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_flag_type = 27
guild_decoder.S2C_UPDATE_FLAG_TYPE = 27
local s2c_update_flag_type_pb
decoder[27] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_flag_type_pb or guild_pb.S2CUpdateFlagTypeProto()

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

-- local s2c_fail_update_flag_type = 28
guild_decoder.S2C_FAIL_UPDATE_FLAG_TYPE = 28
decoder[28] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_member_class_level = 29
local c2s_update_member_class_level_pb


guild_decoder.NewC2sUpdateMemberClassLevelMsg = function(id, class_level)



    if not c2s_update_member_class_level_pb then c2s_update_member_class_level_pb = guild_pb.C2SUpdateMemberClassLevelProto() end

    
    c2s_update_member_class_level_pb.id = id
    c2s_update_member_class_level_pb.class_level = class_level
    buffer[4] = char(9)
    buffer[5] = char(29)


    move_offset(5)
    c2s_update_member_class_level_pb:_InternalSerialize(write_to_buffer)
    c2s_update_member_class_level_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_member_class_level = 30
guild_decoder.S2C_UPDATE_MEMBER_CLASS_LEVEL = 30
local s2c_update_member_class_level_pb
decoder[30] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_update_member_class_level = 31
guild_decoder.S2C_FAIL_UPDATE_MEMBER_CLASS_LEVEL = 31
decoder[31] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_cancel_change_leader = 80
local c2s_cancel_change_leader_pb

guild_decoder.C2S_CANCEL_CHANGE_LEADER = function()
	if c2s_cancel_change_leader_pb then return c2s_cancel_change_leader_pb end
    buffer[4] = char(9)
    buffer[5] = char(80)
    c2s_cancel_change_leader_pb = concat(buffer, '', 1, 5)    return c2s_cancel_change_leader_pb
end

-- local s2c_cancel_change_leader = 81
guild_decoder.S2C_CANCEL_CHANGE_LEADER = 81
local s2c_cancel_change_leader_pb
decoder[81] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_cancel_change_leader = 82
guild_decoder.S2C_FAIL_CANCEL_CHANGE_LEADER = 82
decoder[82] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_join_guild_v01 = 32
local c2s_join_guild_v01_pb


guild_decoder.NewC2sJoinGuildV01Msg = function(id)



    if not c2s_join_guild_v01_pb then c2s_join_guild_v01_pb = guild_pb.C2SJoinGuildV01Proto() end

    
    c2s_join_guild_v01_pb.id = id
    buffer[4] = char(9)
    buffer[5] = char(32)


    move_offset(5)
    c2s_join_guild_v01_pb:_InternalSerialize(write_to_buffer)
    c2s_join_guild_v01_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_join_guild_v01 = 33
guild_decoder.S2C_JOIN_GUILD_V01 = 33
local s2c_join_guild_v01_pb
decoder[33] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_join_guild_v01_pb or guild_pb.S2CJoinGuildV01Proto()

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

-- local s2c_fail_join_guild_v01 = 34
guild_decoder.S2C_FAIL_JOIN_GUILD_V01 = 34
decoder[34] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_join_condition = 68
local c2s_update_join_condition_pb


guild_decoder.NewC2sUpdateJoinConditionMsg = function(reject_auto_join, required_hero_level, required_jun_xian_level, required_tower_max_floor)



    if not c2s_update_join_condition_pb then c2s_update_join_condition_pb = guild_pb.C2SUpdateJoinConditionProto() end

    
    c2s_update_join_condition_pb.reject_auto_join = reject_auto_join
    c2s_update_join_condition_pb.required_hero_level = required_hero_level
    c2s_update_join_condition_pb.required_jun_xian_level = required_jun_xian_level
    c2s_update_join_condition_pb.required_tower_max_floor = required_tower_max_floor
    buffer[4] = char(9)
    buffer[5] = char(68)


    move_offset(5)
    c2s_update_join_condition_pb:_InternalSerialize(write_to_buffer)
    c2s_update_join_condition_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_join_condition = 69
guild_decoder.S2C_UPDATE_JOIN_CONDITION = 69
local s2c_update_join_condition_pb
decoder[69] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_join_condition_pb or guild_pb.S2CUpdateJoinConditionProto()

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

-- local s2c_fail_update_join_condition = 70
guild_decoder.S2C_FAIL_UPDATE_JOIN_CONDITION = 70
decoder[70] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_guild_name = 71
local c2s_update_guild_name_pb


guild_decoder.NewC2sUpdateGuildNameMsg = function(name, flag_name)



    if not c2s_update_guild_name_pb then c2s_update_guild_name_pb = guild_pb.C2SUpdateGuildNameProto() end

    
    c2s_update_guild_name_pb.name = name
    c2s_update_guild_name_pb.flag_name = flag_name
    buffer[4] = char(9)
    buffer[5] = char(71)


    move_offset(5)
    c2s_update_guild_name_pb:_InternalSerialize(write_to_buffer)
    c2s_update_guild_name_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_guild_name = 72
guild_decoder.S2C_UPDATE_GUILD_NAME = 72
local s2c_update_guild_name_pb
decoder[72] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_guild_name_pb or guild_pb.S2CUpdateGuildNameProto()

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

-- local s2c_fail_update_guild_name = 73
guild_decoder.S2C_FAIL_UPDATE_GUILD_NAME = 73
decoder[73] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_guild_name_broadcast = 74
guild_decoder.S2C_UPDATE_GUILD_NAME_BROADCAST = 74
local s2c_update_guild_name_broadcast_pb
decoder[74] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_guild_name_broadcast_pb or guild_pb.S2CUpdateGuildNameBroadcastProto()

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

-- local c2s_update_guild_label = 75
local c2s_update_guild_label_pb


guild_decoder.NewC2sUpdateGuildLabelMsg = function(label)



    if not c2s_update_guild_label_pb then c2s_update_guild_label_pb = guild_pb.C2SUpdateGuildLabelProto() end

    
    for k,v in pairs(label) do table.insert(c2s_update_guild_label_pb.label,v) end
    buffer[4] = char(9)
    buffer[5] = char(75)


    move_offset(5)
    c2s_update_guild_label_pb:_InternalSerialize(write_to_buffer)
    c2s_update_guild_label_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_guild_label = 76
guild_decoder.S2C_UPDATE_GUILD_LABEL = 76
local s2c_update_guild_label_pb
decoder[76] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_guild_label_pb or guild_pb.S2CUpdateGuildLabelProto()

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

-- local s2c_fail_update_guild_label = 77
guild_decoder.S2C_FAIL_UPDATE_GUILD_LABEL = 77
decoder[77] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_contribution_coin = 86
guild_decoder.S2C_UPDATE_CONTRIBUTION_COIN = 86
local s2c_update_contribution_coin_pb
decoder[86] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_contribution_coin_pb or guild_pb.S2CUpdateContributionCoinProto()

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

-- local c2s_donate = 83
local c2s_donate_pb


guild_decoder.NewC2sDonateMsg = function(sequence)



    if not c2s_donate_pb then c2s_donate_pb = guild_pb.C2SDonateProto() end

    
    c2s_donate_pb.sequence = sequence
    buffer[4] = char(9)
    buffer[5] = char(83)


    move_offset(5)
    c2s_donate_pb:_InternalSerialize(write_to_buffer)
    c2s_donate_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_donate = 84
guild_decoder.S2C_DONATE = 84
local s2c_donate_pb
decoder[84] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_donate_pb or guild_pb.S2CDonateProto()

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

-- local s2c_fail_donate = 85
guild_decoder.S2C_FAIL_DONATE = 85
decoder[85] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade_level = 90
local c2s_upgrade_level_pb

guild_decoder.C2S_UPGRADE_LEVEL = function()
	if c2s_upgrade_level_pb then return c2s_upgrade_level_pb end
    buffer[4] = char(9)
    buffer[5] = char(90)
    c2s_upgrade_level_pb = concat(buffer, '', 1, 5)    return c2s_upgrade_level_pb
end

-- local s2c_upgrade_level = 91
guild_decoder.S2C_UPGRADE_LEVEL = 91
local s2c_upgrade_level_pb
decoder[91] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_upgrade_level = 92
guild_decoder.S2C_FAIL_UPGRADE_LEVEL = 92
decoder[92] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_reduce_upgrade_level_cd = 93
local c2s_reduce_upgrade_level_cd_pb


guild_decoder.NewC2sReduceUpgradeLevelCdMsg = function(times)



    if not c2s_reduce_upgrade_level_cd_pb then c2s_reduce_upgrade_level_cd_pb = guild_pb.C2SReduceUpgradeLevelCdProto() end

    
    c2s_reduce_upgrade_level_cd_pb.times = times
    buffer[4] = char(9)
    buffer[5] = char(93)


    move_offset(5)
    c2s_reduce_upgrade_level_cd_pb:_InternalSerialize(write_to_buffer)
    c2s_reduce_upgrade_level_cd_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_reduce_upgrade_level_cd = 94
guild_decoder.S2C_REDUCE_UPGRADE_LEVEL_CD = 94
local s2c_reduce_upgrade_level_cd_pb
decoder[94] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_reduce_upgrade_level_cd = 95
guild_decoder.S2C_FAIL_REDUCE_UPGRADE_LEVEL_CD = 95
decoder[95] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_impeach_leader = 96
local c2s_impeach_leader_pb

guild_decoder.C2S_IMPEACH_LEADER = function()
	if c2s_impeach_leader_pb then return c2s_impeach_leader_pb end
    buffer[4] = char(9)
    buffer[5] = char(96)
    c2s_impeach_leader_pb = concat(buffer, '', 1, 5)    return c2s_impeach_leader_pb
end

-- local s2c_impeach_leader = 97
guild_decoder.S2C_IMPEACH_LEADER = 97
local s2c_impeach_leader_pb
decoder[97] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_impeach_leader = 98
guild_decoder.S2C_FAIL_IMPEACH_LEADER = 98
decoder[98] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_impeach_leader_vote = 99
local c2s_impeach_leader_vote_pb


guild_decoder.NewC2sImpeachLeaderVoteMsg = function(target)



    if not c2s_impeach_leader_vote_pb then c2s_impeach_leader_vote_pb = guild_pb.C2SImpeachLeaderVoteProto() end

    
    c2s_impeach_leader_vote_pb.target = target
    buffer[4] = char(9)
    buffer[5] = char(99)


    move_offset(5)
    c2s_impeach_leader_vote_pb:_InternalSerialize(write_to_buffer)
    c2s_impeach_leader_vote_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_impeach_leader_vote = 100
guild_decoder.S2C_IMPEACH_LEADER_VOTE = 100
local s2c_impeach_leader_vote_pb
decoder[100] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_impeach_leader_vote = 101
guild_decoder.S2C_FAIL_IMPEACH_LEADER_VOTE = 101
decoder[101] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_list_guild_by_ids = 102
local c2s_list_guild_by_ids_pb


guild_decoder.NewC2sListGuildByIdsMsg = function(ids)



    if not c2s_list_guild_by_ids_pb then c2s_list_guild_by_ids_pb = guild_pb.C2SListGuildByIdsProto() end

    
    for k,v in pairs(ids) do table.insert(c2s_list_guild_by_ids_pb.ids,v) end
    buffer[4] = char(9)
    buffer[5] = char(102)


    move_offset(5)
    c2s_list_guild_by_ids_pb:_InternalSerialize(write_to_buffer)
    c2s_list_guild_by_ids_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_list_guild_by_ids = 103
guild_decoder.S2C_LIST_GUILD_BY_IDS = 103
local s2c_list_guild_by_ids_pb
decoder[103] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_list_guild_by_ids_pb or guild_pb.S2CListGuildByIdsProto()

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

-- local s2c_fail_list_guild_by_ids = 104
guild_decoder.S2C_FAIL_LIST_GUILD_BY_IDS = 104
decoder[104] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_user_request_join = 40
local c2s_user_request_join_pb


guild_decoder.NewC2sUserRequestJoinMsg = function(id)



    if not c2s_user_request_join_pb then c2s_user_request_join_pb = guild_pb.C2SUserRequestJoinProto() end

    
    c2s_user_request_join_pb.id = id
    buffer[4] = char(9)
    buffer[5] = char(40)


    move_offset(5)
    c2s_user_request_join_pb:_InternalSerialize(write_to_buffer)
    c2s_user_request_join_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_user_request_join = 41
guild_decoder.S2C_USER_REQUEST_JOIN = 41
local s2c_user_request_join_pb
decoder[41] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_user_request_join_pb or guild_pb.S2CUserRequestJoinProto()

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

-- local s2c_fail_user_request_join = 42
guild_decoder.S2C_FAIL_USER_REQUEST_JOIN = 42
decoder[42] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_user_remove_join_request = 118
guild_decoder.S2C_USER_REMOVE_JOIN_REQUEST = 118
local s2c_user_remove_join_request_pb
decoder[118] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_user_remove_join_request_pb or guild_pb.S2CUserRemoveJoinRequestProto()

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

-- local s2c_user_clear_join_request = 119
guild_decoder.S2C_USER_CLEAR_JOIN_REQUEST = 119
local s2c_user_clear_join_request_pb
decoder[119] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local c2s_user_cancel_join_request = 43
local c2s_user_cancel_join_request_pb


guild_decoder.NewC2sUserCancelJoinRequestMsg = function(id)



    if not c2s_user_cancel_join_request_pb then c2s_user_cancel_join_request_pb = guild_pb.C2SUserCancelJoinRequestProto() end

    
    c2s_user_cancel_join_request_pb.id = id
    buffer[4] = char(9)
    buffer[5] = char(43)


    move_offset(5)
    c2s_user_cancel_join_request_pb:_InternalSerialize(write_to_buffer)
    c2s_user_cancel_join_request_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_user_cancel_join_request = 44
guild_decoder.S2C_USER_CANCEL_JOIN_REQUEST = 44
local s2c_user_cancel_join_request_pb
decoder[44] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_user_cancel_join_request_pb or guild_pb.S2CUserCancelJoinRequestProto()

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

-- local s2c_fail_user_cancel_join_request = 45
guild_decoder.S2C_FAIL_USER_CANCEL_JOIN_REQUEST = 45
decoder[45] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_add_guild_member = 35
guild_decoder.S2C_ADD_GUILD_MEMBER = 35
local s2c_add_guild_member_pb
decoder[35] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_add_guild_member_pb or guild_pb.S2CAddGuildMemberProto()

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

-- local s2c_user_joined = 36
guild_decoder.S2C_USER_JOINED = 36
local s2c_user_joined_pb
decoder[36] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_user_joined_pb or guild_pb.S2CUserJoinedProto()

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

-- local c2s_guild_reply_join_request = 55
local c2s_guild_reply_join_request_pb


guild_decoder.NewC2sGuildReplyJoinRequestMsg = function(id, agree)



    if not c2s_guild_reply_join_request_pb then c2s_guild_reply_join_request_pb = guild_pb.C2SGuildReplyJoinRequestProto() end

    
    c2s_guild_reply_join_request_pb.id = id
    c2s_guild_reply_join_request_pb.agree = agree
    buffer[4] = char(9)
    buffer[5] = char(55)


    move_offset(5)
    c2s_guild_reply_join_request_pb:_InternalSerialize(write_to_buffer)
    c2s_guild_reply_join_request_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_guild_reply_join_request = 56
guild_decoder.S2C_GUILD_REPLY_JOIN_REQUEST = 56
local s2c_guild_reply_join_request_pb
decoder[56] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_guild_reply_join_request_pb or guild_pb.S2CGuildReplyJoinRequestProto()

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

-- local s2c_fail_guild_reply_join_request = 57
guild_decoder.S2C_FAIL_GUILD_REPLY_JOIN_REQUEST = 57
decoder[57] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_guild_invate_other = 109
local c2s_guild_invate_other_pb


guild_decoder.NewC2sGuildInvateOtherMsg = function(id)



    if not c2s_guild_invate_other_pb then c2s_guild_invate_other_pb = guild_pb.C2SGuildInvateOtherProto() end

    
    c2s_guild_invate_other_pb.id = id
    buffer[4] = char(9)
    buffer[5] = char(109)


    move_offset(5)
    c2s_guild_invate_other_pb:_InternalSerialize(write_to_buffer)
    c2s_guild_invate_other_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_guild_invate_other = 110
guild_decoder.S2C_GUILD_INVATE_OTHER = 110
local s2c_guild_invate_other_pb
decoder[110] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_guild_invate_other_pb or guild_pb.S2CGuildInvateOtherProto()

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

-- local s2c_fail_guild_invate_other = 111
guild_decoder.S2C_FAIL_GUILD_INVATE_OTHER = 111
decoder[111] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_guild_cancel_invate_other = 112
local c2s_guild_cancel_invate_other_pb


guild_decoder.NewC2sGuildCancelInvateOtherMsg = function(id)



    if not c2s_guild_cancel_invate_other_pb then c2s_guild_cancel_invate_other_pb = guild_pb.C2SGuildCancelInvateOtherProto() end

    
    c2s_guild_cancel_invate_other_pb.id = id
    buffer[4] = char(9)
    buffer[5] = char(112)


    move_offset(5)
    c2s_guild_cancel_invate_other_pb:_InternalSerialize(write_to_buffer)
    c2s_guild_cancel_invate_other_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_guild_cancel_invate_other = 113
guild_decoder.S2C_GUILD_CANCEL_INVATE_OTHER = 113
local s2c_guild_cancel_invate_other_pb
decoder[113] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_guild_cancel_invate_other_pb or guild_pb.S2CGuildCancelInvateOtherProto()

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

-- local s2c_fail_guild_cancel_invate_other = 114
guild_decoder.S2C_FAIL_GUILD_CANCEL_INVATE_OTHER = 114
decoder[114] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_user_add_been_invate_guild = 120
guild_decoder.S2C_USER_ADD_BEEN_INVATE_GUILD = 120
local s2c_user_add_been_invate_guild_pb
decoder[120] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_user_add_been_invate_guild_pb or guild_pb.S2CUserAddBeenInvateGuildProto()

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

-- local s2c_user_remove_been_invate_guild = 121
guild_decoder.S2C_USER_REMOVE_BEEN_INVATE_GUILD = 121
local s2c_user_remove_been_invate_guild_pb
decoder[121] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_user_remove_been_invate_guild_pb or guild_pb.S2CUserRemoveBeenInvateGuildProto()

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

-- local c2s_user_reply_invate_request = 48
local c2s_user_reply_invate_request_pb


guild_decoder.NewC2sUserReplyInvateRequestMsg = function(id, agree)



    if not c2s_user_reply_invate_request_pb then c2s_user_reply_invate_request_pb = guild_pb.C2SUserReplyInvateRequestProto() end

    
    c2s_user_reply_invate_request_pb.id = id
    c2s_user_reply_invate_request_pb.agree = agree
    buffer[4] = char(9)
    buffer[5] = char(48)


    move_offset(5)
    c2s_user_reply_invate_request_pb:_InternalSerialize(write_to_buffer)
    c2s_user_reply_invate_request_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_user_reply_invate_request = 49
guild_decoder.S2C_USER_REPLY_INVATE_REQUEST = 49
local s2c_user_reply_invate_request_pb
decoder[49] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_user_reply_invate_request_pb or guild_pb.S2CUserReplyInvateRequestProto()

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

-- local s2c_fail_user_reply_invate_request = 50
guild_decoder.S2C_FAIL_USER_REPLY_INVATE_REQUEST = 50
decoder[50] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_friend_guild = 125
local c2s_update_friend_guild_pb


guild_decoder.NewC2sUpdateFriendGuildMsg = function(text)



    if not c2s_update_friend_guild_pb then c2s_update_friend_guild_pb = guild_pb.C2SUpdateFriendGuildProto() end

    
    c2s_update_friend_guild_pb.text = text
    buffer[4] = char(9)
    buffer[5] = char(125)


    move_offset(5)
    c2s_update_friend_guild_pb:_InternalSerialize(write_to_buffer)
    c2s_update_friend_guild_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_friend_guild = 126
guild_decoder.S2C_UPDATE_FRIEND_GUILD = 126
local s2c_update_friend_guild_pb
decoder[126] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_friend_guild_pb or guild_pb.S2CUpdateFriendGuildProto()

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

-- local s2c_fail_update_friend_guild = 127
guild_decoder.S2C_FAIL_UPDATE_FRIEND_GUILD = 127
decoder[127] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_enemy_guild = 128
local c2s_update_enemy_guild_pb


guild_decoder.NewC2sUpdateEnemyGuildMsg = function(text)



    if not c2s_update_enemy_guild_pb then c2s_update_enemy_guild_pb = guild_pb.C2SUpdateEnemyGuildProto() end

    
    c2s_update_enemy_guild_pb.text = text
    buffer[4] = char(9)
    buffer[5] = char(128)
    buffer[6] = char(1)


    move_offset(6)
    c2s_update_enemy_guild_pb:_InternalSerialize(write_to_buffer)
    c2s_update_enemy_guild_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_enemy_guild = 129
guild_decoder.S2C_UPDATE_ENEMY_GUILD = 129
local s2c_update_enemy_guild_pb
decoder[129] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_enemy_guild_pb or guild_pb.S2CUpdateEnemyGuildProto()

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

-- local s2c_fail_update_enemy_guild = 130
guild_decoder.S2C_FAIL_UPDATE_ENEMY_GUILD = 130
decoder[130] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_update_guild_prestige = 131
local c2s_update_guild_prestige_pb


guild_decoder.NewC2sUpdateGuildPrestigeMsg = function(target)



    if not c2s_update_guild_prestige_pb then c2s_update_guild_prestige_pb = guild_pb.C2SUpdateGuildPrestigeProto() end

    
    c2s_update_guild_prestige_pb.target = target
    buffer[4] = char(9)
    buffer[5] = char(131)
    buffer[6] = char(1)


    move_offset(6)
    c2s_update_guild_prestige_pb:_InternalSerialize(write_to_buffer)
    c2s_update_guild_prestige_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_update_guild_prestige = 132
guild_decoder.S2C_UPDATE_GUILD_PRESTIGE = 132
local s2c_update_guild_prestige_pb
decoder[132] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_guild_prestige_pb or guild_pb.S2CUpdateGuildPrestigeProto()

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

-- local s2c_fail_update_guild_prestige = 133
guild_decoder.S2C_FAIL_UPDATE_GUILD_PRESTIGE = 133
decoder[133] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_place_guild_statue = 134
local c2s_place_guild_statue_pb


guild_decoder.NewC2sPlaceGuildStatueMsg = function(realm_id)



    if not c2s_place_guild_statue_pb then c2s_place_guild_statue_pb = guild_pb.C2SPlaceGuildStatueProto() end

    
    c2s_place_guild_statue_pb.realm_id = realm_id
    buffer[4] = char(9)
    buffer[5] = char(134)
    buffer[6] = char(1)


    move_offset(6)
    c2s_place_guild_statue_pb:_InternalSerialize(write_to_buffer)
    c2s_place_guild_statue_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_place_guild_statue = 135
guild_decoder.S2C_PLACE_GUILD_STATUE = 135
local s2c_place_guild_statue_pb
decoder[135] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_place_guild_statue = 136
guild_decoder.S2C_FAIL_PLACE_GUILD_STATUE = 136
decoder[136] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_guild_statue = 137
guild_decoder.S2C_GUILD_STATUE = 137
local s2c_guild_statue_pb
decoder[137] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_guild_statue_pb or guild_pb.S2CGuildStatueProto()

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

-- local c2s_take_back_guild_statue = 138
local c2s_take_back_guild_statue_pb

guild_decoder.C2S_TAKE_BACK_GUILD_STATUE = function()
	if c2s_take_back_guild_statue_pb then return c2s_take_back_guild_statue_pb end
    buffer[4] = char(9)
    buffer[5] = char(138)
    buffer[6] = char(1)
    c2s_take_back_guild_statue_pb = concat(buffer, '', 1, 6)    return c2s_take_back_guild_statue_pb
end

-- local s2c_take_back_guild_statue = 139
guild_decoder.S2C_TAKE_BACK_GUILD_STATUE = 139
local s2c_take_back_guild_statue_pb
decoder[139] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end
-- local s2c_broadcast_take_back_guild_statue = 140
guild_decoder.S2C_BROADCAST_TAKE_BACK_GUILD_STATUE = 140
local s2c_broadcast_take_back_guild_statue_pb
decoder[140] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_take_back_guild_statue = 141
guild_decoder.S2C_FAIL_TAKE_BACK_GUILD_STATUE = 141
decoder[141] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


guild_decoder.Decoder = decoder

return guild_decoder

