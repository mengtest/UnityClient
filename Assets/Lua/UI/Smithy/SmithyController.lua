local _C = UIManager.Controller(UIManager.ControllerName.Smithy, UIManager.ViewName.Smithy)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil

local itemList = nil
-- 缺省个数
local defaultNum = 32
-- 道具实例化信息
local itemsInsData = DataTrunk.PlayerInfo.ItemsData
-- 装备强化道具icon
local upgradeIcon = GoodsCommonConfig.Config.EquipUpgradeReqGood.Icon
local refineIcon = GoodsCommonConfig.Config.EquipRefinedReqGood.Icon

-- 获取道具列表
local function getItemList()
    itemList = { }
    local id = 0

    for k, v in pairs(itemsInsData.Equips) do
        id = id + 1
        v.Selected = false
        itemList[id] = v
    end
    for k, v in pairs(itemsInsData.Temp) do
        id = id + 1
        v.Selected = false
        itemList[id] = v
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

    -- 缺省个数
    if id < defaultNum then
        id = defaultNum
    end

    view.EquipList.numItems = id
    view.EquipList:RefreshVirtualList()

    -- 取消选中
    view.BtnWhite.selected = false
    view.BtnGreen.selected = false
    view.BtnBlue.selected = false
    view.BtnPurple.selected = false
    view.BtnOrange.selected = false
    view.BtnRed.selected = false
end
-- 获取选中装备
local function getSelected()
    local equipSelected = { }
    for k, v in pairs(itemList) do
        if nil ~= v and v.Selected then
            table.insert(equipSelected, v.InsId)
        end
    end
    if #equipSelected == 0 then
        UIManager.showTip( { content = Localization.SmithySelectedNone, result = false })
        return false, equipSelected
    else
        return true, equipSelected
    end
end
-- 熔炼回复
local function smeltAck()
    if not _C.IsOpen then
        return
    end
    getItemList()
end
-- 重铸回复
local function rebuildAck()
    if not _C.IsOpen then
        return
    end
    getItemList()
end

-- 返回
local function btnBack()
    _C:close()
end
-- 熔炼
local function btnSmelt()
    local smelt = { }
    local upgradeReturn, refineReturn = 0, 0
    for k, v in pairs(itemList) do
        if nil ~= v and v.Selected then
            table.insert(smelt, v.InsId)

            upgradeReturn = upgradeReturn + v.UpgradeSmeltReturnItemCount
            refineReturn = refineReturn + v.RefineItemCostTotalCount
        end
    end

    if #smelt == 0 then
        UIManager.showTip( { content = Localization.SmithySelectedNone, result = false })
    else
        -- 标题 + 物品列表 + 取消 + 确认
        local billData = {
            { icon = upgradeIcon, count = upgradeReturn },
            { icon = refineIcon, count = refineReturn },
        }
        local data = {
            UIManager.PopupStyle.TitleListYesNo,
            title = Localization.SmithySmelt,
            listData = billData,
            btnTitle = { Localization.Cancel, Localization.Confirm },
            btnFunc = function() NetworkManager.C2SSmeltEquipmentProto(smelt) end
        }
        -- 打开二次弹框
        UIManager.openController(UIManager.ControllerName.Popup, data)
    end
end
-- 重铸
local function btnRebuild()
    local rebuild = { }
    local upgradeReturn, refineReturn = 0, 0
    for k, v in pairs(itemList) do
        if nil ~= v and v.Selected and(v.Level > 1 or v.RefinedLevel > 0) then
            table.insert(rebuild, v.InsId)

            upgradeReturn = upgradeReturn + v.UpgradeRebuildReturnItemCount
            refineReturn = refineReturn + v.RefineItemCostTotalCount
        end
    end

    if #rebuild == 0 then
        UIManager.showTip( { content = Localization.SmithyRebuildNone, result = false })
    else
        -- 标题 + 物品列表 + 取消 + 确认
        local billData = {
            { icon = upgradeIcon, count = upgradeReturn },
            { icon = refineIcon, count = refineReturn },
        }
        local data = {
            UIManager.PopupStyle.TitleListYesNo,
            title = Localization.SmithyRebuild,
            listData = billData,
            btnTitle = { Localization.Cancel, Localization.Confirm },
            btnFunc = function() NetworkManager.C2SRebuildEquipmentProto(rebuild) end
        }
        -- 打开二次弹框
        UIManager.openController(UIManager.ControllerName.Popup, data)
    end
end
-- 品质选择
local function btnQualitySelected(quality, selected)
    for k, v in pairs(itemList) do
        if nil ~= v and v.Config.Quality.Type == quality then
            v.Selected = selected
        end
    end

    local item
    local numChild = view.EquipList.numChildren
    for i = 0, numChild - 1 do
        item = view.EquipList:GetChildAt(i)

        local insInfo = itemList[tonumber(item.name) + 1]
        if nil == insInfo then
            item.selected = false
        elseif insInfo.Config.Quality.Type == quality then
            item.selected = selected
        end
    end
end

-- item渲染
local function onItemRender(index, obj)
    obj.name = tostring(index)
    local insInfo = itemList[index + 1]

    if nil == insInfo then
        obj:GetController("State_C").selectedIndex = 3
        obj.selected = false
    else
        obj:GetController("State_C").selectedIndex = 0
        obj:GetChild("icon").url = insInfo.Config.Icon
        obj:GetChild("Loader_Quality").url = UIConfig.Item.EquipQuality[insInfo.Config.Quality.Level]
        obj:GetChild("title").text = insInfo.Level

        -- 选中
        obj.selected = insInfo.Selected
        -- 强化等级
        local list = obj:GetChild("List_EquipStar").asList
        list:RemoveChildrenToPool()

        local half = 0
        local max = math.ceil(insInfo.Config.Quality.RefinedLevelLimit * 0.5)
        local full = math.floor(insInfo.RefinedLevel * 0.5)
        if full < insInfo.RefinedLevel * 0.5 then half = 1 end

        for id = 1, full, 1 do
            list:AddChild(list:AddItemFromPool())
        end
        if half == 1 then
            list:AddChild(list:AddItemFromPool())
        end
        for id = 1, max - half - full do
            list:AddChild(list:AddItemFromPool())
        end
    end
end
-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.name)
    if nil == itemList[index + 1] then
        item.data.selected = false
    else
        itemList[index + 1].Selected = item.data.selected
    end
end

function _C:onCreat()
    view = _C.View

    view.BtnBack.onClick:Set(btnBack)
    view.BtnSmelt.onClick:Set(btnSmelt)
    view.BtnRebuild.onClick:Set(btnRebuild)
    view.BtnWhite.onClick:Set( function() btnQualitySelected(Quality.White, view.BtnWhite.selected) end)
    view.BtnGreen.onClick:Set( function() btnQualitySelected(Quality.Green, view.BtnGreen.selected) end)
    view.BtnBlue.onClick:Set( function() btnQualitySelected(Quality.Blue, view.BtnBlue.selected) end)
    view.BtnPurple.onClick:Set( function() btnQualitySelected(Quality.Purple, view.BtnPurple.selected) end)
    view.BtnOrange.onClick:Set( function() btnQualitySelected(Quality.Orange, view.BtnOrange.selected) end)
    view.BtnRed.onClick:Set( function() btnQualitySelected(Quality.Red, view.BtnRed.selected) end)
    view.EquipList.itemRenderer = onItemRender
    view.EquipList.onClickItem:Add(onItemClick)

    Event.addListener(Event.SMITHY_SMELT_SUCCEED, smeltAck)
    Event.addListener(Event.SMITHY_SRBUILD_SUCCEED, rebuildAck)

    view.EquipDesc.text = Localization.SmithyMeltedDesc
end
function _C:onOpen(data)
    view.EquipList.numItems = 0
    getItemList()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnSmelt.onClick:Clear()
    view.BtnRebuild.onClick:Clear()
    view.BtnWhite.onClick:Clear()
    view.BtnGreen.onClick:Clear()
    view.BtnBlue.onClick:Clear()
    view.BtnPurple.onClick:Clear()
    view.BtnOrange.onClick:Clear()
    view.BtnRed.onClick:Clear()
    view.EquipList.itemRenderer = nil
    view.EquipList.onClickItem:Clear()

    Event.removeListener(Event.SMITHY_SMELT_SUCCEED, smeltAck)
    Event.removeListener(Event.SMITHY_SRBUILD_SUCCEED, rebuildAck)
end
