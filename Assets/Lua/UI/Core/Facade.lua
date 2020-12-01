local Facade = { }

-- 本地存储--
local ControllerCenter = {
}
local ControllerStack = {
}

-- 关闭栈中之前界面--
local function hidePreCtrl(id)
    if id == 0 then
        return
    end
    local ctrl = ControllerStack[id]
    ctrl:hide()

    if ctrl.IsPopupBox then
        id = id - 1
        hidePreCtrl(id)
    end
end
-- 打开栈中之前界面--
local function showPreCtrl(id)
    if id == 0 then
        return
    end
    local ctrl = ControllerStack[id]
    ctrl:show()

    if ctrl.IsPopupBox then
        id = id - 1
        showPreCtrl(id)
    end
end
-- 从栈中移除指定界面--
local function removeFromStack(ctrl)
    for i =(#(ControllerStack)), 1, -1 do
        if ControllerStack[i] == nil or ControllerStack[i].ControllerName == ctrl.ControllerName then
            table.remove(ControllerStack, i)
            break
        end
    end
end
-- 将界面压栈--
function Facade:pushingStack(ctrl)
    local lastId =(#ControllerStack)
    if lastId ~= 0 then
        local preCtrl = ControllerStack[lastId]
        -- 不置顶
        if not preCtrl.IsStick then
            preCtrl:interactive(false)
        end
        if not ctrl.IsPopupBox then
            hidePreCtrl(lastId)
        end
    end

    removeFromStack(ctrl)
    table.insert(ControllerStack, ctrl)

    for v, k in pairs(ControllerStack) do
        if not k.IsStick then
            k:sortingOrder(v)
        end
    end

    ctrl:interactive(true)
    ctrl:show()
end
-- 将界面出栈--
function Facade:popingStack(ctrl)
    removeFromStack(ctrl)
    ctrl:hide()
    ctrl:interactive(false)

    local lastId =(#ControllerStack)
    if lastId ~= 0 then
        local preCtrl = ControllerStack[lastId]

        preCtrl:interactive(true)
        if not ctrl.IsPopupBox then
            showPreCtrl(lastId)
        end
    end
end
-- 打开指定界面--
function Facade:openController(name, data)
    local ctrl = self:getController(name)
    if ctrl == nil then
        require(name)
        ctrl = self:getController(name)
    end
    ctrl:creat()
    ctrl:open(data)
end
-- 移除指定界面--
function Facade:removeController(name)
    local ctrl = ControllerCenter[name]
    if nil ~= ctrl then
        ctrl:destroy()
    end
end
-- 向所有打开界面广播消息--
function Facade:sendNtfMessage(ntfType, ...)
    for k, v in pairs(ControllerStack) do
        if v ~= nil and v.IsOpen then
            v:ntfHandle(ntfType, ...)
        end
    end
end
-- 注册界面--
function Facade:registerController(windowInfo)
    if type(windowInfo) ~= "table" then
        return
    end
    local key = tostring(windowInfo.ControllerName)
    if ControllerCenter[key] ~= nil then
        error("已存在相同controllerName!!" .. key)
    end
    ControllerCenter[key] = windowInfo
end
-- 获取指定界面--
function Facade:getController(name)
    if name == nil then
        return nil
    end

    return ControllerCenter[name]
end

-- 关闭所有的界面--
function Facade:destroyAllController()
    for k, v in pairs(ControllerCenter) do
        v:destroy(true)
    end
end
-- 更新所有打开的界面--
function Facade:updateAllController()
    for i =(#ControllerStack), 1, -1 do
        if ControllerStack[i] ~= nil and ControllerStack[i].IsShow then
            ControllerStack[i]:update()
        end
    end
end
--[[
function Facade:removeController(name)
	if ControllerCenter == nil then
		return
	end

	for i = (#ControllerCenter), 1, -1 do
		if ControllerCenter[i].ControllerName == name then
			table.remove(ControllerCenter,i)
			break
		end
	end
end
]]

return Facade

