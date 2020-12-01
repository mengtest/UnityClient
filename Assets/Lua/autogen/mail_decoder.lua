

require "autogen.mail_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 8
mail_decoder = {}
mail_decoder.ModuleID = ModuleID
mail_decoder.ModuleName = "mail"

local decoder = {}
local handler = {}

mail_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_list_mail = 1
local c2s_list_mail_pb


mail_decoder.NewC2sListMailMsg = function(read, keep, report, has_prize, collected, min_id, count)



    if not c2s_list_mail_pb then c2s_list_mail_pb = mail_pb.C2SListMailProto() end

    
    c2s_list_mail_pb.read = read
    c2s_list_mail_pb.keep = keep
    c2s_list_mail_pb.report = report
    c2s_list_mail_pb.has_prize = has_prize
    c2s_list_mail_pb.collected = collected
    c2s_list_mail_pb.min_id = min_id
    c2s_list_mail_pb.count = count
    buffer[4] = char(8)
    buffer[5] = char(1)


    move_offset(5)
    c2s_list_mail_pb:_InternalSerialize(write_to_buffer)
    c2s_list_mail_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_list_mail = 2
mail_decoder.S2C_LIST_MAIL = 2
local s2c_list_mail_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_list_mail_pb or mail_pb.S2CListMailProto()

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

-- local s2c_fail_list_mail = 3
mail_decoder.S2C_FAIL_LIST_MAIL = 3
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_receive_mail = 4
mail_decoder.S2C_RECEIVE_MAIL = 4
local s2c_receive_mail_pb
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_receive_mail_pb or mail_pb.S2CReceiveMailProto()

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

-- local c2s_delete_mail = 8
local c2s_delete_mail_pb


mail_decoder.NewC2sDeleteMailMsg = function(id)



    if not c2s_delete_mail_pb then c2s_delete_mail_pb = mail_pb.C2SDeleteMailProto() end

    
    c2s_delete_mail_pb.id = id
    buffer[4] = char(8)
    buffer[5] = char(8)


    move_offset(5)
    c2s_delete_mail_pb:_InternalSerialize(write_to_buffer)
    c2s_delete_mail_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_delete_mail = 9
mail_decoder.S2C_DELETE_MAIL = 9
local s2c_delete_mail_pb
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_delete_mail_pb or mail_pb.S2CDeleteMailProto()

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

-- local s2c_fail_delete_mail = 10
mail_decoder.S2C_FAIL_DELETE_MAIL = 10
decoder[10] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_keep_mail = 11
local c2s_keep_mail_pb


mail_decoder.NewC2sKeepMailMsg = function(id, keep)



    if not c2s_keep_mail_pb then c2s_keep_mail_pb = mail_pb.C2SKeepMailProto() end

    
    c2s_keep_mail_pb.id = id
    c2s_keep_mail_pb.keep = keep
    buffer[4] = char(8)
    buffer[5] = char(11)


    move_offset(5)
    c2s_keep_mail_pb:_InternalSerialize(write_to_buffer)
    c2s_keep_mail_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_keep_mail = 12
mail_decoder.S2C_KEEP_MAIL = 12
local s2c_keep_mail_pb
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_keep_mail_pb or mail_pb.S2CKeepMailProto()

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

-- local s2c_fail_keep_mail = 13
mail_decoder.S2C_FAIL_KEEP_MAIL = 13
decoder[13] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_collect_mail_prize = 14
local c2s_collect_mail_prize_pb


mail_decoder.NewC2sCollectMailPrizeMsg = function(id)



    if not c2s_collect_mail_prize_pb then c2s_collect_mail_prize_pb = mail_pb.C2SCollectMailPrizeProto() end

    
    c2s_collect_mail_prize_pb.id = id
    buffer[4] = char(8)
    buffer[5] = char(14)


    move_offset(5)
    c2s_collect_mail_prize_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_mail_prize_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_mail_prize = 15
mail_decoder.S2C_COLLECT_MAIL_PRIZE = 15
local s2c_collect_mail_prize_pb
decoder[15] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_mail_prize_pb or mail_pb.S2CCollectMailPrizeProto()

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

-- local s2c_fail_collect_mail_prize = 16
mail_decoder.S2C_FAIL_COLLECT_MAIL_PRIZE = 16
decoder[16] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_read_mail = 20
local c2s_read_mail_pb


mail_decoder.NewC2sReadMailMsg = function(id)



    if not c2s_read_mail_pb then c2s_read_mail_pb = mail_pb.C2SReadMailProto() end

    
    c2s_read_mail_pb.id = id
    buffer[4] = char(8)
    buffer[5] = char(20)


    move_offset(5)
    c2s_read_mail_pb:_InternalSerialize(write_to_buffer)
    c2s_read_mail_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_read_mail = 21
mail_decoder.S2C_READ_MAIL = 21
local s2c_read_mail_pb
decoder[21] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_read_mail_pb or mail_pb.S2CReadMailProto()

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

-- local s2c_fail_read_mail = 22
mail_decoder.S2C_FAIL_READ_MAIL = 22
decoder[22] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


mail_decoder.Decoder = decoder

return mail_decoder

