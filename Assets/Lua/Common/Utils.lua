local Utils = { }

local UnityEngine = CS.UnityEngine
local Vector3 = UnityEngine.Vector3

-- 验证两个联盟Id号是否一致
function Utils.IsTheSameGuild(guildId1, guildId2)
    if guildId1 == nil or guildId1 <= 0 or guildId2 == nil or guildId2 <= 0 then
        return false
    end

    return guildId1 == guildId2
end
-- 获取y轴向角度--
function Utils.horizontalAngle(direction)
    return UnityEngine.Mathf.Atan2(direction.x, direction.z) * UnityEngine.Mathf.Rad2Deg
end
-- 计算两向量夹角--
function Utils.angleAroundAxis(direA, direB, axis)
    direA = direA - Vector3.Project(driA, axis)
    direB = direB - Vector3.Project(direB, axis)
    local angle = Vector3.Angle(direA, direB)

    local factor = 1
    if Vector3.Dot(axis, Vector3.Cross(direA, direB)) < 0 then
        factor = -1
    end

    return angle * factor
end
-- 获取方向向量,xz平面取前后左右向量，左手坐标系--
function Utils.directionVector(directionType)
    if directionType == DirectionType.Up then
        return Vector3.forward

    elseif directionType == DirectionType.Left_up then
        return Vector3.Normalize(Vector3.left + Vector3.forward)

    elseif directionType == DirectionType.Left then
        return Vector3.left

    elseif directionType == DirectionType.Left_down then
        return Vector3.Normalize(Vector3.left + Vector3.back)

    elseif directionType == DirectionType.Down then
        return Vector3.back

    elseif directionType == DirectionType.Right_down then
        return Vector3.Normalize(Vector3.right + Vector3.back)

    elseif directionType == DirectionType.Right then
        return Vector3.right

    elseif directionType == DirectionType.Right_up then
        return Vector3.Normalize(Vector3.right + Vector3.forward)
    end
end

-- 时间戳转换(年/月/日 小时:分钟)
function Utils.getTimeStamp(second)
    return os.date("%Y/%m/%d %H:%M", second)
end

-- 时间戳转换(年/月/日 小时:分钟:秒)
function Utils.getTimeStamp_Full(second)
    return os.date("%Y/%m/%d %H:%M:%S", second)
end

-- 显示当天的时间戳,如果超过24个小时,显示N天前
function Utils.getIntradayTimeStamp(timeStamp)
    if timeStamp == nil then
        return
    end

    -- 秒数(大于等于24个小时的显示XX天前)
    local second = TimerManager.currentTime - timeStamp

    if second >= 86400 then
        return Utils.secondFuzzyConversion(second)
    else
        return os.date("%H:%M:%S", timeStamp)
    end

end

-- 秒数转换(x天:xx:xx:xx)
function Utils.secondConversion(second)
    if type(second) ~= "number" then
        return
    end

    local d = math.floor(second / 86400)
    local h = math.floor((second % 86400) / 3600)
    local m = math.floor(second % 3600 / 60)
    local s = second % 60

    if d == 0 then
        if h == 0 then
            if m == 0 then
                return s
            end

            if m < 10 then
                m = "0" .. m
            end

            if s < 10 then
                s = "0" .. s
            end

            return m .. ":" .. s
        end

        if h < 10 then
            h = "0" .. h
        end

        if m < 10 then
            m = "0" .. m
        end

        if s < 10 then
            s = "0" .. s
        end

        return h .. ":" .. m .. ":" .. s
    end

    if h < 10 then
        h = "0" .. h
    end

    if m < 10 then
        m = "0" .. m
    end

    if s < 10 then
        s = "0" .. s
    end

    return d .. Localization.Day .. h .. ":" .. m .. ":" .. s
end

-- 秒数转换(N分钟前,N小时前,N天前)
function Utils.secondFuzzyConversion(second)
    if type(second) ~= "number" or second < 0 then
        return
    end

    if second < 3600 then
        return math.floor(second / 60) .. Localization.MinutesAgo
    elseif second < 86400 then
        return math.floor(second / 3600) .. Localization.HoursAgo
    else
        return math.floor(second / 86400) .. Localization.DaysAgo
    end
end

-- 是否是中文
function Utils.isChinese(text)
    if type(text) ~= "string" then
        return false
    end

    for i = 1, string.len(text) do
        asc2 = string.byte(text, i, i)

        if asc2 <= 127 then
            UIManager.showTip( { content = Localization.Utils_IsNotChinese, result = false })
            return false
        end
    end

    return true
end

-- 是否有敏感词
function Utils.isSensitiveWord(text)
    if type(text) ~= "string" then
        return false
    end
    local id1, id2
    for k, v in pairs(SensitiveWordConfig) do
        id1, id2 = string.find(text, v)
        if nil ~= id1 then
            if string.sub(text, id1, id2) == v then
                return true
            end
        end
    end

    return false
end
-- 敏感词弹框
function Utils.isSensitiveWordWithTips(text)
    local result = Utils.isSensitiveWord(text)
    if result then UIManager.showTip( { content = Localization.Utils_IsSensitiveWord, result = false }) end
    return result
end

-- 敏感词替换
function Utils.sensitiveWordReplace(text)
    if type(text) ~= "string" then
        return
    end
    local id1, id2, str
    for k, v in pairs(SensitiveWordConfig) do
        id1, id2 = string.find(text, v)
        if nil ~= id1 then
            if string.sub(text, id1, id2) == v then
                str = ""
                for i = 1, Utils.stringLen_1(v) do
                    str = str .. "*"
                end
                text = string.gsub(text, v, str)
            end
        end
    end

    return text
end

-- 获得key值不规律的table的长度
function Utils.GetTableLength(table)
    if type(table) ~= "table" then
        return
    end

    local count = 0

    for k, v in pairs(table) do
        if v ~= nil then
            count = count + 1
        end
    end

    return count
end
-- 参数:待分割的字符串,分割字符
-- 返回:子串表.(含有空串)
function Utils.stringSplit(str, split_char)
    local sub_str_tab = { };
    while (true) do
        local pos = string.find(str, split_char);
        if (not pos) then
            sub_str_tab[#sub_str_tab + 1] = str;
            break;
        end
        local sub_str = string.sub(str, 1, pos - 1);
        sub_str_tab[#sub_str_tab + 1] = sub_str;
        str = string.sub(str, pos + 1, #str);
    end

    return sub_str_tab;
end
-- 返回:字符串长度(中文占三个字符)，lua里默认就是三个字符，蛋疼
function Utils.stringLen(str)
    return #(str)
end
-- 返回:字符串长度(中文占一个字符),一般用于字符替换，比如一个汉字替换为一个*
function Utils.stringLen_1(str)
    local _, count = string.gsub(str, "[^\128-\193]", "")
    return count
end
-- 返回:字符串长度(中文占二个字符),策划说用中文两个字符来判断长度---- 正确性待测,反正含中文计算是对的
function Utils.stringLen_2(str)
    local len = #str
    local curByte, byteCount
    for i = 1, len do
        byteCount = 1
        curByte = string.byte(str, i)
        if curByte > 0 and curByte <= 127 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
        end

        i = i + byteCount - 1

        -- 判断如果为汉字,lua里默认就是三个字符，蛋疼
        if byteCount ~= 1 then
            len = len - 1
        end
    end
    return len
end
-- 返回:制定长度字符串，和截取后的字符(中文占二个字符)---- 正确性待测,反正含中文计算是对的
function Utils.stringSub(str, startLen, endLen)
    local calcLen = 0
    local startId, endId = -1, -1
    local curByte, byteCount
    for i = 1, #str do
        byteCount = 1
        curByte = string.byte(str, i)
        if curByte > 0 and curByte <= 127 then
            byteCount = 1
        elseif curByte >= 192 and curByte < 223 then
            byteCount = 2
        elseif curByte >= 224 and curByte < 239 then
            byteCount = 3
        elseif curByte >= 240 and curByte <= 247 then
            byteCount = 4
        end
        calcLen = calcLen + 1

        -- 判断如果为汉字,lua里默认就是三个字符，蛋疼
        if byteCount ~= 1 then
            calcLen = calcLen - 1

            if startId == -1 and(calcLen == startLen or calcLen + 1 == startLen or calcLen + 2 == startLen) then
                startId = i
            end
            if endId == -1 and(calcLen == endLen or calcLen + 1 == endLen or calcLen + 2 == endLen) then
                endId = i + 2
            end
        else
            if startId == -1 and calcLen == startLen then
                startId = i
            end
            if endId == -1 and calcLen == endLen then
                endId = i
            end
        end

        i = i + byteCount - 1
    end
    if startId == -1 then
        startId = 1
    end
    if endId == -1 then
        endId = #str
    end
    return string.sub(str, startId, endId);
end

-- 深拷贝--
function Utils.deepCopy(obj)
    local inTable = { };
    local function Func(obj)
        if type(obj) ~= "table" then
            -- 判断表中是否有表
            return obj;
        end
        local newTable = { };
        -- 定义一个新表
        inTable[obj] = newTable;
        -- 若表中有表，则先把表给inTable，再用newTable去接收内嵌的表
        for k, v in pairs(obj) do
            -- 把旧表的key和Value赋给新表
            newTable[Func(k)] = Func(v);
        end
        return setmetatable(newTable, getmetatable(obj))
        -- 赋值元表
    end
    return Func(obj)
    -- 若表中有表，则把内嵌的表也复制了
end 

-- string 转 table
function Utils.serialize(obj)
    local lua = ""
    local t = type(obj)
    if t == "number" then
        lua = lua .. obj
    elseif t == "boolean" then
        lua = lua .. tostring(obj)
    elseif t == "string" then
        lua = lua .. string.format("%q", obj)
    elseif t == "table" then
        lua = lua .. "{\n"
        for k, v in pairs(obj) do
            lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
        end
        local metatable = getmetatable(obj)
        if metatable ~= nil and type(metatable.__index) == "table" then
            for k, v in pairs(metatable.__index) do
                lua = lua .. "[" .. serialize(k) .. "]=" .. serialize(v) .. ",\n"
            end
        end
        lua = lua .. "}"
    elseif t == "nil" then
        return nil
    else
        error("can not serialize a " .. t .. " type.")
    end
    return lua
end  

-- table转string
function Utils.unserialize(lua)
    local t = type(lua)
    if t == "nil" or lua == "" then
        return nil
    elseif t == "number" or t == "string" or t == "boolean" then
        lua = tostring(lua)
    else
        error("can not unserialize a " .. t .. " type.")
    end
    lua = "return " .. lua
    local func = loadstring(lua)
    if func == nil then
        return nil
    end
    return func()
end

-- 是否为合法名称
-- 特殊字符限制：为帮助玩家之间关于目标名字的交流，角色起名/改名、联盟命名/改名、武将起名/改名只可使用简体中文、数字、字母（聊天不做特殊字符限制）。
function Utils.isLegalName(str, minLen, maxLen)
    if type(str) ~= "string" then
        return
    end

    -- 设置默认值
    minLen = minLen or 4
    maxLen = maxLen or 14

    -- 字符串长度
    local strLen = Utils.stringLen_2(str)

    -- 最小长度
    if strLen < minLen then
        UIManager.showTip( { content = Localization.Utils_NameIsTooShort, result = false })
        return false
    end

    -- 最大长度
    if strLen > maxLen then
        UIManager.showTip( { content = Localization.Utils_NameIsTooLong, result = false })
        return false
    end

    -- 敏感词
    if Utils.isSensitiveWordWithTips(str) then
        return false
    end

    -- 字母或数字
    -- string.find(str,"%W") == nil
    local result = CS.LPCFramework.StringTools.CalculateChineseWord(str)

    if not result then
        UIManager.showTip( { content = Localization.Utils_IsNotLegalName, result = false })
    end

    return result
end

return Utils

