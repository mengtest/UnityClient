local _C = UIManager.Controller(UIManager.ControllerName.InsideMenu, UIManager.ViewName.InsideMenu)
_C.IsPopupBox = true
local view = nil
-- 建筑信息
local buildingData = DataTrunk.PlayerInfo.InternalAffairsData.BuildingsInfo

-- 边缘处理
local function EdgeProcessing()
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

function _C:onOpen(buildingObj)
    if buildingObj == nil then
        return
    end

    -- 模型名字
    local name = buildingObj.name
    -- 初始化位置
    view.UI.position = CS.LPCFramework.InputController.WorldToScreenPoint(buildingObj.transform.position)
    EdgeProcessing()

    for i = 1, 4 do
        view["MenuBtn" .. i].onClick:Add( function() _C:close() end)
    end

    -- 千重楼
    if name == "ClimbingTower" then
        view.State_C.selectedIndex = 0
        view.MenuBtn1.title = Localization.Tower
        view.MenuBtn1.onClick:Add(
        function()
            UIManager.openController(UIManager.ControllerName.ClimbingTowerMain)
        end )

        --        if DataTrunk.PlayerInfo.TowerBackroom.OpenMaxFloor > 0 then

        --            view.MenuBtn2.title = Localization.Backroom
        --            view.MenuBtn2.onClick:Add(
        --            function()
        --                UIManager.openController(UIManager.ControllerName.TowerBackroomMain)
        --            end )
        --            view.State_C.selectedIndex = 1
        --        end

        return
    end

    -- 以下为默认第一按钮为升级

    -- 通用升级按钮
    view.MenuBtn1.title = Localization.Upgrade
    view.MenuBtn1.onClick:Add(
    function()
        CS.UnityEngine.GameObject.Find("BuildingsTag").transform.localScale = CS.UnityEngine.Vector3.zero
        CS.LPCFramework.CameraController.SetTargetCamera(name)
        UIManager.openController(UIManager.ControllerName.Upgrade, buildingData[BuildingType[name]])
    end )

    if name == "FeudalOfficial" then
        view.State_C.selectedIndex = 0
    elseif name == "Warehouse" then
        view.State_C.selectedIndex = 1
        view.MenuBtn2.title = Localization.ChaKan
        view.MenuBtn2.onClick:Add(
        function()
            UIManager.openController(UIManager.ControllerName.Warehouse)
        end )
    elseif name == "Tavern" then
        view.State_C.selectedIndex = 1
        view.MenuBtn2.title = Localization.YanQing
        view.MenuBtn2.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.Tavern)
        end )
    elseif name == "Barrack" then
        view.State_C.selectedIndex = 2
        view.MenuBtn2.title = Localization.XunLian
        view.MenuBtn3.title = Localization.JinJie
        view.MenuBtn2.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.Barrack)
        end )
        view.MenuBtn3.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.SoldierUpgrade)
        end )
    elseif name == "Rampart" then
        view.State_C.selectedIndex = 1
        view.MenuBtn2.title = Localization.ShouCheng
        view.MenuBtn2.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.WallDefense)
        end )
    elseif name == "Academy" then
        view.State_C.selectedIndex = 1
        view.MenuBtn2.title = Localization.KeJi
        view.MenuBtn2.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.Academy)
        end )
    elseif name == "Recruitment" then
        view.State_C.selectedIndex = 1
        view.MenuBtn2.title = Localization.LianMeng
        view.MenuBtn2.onClick:Add( function()
            -- 未加入联盟，打开选择联盟界面；否则打开我的联盟界面
            if DataTrunk.PlayerInfo.MonarchsData.GuildId == 0 then
                UIManager.openController(UIManager.ControllerName.CreateOrJoinAlliance)
            else
                UIManager.openController(UIManager.ControllerName.Alliance)
            end
        end )
    elseif name == "PracticeHall" then
        --         view.State_C.selectedIndex = 3
        view.State_C.selectedIndex = 1
        view.MenuBtn2.title = Localization.XiuLian
        --         view.MenuBtn3.title = Localization.ChangeRace
        --         view.MenuBtn4.title = Localization.GeneralRebirth
        view.MenuBtn2.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.PracticeHall)
        end )
        -- view.MenuBtn3.onClick:Add( function()
        --    UIManager.openController(UIManager.ControllerName.GeneralChangeRace)
        -- end )
        -- view.MenuBtn4.onClick:Add( function()
        --    UIManager.openController(UIManager.ControllerName.GeneralRebirthPre)
        -- end )
    elseif name == "Smithy" then
        view.State_C.selectedIndex = 2
        view.MenuBtn2.title = Localization.DuanZao
        view.MenuBtn2.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.EquipmentForge)
        end )
        view.MenuBtn3.title = Localization.HeCheng
        view.MenuBtn3.onClick:Add( function()
            local openedSuits = DataTrunk.PlayerInfo.ItemsData.SmithyCombineSuits
            if openedSuits == nil or Utils.GetTableLength(openedSuits) == 0 then
                UIManager.showTip( { content = Localization.FragementNotEnough, result = false })
                return
            end
            UIManager.openController(UIManager.ControllerName.FragmentCombine)
        end )
    elseif name == "Campsite" then
        view.State_C.selectedIndex = 1
        view.MenuBtn2.title = Localization.Campsite
        view.MenuBtn2.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.Campsite, DataTrunk.PlayerInfo.MonarchsData.Id)
        end )
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

function _C:onClose()
    for i = 1, 4 do
        view["MenuBtn" .. i].onClick:Clear()
    end
end

function _C:onCreat()
    view = _C.View
end