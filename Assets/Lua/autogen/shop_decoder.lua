

require "autogen.shop_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 20
shop_decoder = {}
shop_decoder.ModuleID = ModuleID
shop_decoder.ModuleName = "shop"

local decoder = {}
local handler = {}

shop_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local s2c_update_daily_shop_goods = 1
shop_decoder.S2C_UPDATE_DAILY_SHOP_GOODS = 1
local s2c_update_daily_shop_goods_pb
decoder[1] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_daily_shop_goods_pb or shop_pb.S2CUpdateDailyShopGoodsProto()

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

-- local c2s_buy_goods = 2
local c2s_buy_goods_pb


shop_decoder.NewC2sBuyGoodsMsg = function(id, count)



    if not c2s_buy_goods_pb then c2s_buy_goods_pb = shop_pb.C2SBuyGoodsProto() end

    
    c2s_buy_goods_pb.id = id
    c2s_buy_goods_pb.count = count
    buffer[4] = char(20)
    buffer[5] = char(2)


    move_offset(5)
    c2s_buy_goods_pb:_InternalSerialize(write_to_buffer)
    c2s_buy_goods_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_buy_goods = 3
shop_decoder.S2C_BUY_GOODS = 3
local s2c_buy_goods_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_buy_goods_pb or shop_pb.S2CBuyGoodsProto()

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

-- local s2c_fail_buy_goods = 4
shop_decoder.S2C_FAIL_BUY_GOODS = 4
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


shop_decoder.Decoder = decoder

return shop_decoder

