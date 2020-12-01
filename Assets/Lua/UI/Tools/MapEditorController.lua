local _C = UIManager.Controller(UIManager.ControllerName.MapEditor, UIManager.ViewName.MapEditor)

local view = nil

local GotoNonePage;
local GotoSelectLevelPage;
local GotoGroudMenuPage;

-- 当前关卡Id
local CurrentLevelId = 0

-- 地图，此处先hardcode，需要等关卡表格设计完毕后，从表格读取野外地图类型地图id
local Levels = {
    LevelType.WorldMap
}

local levelLogicScript = "LevelLogic.MapEditorLevelLogic"


-- 边缘处理
local function EdgeProcessing()
    if (view.PageGroundMenu.position.y - view.PageGroundMenu.height / 2) < 0 then
        view.PageGroundMenu.position = CS.UnityEngine.Vector3(view.PageGroundMenu.position.x, view.PageGroundMenu.height / 2)
    elseif (view.PageGroundMenu.position.y + view.PageGroundMenu.height / 2) > GRoot.inst.height then
        view.PageGroundMenu.position = CS.UnityEngine.Vector3(view.PageGroundMenu.position.x, GRoot.inst.height - view.PageGroundMenu.height / 2)
    elseif (view.PageGroundMenu.position.x - view.PageGroundMenu.width / 2) < 0 then
        view.PageGroundMenu.position = CS.UnityEngine.Vector3(view.PageGroundMenu.width / 2, view.PageGroundMenu.position.y)
    elseif (view.PageGroundMenu.position.x + view.PageGroundMenu.width / 2) > GRoot.inst.width then
        view.PageGroundMenu.position = CS.UnityEngine.Vector3(GRoot.inst.width - view.PageGroundMenu.width / 2, view.PageGroundMenu.position.y)
    end
end

-- 设置为障碍物
local function SetGroundAsObstacle()
    if CS.LPCFramework.TerrainLuaDelegates.SetMarkType(2) then
        GotoNonePage()
    end
end

-- 设置为水面
local function SetGroundAsWater()
    if CS.LPCFramework.TerrainLuaDelegates.SetMarkType(3) then
        GotoNonePage()
    end
end

-- 设置为空地
local function SetGroundAsOpenSpace()
    if CS.LPCFramework.TerrainLuaDelegates.SetMarkType(1) then
        GotoNonePage()
    end
end

-- 开启/关闭手动标记
local function EnableManualMarking(value)
    CS.LPCFramework.TerrainLuaDelegates.EnableManualMarking(value)
end

-- 关闭标记笔刷
local function DisableMarkDrawing()
    if CS.LPCFramework.TerrainLuaDelegates.EnableMarkDrawing(false) then
        GotoNonePage()
    end
end

-- 保存记录
local function SaveFile()
    if CS.LPCFramework.TerrainLuaDelegates.SaveGridPropertyToFile(CurrentLevelId) then
        UIManager.showTip({ content = "保存地图配置成功" , result = true })
    else
        UIManager.showTip({ content = "保存地图配置失败" , result = false })
    end
end

-- 去菜单页
GotoNonePage = function()
    EnableManualMarking(false)

    view.State_C.selectedIndex = 0
end
-- 去选择关卡页
GotoSelectLevelPage = function()
    EnableManualMarking(false)

    view.State_C.selectedIndex = 1
end
-- 去设置地表类型页
GotoGroudMenuPage = function()
    view.PageGroundMenu:SetPosition(Stage.inst.touchPosition.x, Stage.inst.touchPosition.y, 0)
    EdgeProcessing()

    EnableManualMarking(true)

    view.State_C.selectedIndex = 2
end

-- 加载场景
-- Todo：LevelManager.LoadScene需要修改为使用地图Id方式加载
local function OnLoadLevel(levelType)
    LevelManager.loadSceneForDebug(levelType, levelLogicScript)

end

-- 更新选择关卡列表
local function UpdateSelectLevelList()
    view.ListLevels:RemoveChildrenToPool()

    for k,v in pairs(Levels) do
        if LevelConfig[v] ~= nil then
            local item = view.ListLevels:AddItemFromPool()
            item.title = LevelConfig[v].SceneName
            item.onClick:Set(
            function()
                OnLoadLevel(v)
            end)
        end
    end
end

function _C:onCreat()
    view = _C.View

    UpdateSelectLevelList()

    view.BtnClose.onClick:Set(GotoNonePage)
    view.BtnSelectLevel.onClick:Set(GotoSelectLevelPage)
    view.BtnSave.onClick:Set(SaveFile)

    -- 地表菜单按钮事件
    view.BtnPGMLeft.onClick:Set(SetGroundAsObstacle)
    view.BtnPGMTop.onClick:Set(SetGroundAsWater)
    view.BtnPGMRight.onClick:Set(SetGroundAsOpenSpace)
    view.BtnPGMBottom.onClick:Set(DisableMarkDrawing)

    Stage.inst.onMouseWheel:Set(GotoGroudMenuPage)

    Event.addListener(Event.HIT_OPEN_SPACE, GotoGroudMenuPage)
    Event.addListener(Event.CLOSE_CITY_MENU, GotoNonePage)
end

function _C:onOpen()
    CurrentLevelId = LevelManager.CurrLevelLogic:getCurrentMapId()
end

function _C:onDestroy()
    Event.removeListener(Event.HIT_OPEN_SPACE, GotoGroudMenuPage)
    Event.removeListener(Event.CLOSE_CITY_MENU, GotoNonePage)
end