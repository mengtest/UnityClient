local _C = UIManager.SubController(UIManager.ControllerName.BagGem, nil)
_C.handle = nil
_C.view = nil

local view = nil
-- 宝石数据
local gemList = { }
-- 缺省个数
local defaultNum = 40

-- 宝石刷新
local function onGenUpdate()
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
    local gemInfo = gemList[index + 1]
    -- 刷新
    if gemInfo == nil then
        obj:GetController("Count_C").selectedIndex = 0
        obj:GetController("State_C").selectedIndex = 0
    else
        obj:GetController("Count_C").selectedIndex = 1
        obj:GetController("State_C").selectedIndex = 1
        obj:GetController("CornerMark_C").selectedIndex = 0
        _C:updateItemInfo(obj, gemInfo)
    end
end

-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    if gemList[index + 1] ~= nil then
        _C.handle:onItemClick(_C, item.data, gemList[index + 1], 2)
    end
end

-- 更新数据
function _C:updateItemInfo(item, insInfo)
    item.title = insInfo.Amount
    item:GetChild("icon").url = insInfo.Config.Icon
    item:GetChild("quality").url = UIConfig.Item.DefaultQuality[insInfo.Config.Quality]
end
-- 刷新宝石信息
function _C:refreshVirtualList()
    gemList = { }
    local id = 0
    for k, v in pairs(DataTrunk.PlayerInfo.ItemsData.Gems) do
        if v ~= nil then
            id = id + 1
            gemList[id] = v
        end
    end
    -- 排序
    table.sort(gemList, function(a, b)
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
    _C.view.BagGemList.numItems = id
    _C.view.BagGemList:RefreshVirtualList()
    _C.view.BagGemList:SelectNone()
end

function _C:onCreat()
    _C.view.BagGemList.itemRenderer = onItemRender
    _C.view.BagGemList.onClickItem:Add(onItemClick)
    _C.view.BagGemList.scrollPane.onScroll:Add(onListScroll)

    Event.addListener(Event.ITEM_GEN_UPDATE, onGenUpdate)
end

function _C:onOpen(index)
    _C:refreshVirtualList()
end

function _C:onDestroy()
    _C.view.BagGemList.itemRenderer = nil
    _C.view.BagGemList.onClickItem:Clear()
    _C.view.BagGemList.scrollPane.onScroll:Clear()

    Event.removeListener(Event.ITEM_GEN_UPDATE, onGenUpdate)
end
return _C