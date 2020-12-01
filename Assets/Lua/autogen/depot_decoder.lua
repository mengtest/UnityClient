

require "autogen.depot_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 11
depot_decoder = {}
depot_decoder.ModuleID = ModuleID
depot_decoder.ModuleName = "depot"

local decoder = {}
local handler = {}

depot_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local s2c_update_goods = 1
depot_decoder.S2C_UPDATE_GOODS = 1
local s2c_update_goods_pb
decoder[1] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_goods_pb or depot_pb.S2CUpdateGoodsProto()

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

-- local s2c_update_multi_goods = 5
depot_decoder.S2C_UPDATE_MULTI_GOODS = 5
local s2c_update_multi_goods_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_multi_goods_pb or depot_pb.S2CUpdateMultiGoodsProto()

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

-- local c2s_use_goods = 2
local c2s_use_goods_pb


depot_decoder.NewC2sUseGoodsMsg = function(id, count)



    if not c2s_use_goods_pb then c2s_use_goods_pb = depot_pb.C2SUseGoodsProto() end

    
    c2s_use_goods_pb.id = id
    c2s_use_goods_pb.count = count
    buffer[4] = char(11)
    buffer[5] = char(2)


    move_offset(5)
    c2s_use_goods_pb:_InternalSerialize(write_to_buffer)
    c2s_use_goods_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_use_goods = 3
depot_decoder.S2C_USE_GOODS = 3
local s2c_use_goods_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_use_goods_pb or depot_pb.S2CUseGoodsProto()

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

-- local s2c_fail_use_goods = 4
depot_decoder.S2C_FAIL_USE_GOODS = 4
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_use_cdr_goods = 6
local c2s_use_cdr_goods_pb


depot_decoder.NewC2sUseCdrGoodsMsg = function(id, count, cdr_type, index)



    if not c2s_use_cdr_goods_pb then c2s_use_cdr_goods_pb = depot_pb.C2SUseCdrGoodsProto() end

    
    c2s_use_cdr_goods_pb.id = id
    c2s_use_cdr_goods_pb.count = count
    c2s_use_cdr_goods_pb.cdr_type = cdr_type
    c2s_use_cdr_goods_pb.index = index
    buffer[4] = char(11)
    buffer[5] = char(6)


    move_offset(5)
    c2s_use_cdr_goods_pb:_InternalSerialize(write_to_buffer)
    c2s_use_cdr_goods_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_use_cdr_goods = 7
depot_decoder.S2C_USE_CDR_GOODS = 7
local s2c_use_cdr_goods_pb
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_use_cdr_goods_pb or depot_pb.S2CUseCdrGoodsProto()

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

-- local s2c_fail_use_cdr_goods = 8
depot_decoder.S2C_FAIL_USE_CDR_GOODS = 8
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_goods_combine = 9
local c2s_goods_combine_pb


depot_decoder.NewC2sGoodsCombineMsg = function(id, count)



    if not c2s_goods_combine_pb then c2s_goods_combine_pb = depot_pb.C2SGoodsCombineProto() end

    
    c2s_goods_combine_pb.id = id
    c2s_goods_combine_pb.count = count
    buffer[4] = char(11)
    buffer[5] = char(9)


    move_offset(5)
    c2s_goods_combine_pb:_InternalSerialize(write_to_buffer)
    c2s_goods_combine_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_goods_combine = 10
depot_decoder.S2C_GOODS_COMBINE = 10
local s2c_goods_combine_pb
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_goods_combine = 11
depot_decoder.S2C_FAIL_GOODS_COMBINE = 11
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_goods_expired = 16
depot_decoder.S2C_GOODS_EXPIRED = 16
local s2c_goods_expired_pb
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_goods_expired_pb or depot_pb.S2CGoodsExpiredProto()

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

-- local s2c_goods_expire_time_remove = 17
depot_decoder.S2C_GOODS_EXPIRE_TIME_REMOVE = 17
local s2c_goods_expire_time_remove_pb
decoder[17] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_goods_expire_time_remove_pb or depot_pb.S2CGoodsExpireTimeRemoveProto()

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


depot_decoder.Decoder = decoder

return depot_decoder

