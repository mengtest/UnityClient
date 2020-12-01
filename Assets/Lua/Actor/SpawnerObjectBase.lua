-- ==============================================================================
--
-- Created: 2017-3-3
-- Author: Panda
-- Company: LightPaw
--
-- ==============================================================================

local GameObjectBase = require "Actor.GameObjectBase"
local SpawnerObjectBase = GameObjectBase:extend("SpawnerObjectBase")

function SpawnerObjectBase:init()
end
-- 初始化
-- <param name="gameObject" type="GameObject"></param>
-- <param name="insInfo" type="table"></param>
-- <param name="config" type="GameObjectConfig"></param>
function SpawnerObjectBase:initialize(gameObject, insInfo, config, speedRate)
    self.super.initialize(self, gameObject, insInfo, config, speedRate)

    if nil == config or not config.lifeTime == -1 then
        return
    end
    self:setAliveTime(config.lifeTime)
    self.aliveTimer:start()
end
return SpawnerObjectBase

