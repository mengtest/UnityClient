local _C = UIManager.Controller(UIManager.ControllerName.ResourceMenu, UIManager.ViewName.ResourceMenu)
_C.IsPopupBox = true
local view = nil

local clickedAreaInfo = nil
local offsetX = nil
local offsetY = nil
local layoutId = nil

-- 边缘处理
local function edgeProcessing()
    if (view.UI.position.y - view.UI.height / 2) < 0 then
        view.UI.position = CS.UnityEngine.Vector3(view.UI.position.x, view.UI.height / 2)
    elseif (view.UI.position.y + view.UI.height / 2) > GRoot.inst.height then
        view.UI.position = CS.UnityEngine.Vector3(view.UI.position.x, GRoot.inst.height - view.UI.height / 2)
    elseif (view.UI.position.x - view.UI.width / 2) < 0 then
        view.UI.position = CS.UnityEngine.Vector3(view.UI.width / 2, view.UI.position.y)
    elseif (view.UI.position.x + view.UI.width / 2) > GRoot.inst.width then
        view.UI.position = CS.UnityEngine.Vector3(GRoot.inst.width - view.UI.width / 2, view.UI.position.y)
    end
end
-- 关闭自己
local function closeSelf()
    _C:close()
end
Event.addListener(Event.CLOSE_RESOURCE_MENU, closeSelf)

-- 创建铜矿
local function onCreateGoldMine()
    NetworkManager.C2SCreateBuildingProto(layoutId, BuildingType.GoldMine)
    closeSelf()
end
-- 创建农田
local function onCreateCropland()
    NetworkManager.C2SCreateBuildingProto(layoutId, BuildingType.Cropland)
    closeSelf()
end
-- 创建伐木场
local function onCreateSawmill()
    NetworkManager.C2SCreateBuildingProto(layoutId, BuildingType.Sawmill)
    closeSelf()
end
-- 创建采石场
local function onCreateStonePit()
    NetworkManager.C2SCreateBuildingProto(layoutId, BuildingType.StonePit)
    closeSelf()
end
-- 收获
local function onHarvest()
    NetworkManager.C2SCollectResourceProto(layoutId)
    closeSelf()
end
-- 改建为铜矿
local function onRebuildGoldMine()
    NetworkManager.C2SRebuildResourceBuildingProto(layoutId, BuildingType.GoldMine)
    closeSelf()
end
-- 改建为农田
local function onRebuildCropland()
    NetworkManager.C2SRebuildResourceBuildingProto(layoutId, BuildingType.Cropland)
    closeSelf()
end
-- 改建为伐木场
local function onRebuildSawmill()
    NetworkManager.C2SRebuildResourceBuildingProto(layoutId, BuildingType.Sawmill)
    closeSelf()
end
-- 改建为采石场
local function onRebuildStonePit()
    NetworkManager.C2SRebuildResourceBuildingProto(layoutId, BuildingType.StonePit)
    closeSelf()
end

function _C:onOpen(data)
    -- 互斥，关闭城池菜单
    Event.dispatch(Event.CLOSE_CITY_MENU)

    -- 获取点击的区域信息
    clickedAreaInfo = LevelManager.CurrLevelLogic.getCurrentClickedAreaInfo()
    if clickedAreaInfo == nil or clickedAreaInfo.m_bIsPlayerMainCity == false then
        _C:close()
    end

    view.UI.position = CS.LPCFramework.InputController.WorldToScreenPoint(clickedAreaInfo.m_vGroundItemPos)

    edgeProcessing()

    -- 通过坐标计算偏移(此处坐标跟配置的坐标不属于同一个坐标系,所以需要转换)
    offsetX =  clickedAreaInfo.m_iOddQX - DataTrunk.PlayerInfo.MonarchsData.BaseX
    offsetY = DataTrunk.PlayerInfo.MonarchsData.BaseY - clickedAreaInfo.m_iOddQY
    -- 如果偏移量是奇数 并且当前坐标的OddQX也是奇数,需要偏移量减1, 否则建资源点或者迁城后资源会错乱.
    if offsetX % 2 ~= 0  and clickedAreaInfo.m_iOddQX % 2 ~= 0 then
        offsetY = offsetY - 1
    end
    -- 获取布局Id
    layoutId = BuildingLayoutConfig:getLayoutByCoordinatesOffset(offsetX, offsetY)

    if layoutId == nil then
        _C:close()
    end

    -- 没有资源，需要创建
    if clickedAreaInfo.m_byGroundItemType == BuildingType.None then
        view.Type_C.selectedIndex = 1
        view.TopBtn.visible = true
        view.TopBtnCtrl.selectedIndex = 14
        view.BottomBtnCtrl.selectedIndex = 16
        view.LeftBtnCtrl.selectedIndex = 17
        view.RightBtnCtrl.selectedIndex = 15

        view.TopBtn.onClick:Set(onCreateGoldMine)
        view.BottomBtn.onClick:Set(onCreateSawmill)
        view.LeftBtn.onClick:Set(onCreateStonePit)
        view.RightBtn.onClick:Set(onCreateCropland)
    else
        view.Type_C.selectedIndex = 0
        view.TopBtn.visible = false
        -- 收获
        view.LeftBtnCtrl.selectedIndex = 22
        view.LeftBtn.onClick:Set(onHarvest)
        -- 改建
        view.RightBtnCtrl.selectedIndex = 23

        if clickedAreaInfo.m_byGroundItemType == BuildingType.GoldMine then
            view.RightBtn.onClick:Set(
            function()
                view.TopBtn.visible = true
                view.TopBtnCtrl.selectedIndex = 19

                view.LeftBtnCtrl.selectedIndex = 20

                view.RightBtnCtrl.selectedIndex = 21

                view.TopBtn.onClick:Set(onRebuildCropland)
                view.LeftBtn.onClick:Set(onRebuildSawmill)
                view.RightBtn.onClick:Set(onRebuildStonePit)
            end )
        elseif clickedAreaInfo.m_byGroundItemType == BuildingType.Cropland then
            view.RightBtn.onClick:Set(
            function()
                view.TopBtn.visible = true
                view.TopBtnCtrl.selectedIndex = 18

                view.LeftBtnCtrl.selectedIndex = 20

                view.RightBtnCtrl.selectedIndex = 21

                view.TopBtn.onClick:Set(onRebuildGoldMine)
                view.LeftBtn.onClick:Set(onRebuildSawmill)
                view.RightBtn.onClick:Set(onRebuildStonePit)
            end )
        elseif clickedAreaInfo.m_byGroundItemType == BuildingType.Sawmill then
            view.RightBtn.onClick:Set(
            function()
                view.TopBtn.visible = true
                view.TopBtnCtrl.selectedIndex = 18

                view.LeftBtnCtrl.selectedIndex = 19

                view.RightBtnCtrl.selectedIndex = 21

                view.TopBtn.onClick:Set(onRebuildGoldMine)
                view.LeftBtn.onClick:Set(onRebuildCropland)
                view.RightBtn.onClick:Set(onRebuildStonePit)
            end )
        elseif clickedAreaInfo.m_byGroundItemType == BuildingType.StonePit then
            view.RightBtn.onClick:Set(
            function()
                view.TopBtn.visible = true
                view.TopBtnCtrl.selectedIndex = 18

                view.LeftBtnCtrl.selectedIndex = 19

                view.RightBtnCtrl.selectedIndex = 20

                view.TopBtn.onClick:Set(onRebuildGoldMine)
                view.LeftBtn.onClick:Set(onRebuildCropland)
                view.RightBtn.onClick:Set(onRebuildSawmill)
            end )
        end
    end
end

local function StageOnTouchBegin()
    if not _C.IsOpen then
        return
    end

    if Stage.isTouchOnUI == false and _C.IsOpen then
        _C:close()
    end
end

function _C:onShow()
    Event.addListener(Event.STAGE_ON_TOUCH_BEGIN, StageOnTouchBegin)
end

function _C:onHide()
    Event.removeListener(Event.STAGE_ON_TOUCH_BEGIN, StageOnTouchBegin)
end


function _C:onCreat()
    view = _C.View
end

function _C:onDestroy()
end
