--==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local next         = next
local assert       = assert
local pairs        = pairs
local type         = type
local tostring     = tostring
local setmetatable = setmetatable

local _class
local baseMt     = {}                                       -- 基础原表
local _instances = setmetatable({},{__mode = 'k'})          -- 实例化对象引用表
local _classes   = setmetatable({},{__mode = 'k'})          -- 所有类的引用表

local function assert_call_from_class(class, method)
	assert(_classes[class], ('Wrong method call. Expected class:%s.'):format(method))
end

-- 绑定
local function bind(f, v) 
	return  function(...) 
                return f(v, ...) 
            end 
end

local default_filter = function() 
    return true 
end
	
-- 深拷贝
local function deep_copy(t, dest, aType)
	t = t or {}
	local r = dest or {}
	for k,v in pairs(t) do
		if aType ~= nil and type(v) == aType then
			r[k] = (type(v) == 'table')
							and ((_classes[v] or _instances[v]) and v or deep_copy(v))
							or v
		elseif aType == nil then
			r[k] = (type(v) == 'table') 
			        and k~= '__index' and ((_classes[v] or _instances[v]) and v or deep_copy(v)) 
							or v
		end
	end
	return r
end

-- 实例化
local function instantiate(call_init, self, ...)
	assert_call_from_class(self, 'new(...) or class(...)')
	local instance = {class = self}
	_instances[instance] = tostring(instance)
	deep_copy(self, instance, 'table')
	instance.__index = nil
	setmetatable(instance,self)
	if call_init and self.init then
		if type(self.init) == 'table' then
			deep_copy(self.init, instance)
		else
			self.init(instance, ...)
		end
	end
	return instance
end

-- 扩展
local function extend(self, name, extra_params)
	assert_call_from_class(self, 'extend(...)')
	local heir = {}
	_classes[heir] = tostring(heir)
	deep_copy(extra_params, deep_copy(self, heir))
	heir.name    = extra_params and extra_params.name or name
	heir.__index = heir
	heir.super   = self
	return setmetatable(heir,self)
end

baseMt = 
{
	__call = function (self,...) 
        return self:new(...) 
    end,
	
	__tostring = function(self,...)
		if _instances[self] then
			return ("instance of '%s' (%s)"):format(rawget(self.class,'name') or '?', _instances[self])
		end
		return _classes[self] and ("class '%s' (%s)"):format(rawget(self,'name') or '?', _classes[self]) or self
	end
}

_classes[baseMt] = tostring(baseMt)
setmetatable(baseMt, {__tostring = baseMt.__tostring})

local class = {}

_class = function(name, attr)
	local c = deep_copy(attr)
	_classes[c] = tostring(c)
	c.name = name or c.name
	c.__tostring = baseMt.__tostring
	c.__call = baseMt.__call
	c.new = bind(instantiate, true)
	c.extend = extend
	c.__index = c
    c.__newIndex = function(t, k, v)
            if key == c.new then
                print("不可修改new")
            end
        end

	return setmetatable(c, baseMt)
end

return setmetatable(class,{__call = function(_,...) return _class(...) end })