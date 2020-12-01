local RegionWarSituation = { }

RegionWarSituation.ACTOR_CLICK_RESPONSE_REDIUS = 1.5
RegionWarSituation.STAY_POINT_COUNT = 4
RegionWarSituation.STAY_CIRCLE_REDIUS = 3
RegionWarSituation.ACTOR_WAR_SITUATION_ID = 11
RegionWarSituation.ACTOR_ATTACKING_ID = 12
RegionWarSituation.ACTOR_INIT_POOL_SIZE = 10
RegionWarSituation.ACTOR_MAX_POOL_SIZE = 20
RegionWarSituation.StayPoints = { }

function RegionWarSituation:NewWarSituationObj()
    local obj = { }
    obj.LineId = -1
    obj.RunningHorse = nil
    obj.StayingHorse = nil
    return obj
end

function RegionWarSituation:ShowLine(fromX, fromY, toX, toY, color)
    return CS.LPCFramework.TerrainLuaDelegates.ShowLine(fromX, fromY, toX, toY, color)
end

function RegionWarSituation:HideLine(lineId)
    if lineId ~= -1 then
        CS.LPCFramework.TerrainLuaDelegates.HideLine(lineId)
    end
end

function RegionWarSituation:ShowHorseRun(combineId, fromX, fromY, toX, toY, startTime, arrivedTime)
    local insInfo = { }
    insInfo.InsId = combineId  
    local posInfo = self:GetPath(fromX, fromY, toX, toY)
    local instance = GameObjectManager.spawnActor(insInfo, self.ACTOR_WAR_SITUATION_ID, 1, nil, nil, nil)
    GameObjectManager.SetGameObjectMovePath(insInfo, posInfo, startTime, arrivedTime, true)
    return instance
end

function RegionWarSituation:ClearHorseRun(horse, id)
    if horse ~= nil then
        GameObjectManager.returnObjectToPool(horse.actor, id, self.ACTOR_WAR_SITUATION_ID, true)
    end
end

function RegionWarSituation:ShowHorseStay(combineId, targetId, fromX, fromY, toX, toY, actionType)
    local insInfo = { }
    insInfo.InsId = combineId
    local posInfo = self:GetPath(fromX, fromY, toX, toY)
    local finialPoint = posInfo[#posInfo]
    local instance = GameObjectManager.spawnActor(insInfo, self.ACTOR_ATTACKING_ID, 1, nil, nil, nil)
    local x, z = self:GetStayPoint(finialPoint.x, finialPoint.z, instance, targetId)
    instance:setPosAndDir(x, finialPoint.y, z, finialPoint.x, finialPoint.y, finialPoint.z, actionType)
    return instance
end

function RegionWarSituation:ClearHorseStay(horse, id)
    for k, v in pairs(self.StayPoints) do
        for k1, v1 in pairs(v) do
            if v1.script == horse then
                v1.script = nil
                v1.target = nil
            end
        end
    end

    if horse ~= nil then
        GameObjectManager.returnObjectToPool(horse.actor, id, self.ACTOR_ATTACKING_ID, true)
    end
end

-- 根据起点和终点坐标获取路径坐标信息
function RegionWarSituation:GetPath(fromX, fromY, toX, toY)
    return CS.LPCFramework.TerrainLuaDelegates.SamplePosition(fromX, fromY, toX, toY)
end

function RegionWarSituation:GetStayPoint(posX, posZ, script, targetId)
    -- 如果坐标点是新的,先生成可在城堡周围停留的点
    local key = posX .. posZ
    if self.StayPoints[key] == nil then
        self.StayPoints[key] = { }
        local OneCastleAttackPointInfo = { }
        for i = 1, self.STAY_POINT_COUNT do
            local EachPointInfo = {}
            EachPointInfo.x = self.STAY_CIRCLE_REDIUS * math.cos( 360 / self.STAY_POINT_COUNT * (i - 1) ) + posX
            EachPointInfo.z = self.STAY_CIRCLE_REDIUS * math.sin( 360 / self.STAY_POINT_COUNT * (i - 1) ) + posZ
            EachPointInfo.script = nil
            EachPointInfo.target = nil
            OneCastleAttackPointInfo[i] = EachPointInfo
        end
        self.StayPoints[key] = OneCastleAttackPointInfo
    end

    if self.StayPoints[key] == nil then
        return nil, nil
    end

    -- 获取没有被占用的点来放置攻击或者援助的单位
    for i, v in ipairs(self.StayPoints[key]) do
        if v.script == nil then
            v.script = script
            v.target = targetId
            return v.x, v.z
        elseif v.script == script then
            return v.x, v.z
        end
    end
end

function RegionWarSituation:GetClickedWarSituation(posX, posZ)
    if self.StayPoints == nil then
        return nil
    else
        for k, v in pairs(self.StayPoints) do
            if v ~= nil then
                for k1, v1 in pairs(v) do
                    if math.abs(v1.x - posX) < self.ACTOR_CLICK_RESPONSE_REDIUS
                        and math.abs(v1.z - posZ) < self.ACTOR_CLICK_RESPONSE_REDIUS then
                        return v1.target, v1.script.Action
                    end
                end
            end
        end
    end

    return nil
end

function RegionWarSituation:Clear()
    self.StayPoints = { }
end

return RegionWarSituation