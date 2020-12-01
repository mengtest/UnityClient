

require "autogen.gem_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 19
gem_decoder = {}
gem_decoder.ModuleID = ModuleID
gem_decoder.ModuleName = "gem"

local decoder = {}
local handler = {}

gem_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_use_gem = 3
local c2s_use_gem_pb


gem_decoder.NewC2sUseGemMsg = function(captain_id, slot_idx, down, gem_id)



    if not c2s_use_gem_pb then c2s_use_gem_pb = gem_pb.C2SUseGemProto() end

    
    c2s_use_gem_pb.captain_id = captain_id
    c2s_use_gem_pb.slot_idx = slot_idx
    c2s_use_gem_pb.down = down
    c2s_use_gem_pb.gem_id = gem_id
    buffer[4] = char(19)
    buffer[5] = char(3)


    move_offset(5)
    c2s_use_gem_pb:_InternalSerialize(write_to_buffer)
    c2s_use_gem_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_use_gem = 4
gem_decoder.S2C_USE_GEM = 4
local s2c_use_gem_pb
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_use_gem_pb or gem_pb.S2CUseGemProto()

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

-- local s2c_fail_use_gem = 5
gem_decoder.S2C_FAIL_USE_GEM = 5
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_combine_gem = 6
local c2s_combine_gem_pb


gem_decoder.NewC2sCombineGemMsg = function(captain_id, slot_idx)



    if not c2s_combine_gem_pb then c2s_combine_gem_pb = gem_pb.C2SCombineGemProto() end

    
    c2s_combine_gem_pb.captain_id = captain_id
    c2s_combine_gem_pb.slot_idx = slot_idx
    buffer[4] = char(19)
    buffer[5] = char(6)


    move_offset(5)
    c2s_combine_gem_pb:_InternalSerialize(write_to_buffer)
    c2s_combine_gem_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_combine_gem = 7
gem_decoder.S2C_COMBINE_GEM = 7
local s2c_combine_gem_pb
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_combine_gem_pb or gem_pb.S2CCombineGemProto()

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

-- local s2c_fail_combine_gem = 8
gem_decoder.S2C_FAIL_COMBINE_GEM = 8
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_one_key_use_gem = 9
local c2s_one_key_use_gem_pb


gem_decoder.NewC2sOneKeyUseGemMsg = function(captain_id, down_all)



    if not c2s_one_key_use_gem_pb then c2s_one_key_use_gem_pb = gem_pb.C2SOneKeyUseGemProto() end

    
    c2s_one_key_use_gem_pb.captain_id = captain_id
    c2s_one_key_use_gem_pb.down_all = down_all
    buffer[4] = char(19)
    buffer[5] = char(9)


    move_offset(5)
    c2s_one_key_use_gem_pb:_InternalSerialize(write_to_buffer)
    c2s_one_key_use_gem_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_one_key_use_gem = 10
gem_decoder.S2C_ONE_KEY_USE_GEM = 10
local s2c_one_key_use_gem_pb
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_one_key_use_gem_pb or gem_pb.S2COneKeyUseGemProto()

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

-- local s2c_fail_one_key_use_gem = 14
gem_decoder.S2C_FAIL_ONE_KEY_USE_GEM = 14
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_one_key_combine_gem = 11
local c2s_one_key_combine_gem_pb


gem_decoder.NewC2sOneKeyCombineGemMsg = function(captain_id, slot_idx)



    if not c2s_one_key_combine_gem_pb then c2s_one_key_combine_gem_pb = gem_pb.C2SOneKeyCombineGemProto() end

    
    c2s_one_key_combine_gem_pb.captain_id = captain_id
    c2s_one_key_combine_gem_pb.slot_idx = slot_idx
    buffer[4] = char(19)
    buffer[5] = char(11)


    move_offset(5)
    c2s_one_key_combine_gem_pb:_InternalSerialize(write_to_buffer)
    c2s_one_key_combine_gem_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_one_key_combine_gem = 12
gem_decoder.S2C_ONE_KEY_COMBINE_GEM = 12
local s2c_one_key_combine_gem_pb
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_one_key_combine_gem_pb or gem_pb.S2COneKeyCombineGemProto()

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

-- local s2c_fail_one_key_combine_gem = 13
gem_decoder.S2C_FAIL_ONE_KEY_COMBINE_GEM = 13
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_request_one_key_combine_cost = 15
local c2s_request_one_key_combine_cost_pb


gem_decoder.NewC2sRequestOneKeyCombineCostMsg = function(captain_id, slot_idx)



    if not c2s_request_one_key_combine_cost_pb then c2s_request_one_key_combine_cost_pb = gem_pb.C2SRequestOneKeyCombineCostProto() end

    
    c2s_request_one_key_combine_cost_pb.captain_id = captain_id
    c2s_request_one_key_combine_cost_pb.slot_idx = slot_idx
    buffer[4] = char(19)
    buffer[5] = char(15)


    move_offset(5)
    c2s_request_one_key_combine_cost_pb:_InternalSerialize(write_to_buffer)
    c2s_request_one_key_combine_cost_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_request_one_key_combine_cost = 16
gem_decoder.S2C_REQUEST_ONE_KEY_COMBINE_COST = 16
local s2c_request_one_key_combine_cost_pb
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_request_one_key_combine_cost_pb or gem_pb.S2CRequestOneKeyCombineCostProto()

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

-- local s2c_fail_request_one_key_combine_cost = 17
gem_decoder.S2C_FAIL_REQUEST_ONE_KEY_COMBINE_COST = 17
decoder[17] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


gem_decoder.Decoder = decoder

return gem_decoder

