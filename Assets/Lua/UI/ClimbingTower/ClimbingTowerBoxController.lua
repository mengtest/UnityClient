
local _C = UIManager.Controller(UIManager.ControllerName.ClimbingTowerBox, UIManager.ViewName.ClimbingTowerBox)
_C.IsPopupBox = true

local view = nil
-- 千重楼实例化信息
local towerInsInfo = DataTrunk.PlayerInfo.TowerData
-- 楼层宝箱信息
local itemListInfo = nil

-- 道具信息
local itemList = { }
-- 返回
local function btnBack()
    _C:close()
end
-- 领取
local function btnToDraw()
    NetworkManager.C2SCollectBox()
end
-- item点击
local function onItemClick(item)
    local index = tonumber(item.data.gameObjectName)
    UIManager.openController(UIManager.ControllerName.ItemTips, itemListInfo[index + 1])
end
-- item渲染
local function onItemRender(index, obj)
    obj.gameObjectName = tostring(index)

    local itemInfo = itemListInfo[index + 1]
    -- 刷新数据
    obj:GetController("State_C").selectedIndex = 1
    obj:GetController("Count_C").selectedIndex = 1
    obj:GetController("CornerMark_C").selectedIndex = 0

    obj:GetChild("title").text = itemInfo.Amount
    obj:GetChild("icon").url = itemInfo.Config.Icon

    -- 品质
    if itemInfo.ClassifyType == ItemClassifyType.Equip then
        obj:GetChild("quality").url = UIConfig.Item.EquipQuality[itemInfo.Config.Quality.Level]
    else
        obj:GetChild("quality").url = UIConfig.Item.DefaultQuality[itemInfo.Config.Quality]
    end
end
-- 刷新
local function updateTowerBoxInfo()
    if not _C.IsOpen then
        return
    end

    -- 楼层信息
    local floor = towerInsInfo.BoxFloor
    -- 无宝箱可开启时，直接关闭此界面
    if nil == floor then
        _C:close()
        return
    end

    -- item数据
    local floorConfig = TowerConfig:getConfigById(floor)
    -- 获得道具
    itemListInfo = { }
    award = function(t)
        if nil ~= t then
            for k, v in pairs(t) do
                table.insert(itemListInfo, v)
            end
        end
    end
    -- 宝箱道具
    if nil ~= floorConfig.BoxPrize then
        award(floorConfig.BoxPrize.Goods)
        award(floorConfig.BoxPrize.Equips)
        award(floorConfig.BoxPrize.Currencys)
    end

    view.AwardItemList.numItems = 0
    view.AwardItemList.numItems = #itemListInfo

    -- 是否可领取
    if towerInsInfo.CurrentFloor >= floor then
        view.DrawStat.selectedIndex = 1
    else
        view.DrawStat.selectedIndex = 0
    end

    -- 设置楼层
    view.Floors.text = floor
end

function _C:onCreat()
    view = _C.View

    view.BtnBack.onClick:Add(btnBack)
    view.BtnDrawAward.onClick:Add(btnToDraw)
    view.AwardItemList.itemRenderer = onItemRender
    view.AwardItemList.onClickItem:Add(onItemClick)

    Event.addListener(Event.TOWER_AWARD_BOX_UPDATE, updateTowerBoxInfo)
end
function _C:onOpen(data)
    view.EnterEffect:Play()
    updateTowerBoxInfo()
end
function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnDrawAward.onClick:Clear()
    view.AwardItemList.itemRenderer = nil
    view.AwardItemList.onClickItem:Clear()

    Event.removeListener(Event.TOWER_AWARD_BOX_UPDATE, updateTowerBoxInfo)
end
