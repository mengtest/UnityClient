
require "autogen.achieve_decoder"
require "autogen.bai_zhan_decoder"
require "autogen.captain_soul_decoder"
require "autogen.chat_decoder"
require "autogen.client_config_decoder"
require "autogen.country_decoder"
require "autogen.depot_decoder"
require "autogen.domestic_decoder"
require "autogen.dungeon_decoder"
require "autogen.equipment_decoder"
require "autogen.fishing_decoder"
require "autogen.gem_decoder"
require "autogen.gm_decoder"
require "autogen.guild_decoder"
require "autogen.login_decoder"
require "autogen.mail_decoder"
require "autogen.market_decoder"
require "autogen.military_decoder"
require "autogen.misc_decoder"
require "autogen.rank_decoder"
require "autogen.region_decoder"
require "autogen.secret_tower_decoder"
require "autogen.shop_decoder"
require "autogen.stress_decoder"
require "autogen.tag_decoder"
require "autogen.task_decoder"
require "autogen.tower_decoder"

require "autogen.shared_pb"

local pb = require "pb"
local varint32 = pb.signed_varint_decoder

autogen = {}
local modules = {}

modules[achieve_decoder.ModuleID] = achieve_decoder.Decoder
modules[bai_zhan_decoder.ModuleID] = bai_zhan_decoder.Decoder
modules[captain_soul_decoder.ModuleID] = captain_soul_decoder.Decoder
modules[chat_decoder.ModuleID] = chat_decoder.Decoder
modules[client_config_decoder.ModuleID] = client_config_decoder.Decoder
modules[country_decoder.ModuleID] = country_decoder.Decoder
modules[depot_decoder.ModuleID] = depot_decoder.Decoder
modules[domestic_decoder.ModuleID] = domestic_decoder.Decoder
modules[dungeon_decoder.ModuleID] = dungeon_decoder.Decoder
modules[equipment_decoder.ModuleID] = equipment_decoder.Decoder
modules[fishing_decoder.ModuleID] = fishing_decoder.Decoder
modules[gem_decoder.ModuleID] = gem_decoder.Decoder
modules[gm_decoder.ModuleID] = gm_decoder.Decoder
modules[guild_decoder.ModuleID] = guild_decoder.Decoder
modules[login_decoder.ModuleID] = login_decoder.Decoder
modules[mail_decoder.ModuleID] = mail_decoder.Decoder
modules[market_decoder.ModuleID] = market_decoder.Decoder
modules[military_decoder.ModuleID] = military_decoder.Decoder
modules[misc_decoder.ModuleID] = misc_decoder.Decoder
modules[rank_decoder.ModuleID] = rank_decoder.Decoder
modules[region_decoder.ModuleID] = region_decoder.Decoder
modules[secret_tower_decoder.ModuleID] = secret_tower_decoder.Decoder
modules[shop_decoder.ModuleID] = shop_decoder.Decoder
modules[stress_decoder.ModuleID] = stress_decoder.Decoder
modules[tag_decoder.ModuleID] = tag_decoder.Decoder
modules[task_decoder.ModuleID] = task_decoder.Decoder
modules[tower_decoder.ModuleID] = tower_decoder.Decoder

-- 解析服务器包，会直接调用注册的处理函数
function autogen.Decode(data, length)
    local moduleId, off = varint32(data, 0)
    local mo = modules[moduleId]
    if mo == nil then
    	print('收到条模块号不存在的消息: ' .. moduleId)
        return
    end

    local msgId
    msgId, off = varint32(data, off)
    local decoder = mo[msgId]
    if decoder == nil then
    	print('收到条消息号不存在的消息: ' .. moduleId .. "-" .. msgId)
        return
    end

    print("处理消息", moduleId, '-', msgId)
    local ok, err = pcall(decoder, msgId, data, off, length)
    if not ok then
        error('消息处理出错. 消息 ' .. moduleId .. '-' .. msgId .. ": " .. err)
    end
end

return autogen
