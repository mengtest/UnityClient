local _C = UIManager.SubController(UIManager.ControllerName.ChatRecently, nil)
_C.view = nil
_C.Contents = nil

--item渲染
local function onItemRender(index ,obj)
end
--item点击
local function onItemClick(item)
end

function _C:onCreat()
    _C.view.ChatFriendList.itemRenderer = onItemRender
    _C.view.ChatFriendList.onClickItem:Add(onItemClick)
end
function _C:onOpen(data)
    _C.view.ChatFriendList.numItems = 4
end
function _C:onDestroy()
    _C.view.ChatFriendList.itemRenderer = nil
    _C.view.ChatFriendList.onClickItem:Clear()
end

return _C