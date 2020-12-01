

require "autogen.domestic_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 2
domestic_decoder = {}
domestic_decoder.ModuleID = ModuleID
domestic_decoder.ModuleName = "domestic"

local decoder = {}
local handler = {}

domestic_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_create_building = 1
local c2s_create_building_pb


domestic_decoder.NewC2sCreateBuildingMsg = function(id, type)



    if not c2s_create_building_pb then c2s_create_building_pb = domestic_pb.C2SCreateBuildingProto() end

    
    c2s_create_building_pb.id = id
    c2s_create_building_pb.type = type
    buffer[4] = char(2)
    buffer[5] = char(1)


    move_offset(5)
    c2s_create_building_pb:_InternalSerialize(write_to_buffer)
    c2s_create_building_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_create_building = 2
domestic_decoder.S2C_CREATE_BUILDING = 2
local s2c_create_building_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_create_building_pb or domestic_pb.S2CCreateBuildingProto()

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

-- local s2c_fail_create_building = 3
domestic_decoder.S2C_FAIL_CREATE_BUILDING = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade_building = 4
local c2s_upgrade_building_pb


domestic_decoder.NewC2sUpgradeBuildingMsg = function(id)



    if not c2s_upgrade_building_pb then c2s_upgrade_building_pb = domestic_pb.C2SUpgradeBuildingProto() end

    
    c2s_upgrade_building_pb.id = id
    buffer[4] = char(2)
    buffer[5] = char(4)


    move_offset(5)
    c2s_upgrade_building_pb:_InternalSerialize(write_to_buffer)
    c2s_upgrade_building_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_upgrade_building = 5
domestic_decoder.S2C_UPGRADE_BUILDING = 5
local s2c_upgrade_building_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_upgrade_building_pb or domestic_pb.S2CUpgradeBuildingProto()

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

-- local s2c_fail_upgrade_building = 6
domestic_decoder.S2C_FAIL_UPGRADE_BUILDING = 6
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_rebuild_resource_building = 7
local c2s_rebuild_resource_building_pb


domestic_decoder.NewC2sRebuildResourceBuildingMsg = function(id, type)



    if not c2s_rebuild_resource_building_pb then c2s_rebuild_resource_building_pb = domestic_pb.C2SRebuildResourceBuildingProto() end

    
    c2s_rebuild_resource_building_pb.id = id
    c2s_rebuild_resource_building_pb.type = type
    buffer[4] = char(2)
    buffer[5] = char(7)


    move_offset(5)
    c2s_rebuild_resource_building_pb:_InternalSerialize(write_to_buffer)
    c2s_rebuild_resource_building_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_rebuild_resource_building = 8
domestic_decoder.S2C_REBUILD_RESOURCE_BUILDING = 8
local s2c_rebuild_resource_building_pb
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_rebuild_resource_building_pb or domestic_pb.S2CRebuildResourceBuildingProto()

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

-- local s2c_fail_rebuild_resource_building = 9
domestic_decoder.S2C_FAIL_REBUILD_RESOURCE_BUILDING = 9
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_resource_building_info = 10
local c2s_resource_building_info_pb

domestic_decoder.C2S_RESOURCE_BUILDING_INFO = function()
	if c2s_resource_building_info_pb then return c2s_resource_building_info_pb end
    buffer[4] = char(2)
    buffer[5] = char(10)
    c2s_resource_building_info_pb = concat(buffer, '', 1, 5)    return c2s_resource_building_info_pb
end

-- local s2c_resource_building_info = 11
domestic_decoder.S2C_RESOURCE_BUILDING_INFO = 11
local s2c_resource_building_info_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_resource_building_info_pb or domestic_pb.S2CResourceBuildingInfoProto()

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

-- local s2c_fail_resource_building_info = 23
domestic_decoder.S2C_FAIL_RESOURCE_BUILDING_INFO = 23
decoder[23] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_resource_building_update = 12
domestic_decoder.S2C_RESOURCE_BUILDING_UPDATE = 12
local s2c_resource_building_update_pb
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_resource_building_update_pb or domestic_pb.S2CResourceBuildingUpdateProto()

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

-- local s2c_resource_update = 13
domestic_decoder.S2C_RESOURCE_UPDATE = 13
local s2c_resource_update_pb
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_resource_update_pb or domestic_pb.S2CResourceUpdateProto()

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

-- local s2c_resource_update_single = 28
domestic_decoder.S2C_RESOURCE_UPDATE_SINGLE = 28
local s2c_resource_update_single_pb
decoder[28] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_resource_update_single_pb or domestic_pb.S2CResourceUpdateSingleProto()

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

-- local s2c_resource_capcity_update = 14
domestic_decoder.S2C_RESOURCE_CAPCITY_UPDATE = 14
local s2c_resource_capcity_update_pb
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_resource_capcity_update_pb or domestic_pb.S2CResourceCapcityUpdateProto()

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

-- local c2s_collect_resource = 15
local c2s_collect_resource_pb


domestic_decoder.NewC2sCollectResourceMsg = function(id)



    if not c2s_collect_resource_pb then c2s_collect_resource_pb = domestic_pb.C2SCollectResourceProto() end

    
    c2s_collect_resource_pb.id = id
    buffer[4] = char(2)
    buffer[5] = char(15)


    move_offset(5)
    c2s_collect_resource_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_resource_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_resource = 16
domestic_decoder.S2C_COLLECT_RESOURCE = 16
local s2c_collect_resource_pb
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_resource_pb or domestic_pb.S2CCollectResourceProto()

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

-- local s2c_fail_collect_resource = 17
domestic_decoder.S2C_FAIL_COLLECT_RESOURCE = 17
decoder[17] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_learn_technology = 18
local c2s_learn_technology_pb


domestic_decoder.NewC2sLearnTechnologyMsg = function(id)



    if not c2s_learn_technology_pb then c2s_learn_technology_pb = domestic_pb.C2SLearnTechnologyProto() end

    
    c2s_learn_technology_pb.id = id
    buffer[4] = char(2)
    buffer[5] = char(18)


    move_offset(5)
    c2s_learn_technology_pb:_InternalSerialize(write_to_buffer)
    c2s_learn_technology_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_learn_technology = 19
domestic_decoder.S2C_LEARN_TECHNOLOGY = 19
local s2c_learn_technology_pb
decoder[19] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_learn_technology_pb or domestic_pb.S2CLearnTechnologyProto()

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

-- local s2c_fail_learn_technology = 20
domestic_decoder.S2C_FAIL_LEARN_TECHNOLOGY = 20
decoder[20] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_upgrade_stable_building = 24
local c2s_upgrade_stable_building_pb


domestic_decoder.NewC2sUpgradeStableBuildingMsg = function(type, level)



    if not c2s_upgrade_stable_building_pb then c2s_upgrade_stable_building_pb = domestic_pb.C2SUpgradeStableBuildingProto() end

    
    c2s_upgrade_stable_building_pb.type = type
    c2s_upgrade_stable_building_pb.level = level
    buffer[4] = char(2)
    buffer[5] = char(24)


    move_offset(5)
    c2s_upgrade_stable_building_pb:_InternalSerialize(write_to_buffer)
    c2s_upgrade_stable_building_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_upgrade_stable_building = 25
domestic_decoder.S2C_UPGRADE_STABLE_BUILDING = 25
local s2c_upgrade_stable_building_pb
decoder[25] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_upgrade_stable_building_pb or domestic_pb.S2CUpgradeStableBuildingProto()

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

-- local s2c_fail_upgrade_stable_building = 26
domestic_decoder.S2C_FAIL_UPGRADE_STABLE_BUILDING = 26
decoder[26] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_hero_update_exp = 22
domestic_decoder.S2C_HERO_UPDATE_EXP = 22
local s2c_hero_update_exp_pb
decoder[22] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_hero_update_exp_pb or domestic_pb.S2CHeroUpdateExpProto()

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

-- local s2c_hero_upgrade_level = 21
domestic_decoder.S2C_HERO_UPGRADE_LEVEL = 21
local s2c_hero_upgrade_level_pb
decoder[21] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_hero_upgrade_level_pb or domestic_pb.S2CHeroUpgradeLevelProto()

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

-- local s2c_hero_update_prosperity = 27
domestic_decoder.S2C_HERO_UPDATE_PROSPERITY = 27
local s2c_hero_update_prosperity_pb
decoder[27] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_hero_update_prosperity_pb or domestic_pb.S2CHeroUpdateProsperityProto()

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

-- local c2s_change_hero_name = 30
local c2s_change_hero_name_pb


domestic_decoder.NewC2sChangeHeroNameMsg = function(name)



    if not c2s_change_hero_name_pb then c2s_change_hero_name_pb = domestic_pb.C2SChangeHeroNameProto() end

    
    c2s_change_hero_name_pb.name = name
    buffer[4] = char(2)
    buffer[5] = char(30)


    move_offset(5)
    c2s_change_hero_name_pb:_InternalSerialize(write_to_buffer)
    c2s_change_hero_name_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_change_hero_name = 31
domestic_decoder.S2C_CHANGE_HERO_NAME = 31
local s2c_change_hero_name_pb
decoder[31] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_change_hero_name_pb or domestic_pb.S2CChangeHeroNameProto()

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

-- local s2c_fail_change_hero_name = 32
domestic_decoder.S2C_FAIL_CHANGE_HERO_NAME = 32
decoder[32] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_hero_name_changed_broadcast = 49
domestic_decoder.S2C_HERO_NAME_CHANGED_BROADCAST = 49
local s2c_hero_name_changed_broadcast_pb
decoder[49] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_hero_name_changed_broadcast_pb or domestic_pb.S2CHeroNameChangedBroadcastProto()

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

-- local c2s_list_old_name = 33
local c2s_list_old_name_pb


domestic_decoder.NewC2sListOldNameMsg = function(id)



    if not c2s_list_old_name_pb then c2s_list_old_name_pb = domestic_pb.C2SListOldNameProto() end

    
    c2s_list_old_name_pb.id = id
    buffer[4] = char(2)
    buffer[5] = char(33)


    move_offset(5)
    c2s_list_old_name_pb:_InternalSerialize(write_to_buffer)
    c2s_list_old_name_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_list_old_name = 34
domestic_decoder.S2C_LIST_OLD_NAME = 34
local s2c_list_old_name_pb
decoder[34] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_list_old_name_pb or domestic_pb.S2CListOldNameProto()

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

-- local s2c_fail_list_old_name = 37
domestic_decoder.S2C_FAIL_LIST_OLD_NAME = 37
decoder[37] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_view_other_hero = 35
local c2s_view_other_hero_pb


domestic_decoder.NewC2sViewOtherHeroMsg = function(id)



    if not c2s_view_other_hero_pb then c2s_view_other_hero_pb = domestic_pb.C2SViewOtherHeroProto() end

    
    c2s_view_other_hero_pb.id = id
    buffer[4] = char(2)
    buffer[5] = char(35)


    move_offset(5)
    c2s_view_other_hero_pb:_InternalSerialize(write_to_buffer)
    c2s_view_other_hero_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_view_other_hero = 36
domestic_decoder.S2C_VIEW_OTHER_HERO = 36
local s2c_view_other_hero_pb
decoder[36] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_view_other_hero_pb or domestic_pb.S2CViewOtherHeroProto()

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

-- local s2c_fail_view_other_hero = 38
domestic_decoder.S2C_FAIL_VIEW_OTHER_HERO = 38
decoder[38] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_building_worker_coef = 39
domestic_decoder.S2C_UPDATE_BUILDING_WORKER_COEF = 39
local s2c_update_building_worker_coef_pb
decoder[39] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_building_worker_coef_pb or domestic_pb.S2CUpdateBuildingWorkerCoefProto()

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

-- local s2c_update_tech_worker_coef = 40
domestic_decoder.S2C_UPDATE_TECH_WORKER_COEF = 40
local s2c_update_tech_worker_coef_pb
decoder[40] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_tech_worker_coef_pb or domestic_pb.S2CUpdateTechWorkerCoefProto()

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

-- local s2c_update_building_worker_fatigue_duration = 55
domestic_decoder.S2C_UPDATE_BUILDING_WORKER_FATIGUE_DURATION = 55
local s2c_update_building_worker_fatigue_duration_pb
decoder[55] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_building_worker_fatigue_duration_pb or domestic_pb.S2CUpdateBuildingWorkerFatigueDurationProto()

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

-- local s2c_update_tech_worker_fatigue_duration = 56
domestic_decoder.S2C_UPDATE_TECH_WORKER_FATIGUE_DURATION = 56
local s2c_update_tech_worker_fatigue_duration_pb
decoder[56] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_tech_worker_fatigue_duration_pb or domestic_pb.S2CUpdateTechWorkerFatigueDurationProto()

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

-- local c2s_miao_building_worker_cd = 41
local c2s_miao_building_worker_cd_pb


domestic_decoder.NewC2sMiaoBuildingWorkerCdMsg = function(worker_pos)



    if not c2s_miao_building_worker_cd_pb then c2s_miao_building_worker_cd_pb = domestic_pb.C2SMiaoBuildingWorkerCdProto() end

    
    c2s_miao_building_worker_cd_pb.worker_pos = worker_pos
    buffer[4] = char(2)
    buffer[5] = char(41)


    move_offset(5)
    c2s_miao_building_worker_cd_pb:_InternalSerialize(write_to_buffer)
    c2s_miao_building_worker_cd_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_miao_building_worker_cd = 42
domestic_decoder.S2C_MIAO_BUILDING_WORKER_CD = 42
local s2c_miao_building_worker_cd_pb
decoder[42] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_miao_building_worker_cd_pb or domestic_pb.S2CMiaoBuildingWorkerCdProto()

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

-- local s2c_fail_miao_building_worker_cd = 43
domestic_decoder.S2C_FAIL_MIAO_BUILDING_WORKER_CD = 43
decoder[43] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_miao_tech_worker_cd = 44
local c2s_miao_tech_worker_cd_pb


domestic_decoder.NewC2sMiaoTechWorkerCdMsg = function(worker_pos)



    if not c2s_miao_tech_worker_cd_pb then c2s_miao_tech_worker_cd_pb = domestic_pb.C2SMiaoTechWorkerCdProto() end

    
    c2s_miao_tech_worker_cd_pb.worker_pos = worker_pos
    buffer[4] = char(2)
    buffer[5] = char(44)


    move_offset(5)
    c2s_miao_tech_worker_cd_pb:_InternalSerialize(write_to_buffer)
    c2s_miao_tech_worker_cd_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_miao_tech_worker_cd = 45
domestic_decoder.S2C_MIAO_TECH_WORKER_CD = 45
local s2c_miao_tech_worker_cd_pb
decoder[45] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_miao_tech_worker_cd_pb or domestic_pb.S2CMiaoTechWorkerCdProto()

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

-- local s2c_fail_miao_tech_worker_cd = 46
domestic_decoder.S2C_FAIL_MIAO_TECH_WORKER_CD = 46
decoder[46] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_yuanbao = 47
domestic_decoder.S2C_UPDATE_YUANBAO = 47
local s2c_update_yuanbao_pb
decoder[47] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_yuanbao_pb or domestic_pb.S2CUpdateYuanbaoProto()

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

-- local s2c_update_hero_fight_amount = 48
domestic_decoder.S2C_UPDATE_HERO_FIGHT_AMOUNT = 48
local s2c_update_hero_fight_amount_pb
decoder[48] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_hero_fight_amount_pb or domestic_pb.S2CUpdateHeroFightAmountProto()

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

-- local s2c_recovery_forging_time_change = 54
domestic_decoder.S2C_RECOVERY_FORGING_TIME_CHANGE = 54
local s2c_recovery_forging_time_change_pb
decoder[54] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_recovery_forging_time_change_pb or domestic_pb.S2CRecoveryForgingTimeChangeProto()

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

-- local c2s_forging_equip = 51
local c2s_forging_equip_pb


domestic_decoder.NewC2sForgingEquipMsg = function(slot, count)



    if not c2s_forging_equip_pb then c2s_forging_equip_pb = domestic_pb.C2SForgingEquipProto() end

    
    c2s_forging_equip_pb.slot = slot
    c2s_forging_equip_pb.count = count
    buffer[4] = char(2)
    buffer[5] = char(51)


    move_offset(5)
    c2s_forging_equip_pb:_InternalSerialize(write_to_buffer)
    c2s_forging_equip_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_forging_equip = 52
domestic_decoder.S2C_FORGING_EQUIP = 52
local s2c_forging_equip_pb
decoder[52] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_forging_equip = 53
domestic_decoder.S2C_FAIL_FORGING_EQUIP = 53
decoder[53] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_sign = 66
local c2s_sign_pb


domestic_decoder.NewC2sSignMsg = function(text)



    if not c2s_sign_pb then c2s_sign_pb = domestic_pb.C2SSignProto() end

    
    c2s_sign_pb.text = text
    buffer[4] = char(2)
    buffer[5] = char(66)


    move_offset(5)
    c2s_sign_pb:_InternalSerialize(write_to_buffer)
    c2s_sign_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_sign = 67
domestic_decoder.S2C_SIGN = 67
local s2c_sign_pb
decoder[67] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_sign = 68
domestic_decoder.S2C_FAIL_SIGN = 68
decoder[68] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_voice = 69
local c2s_voice_pb


domestic_decoder.NewC2sVoiceMsg = function(content)



    if not c2s_voice_pb then c2s_voice_pb = domestic_pb.C2SVoiceProto() end

    
    c2s_voice_pb.content = content
    buffer[4] = char(2)
    buffer[5] = char(69)


    move_offset(5)
    c2s_voice_pb:_InternalSerialize(write_to_buffer)
    c2s_voice_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_voice = 70
domestic_decoder.S2C_VOICE = 70
local s2c_voice_pb
decoder[70] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_voice = 71
domestic_decoder.S2C_FAIL_VOICE = 71
decoder[71] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_building_worker_time_changed = 57
domestic_decoder.S2C_BUILDING_WORKER_TIME_CHANGED = 57
local s2c_building_worker_time_changed_pb
decoder[57] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_building_worker_time_changed_pb or domestic_pb.S2CBuildingWorkerTimeChangedProto()

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

-- local s2c_tech_worker_time_changed = 58
domestic_decoder.S2C_TECH_WORKER_TIME_CHANGED = 58
local s2c_tech_worker_time_changed_pb
decoder[58] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_tech_worker_time_changed_pb or domestic_pb.S2CTechWorkerTimeChangedProto()

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

-- local s2c_city_event_time_changed = 59
domestic_decoder.S2C_CITY_EVENT_TIME_CHANGED = 59
local s2c_city_event_time_changed_pb
decoder[59] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_city_event_time_changed_pb or domestic_pb.S2CCityEventTimeChangedProto()

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

-- local c2s_request_city_exchange_event = 60
local c2s_request_city_exchange_event_pb

domestic_decoder.C2S_REQUEST_CITY_EXCHANGE_EVENT = function()
	if c2s_request_city_exchange_event_pb then return c2s_request_city_exchange_event_pb end
    buffer[4] = char(2)
    buffer[5] = char(60)
    c2s_request_city_exchange_event_pb = concat(buffer, '', 1, 5)    return c2s_request_city_exchange_event_pb
end

-- local s2c_request_city_exchange_event = 61
domestic_decoder.S2C_REQUEST_CITY_EXCHANGE_EVENT = 61
local s2c_request_city_exchange_event_pb
decoder[61] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_city_exchange_event_pb or domestic_pb.S2CRequestCityExchangeEventProto()

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

-- local s2c_fail_request_city_exchange_event = 62
domestic_decoder.S2C_FAIL_REQUEST_CITY_EXCHANGE_EVENT = 62
decoder[62] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_city_event_exchange = 63
local c2s_city_event_exchange_pb


domestic_decoder.NewC2sCityEventExchangeMsg = function(give_up)



    if not c2s_city_event_exchange_pb then c2s_city_event_exchange_pb = domestic_pb.C2SCityEventExchangeProto() end

    
    c2s_city_event_exchange_pb.give_up = give_up
    buffer[4] = char(2)
    buffer[5] = char(63)


    move_offset(5)
    c2s_city_event_exchange_pb:_InternalSerialize(write_to_buffer)
    c2s_city_event_exchange_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_city_event_exchange = 64
domestic_decoder.S2C_CITY_EVENT_EXCHANGE = 64
local s2c_city_event_exchange_pb
decoder[64] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_city_event_exchange_pb or domestic_pb.S2CCityEventExchangeProto()

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

-- local s2c_fail_city_event_exchange = 65
domestic_decoder.S2C_FAIL_CITY_EVENT_EXCHANGE = 65
decoder[65] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_update_strategy_restore_start_time = 72
domestic_decoder.S2C_UPDATE_STRATEGY_RESTORE_START_TIME = 72
local s2c_update_strategy_restore_start_time_pb
decoder[72] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_strategy_restore_start_time_pb or domestic_pb.S2CUpdateStrategyRestoreStartTimeProto()

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

-- local s2c_update_strategy_next_use_time = 73
domestic_decoder.S2C_UPDATE_STRATEGY_NEXT_USE_TIME = 73
local s2c_update_strategy_next_use_time_pb
decoder[73] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_strategy_next_use_time_pb or domestic_pb.S2CUpdateStrategyNextUseTimeProto()

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


domestic_decoder.Decoder = decoder

return domestic_decoder

