local _C = UIManager.SubController(UIManager.ControllerName.BagEquip, nil)
_C.handle = nil
_C.view = nil

local itemList = nil
-- 缺省个数
local defaultNum = 40

-- 装备道具刷新
local function onEquipUpdate()
    if not _C.IsOpen then
        return
    end

    _C:refreshVirtualList()
end

-- 当滚动进行
local function onListScroll()
    _C.view:stopEffect()
    _C.view.BagEquipList:SelectNone()
end
-- item渲染
local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    _C:updateItemInfo(obj, itemList[index + 1])
end
-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    _C.handle:onItemClick(_C, item.data, itemList[index + 1], 1)
end

-- 更新数据
function _C:updateItemInfo(item, insInfo)
    -- 为空时
    if insInfo == nil then
        item:GetController("zhuangbei").selectedIndex = 2
        item:GetChild("wenzi_bwkong").text = ""
        return
    end

    item:GetController("zhuangbei").selectedIndex = 0
    item:GetChild("icon").url = insInfo.Config.Icon
    item:GetChild("quality").url = UIConfig.Item.EquipQuality[insInfo.Config.Quality.Level]
    item:GetChild("title").text = insInfo.Level

    -- 强化等级
    local list = item:GetChild("xingliebiao").asList
    list:RemoveChildrenToPool()

    local half = 0
    local max = math.ceil(insInfo.Config.Quality.RefinedLevelLimit * 0.5)
    local full = math.floor(insInfo.RefinedLevel * 0.5)
    if full < insInfo.RefinedLevel * 0.5 then half = 1 end

    for id = 1, full, 1 do
        list:AddChild(list:AddItemFromPool(UIConfig.Item.StarFullUrl))
    end
    if half == 1 then
        list:AddChild(list:AddItemFromPool(UIConfig.Item.StarHalfUrl))
    end
    for id = 1, max - half - full do
        list:AddChild(list:AddItemFromPool(UIConfig.Item.StarEmptyUrl))
    end
end
-- 刷新道具信息
function _C:refreshVirtualList()
    itemList = { }
    local id = 0
    for k, v in pairs(DataTrunk.PlayerInfo.ItemsData.Equips) do
        if nil ~= v then
            id = id + 1
            itemList[id] = v
        end
    end
    -- 排序
    table.sort(itemList, function(a, b)
        local result
        if a.RefinedLevel == b.RefinedLevel then
            if a.Config.Quality.Level == b.Config.Quality.Level then
                result = a.Config.Id > b.Config.Id
            else
                result = a.Config.Quality.Level > b.Config.Quality.Level
            end
        else
            result = a.RefinedLevel > b.RefinedLevel
        end
        return result
    end )

    _C.view.BagEquipCount.text = string.format(Localization.EquipCount, id, 200)
    -- 缺省个数
    if id < defaultNum then
        id = defaultNum
    end
    _C.view.BagEquipList.numItems = id
    _C.view.BagEquipList:RefreshVirtualList()
    _C.view.BagEquipList:SelectNone()
end
function _C:onCreat()
    _C.view.BagEquipList.itemRenderer = onItemRender
    _C.view.BagEquipList.onClickItem:Add(onItemClick)
    _C.view.BagEquipList.scrollPane.onScroll:Add(onListScroll)

    Event.addListener(Event.ITEM_EQUIP_UPDATE, onEquipUpdate)
end
function _C:onOpen(data)
    _C:refreshVirtualList()
end
function _C:onDestroy()
    _C.view.BagEquipList.itemRenderer = nil
    _C.view.BagEquipList.onClickItem:Clear()
    _C.view.BagEquipList.scrollPane.onScroll:Clear()

    Event.removeListener(Event.ITEM_EQUIP_UPDATE, onEquipUpdate)
end
return _C