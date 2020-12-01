local _C = UIManager.SubController(UIManager.ControllerName.BagDefault, nil)
_C.handle = nil
_C.view = nil

local itemList = nil
-- 缺省个数
local defaultNum = 40

-- 堆叠道具刷新
local function onDefaultUpdate()
    if not _C.IsOpen then
        return
    end

    _C:refreshVirtualList()
end

-- 当滚动进行
local function onListScroll()
    _C.view:stopEffect()
    _C.view.BagDefaultList:SelectNone()
end
-- item渲染
local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    local itemInfo = itemList[index + 1]
    -- 刷新
    if itemInfo == nil then
        obj:GetController("Count_C").selectedIndex = 0
        obj:GetController("State_C").selectedIndex = 0
    else
        obj:GetController("Count_C").selectedIndex = 1
        obj:GetController("State_C").selectedIndex = 1
        _C:updateItemInfo(obj, itemInfo)
    end
end
-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    _C.handle:onItemClick(_C, item.data, itemList[index + 1], 0)
end
-- 更新数据
function _C:updateItemInfo(item, insInfo)
    item.title = insInfo.Amount
    item:GetChild("icon").url = insInfo.Config.Icon
    item:GetChild("quality").url = UIConfig.Item.DefaultQuality[insInfo.Config.Quality]
end
-- 刷新道具信息
function _C:refreshVirtualList()
    itemList = { }
    local id = 0
    for k, v in pairs(DataTrunk.PlayerInfo.ItemsData.Default) do
        if v ~= nil then
            id = id + 1
            itemList[id] = v
        end
    end
    -- 排序
    table.sort(itemList, function(a, b)
        local result
        if a.Config.Quality == b.Config.Quality then
            result = a.Config.Id > b.Config.Id
        else
            result = a.Config.Quality > b.Config.Quality
        end
        return result
    end )
    -- 缺省个数
    if id < defaultNum then
        id = defaultNum
    end
    _C.view.BagDefaultList.numItems = id
    _C.view.BagDefaultList:RefreshVirtualList()
    _C.view.BagDefaultList:SelectNone()
end

function _C:onCreat()
    _C.view.BagDefaultList.itemRenderer = onItemRender
    _C.view.BagDefaultList.onClickItem:Add(onItemClick)
    _C.view.BagDefaultList.scrollPane.onScroll:Add(onListScroll)

    Event.addListener(Event.ITEM_DEFAULT_UPDATE, onDefaultUpdate)
end
function _C:onOpen(data)
    _C:refreshVirtualList()
end
function _C:onDestroy()
    _C.view.BagDefaultList.itemRenderer = nil
    _C.view.BagDefaultList.onClickItem:Clear()
    _C.view.BagDefaultList.scrollPane.onScroll:Clear()

    Event.removeListener(Event.ITEM_DEFAULT_UPDATE, onDefaultUpdate)

    itemList = nil
end
return _C
