

require "autogen.secret_tower_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 22
secret_tower_decoder = {}
secret_tower_decoder.ModuleID = ModuleID
secret_tower_decoder.ModuleName = "secret_tower"

local decoder = {}
local handler = {}

secret_tower_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local s2c_unlock_secret_tower = 1
secret_tower_decoder.S2C_UNLOCK_SECRET_TOWER = 1
local s2c_unlock_secret_tower_pb
decoder[1] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_unlock_secret_tower_pb or secret_tower_pb.S2CUnlockSecretTowerProto()

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

-- local c2s_request_team_count = 2
local c2s_request_team_count_pb

secret_tower_decoder.C2S_REQUEST_TEAM_COUNT = function()
	if c2s_request_team_count_pb then return c2s_request_team_count_pb end
    buffer[4] = char(22)
    buffer[5] = char(2)
    c2s_request_team_count_pb = concat(buffer, '', 1, 5)    return c2s_request_team_count_pb
end

-- local s2c_request_team_count = 3
secret_tower_decoder.S2C_REQUEST_TEAM_COUNT = 3
local s2c_request_team_count_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_team_count_pb or secret_tower_pb.S2CRequestTeamCountProto()

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

-- local s2c_fail_request_team_count = 4
secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_COUNT = 4
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_request_team_list = 5
local c2s_request_team_list_pb


secret_tower_decoder.NewC2sRequestTeamListMsg = function(secret_tower_id)



    if not c2s_request_team_list_pb then c2s_request_team_list_pb = secret_tower_pb.C2SRequestTeamListProto() end

    
    c2s_request_team_list_pb.secret_tower_id = secret_tower_id
    buffer[4] = char(22)
    buffer[5] = char(5)


    move_offset(5)
    c2s_request_team_list_pb:_InternalSerialize(write_to_buffer)
    c2s_request_team_list_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_request_team_list = 6
secret_tower_decoder.S2C_REQUEST_TEAM_LIST = 6
local s2c_request_team_list_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_team_list_pb or secret_tower_pb.S2CRequestTeamListProto()

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

-- local s2c_fail_request_team_list = 7
secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_LIST = 7
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_create_team = 8
local c2s_create_team_pb


secret_tower_decoder.NewC2sCreateTeamMsg = function(secret_tower_id, captain_id, is_guild)



    if not c2s_create_team_pb then c2s_create_team_pb = secret_tower_pb.C2SCreateTeamProto() end

    
    c2s_create_team_pb.secret_tower_id = secret_tower_id
    for k,v in pairs(captain_id) do table.insert(c2s_create_team_pb.captain_id,v) end
    c2s_create_team_pb.is_guild = is_guild
    buffer[4] = char(22)
    buffer[5] = char(8)


    move_offset(5)
    c2s_create_team_pb:_InternalSerialize(write_to_buffer)
    c2s_create_team_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_create_team = 9
secret_tower_decoder.S2C_CREATE_TEAM = 9
local s2c_create_team_pb
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_create_team_pb or secret_tower_pb.S2CCreateTeamProto()

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

-- local s2c_fail_create_team = 10
secret_tower_decoder.S2C_FAIL_CREATE_TEAM = 10
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_join_team = 11
local c2s_join_team_pb


secret_tower_decoder.NewC2sJoinTeamMsg = function(team_id, captain_id)



    if not c2s_join_team_pb then c2s_join_team_pb = secret_tower_pb.C2SJoinTeamProto() end

    
    c2s_join_team_pb.team_id = team_id
    for k,v in pairs(captain_id) do table.insert(c2s_join_team_pb.captain_id,v) end
    buffer[4] = char(22)
    buffer[5] = char(11)


    move_offset(5)
    c2s_join_team_pb:_InternalSerialize(write_to_buffer)
    c2s_join_team_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_join_team = 12
secret_tower_decoder.S2C_JOIN_TEAM = 12
local s2c_join_team_pb
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_join_team_pb or secret_tower_pb.S2CJoinTeamProto()

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
-- local s2c_other_join_join_team = 13
secret_tower_decoder.S2C_OTHER_JOIN_JOIN_TEAM = 13
local s2c_other_join_join_team_pb
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_other_join_join_team_pb or secret_tower_pb.S2COtherJoinJoinTeamProto()

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

-- local s2c_fail_join_team = 14
secret_tower_decoder.S2C_FAIL_JOIN_TEAM = 14
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_leave_team = 15
local c2s_leave_team_pb

secret_tower_decoder.C2S_LEAVE_TEAM = function()
	if c2s_leave_team_pb then return c2s_leave_team_pb end
    buffer[4] = char(22)
    buffer[5] = char(15)
    c2s_leave_team_pb = concat(buffer, '', 1, 5)    return c2s_leave_team_pb
end

-- local s2c_leave_team = 16
secret_tower_decoder.S2C_LEAVE_TEAM = 16
local s2c_leave_team_pb
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end
-- local s2c_other_leave_leave_team = 17
secret_tower_decoder.S2C_OTHER_LEAVE_LEAVE_TEAM = 17
local s2c_other_leave_leave_team_pb
decoder[17] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_other_leave_leave_team_pb or secret_tower_pb.S2COtherLeaveLeaveTeamProto()

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

-- local s2c_fail_leave_team = 18
secret_tower_decoder.S2C_FAIL_LEAVE_TEAM = 18
decoder[18] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_kick_member = 19
local c2s_kick_member_pb


secret_tower_decoder.NewC2sKickMemberMsg = function(id)



    if not c2s_kick_member_pb then c2s_kick_member_pb = secret_tower_pb.C2SKickMemberProto() end

    
    c2s_kick_member_pb.id = id
    buffer[4] = char(22)
    buffer[5] = char(19)


    move_offset(5)
    c2s_kick_member_pb:_InternalSerialize(write_to_buffer)
    c2s_kick_member_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_kick_member = 20
secret_tower_decoder.S2C_KICK_MEMBER = 20
local s2c_kick_member_pb
decoder[20] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_kick_member_pb or secret_tower_pb.S2CKickMemberProto()

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
-- local s2c_you_been_kicked_kick_member = 21
secret_tower_decoder.S2C_YOU_BEEN_KICKED_KICK_MEMBER = 21
local s2c_you_been_kicked_kick_member_pb
decoder[21] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end
-- local s2c_other_been_kick_kick_member = 22
secret_tower_decoder.S2C_OTHER_BEEN_KICK_KICK_MEMBER = 22
local s2c_other_been_kick_kick_member_pb
decoder[22] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_other_been_kick_kick_member_pb or secret_tower_pb.S2COtherBeenKickKickMemberProto()

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

-- local s2c_fail_kick_member = 23
secret_tower_decoder.S2C_FAIL_KICK_MEMBER = 23
decoder[23] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_move_member = 24
local c2s_move_member_pb


secret_tower_decoder.NewC2sMoveMemberMsg = function(id, up)



    if not c2s_move_member_pb then c2s_move_member_pb = secret_tower_pb.C2SMoveMemberProto() end

    
    c2s_move_member_pb.id = id
    c2s_move_member_pb.up = up
    buffer[4] = char(22)
    buffer[5] = char(24)


    move_offset(5)
    c2s_move_member_pb:_InternalSerialize(write_to_buffer)
    c2s_move_member_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_broadcsat_move_member = 25
secret_tower_decoder.S2C_BROADCSAT_MOVE_MEMBER = 25
local s2c_broadcsat_move_member_pb
decoder[25] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_broadcsat_move_member_pb or secret_tower_pb.S2CBroadcsatMoveMemberProto()

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

-- local s2c_fail_move_member = 26
secret_tower_decoder.S2C_FAIL_MOVE_MEMBER = 26
decoder[26] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_change_mode = 27
local c2s_change_mode_pb


secret_tower_decoder.NewC2sChangeModeMsg = function(mode)



    if not c2s_change_mode_pb then c2s_change_mode_pb = secret_tower_pb.C2SChangeModeProto() end

    
    c2s_change_mode_pb.mode = mode
    buffer[4] = char(22)
    buffer[5] = char(27)


    move_offset(5)
    c2s_change_mode_pb:_InternalSerialize(write_to_buffer)
    c2s_change_mode_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_change_mode = 28
secret_tower_decoder.S2C_CHANGE_MODE = 28
local s2c_change_mode_pb
decoder[28] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_change_mode_pb or secret_tower_pb.S2CChangeModeProto()

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
-- local s2c_other_changed_change_mode = 29
secret_tower_decoder.S2C_OTHER_CHANGED_CHANGE_MODE = 29
local s2c_other_changed_change_mode_pb
decoder[29] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_other_changed_change_mode_pb or secret_tower_pb.S2COtherChangedChangeModeProto()

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

-- local s2c_fail_change_mode = 30
secret_tower_decoder.S2C_FAIL_CHANGE_MODE = 30
decoder[30] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_help_times_change = 31
secret_tower_decoder.S2C_HELP_TIMES_CHANGE = 31
local s2c_help_times_change_pb
decoder[31] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_help_times_change_pb or secret_tower_pb.S2CHelpTimesChangeProto()

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

-- local s2c_times_change = 32
secret_tower_decoder.S2C_TIMES_CHANGE = 32
local s2c_times_change_pb
decoder[32] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_times_change_pb or secret_tower_pb.S2CTimesChangeProto()

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

-- local c2s_invite = 33
local c2s_invite_pb


secret_tower_decoder.NewC2sInviteMsg = function(id)



    if not c2s_invite_pb then c2s_invite_pb = secret_tower_pb.C2SInviteProto() end

    
    c2s_invite_pb.id = id
    buffer[4] = char(22)
    buffer[5] = char(33)


    move_offset(5)
    c2s_invite_pb:_InternalSerialize(write_to_buffer)
    c2s_invite_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_invite = 34
secret_tower_decoder.S2C_INVITE = 34
local s2c_invite_pb
decoder[34] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_invite_pb or secret_tower_pb.S2CInviteProto()

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
-- local s2c_fail_target_not_found_invite = 51
secret_tower_decoder.S2C_FAIL_TARGET_NOT_FOUND_INVITE = 51
local s2c_fail_target_not_found_invite_pb
decoder[51] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_target_not_found_invite_pb or secret_tower_pb.S2CFailTargetNotFoundInviteProto()

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
-- local s2c_fail_target_not_in_my_guild_invite = 52
secret_tower_decoder.S2C_FAIL_TARGET_NOT_IN_MY_GUILD_INVITE = 52
local s2c_fail_target_not_in_my_guild_invite_pb
decoder[52] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_target_not_in_my_guild_invite_pb or secret_tower_pb.S2CFailTargetNotInMyGuildInviteProto()

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
-- local s2c_fail_target_not_open_invite = 53
secret_tower_decoder.S2C_FAIL_TARGET_NOT_OPEN_INVITE = 53
local s2c_fail_target_not_open_invite_pb
decoder[53] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_target_not_open_invite_pb or secret_tower_pb.S2CFailTargetNotOpenInviteProto()

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
-- local s2c_fail_target_not_online_invite = 54
secret_tower_decoder.S2C_FAIL_TARGET_NOT_ONLINE_INVITE = 54
local s2c_fail_target_not_online_invite_pb
decoder[54] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_target_not_online_invite_pb or secret_tower_pb.S2CFailTargetNotOnlineInviteProto()

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
-- local s2c_fail_target_in_your_team_invite = 55
secret_tower_decoder.S2C_FAIL_TARGET_IN_YOUR_TEAM_INVITE = 55
local s2c_fail_target_in_your_team_invite_pb
decoder[55] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_target_in_your_team_invite_pb or secret_tower_pb.S2CFailTargetInYourTeamInviteProto()

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
-- local s2c_fail_target_no_times_invite = 56
secret_tower_decoder.S2C_FAIL_TARGET_NO_TIMES_INVITE = 56
local s2c_fail_target_no_times_invite_pb
decoder[56] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_target_no_times_invite_pb or secret_tower_pb.S2CFailTargetNoTimesInviteProto()

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

-- local s2c_fail_invite = 35
secret_tower_decoder.S2C_FAIL_INVITE = 35
decoder[35] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_receive_invite = 36
secret_tower_decoder.S2C_RECEIVE_INVITE = 36
local s2c_receive_invite_pb
decoder[36] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_receive_invite_pb or secret_tower_pb.S2CReceiveInviteProto()

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

-- local c2s_request_invite_list = 37
local c2s_request_invite_list_pb

secret_tower_decoder.C2S_REQUEST_INVITE_LIST = function()
	if c2s_request_invite_list_pb then return c2s_request_invite_list_pb end
    buffer[4] = char(22)
    buffer[5] = char(37)
    c2s_request_invite_list_pb = concat(buffer, '', 1, 5)    return c2s_request_invite_list_pb
end

-- local s2c_request_invite_list = 38
secret_tower_decoder.S2C_REQUEST_INVITE_LIST = 38
local s2c_request_invite_list_pb
decoder[38] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_invite_list_pb or secret_tower_pb.S2CRequestInviteListProto()

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

-- local c2s_request_team_detail = 39
local c2s_request_team_detail_pb

secret_tower_decoder.C2S_REQUEST_TEAM_DETAIL = function()
	if c2s_request_team_detail_pb then return c2s_request_team_detail_pb end
    buffer[4] = char(22)
    buffer[5] = char(39)
    c2s_request_team_detail_pb = concat(buffer, '', 1, 5)    return c2s_request_team_detail_pb
end

-- local s2c_request_team_detail = 40
secret_tower_decoder.S2C_REQUEST_TEAM_DETAIL = 40
local s2c_request_team_detail_pb
decoder[40] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_team_detail_pb or secret_tower_pb.S2CRequestTeamDetailProto()

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

-- local s2c_fail_request_team_detail = 41
secret_tower_decoder.S2C_FAIL_REQUEST_TEAM_DETAIL = 41
decoder[41] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_start_challenge = 42
local c2s_start_challenge_pb

secret_tower_decoder.C2S_START_CHALLENGE = function()
	if c2s_start_challenge_pb then return c2s_start_challenge_pb end
    buffer[4] = char(22)
    buffer[5] = char(42)
    c2s_start_challenge_pb = concat(buffer, '', 1, 5)    return c2s_start_challenge_pb
end

-- local s2c_broadcast_start_challenge = 43
secret_tower_decoder.S2C_BROADCAST_START_CHALLENGE = 43
local s2c_broadcast_start_challenge_pb
decoder[43] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_broadcast_start_challenge_pb or secret_tower_pb.S2CBroadcastStartChallengeProto()

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
-- local s2c_fail_with_member_times_not_enough_start_challenge = 44
secret_tower_decoder.S2C_FAIL_WITH_MEMBER_TIMES_NOT_ENOUGH_START_CHALLENGE = 44
local s2c_fail_with_member_times_not_enough_start_challenge_pb
decoder[44] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_with_member_times_not_enough_start_challenge_pb or secret_tower_pb.S2CFailWithMemberTimesNotEnoughStartChallengeProto()

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
-- local s2c_fail_with_member_help_times_not_enough_start_challenge = 45
secret_tower_decoder.S2C_FAIL_WITH_MEMBER_HELP_TIMES_NOT_ENOUGH_START_CHALLENGE = 45
local s2c_fail_with_member_help_times_not_enough_start_challenge_pb
decoder[45] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_with_member_help_times_not_enough_start_challenge_pb or secret_tower_pb.S2CFailWithMemberHelpTimesNotEnoughStartChallengeProto()

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
-- local s2c_fail_with_member_no_guild_start_challenge = 46
secret_tower_decoder.S2C_FAIL_WITH_MEMBER_NO_GUILD_START_CHALLENGE = 46
local s2c_fail_with_member_no_guild_start_challenge_pb
decoder[46] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_with_member_no_guild_start_challenge_pb or secret_tower_pb.S2CFailWithMemberNoGuildStartChallengeProto()

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
-- local s2c_fail_with_member_not_my_guild_start_challenge = 47
secret_tower_decoder.S2C_FAIL_WITH_MEMBER_NOT_MY_GUILD_START_CHALLENGE = 47
local s2c_fail_with_member_not_my_guild_start_challenge_pb
decoder[47] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_with_member_not_my_guild_start_challenge_pb or secret_tower_pb.S2CFailWithMemberNotMyGuildStartChallengeProto()

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
-- local s2c_fail_with_member_is_help_but_no_guild_start_challenge = 48
secret_tower_decoder.S2C_FAIL_WITH_MEMBER_IS_HELP_BUT_NO_GUILD_START_CHALLENGE = 48
local s2c_fail_with_member_is_help_but_no_guild_start_challenge_pb
decoder[48] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_with_member_is_help_but_no_guild_start_challenge_pb or secret_tower_pb.S2CFailWithMemberIsHelpButNoGuildStartChallengeProto()

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
-- local s2c_fail_with_member_is_help_but_no_guild_member_start_challenge = 49
secret_tower_decoder.S2C_FAIL_WITH_MEMBER_IS_HELP_BUT_NO_GUILD_MEMBER_START_CHALLENGE = 49
local s2c_fail_with_member_is_help_but_no_guild_member_start_challenge_pb
decoder[49] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fail_with_member_is_help_but_no_guild_member_start_challenge_pb or secret_tower_pb.S2CFailWithMemberIsHelpButNoGuildMemberStartChallengeProto()

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

-- local s2c_fail_start_challenge = 50
secret_tower_decoder.S2C_FAIL_START_CHALLENGE = 50
decoder[50] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


secret_tower_decoder.Decoder = decoder

return secret_tower_decoder

