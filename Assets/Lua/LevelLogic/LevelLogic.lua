local LevelLogic = Class("LevelLogic")

LevelLogic.Config = nil
LevelLogic.SpeedRate = nil

-- 初始化场景地图--
function LevelLogic:initLevel(levelConfig)
    self.Config = levelConfig
    self.SpeedRate = 1
end
-- 更新--
function LevelLogic:update()
    GameObjectManager.update()
end

return LevelLogic

