

require "autogen.task_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 15
task_decoder = {}
task_decoder.ModuleID = ModuleID
task_decoder.ModuleName = "task"

local decoder = {}
local handler = {}

task_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local s2c_update_task_progress = 1
task_decoder.S2C_UPDATE_TASK_PROGRESS = 1
local s2c_update_task_progress_pb
decoder[1] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_update_task_progress_pb or task_pb.S2CUpdateTaskProgressProto()

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

-- local c2s_collect_task_prize = 2
local c2s_collect_task_prize_pb


task_decoder.NewC2sCollectTaskPrizeMsg = function(id)



    if not c2s_collect_task_prize_pb then c2s_collect_task_prize_pb = task_pb.C2SCollectTaskPrizeProto() end

    
    c2s_collect_task_prize_pb.id = id
    buffer[4] = char(15)
    buffer[5] = char(2)


    move_offset(5)
    c2s_collect_task_prize_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_task_prize_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_task_prize = 3
task_decoder.S2C_COLLECT_TASK_PRIZE = 3
local s2c_collect_task_prize_pb
decoder[3] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_task_prize_pb or task_pb.S2CCollectTaskPrizeProto()

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

-- local s2c_fail_collect_task_prize = 4
task_decoder.S2C_FAIL_COLLECT_TASK_PRIZE = 4
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local s2c_new_task = 5
task_decoder.S2C_NEW_TASK = 5
local s2c_new_task_pb
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_new_task_pb or task_pb.S2CNewTaskProto()

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

-- local c2s_collect_task_box_prize = 6
local c2s_collect_task_box_prize_pb


task_decoder.NewC2sCollectTaskBoxPrizeMsg = function(id)



    if not c2s_collect_task_box_prize_pb then c2s_collect_task_box_prize_pb = task_pb.C2SCollectTaskBoxPrizeProto() end

    
    c2s_collect_task_box_prize_pb.id = id
    buffer[4] = char(15)
    buffer[5] = char(6)


    move_offset(5)
    c2s_collect_task_box_prize_pb:_InternalSerialize(write_to_buffer)
    c2s_collect_task_box_prize_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_collect_task_box_prize = 7
task_decoder.S2C_COLLECT_TASK_BOX_PRIZE = 7
local s2c_collect_task_box_prize_pb
decoder[7] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_collect_task_box_prize_pb or task_pb.S2CCollectTaskBoxPrizeProto()

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

-- local s2c_fail_collect_task_box_prize = 8
task_decoder.S2C_FAIL_COLLECT_TASK_BOX_PRIZE = 8
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end


task_decoder.Decoder = decoder

return task_decoder

