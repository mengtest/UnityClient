local _C = UIManager.Controller(UIManager.ControllerName.ToolsMainPage, UIManager.ViewName.ToolsMainPage)
_C.IsPopupBox = true

local view = nil

-- 地图，此处先hardcode，需要等关卡表格设计完毕后，从表格读取野外地图类型地图id
local Levels = {
    LevelType.WorldMap
}

local levelLogicScript = "LevelLogic.MapEditorLevelLogic"

local function OnCloseSelf()
    _C:close()
end

-- 加载场景
-- Todo：LevelManager.LoadScene需要修改为使用地图Id方式加载
local function OnLoadLevel(levelType)
    LevelManager.loadSceneForDebug(levelType, levelLogicScript)

    UIManager.removeController(UIManager.ControllerName.ToolsMainPage)
    UIManager.removeController(UIManager.ControllerName.LoginMain)
    UIManager.removeController(UIManager.ControllerName.LoginTry)
    UIManager.removeController(UIManager.ControllerName.Login2Register)
    UIManager.removeController(UIManager.ControllerName.LoginServer)
    UIManager.removeController(UIManager.ControllerName.CreatRole)
    UIManager.removeController(UIManager.ControllerName.ServerList)
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
    
    view.BtnClose.onClick:Set(OnCloseSelf)
    
    UpdateSelectLevelList()
end