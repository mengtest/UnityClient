

require "autogen.region_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 7
region_decoder = {}
region_decoder.ModuleID = ModuleID
region_decoder.ModuleName = "region"

local decoder = {}
local handler = {}

region_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_switch_action = 46
local c2s_switch_action_pb


region_decoder.NewC2sSwitchActionMsg = function(open)



    if not c2s_switch_action_pb then c2s_switch_action_pb = region_pb.C2SSwitchActionProto() end

    
    c2s_switch_action_pb.open = open
    buffer[4] = char(7)
    buffer[5] = char(46)


    move_offset(5)
    c2s_switch_action_pb:_InternalSerialize(write_to_buffer)
    c2s_switch_action_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_switch_action = 47
region_decoder.S2C_SWITCH_ACTION = 47
local s2c_switch_action_pb
decoder[47] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_switch_action_pb or region_pb.S2CSwitchActionProto()

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

-- local c2s_switch_map = 43
local c2s_switch_map_pb


region_decoder.NewC2sSwitchMapMsg = function(map_id)



    if not c2s_switch_map_pb then c2s_switch_map_pb = region_pb.C2SSwitchMapProto() end

    
    c2s_switch_map_pb.map_id = map_id
    buffer[4] = char(7)
    buffer[5] = char(43)


    move_offset(5)
    c2s_switch_map_pb:_InternalSerialize(write_to_buffer)
    c2s_switch_map_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_switch_map = 44
region_decoder.S2C_SWITCH_MAP = 44
local s2c_switch_map_pb
decoder[44] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_switch_map_pb or region_pb.S2CSwitchMapProto()

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

-- local s2c_fail_switch_map = 48
region_decoder.S2C_FAIL_SWITCH_MAP = 48
decoder[48] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_base_info = 18
region_decoder.S2C_BASE_INFO = 18
local s2c_base_info_pb
decoder[18] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_base_info_pb or region_pb.S2CBaseInfoProto()

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

-- local s2c_fail_base_info = 27
region_decoder.S2C_FAIL_BASE_INFO = 27
decoder[27] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_base_defenser = 74
region_decoder.S2C_UPDATE_BASE_DEFENSER = 74
local s2c_update_base_defenser_pb
decoder[74] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_base_defenser_pb or region_pb.S2CUpdateBaseDefenserProto()

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

-- local s2c_init_invate_tent = 75
region_decoder.S2C_INIT_INVATE_TENT = 75
local s2c_init_invate_tent_pb
decoder[75] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_init_invate_tent_pb or region_pb.S2CInitInvateTentProto()

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

-- local s2c_add_invate_tent = 76
region_decoder.S2C_ADD_INVATE_TENT = 76
local s2c_add_invate_tent_pb
decoder[76] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_add_invate_tent_pb or region_pb.S2CAddInvateTentProto()

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

-- local s2c_remove_invate_tent = 77
region_decoder.S2C_REMOVE_INVATE_TENT = 77
local s2c_remove_invate_tent_pb
decoder[77] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_remove_invate_tent_pb or region_pb.S2CRemoveInvateTentProto()

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

-- local s2c_remove_base = 19
region_decoder.S2C_REMOVE_BASE = 19
local s2c_remove_base_pb
decoder[19] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_remove_base_pb or region_pb.S2CRemoveBaseProto()

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

-- local s2c_update_base_info = 20
region_decoder.S2C_UPDATE_BASE_INFO = 20
local s2c_update_base_info_pb
decoder[20] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_base_info_pb or region_pb.S2CUpdateBaseInfoProto()

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

-- local s2c_update_self_mian_disappear_time = 90
region_decoder.S2C_UPDATE_SELF_MIAN_DISAPPEAR_TIME = 90
local s2c_update_self_mian_disappear_time_pb
decoder[90] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_self_mian_disappear_time_pb or region_pb.S2CUpdateSelfMianDisappearTimeProto()

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

-- local c2s_use_mian_goods = 91
local c2s_use_mian_goods_pb


region_decoder.NewC2sUseMianGoodsMsg = function(id)



    if not c2s_use_mian_goods_pb then c2s_use_mian_goods_pb = region_pb.C2SUseMianGoodsProto() end

    
    c2s_use_mian_goods_pb.id = id
    buffer[4] = char(7)
    buffer[5] = char(91)


    move_offset(5)
    c2s_use_mian_goods_pb:_InternalSerialize(write_to_buffer)
    c2s_use_mian_goods_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_use_mian_goods = 92
region_decoder.S2C_USE_MIAN_GOODS = 92
local s2c_use_mian_goods_pb
decoder[92] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_use_mian_goods_pb or region_pb.S2CUseMianGoodsProto()

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

-- local s2c_fail_use_mian_goods = 93
region_decoder.S2C_FAIL_USE_MIAN_GOODS = 93
decoder[93] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_base_prosperity = 80
region_decoder.S2C_UPDATE_BASE_PROSPERITY = 80
local s2c_update_base_prosperity_pb
decoder[80] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_base_prosperity_pb or region_pb.S2CUpdateBaseProsperityProto()

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

-- local c2s_create_base = 1
local c2s_create_base_pb


region_decoder.NewC2sCreateBaseMsg = function(map_id, new_x, new_y)



    if not c2s_create_base_pb then c2s_create_base_pb = region_pb.C2SCreateBaseProto() end

    
    c2s_create_base_pb.map_id = map_id
    c2s_create_base_pb.new_x = new_x
    c2s_create_base_pb.new_y = new_y
    buffer[4] = char(7)
    buffer[5] = char(1)


    move_offset(5)
    c2s_create_base_pb:_InternalSerialize(write_to_buffer)
    c2s_create_base_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_create_base = 2
region_decoder.S2C_CREATE_BASE = 2
local s2c_create_base_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_create_base_pb or region_pb.S2CCreateBaseProto()

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

-- local s2c_fail_create_base = 3
region_decoder.S2C_FAIL_CREATE_BASE = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_slowly_move_base = 5
local c2s_slowly_move_base_pb


region_decoder.NewC2sSlowlyMoveBaseMsg = function(map_id, new_x, new_y)



    if not c2s_slowly_move_base_pb then c2s_slowly_move_base_pb = region_pb.C2SSlowlyMoveBaseProto() end

    
    c2s_slowly_move_base_pb.map_id = map_id
    c2s_slowly_move_base_pb.new_x = new_x
    c2s_slowly_move_base_pb.new_y = new_y
    buffer[4] = char(7)
    buffer[5] = char(5)


    move_offset(5)
    c2s_slowly_move_base_pb:_InternalSerialize(write_to_buffer)
    c2s_slowly_move_base_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_slowly_move_base = 6
region_decoder.S2C_SLOWLY_MOVE_BASE = 6
local s2c_slowly_move_base_pb
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_slowly_move_base_pb or region_pb.S2CSlowlyMoveBaseProto()

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

-- local s2c_fail_slowly_move_base = 7
region_decoder.S2C_FAIL_SLOWLY_MOVE_BASE = 7
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_cancel_slowly_move_base = 12
local c2s_cancel_slowly_move_base_pb

region_decoder.C2S_CANCEL_SLOWLY_MOVE_BASE = function()
	if c2s_cancel_slowly_move_base_pb then return c2s_cancel_slowly_move_base_pb end
    buffer[4] = char(7)
    buffer[5] = char(12)
    c2s_cancel_slowly_move_base_pb = concat(buffer, '', 1, 5)    return c2s_cancel_slowly_move_base_pb
end

-- local s2c_cancel_slowly_move_base = 13
region_decoder.S2C_CANCEL_SLOWLY_MOVE_BASE = 13
local s2c_cancel_slowly_move_base_pb
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_cancel_slowly_move_base = 38
region_decoder.S2C_FAIL_CANCEL_SLOWLY_MOVE_BASE = 38
decoder[38] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_slowly_move_base_result = 33
region_decoder.S2C_SLOWLY_MOVE_BASE_RESULT = 33
local s2c_slowly_move_base_result_pb
decoder[33] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_slowly_move_base_result_pb or region_pb.S2CSlowlyMoveBaseResultProto()

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

-- local c2s_fast_move_base = 14
local c2s_fast_move_base_pb


region_decoder.NewC2sFastMoveBaseMsg = function(map_id, new_x, new_y, goods_id, is_tent)



    if not c2s_fast_move_base_pb then c2s_fast_move_base_pb = region_pb.C2SFastMoveBaseProto() end

    
    c2s_fast_move_base_pb.map_id = map_id
    c2s_fast_move_base_pb.new_x = new_x
    c2s_fast_move_base_pb.new_y = new_y
    c2s_fast_move_base_pb.goods_id = goods_id
    c2s_fast_move_base_pb.is_tent = is_tent
    buffer[4] = char(7)
    buffer[5] = char(14)


    move_offset(5)
    c2s_fast_move_base_pb:_InternalSerialize(write_to_buffer)
    c2s_fast_move_base_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_fast_move_base = 15
region_decoder.S2C_FAST_MOVE_BASE = 15
local s2c_fast_move_base_pb
decoder[15] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_fast_move_base_pb or region_pb.S2CFastMoveBaseProto()

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

-- local s2c_fail_fast_move_base = 16
region_decoder.S2C_FAIL_FAST_MOVE_BASE = 16
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade_base = 40
local c2s_upgrade_base_pb

region_decoder.C2S_UPGRADE_BASE = function()
	if c2s_upgrade_base_pb then return c2s_upgrade_base_pb end
    buffer[4] = char(7)
    buffer[5] = char(40)
    c2s_upgrade_base_pb = concat(buffer, '', 1, 5)    return c2s_upgrade_base_pb
end

-- local s2c_upgrade_base = 41
region_decoder.S2C_UPGRADE_BASE = 41
local s2c_upgrade_base_pb
decoder[41] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_upgrade_base = 42
region_decoder.S2C_FAIL_UPGRADE_BASE = 42
decoder[42] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_self_update_base_level = 52
region_decoder.S2C_SELF_UPDATE_BASE_LEVEL = 52
local s2c_self_update_base_level_pb
decoder[52] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_self_update_base_level_pb or region_pb.S2CSelfUpdateBaseLevelProto()

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

-- local s2c_resource_building_conflic = 11
region_decoder.S2C_RESOURCE_BUILDING_CONFLIC = 11
local s2c_resource_building_conflic_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_resource_building_conflic_pb or region_pb.S2CResourceBuildingConflicProto()

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

-- local s2c_military_info = 21
region_decoder.S2C_MILITARY_INFO = 21
local s2c_military_info_pb
decoder[21] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_military_info_pb or region_pb.S2CMilitaryInfoProto()

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

-- local s2c_map_military_info = 45
region_decoder.S2C_MAP_MILITARY_INFO = 45
local s2c_map_military_info_pb
decoder[45] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_map_military_info_pb or region_pb.S2CMapMilitaryInfoProto()

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

-- local s2c_update_military_info = 22
region_decoder.S2C_UPDATE_MILITARY_INFO = 22
local s2c_update_military_info_pb
decoder[22] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_military_info_pb or region_pb.S2CUpdateMilitaryInfoProto()

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

-- local s2c_remove_military_info = 23
region_decoder.S2C_REMOVE_MILITARY_INFO = 23
local s2c_remove_military_info_pb
decoder[23] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_remove_military_info_pb or region_pb.S2CRemoveMilitaryInfoProto()

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

-- local s2c_update_self_military_info = 50
region_decoder.S2C_UPDATE_SELF_MILITARY_INFO = 50
local s2c_update_self_military_info_pb
decoder[50] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_self_military_info_pb or region_pb.S2CUpdateSelfMilitaryInfoProto()

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

-- local s2c_remove_self_military_info = 51
region_decoder.S2C_REMOVE_SELF_MILITARY_INFO = 51
local s2c_remove_self_military_info_pb
decoder[51] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_remove_self_military_info_pb or region_pb.S2CRemoveSelfMilitaryInfoProto()

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

-- local s2c_update_defending_military_info = 78
region_decoder.S2C_UPDATE_DEFENDING_MILITARY_INFO = 78
local s2c_update_defending_military_info_pb
decoder[78] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_defending_military_info_pb or region_pb.S2CUpdateDefendingMilitaryInfoProto()

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

-- local s2c_remove_defending_military_info = 79
region_decoder.S2C_REMOVE_DEFENDING_MILITARY_INFO = 79
local s2c_remove_defending_military_info_pb
decoder[79] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_remove_defending_military_info_pb or region_pb.S2CRemoveDefendingMilitaryInfoProto()

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

-- local c2s_invasion = 24
local c2s_invasion_pb


region_decoder.NewC2sInvasionMsg = function(invation, target, map_id, troop_index)



    if not c2s_invasion_pb then c2s_invasion_pb = region_pb.C2SInvasionProto() end

    
    c2s_invasion_pb.invation = invation
    c2s_invasion_pb.target = target
    c2s_invasion_pb.map_id = map_id
    c2s_invasion_pb.troop_index = troop_index
    buffer[4] = char(7)
    buffer[5] = char(24)


    move_offset(5)
    c2s_invasion_pb:_InternalSerialize(write_to_buffer)
    c2s_invasion_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_invasion = 25
region_decoder.S2C_INVASION = 25
local s2c_invasion_pb
decoder[25] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_invasion_pb or region_pb.S2CInvasionProto()

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

-- local s2c_fail_invasion = 34
region_decoder.S2C_FAIL_INVASION = 34
decoder[34] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_remove_troop_outside = 81
region_decoder.S2C_REMOVE_TROOP_OUTSIDE = 81
local s2c_remove_troop_outside_pb
decoder[81] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_remove_troop_outside_pb or region_pb.S2CRemoveTroopOutsideProto()

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

-- local s2c_update_self_troops = 56
region_decoder.S2C_UPDATE_SELF_TROOPS = 56
local s2c_update_self_troops_pb
decoder[56] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_self_troops_pb or region_pb.S2CUpdateSelfTroopsProto()

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

-- local c2s_cancel_invasion = 26
local c2s_cancel_invasion_pb


region_decoder.NewC2sCancelInvasionMsg = function(id)



    if not c2s_cancel_invasion_pb then c2s_cancel_invasion_pb = region_pb.C2SCancelInvasionProto() end

    
    c2s_cancel_invasion_pb.id = id
    buffer[4] = char(7)
    buffer[5] = char(26)


    move_offset(5)
    c2s_cancel_invasion_pb:_InternalSerialize(write_to_buffer)
    c2s_cancel_invasion_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_cancel_invasion = 28
region_decoder.S2C_CANCEL_INVASION = 28
local s2c_cancel_invasion_pb
decoder[28] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_cancel_invasion_pb or region_pb.S2CCancelInvasionProto()

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

-- local s2c_fail_cancel_invasion = 29
region_decoder.S2C_FAIL_CANCEL_INVASION = 29
decoder[29] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_repatriate = 71
local c2s_repatriate_pb


region_decoder.NewC2sRepatriateMsg = function(id, is_tent)



    if not c2s_repatriate_pb then c2s_repatriate_pb = region_pb.C2SRepatriateProto() end

    
    c2s_repatriate_pb.id = id
    c2s_repatriate_pb.is_tent = is_tent
    buffer[4] = char(7)
    buffer[5] = char(71)


    move_offset(5)
    c2s_repatriate_pb:_InternalSerialize(write_to_buffer)
    c2s_repatriate_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_repatriate = 72
region_decoder.S2C_REPATRIATE = 72
local s2c_repatriate_pb
decoder[72] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_repatriate_pb or region_pb.S2CRepatriateProto()

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

-- local s2c_fail_repatriate = 73
region_decoder.S2C_FAIL_REPATRIATE = 73
decoder[73] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_expel = 30
local c2s_expel_pb


region_decoder.NewC2sExpelMsg = function(id, mapid, troop_index)



    if not c2s_expel_pb then c2s_expel_pb = region_pb.C2SExpelProto() end

    
    c2s_expel_pb.id = id
    c2s_expel_pb.mapid = mapid
    c2s_expel_pb.troop_index = troop_index
    buffer[4] = char(7)
    buffer[5] = char(30)


    move_offset(5)
    c2s_expel_pb:_InternalSerialize(write_to_buffer)
    c2s_expel_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_expel = 31
region_decoder.S2C_EXPEL = 31
local s2c_expel_pb
decoder[31] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_expel_pb or region_pb.S2CExpelProto()

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

-- local s2c_fail_expel = 32
region_decoder.S2C_FAIL_EXPEL = 32
decoder[32] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_new_tent = 53
local c2s_new_tent_pb


region_decoder.NewC2sNewTentMsg = function(map_id, new_x, new_y)



    if not c2s_new_tent_pb then c2s_new_tent_pb = region_pb.C2SNewTentProto() end

    
    c2s_new_tent_pb.map_id = map_id
    c2s_new_tent_pb.new_x = new_x
    c2s_new_tent_pb.new_y = new_y
    buffer[4] = char(7)
    buffer[5] = char(53)


    move_offset(5)
    c2s_new_tent_pb:_InternalSerialize(write_to_buffer)
    c2s_new_tent_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_new_tent = 54
region_decoder.S2C_NEW_TENT = 54
local s2c_new_tent_pb
decoder[54] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_new_tent_pb or region_pb.S2CNewTentProto()

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

-- local s2c_fail_new_tent = 55
region_decoder.S2C_FAIL_NEW_TENT = 55
decoder[55] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_miao_tent_building_cd = 82
local c2s_miao_tent_building_cd_pb

region_decoder.C2S_MIAO_TENT_BUILDING_CD = function()
	if c2s_miao_tent_building_cd_pb then return c2s_miao_tent_building_cd_pb end
    buffer[4] = char(7)
    buffer[5] = char(82)
    c2s_miao_tent_building_cd_pb = concat(buffer, '', 1, 5)    return c2s_miao_tent_building_cd_pb
end

-- local s2c_miao_tent_building_cd = 83
region_decoder.S2C_MIAO_TENT_BUILDING_CD = 83
local s2c_miao_tent_building_cd_pb
decoder[83] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_miao_tent_building_cd = 84
region_decoder.S2C_FAIL_MIAO_TENT_BUILDING_CD = 84
decoder[84] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_remove_tent = 59
local c2s_remove_tent_pb

region_decoder.C2S_REMOVE_TENT = function()
	if c2s_remove_tent_pb then return c2s_remove_tent_pb end
    buffer[4] = char(7)
    buffer[5] = char(59)
    c2s_remove_tent_pb = concat(buffer, '', 1, 5)    return c2s_remove_tent_pb
end

-- local s2c_remove_tent = 60
region_decoder.S2C_REMOVE_TENT = 60
local s2c_remove_tent_pb
decoder[60] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_remove_tent = 61
region_decoder.S2C_FAIL_REMOVE_TENT = 61
decoder[61] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_tent_info = 70
region_decoder.S2C_UPDATE_TENT_INFO = 70
local s2c_update_tent_info_pb
decoder[70] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_tent_info_pb or region_pb.S2CUpdateTentInfoProto()

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

-- local c2s_region_level_count = 62
local c2s_region_level_count_pb

region_decoder.C2S_REGION_LEVEL_COUNT = function()
	if c2s_region_level_count_pb then return c2s_region_level_count_pb end
    buffer[4] = char(7)
    buffer[5] = char(62)
    c2s_region_level_count_pb = concat(buffer, '', 1, 5)    return c2s_region_level_count_pb
end

-- local s2c_region_level_count = 63
region_decoder.S2C_REGION_LEVEL_COUNT = 63
local s2c_region_level_count_pb
decoder[63] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_region_level_count_pb or region_pb.S2CRegionLevelCountProto()

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

-- local s2c_update_tent_prosperity = 64
region_decoder.S2C_UPDATE_TENT_PROSPERITY = 64
local s2c_update_tent_prosperity_pb
decoder[64] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_tent_prosperity_pb or region_pb.S2CUpdateTentProsperityProto()

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

-- local s2c_update_tent_repair_amount = 66
region_decoder.S2C_UPDATE_TENT_REPAIR_AMOUNT = 66
local s2c_update_tent_repair_amount_pb
decoder[66] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_tent_repair_amount_pb or region_pb.S2CUpdateTentRepairAmountProto()

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

-- local c2s_repair_tent = 67
local c2s_repair_tent_pb

region_decoder.C2S_REPAIR_TENT = function()
	if c2s_repair_tent_pb then return c2s_repair_tent_pb end
    buffer[4] = char(7)
    buffer[5] = char(67)
    c2s_repair_tent_pb = concat(buffer, '', 1, 5)    return c2s_repair_tent_pb
end

-- local s2c_repair_tent = 68
region_decoder.S2C_REPAIR_TENT = 68
local s2c_repair_tent_pb
decoder[68] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_repair_tent_pb or region_pb.S2CRepairTentProto()

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

-- local s2c_fail_repair_tent = 69
region_decoder.S2C_FAIL_REPAIR_TENT = 69
decoder[69] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_white_flag = 85
region_decoder.S2C_UPDATE_WHITE_FLAG = 85
local s2c_update_white_flag_pb
decoder[85] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_white_flag_pb or region_pb.S2CUpdateWhiteFlagProto()

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

-- local c2s_white_flag_detail = 86
local c2s_white_flag_detail_pb


region_decoder.NewC2sWhiteFlagDetailMsg = function(hero_id)



    if not c2s_white_flag_detail_pb then c2s_white_flag_detail_pb = region_pb.C2SWhiteFlagDetailProto() end

    
    c2s_white_flag_detail_pb.hero_id = hero_id
    buffer[4] = char(7)
    buffer[5] = char(86)


    move_offset(5)
    c2s_white_flag_detail_pb:_InternalSerialize(write_to_buffer)
    c2s_white_flag_detail_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_white_flag_detail = 87
region_decoder.S2C_WHITE_FLAG_DETAIL = 87
local s2c_white_flag_detail_pb
decoder[87] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_white_flag_detail_pb or region_pb.S2CWhiteFlagDetailProto()

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

-- local s2c_fail_white_flag_detail = 88
region_decoder.S2C_FAIL_WHITE_FLAG_DETAIL = 88
decoder[88] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_military_tips = 89
region_decoder.S2C_UPDATE_MILITARY_TIPS = 89
local s2c_update_military_tips_pb
decoder[89] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_military_tips_pb or region_pb.S2CUpdateMilitaryTipsProto()

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


region_decoder.Decoder = decoder

return region_decoder

