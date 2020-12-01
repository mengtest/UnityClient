local _C = UIManager.Controller(UIManager.ControllerName.ToolsMainPage, UIManager.ViewName.ToolsMainPage)
_C.IsPopupBox = true

local view = nil

-- ��ͼ���˴���hardcode����Ҫ�ȹؿ���������Ϻ󣬴ӱ���ȡҰ���ͼ���͵�ͼid
local Levels = {
    LevelType.WorldMap
}

local levelLogicScript = "LevelLogic.MapEditorLevelLogic"

local function OnCloseSelf()
    _C:close()
end

-- ���س���
-- Todo��LevelManager.LoadScene��Ҫ�޸�Ϊʹ�õ�ͼId��ʽ����
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

-- ����ѡ��ؿ��б�
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