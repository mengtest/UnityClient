local _C = UIManager.SubController(UIManager.ControllerName.ChatOpposite, nil)
_C.view = nil
_C.Contents = nil

--item渲染
local function onItemRender(index ,obj)
end
--item点击
local function onItemClick(item)
end

function _C:onCreat()
    _C.view.ChatOppositeList.itemRenderer = onItemRender
    _C.view.ChatOppositeList.onClickItem:Add(onItemClick)
end
function _C:onOpen(data)
    _C.view.ChatOppositeList.numItems = 23
end
function _C:onDestroy()
    _C.view.ChatOppositeList.itemRenderer = nil
    _C.view.ChatOppositeList.onClickItem:Clear()
end

return _C