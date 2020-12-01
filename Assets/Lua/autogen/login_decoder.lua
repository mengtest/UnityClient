

require "autogen.login_pb"

local buffer = require "autogen.buffer"
local write_to_buffer = buffer.write_to_buffer
local move_offset = buffer.move_offset
local offset = buffer.offset

local char = string.char
local concat = table.concat

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

local ModuleID = 1
login_decoder = {}
login_decoder.ModuleID = ModuleID
login_decoder.ModuleName = "login"

local decoder = {}
local handler = {}

login_decoder.RegisterAction = function(msgId, func)
	if handler[msgId] then error('重复注册消息处理函数. ' .. ModuleID .. "-" .. msgId) end
	handler[msgId] = func
end


-- local c2s_internal_login = 1
local c2s_internal_login_pb


login_decoder.NewC2sInternalLoginMsg = function(id)



    if not c2s_internal_login_pb then c2s_internal_login_pb = login_pb.C2SInternalLoginProto() end

    
    c2s_internal_login_pb.id = id
    buffer[4] = char(1)
    buffer[5] = char(1)


    move_offset(5)
    c2s_internal_login_pb:_InternalSerialize(write_to_buffer)
    c2s_internal_login_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_internal_login = 2
login_decoder.S2C_INTERNAL_LOGIN = 2
local s2c_internal_login_pb
decoder[2] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_internal_login_pb or login_pb.S2CInternalLoginProto()

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

-- local s2c_fail_internal_login = 5
login_decoder.S2C_FAIL_INTERNAL_LOGIN = 5
decoder[5] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_login = 7
local c2s_login_pb

login_decoder.C2S_LOGIN = function()
	if c2s_login_pb then return c2s_login_pb end
    buffer[4] = char(1)
    buffer[5] = char(7)
    c2s_login_pb = concat(buffer, '', 1, 5)    return c2s_login_pb
end

-- local s2c_login = 8
login_decoder.S2C_LOGIN = 8
local s2c_login_pb
decoder[8] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_login_pb or login_pb.S2CLoginProto()

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

-- local s2c_fail_login = 9
login_decoder.S2C_FAIL_LOGIN = 9
decoder[9] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_create_hero = 3
local c2s_create_hero_pb


login_decoder.NewC2sCreateHeroMsg = function(name, male)



    if not c2s_create_hero_pb then c2s_create_hero_pb = login_pb.C2SCreateHeroProto() end

    
    c2s_create_hero_pb.name = name
    c2s_create_hero_pb.male = male
    buffer[4] = char(1)
    buffer[5] = char(3)


    move_offset(5)
    c2s_create_hero_pb:_InternalSerialize(write_to_buffer)
    c2s_create_hero_pb:Clear()

    return concat(buffer, '', 1, offset())
end

-- local s2c_create_hero = 4
login_decoder.S2C_CREATE_HERO = 4
local s2c_create_hero_pb
decoder[4] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end

-- local s2c_fail_create_hero = 6
login_decoder.S2C_FAIL_CREATE_HERO = 6
decoder[6] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_loaded = 10
local c2s_loaded_pb

login_decoder.C2S_LOADED = function()
	if c2s_loaded_pb then return c2s_loaded_pb end
    buffer[4] = char(1)
    buffer[5] = char(10)
    c2s_loaded_pb = concat(buffer, '', 1, 5)    return c2s_loaded_pb
end

-- local s2c_loaded = 11
login_decoder.S2C_LOADED = 11
local s2c_loaded_pb
decoder[11] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local pb = s2c_loaded_pb or login_pb.S2CLoadedProto()

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

-- local s2c_fail_loaded = 12
login_decoder.S2C_FAIL_LOADED = 12
decoder[12] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    local failCode = varint32(data, offset)
    local ok, msg = pcall(handler, failCode)
    if not ok then
	print("处理消息出错 " .. ModuleID .. '-' .. msgId .. ': ' .. msg)
    end
end

-- local c2s_robot_login = 13
local c2s_robot_login_pb

login_decoder.C2S_ROBOT_LOGIN = function()
	if c2s_robot_login_pb then return c2s_robot_login_pb end
    buffer[4] = char(1)
    buffer[5] = char(13)
    c2s_robot_login_pb = concat(buffer, '', 1, 5)    return c2s_robot_login_pb
end

-- local s2c_robot_login = 14
login_decoder.S2C_ROBOT_LOGIN = 14
local s2c_robot_login_pb
decoder[14] = function(msgId, data, offset, length)
    local handler = handler[msgId]
    if not handler then print('消息没有注册处理函数: ' .. ModuleID .. '-' .. msgId); return end

    handler()
end


login_decoder.Decoder = decoder

return login_decoder

