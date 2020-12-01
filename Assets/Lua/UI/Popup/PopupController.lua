local _C = UIManager.Controller(UIManager.ControllerName.Popup, UIManager.ViewName.Popup)
_C.IsPopupBox = true
local view = nil

-- 列表内item
local function ListItemHandler(icon, count)
    if count == 0 then
        return
    end

    local item = view.List:AddItemFromPool(view.List.defaultItem)
    -- 默认角标
    item:GetController("CornerMark_C").selectedIndex = 0
    -- 默认底
    item:GetController("State_C").selectedIndex = 1
    -- 数量控制器
    local count_C = item:GetController("Count_C")
    -- 数量
    item.title = count

    if count == 1 then
        count_C.selectedIndex = 0
    else
        count_C.selectedIndex = 1
    end

    -- 图标
    item.icon = icon
end

local function setBtnGrayAndTouchable(data)
    -- 置灰
    if data.grayed ~= nil and #data.grayed == 2 then
        if data.grayed[1] then
            view.LeftBtn.grayed = true
        end
        if data.grayed[2] then
            view.RightBtn.grayed = true
        end
    end
    -- 可触碰
    if data.touchable ~= nil and #data.touchable == 2 then
        if not data.touchable[1] then
            view.LeftBtn.touchable = false
        end
        if not data.touchable[2] then
            view.RightBtn.touchable = false
        end
    end
end

-- 类型
-- data[1] = UIManager.PopupStyle.XXXX
-- 标题和副标题
-- data.title = {[1] = "XXXX",[2] = nil/"XXXX"}
-- 内容和副内容
-- data.content = {[1] = "XXXX",[2] = nil/"XXXX"}
-- 按钮标题(左/右)
-- data.btnTitle = {[1] = "left", [2] = "right"}
-- 按钮回调,等以后返回按钮有特殊需求了再开
-- data.btnFunc = {[1] = func1, [2] = func2}
-- 列表数据
-- data.listData = {}
function _C:onOpen(data)
    if data.BGCanCancel == nil then
        view.BG.touchable = true
    elseif not data.BGCanCancel then
        view.BG.touchable = false
    end

    view.LeftBtn.grayed = false
    view.LeftBtn.touchable = true
    view.RightBtn.grayed = false
    view.RightBtn.touchable = true
    view.LeftBtn.onClick:Clear()
    view.RightBtn.onClick:Clear()

    if data[1] == UIManager.PopupStyle.Content then
        -- 只有内容
        view.Style_C.selectedIndex = 2
        view.Btn_C.selectedIndex = 2
    elseif data[1] == UIManager.PopupStyle.ContentConfirm then
        -- 内容 + 确认
        view.Style_C.selectedIndex = 0
        view.Btn_C.selectedIndex = 1
        if data.grayed ~= nil then
            if data.grayed then
                view.RightBtn.grayed = true
            end
        end
        if data.touchable ~= nil then
            if not data.touchable then
                view.RightBtn.touchable = false
            end
        end
    elseif data[1] == UIManager.PopupStyle.ContentUnquitConfirm then
        -- 内容 + 确认
        view.Style_C.selectedIndex = 0
        view.Btn_C.selectedIndex = 1
        view.BG.touchable = false
        if data.grayed ~= nil then
            if data.grayed then
                view.RightBtn.grayed = true
            end
        end
        if data.touchable ~= nil then
            if not data.touchable then
                view.RightBtn.touchable = false
            end
        end
    elseif data[1] == UIManager.PopupStyle.ContentYesNo then
        -- 内容 + 取消 + 确认
        view.Style_C.selectedIndex = 0
        view.Btn_C.selectedIndex = 0
        setBtnGrayAndTouchable(data)
    elseif data[1] == UIManager.PopupStyle.ContentSubContentConfirm then
        -- 内容 + 副内容 + 确认
        view.Style_C.selectedIndex = 1
        view.Btn_C.selectedIndex = 1
        if data.grayed ~= nil then
            if data.grayed then
                view.RightBtn.grayed = true
            end
        end
        if data.touchable ~= nil then
            if not data.touchable then
                view.RightBtn.touchable = false
            end
        end
    elseif data[1] == UIManager.PopupStyle.ContentSubContentYesNo then
        -- 内容 + 副内容 + 取消 + 确认
        view.Style_C.selectedIndex = 1
        view.Btn_C.selectedIndex = 0
        setBtnGrayAndTouchable(data)
    elseif data[1] == UIManager.PopupStyle.TitleListConfirm then
        -- 标题 + 物品列表 + 确认
        view.Style_C.selectedIndex = 3
        view.Btn_C.selectedIndex = 1
        view.Title.text = data.title
        view.List:RemoveChildrenToPool()
        if data.grayed ~= nil then
            if data.grayed then
                view.RightBtn.grayed = true
            end
        end
        if data.touchable ~= nil then
            if not data.touchable then
                view.RightBtn.touchable = false
            end
        end
        for k, v in pairs(data.listData) do
            ListItemHandler(v.icon, v.count)
        end
    elseif data[1] == UIManager.PopupStyle.TitleListYesNo then
        -- 标题 + 物品列表 + 取消 + 确认
        view.Style_C.selectedIndex = 3
        view.Btn_C.selectedIndex = 0
        view.Title.text = data.title
        view.List:RemoveChildrenToPool()
        setBtnGrayAndTouchable(data)
        for k, v in pairs(data.listData) do
            ListItemHandler(v.icon, v.count)
        end
    elseif data[1] == UIManager.PopupStyle.TitleInputYesNo then
        -- 标题 + 数字输入框 + 取消 + 确认
        view.Style_C.selectedIndex = 4
        view.Btn_C.selectedIndex = 0
        view.Title.text = data.title
        setBtnGrayAndTouchable(data)
        view.RightBtn.onClick:Add( function() data.btnFunc[2](tonumber(view.Input_Amount.text)) end)
    end

    -- 按钮名称
    if data.btnTitle ~= nil then
        if type(data.btnTitle) == "string" then
            view.RightBtn.title = data.btnTitle
        elseif type(data.btnTitle) == "table" then
            view.LeftBtn.title = data.btnTitle[1]
            view.RightBtn.title = data.btnTitle[2]
        end
    else
        view.LeftBtn.title = Localization.Cancel
        view.RightBtn.title = Localization.Confirm
    end

    -- 按钮监听事件
    if data.btnFunc ~= nil and data[1] ~= UIManager.PopupStyle.TitleInputYesNo then
        if type(data.btnFunc) == "function" then
            view.RightBtn.onClick:Add(data.btnFunc)
        elseif type(data.btnFunc) == "table" then
            view.LeftBtn.onClick:Add(data.btnFunc[1])
            view.RightBtn.onClick:Add(data.btnFunc[2])
        end
    end

    -- 内容&副内容
    if data.content ~= nil then
        if type(data.content) == "string" then
            view.Content.text = data.content
        elseif type(data.content) == "table" then
            view.Content.text = data.content[1]
            view.SubContent.text = data.content[2]
        end
    end

    view.LeftBtn.onClick:Add( function() _C:close() end)
    view.RightBtn.onClick:Add( function() _C:close() end)
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set( function()
        _C:close()
    end )
end

-- 模板
--[[
   -- 只有内容
    data = {
        UIManager.PopupStyle.Content,
        content = "content"
    }
    -- 内容 + 确认按钮
    data = {
        UIManager.PopupStyle.ContentConfirm,
        content = "content",
        btnTitle = "confirmBtn",
        grayed = false,
        touchable = false,
        btnFunc = function() print("confirmFunc") end
    }
    -- 内容 + 取消 + 确认
    data = {
        UIManager.PopupStyle.ContentYesNo,
        content = "content",
        btnTitle = { "cancelBtn", "confirmBtn" },
        grayed = { [1] = true, [2] = true },
        touchable = { [1] = true, [2] = true },
        btnFunc = function() print("confirmFunc") end
    }
    -- 内容 + 副内容 + 确认
    data = {
        UIManager.PopupStyle.ContentSubContentConfirm,
        content = {"content","subContent"},
        btnTitle = "confirmBtn",
        grayed = false,
        touchable = false,
        btnFunc = function() print("confirmFunc") end
    }
    -- 内容 + 副内容 + 取消 + 确认
    data = {
        UIManager.PopupStyle.ContentSubContentYesNo,
        content = {"content","subContent"},
        btnTitle = { "cancelBtn", "confirmBtn" },
        grayed = { [1] = true, [2] = true },
        touchable = { [1] = true, [2] = true },
        btnFunc = function() print("confirmFunc") end
    }
    -- 标题 + 物品列表 + 确认
    data = {
        UIManager.PopupStyle.TitleListConfirm,
        title = "title",
        listData = {{icon:图标,count:数量},...},
        btnTitle = "confirmBtn",
        grayed = false,
        touchable = false,
        btnFunc = function() print("confirmFunc") end
    }
    -- 标题 + 物品列表 + 取消 + 确认
    data = {
        UIManager.PopupStyle.TitleListYesNo,
        title = "title",
        listData = {{icon:图标,count:数量},...},
        btnTitle = { "cancelBtn", "confirmBtn" },
        grayed = { [1] = true, [2] = true },
        touchable = { [1] = true, [2] = true },
        btnFunc = function() print("confirmFunc") end
    }
    -- 标题 + 输入框 + 取消 + 确认
    data = {
        UIManager.PopupStyle.TitleInputYesNo,
        title = "title",
        btnTitle = { "cancelBtn", "confirmBtn" },
        grayed = { [1] = true, [2] = true },
        touchable = { [1] = true, [2] = true },
        btnFunc = {func1,func2}
    }
--]]
