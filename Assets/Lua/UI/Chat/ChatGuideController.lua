local _C = UIManager.SubController(UIManager.ControllerName.ChatGuild, nil)
_C.view = nil
_C.Contents = nil

--item渲染
local function onItemRender(index ,obj)
end
--item点击
local function onItemClick(item)
end

function _C:onCreat()
    _C.view.ChatGuildList.itemRenderer = onItemRender
    _C.view.ChatGuildList.onClickItem:Add(onItemClick)
end
function _C:onOpen(data)
    _C.view.ChatGuildList.numItems = 6
end
function _C:onDestroy()
    _C.view.ChatGuildList.itemRenderer = nil
    _C.view.ChatGuildList.onClickItem:Clear()
end

return _C