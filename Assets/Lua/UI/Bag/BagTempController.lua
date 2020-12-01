local _C = UIManager.SubController(UIManager.ControllerName.BagTemp, nil)
_C.handle = nil
_C.view = nil

local id = nil
local itemList = nil
local itemClick = { item = nil, insInfo = nil }
-- 缺省个数
local defaultNum = 28

-- 临时道具刷新
local function onTempUpdate()
    if not _C.IsOpen then
        return
    end

    _C:refreshVirtualList()
end

-- 当滚动进行
local function onListScroll()
    _C.view:stopEffect()
    _C.view.BagTempList:SelectNone()
end
-- item渲染
local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index)
    _C:updateItemInfo(obj, itemList[index + 1])
end
-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)

    itemClick.item = item
    itemClick.insInfo = itemList[index + 1]
    _C.handle:onItemClick(_C, item.data, itemClick.insInfo, 3)
end

-- 更新数据
function _C:updateItemInfo(item, insInfo)
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
    if full < insInfo.Config.Quality.Level then half = 1 end

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
    id = 0
    itemList = { }
    for k, v in pairs(DataTrunk.PlayerInfo.ItemsData.Temp) do
        if v ~= nil and v.Timer.CurCd > 0 then
            id = id + 1
            itemList[id] = v
        end
    end
    -- 排序
    table.sort(itemList, function(a, b) return a.Timer.CurCd < b.Timer.CurCd end)

    -- 判断是否有临时背包
    if id == 0 then
        itemList = nil
        itemClick.item = nil
        itemClick.insInfo = nil

        _C.view.BagTempStat.selectedIndex = 1
        _C.view.BagList.numItems = 3

        -- 依据当前所在面板，滚动至
        if _C.view.BagList.scrollPane.currentPageX == 1 then
            _C.view.BtnEquip.onClick:Call()
        else
            _C.view.BtnDefault.onClick:Call()
        end
    else
        _C.view.BagTempStat.selectedIndex = 0
        _C.view.BagList.numItems = 4

        _C.view:getTempList()
        _C.view.BagTempList.itemRenderer = onItemRender
        _C.view.BagTempList.onClickItem:Add(onItemClick)
        _C.view.BagTempList.scrollPane.onScroll:Add(onListScroll)

        -- 缺省个数
        if id < defaultNum then
            id = defaultNum
        end
        _C.view.BagTempList.numItems = id
        _C.view.BagTempList:RefreshVirtualList()
        _C.view.BagTempList:SelectNone()
    end
end
function _C:onCreat()
    Event.addListener(Event.ITEM_TEMP_UPDATE, onTempUpdate)
end
function _C:onOpen(data)
    _C:refreshVirtualList()
end
function _C:onDestroy()
    if nil ~= _C.view.BagTempList then
        _C.view.BagTempList.itemRenderer = nil
        _C.view.BagTempList.onClickItem:Clear()
        _C.view.BagTempList.scrollPane.onScroll:Clear()
    end

    Event.removeListener(Event.ITEM_TEMP_UPDATE, onTempUpdate)
end
function _C:onUpdate()
    if nil == itemList then
        return
    end

    -- 计时结束
    if itemList[1].Timer.CurCd <= 0 then
        _C:refreshVirtualList()

        _C.view.BagTempList:SelectNone()
        if _C.view.BagList.scrollPane.currentPageX == 3 then _C.view:stopEffect() end
    else
        if _C.view.BagList.scrollPane.currentPageX ~= 3 then return end

        -- 更新计时显示
        _C.view.BagTempDieTime.text = Utils.secondConversion(math.ceil(itemList[1].Timer.CurCd))
        -- 更新底部面板
        if nil ~= itemClick.insInfo and nil ~= itemClick.insInfo.Timer then
            _C.view.ItemUseDieTime.text = Utils.secondConversion(math.ceil(itemClick.insInfo.Timer.CurCd))
        end
    end
end
return _C