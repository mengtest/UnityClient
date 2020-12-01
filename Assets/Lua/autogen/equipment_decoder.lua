

require "autogen.equipment_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 12
equipment_decoder = {}
equipment_decoder.ModuleID = ModuleID
equipment_decoder.ModuleName = "equipment"

local decoder = {}
local handler = {}

equipment_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local s2c_add_equipment = 18
equipment_decoder.S2C_ADD_EQUIPMENT = 18
local s2c_add_equipment_pb
decoder[18] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_add_equipment_pb or equipment_pb.S2CAddEquipmentProto()

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

-- local s2c_add_equipment_with_expire_time = 34
equipment_decoder.S2C_ADD_EQUIPMENT_WITH_EXPIRE_TIME = 34
local s2c_add_equipment_with_expire_time_pb
decoder[34] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_add_equipment_with_expire_time_pb or equipment_pb.S2CAddEquipmentWithExpireTimeProto()

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

-- local c2s_wear_equipment = 1
local c2s_wear_equipment_pb


equipment_decoder.NewC2sWearEquipmentMsg = function(captain_id, equipment_id, down)



    if not c2s_wear_equipment_pb then c2s_wear_equipment_pb = equipment_pb.C2SWearEquipmentProto() end

    
    c2s_wear_equipment_pb.captain_id = captain_id
    c2s_wear_equipment_pb.equipment_id = equipment_id
    c2s_wear_equipment_pb.down = down
    buffer[4] = char(12)
    buffer[5] = char(1)


    move_offset(5)
    c2s_wear_equipment_pb:_InternalSerialize(write_to_buffer)
    c2s_wear_equipment_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_wear_equipment = 2
equipment_decoder.S2C_WEAR_EQUIPMENT = 2
local s2c_wear_equipment_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_wear_equipment_pb or equipment_pb.S2CWearEquipmentProto()

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

-- local s2c_fail_wear_equipment = 3
equipment_decoder.S2C_FAIL_WEAR_EQUIPMENT = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade_equipment = 4
local c2s_upgrade_equipment_pb


equipment_decoder.NewC2sUpgradeEquipmentMsg = function(captain_id, equipment_id, upgrade_times)



    if not c2s_upgrade_equipment_pb then c2s_upgrade_equipment_pb = equipment_pb.C2SUpgradeEquipmentProto() end

    
    c2s_upgrade_equipment_pb.captain_id = captain_id
    c2s_upgrade_equipment_pb.equipment_id = equipment_id
    c2s_upgrade_equipment_pb.upgrade_times = upgrade_times
    buffer[4] = char(12)
    buffer[5] = char(4)


    move_offset(5)
    c2s_upgrade_equipment_pb:_InternalSerialize(write_to_buffer)
    c2s_upgrade_equipment_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_upgrade_equipment = 5
equipment_decoder.S2C_UPGRADE_EQUIPMENT = 5
local s2c_upgrade_equipment_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_upgrade_equipment_pb or equipment_pb.S2CUpgradeEquipmentProto()

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

-- local s2c_fail_upgrade_equipment = 6
equipment_decoder.S2C_FAIL_UPGRADE_EQUIPMENT = 6
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade_equipment_all = 19
local c2s_upgrade_equipment_all_pb


equipment_decoder.NewC2sUpgradeEquipmentAllMsg = function(captain_id)



    if not c2s_upgrade_equipment_all_pb then c2s_upgrade_equipment_all_pb = equipment_pb.C2SUpgradeEquipmentAllProto() end

    
    c2s_upgrade_equipment_all_pb.captain_id = captain_id
    buffer[4] = char(12)
    buffer[5] = char(19)


    move_offset(5)
    c2s_upgrade_equipment_all_pb:_InternalSerialize(write_to_buffer)
    c2s_upgrade_equipment_all_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_upgrade_equipment_all = 20
equipment_decoder.S2C_UPGRADE_EQUIPMENT_ALL = 20
local s2c_upgrade_equipment_all_pb
decoder[20] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_upgrade_equipment_all_pb or equipment_pb.S2CUpgradeEquipmentAllProto()

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

-- local s2c_fail_upgrade_equipment_all = 21
equipment_decoder.S2C_FAIL_UPGRADE_EQUIPMENT_ALL = 21
decoder[21] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_refined_equipment = 7
local c2s_refined_equipment_pb


equipment_decoder.NewC2sRefinedEquipmentMsg = function(captain_id, equipment_id)



    if not c2s_refined_equipment_pb then c2s_refined_equipment_pb = equipment_pb.C2SRefinedEquipmentProto() end

    
    c2s_refined_equipment_pb.captain_id = captain_id
    c2s_refined_equipment_pb.equipment_id = equipment_id
    buffer[4] = char(12)
    buffer[5] = char(7)


    move_offset(5)
    c2s_refined_equipment_pb:_InternalSerialize(write_to_buffer)
    c2s_refined_equipment_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_refined_equipment = 8
equipment_decoder.S2C_REFINED_EQUIPMENT = 8
local s2c_refined_equipment_pb
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_refined_equipment_pb or equipment_pb.S2CRefinedEquipmentProto()

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

-- local s2c_fail_refined_equipment = 9
equipment_decoder.S2C_FAIL_REFINED_EQUIPMENT = 9
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_equipment = 25
equipment_decoder.S2C_UPDATE_EQUIPMENT = 25
local s2c_update_equipment_pb
decoder[25] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_equipment_pb or equipment_pb.S2CUpdateEquipmentProto()

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

-- local s2c_update_multi_equipment = 26
equipment_decoder.S2C_UPDATE_MULTI_EQUIPMENT = 26
local s2c_update_multi_equipment_pb
decoder[26] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_multi_equipment_pb or equipment_pb.S2CUpdateMultiEquipmentProto()

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

-- local c2s_smelt_equipment = 10
local c2s_smelt_equipment_pb


equipment_decoder.NewC2sSmeltEquipmentMsg = function(equipment_id)



    if not c2s_smelt_equipment_pb then c2s_smelt_equipment_pb = equipment_pb.C2SSmeltEquipmentProto() end

    
    for k,v in pairs(equipment_id) do table.insert(c2s_smelt_equipment_pb.equipment_id,v) end
    buffer[4] = char(12)
    buffer[5] = char(10)


    move_offset(5)
    c2s_smelt_equipment_pb:_InternalSerialize(write_to_buffer)
    c2s_smelt_equipment_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_smelt_equipment = 11
equipment_decoder.S2C_SMELT_EQUIPMENT = 11
local s2c_smelt_equipment_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_smelt_equipment_pb or equipment_pb.S2CSmeltEquipmentProto()

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

-- local s2c_fail_smelt_equipment = 12
equipment_decoder.S2C_FAIL_SMELT_EQUIPMENT = 12
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_rebuild_equipment = 13
local c2s_rebuild_equipment_pb


equipment_decoder.NewC2sRebuildEquipmentMsg = function(equipment_id)



    if not c2s_rebuild_equipment_pb then c2s_rebuild_equipment_pb = equipment_pb.C2SRebuildEquipmentProto() end

    
    for k,v in pairs(equipment_id) do table.insert(c2s_rebuild_equipment_pb.equipment_id,v) end
    buffer[4] = char(12)
    buffer[5] = char(13)


    move_offset(5)
    c2s_rebuild_equipment_pb:_InternalSerialize(write_to_buffer)
    c2s_rebuild_equipment_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_rebuild_equipment = 14
equipment_decoder.S2C_REBUILD_EQUIPMENT = 14
local s2c_rebuild_equipment_pb
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_rebuild_equipment_pb or equipment_pb.S2CRebuildEquipmentProto()

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

-- local s2c_fail_rebuild_equipment = 15
equipment_decoder.S2C_FAIL_REBUILD_EQUIPMENT = 15
decoder[15] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_open_equip_combine = 33
equipment_decoder.S2C_OPEN_EQUIP_COMBINE = 33
local s2c_open_equip_combine_pb
decoder[33] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_open_equip_combine_pb or equipment_pb.S2COpenEquipCombineProto()

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


equipment_decoder.Decoder = decoder

return equipment_decoder

