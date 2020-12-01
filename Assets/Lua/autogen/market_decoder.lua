

require "autogen.market_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 25
market_decoder = {}
market_decoder.ModuleID = ModuleID
market_decoder.ModuleName = "market"

local decoder = {}
local handler = {}

market_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_buy = 1
local c2s_buy_pb


market_decoder.NewC2sBuyMsg = function(id)



    if not c2s_buy_pb then c2s_buy_pb = market_pb.C2SBuyProto() end

    
    c2s_buy_pb.id = id
    buffer[4] = char(25)
    buffer[5] = char(1)


    move_offset(5)
    c2s_buy_pb:_InternalSerialize(write_to_buffer)
    c2s_buy_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_buy = 2
market_decoder.S2C_BUY = 2
local s2c_buy_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_buy_pb or market_pb.S2CBuyProto()

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

-- local s2c_fail_buy = 3
market_decoder.S2C_FAIL_BUY = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


market_decoder.Decoder = decoder

return market_decoder

