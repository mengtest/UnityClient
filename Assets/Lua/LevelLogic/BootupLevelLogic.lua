local levelLogic = require "LevelLogic.LevelLogic"
local BootupLevelLogic = levelLogic:extend()
local Event = require "Event.Event"

---------------------------------------------------------
-- 场景事件
---------------------------------------------------------
local logic = nil

--初始化场景地图--
function BootupLevelLogic:initLevel(levelConfig)
    logic.super.initLevel(logic, levelConfig)
end

--进入场景--
function BootupLevelLogic:onEnterScene(callBack)
    logic = self
    logic:initLevel(LevelManager.CurrLevelConfig)
    -- 逻辑处理完成
    callBack()
     -- 打开战斗界面--
    UIManager.openController(UIManager.ControllerName.LoginMain)
end

--退出场景--
function BootupLevelLogic:onExitScene()
end

-- 更新
function BootupLevelLogic:update()    
    
end

return BootupLevelLogic

