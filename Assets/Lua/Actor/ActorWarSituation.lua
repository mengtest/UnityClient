-- ==============================================================================
--
-- Created: 2017-5-26
-- Author: BitZhang
-- Company: LightPaw
--
-- ==============================================================================

-- 思路
-- 初始给定N个采样点, 军情的开始时间和结束时间, 在进入大地图的时候, 需要根据当前时间, 开始时间和结束时间算出
-- 当前处于运动轨迹的哪一段, 然后根据给定的采样点算出以当前时间为起点的真实位置起点.再开始让马沿路径行走.

local ActorBehaviourBase = require "Actor.ActorBehaviourBase"

local ActorWarSituation = ActorBehaviourBase:extend("ActorWarSituation")

-- 新计算的路径点(当前时间所得的起点和之后的所有点)
ActorWarSituation.PathData = { }
-- 行军的速度
ActorWarSituation.Speed = 0
-- 取得的采样点的数量,只计算一次后续直接使用
ActorWarSituation.OldPathDataCount = 0
-- ActorWarSituation.PathData的数量,只计算一次后续直接使用 
ActorWarSituation.NewPathDataCount = 0
-- 当前行走到了哪一段的编号
ActorWarSituation.CurrentPathIndex = 0
-- 当前行走线段的起始时间
ActorWarSituation.CurrentPathStartTime = 0 
-- 当前行走线段的所需时间
ActorWarSituation.CurrentPathTimeNeed = 0
-- 当前行走线段的方向
ActorWarSituation.MoveDirection = nil

function ActorWarSituation:initialize(objInstance, insInfo, config, position, rotation)
    if objInstance == nil then
        return
    end
    self.super.initialize(self, objInstance) 
end

-- 每次新的数据到达时 清除所有上次的数据
function ActorWarSituation:Clear()
    self.PathData = {}
    self.Speed = 0
    self.OldPathDataCount = 0
    self.NewPathDataCount = 0
    self.CurrentPathIndex = 0
    self.CurrentPathStartTime = 0
    self.CurrentPathTimeNeed = 0
    self.MoveDirection = nil
end

function ActorWarSituation:SetMovePath(pathData, startTime, endTime)
    self:Clear()
    self.OldPathDataCount = Utils.GetTableLength(pathData) 
    local totalDis = self:CalTotalDistance(pathData)
    self.Speed = totalDis / (endTime - startTime)
    local movedDis = (TimerManager.currentTime - startTime) * self.Speed
    if movedDis < 0 then
        movedDis = 0
    end

    self:CalNewPathData(pathData, movedDis)
    self:onWalk()
end

-- 计算总路径长度(用来计算速度)
function ActorWarSituation:CalTotalDistance(pathData)
    local dis = 0
    for i, v in ipairs(pathData) do
        if v ~= nil then
            if i + 1 > self.OldPathDataCount then
                break
            end
            dis = dis + math.sqrt(math.pow(pathData[i].x - pathData[i + 1].x, 2) + math.pow(pathData[i].y - pathData[i + 1].y, 2) + math.pow(pathData[i].z - pathData[i + 1].z, 2))
        end
    end

    return dis
end

function ActorWarSituation:CalNewPathData(pathData, movedDis)
    if movedDis == 0 then
        self.PathData = pathData
        self.NewPathDataCount = self.OldPathDataCount 
        return
    end
    local dis = 0                                   -- 前n段路程的总和
    local findNewStartPos = false
    for i, v in ipairs(pathData) do
        if i + 1 > self.OldPathDataCount then
            table.insert(self.PathData, v)          -- 最后一个点直接插入列表
            break
        end

        if findNewStartPos then
            table.insert(self.PathData, v)          -- 新起点找到之后的点都直接插入列表
        else
            local length = math.sqrt(math.pow(pathData[i].x - pathData[i + 1].x, 2) + math.pow(pathData[i].y - pathData[i + 1].y, 2) + math.pow(pathData[i].z - pathData[i + 1].z, 2))  -- 当前一个线段的长度
            dis = dis + length 

            if dis > movedDis then
                -- 计算新的起点位置
                local pointX = ((length - (dis - movedDis)) / length) * (pathData[i + 1].x - pathData[i].x) + pathData[i].x
                local pointY = ((length - (dis - movedDis)) / length) * (pathData[i + 1].y - pathData[i].y) + pathData[i].y
                local pointZ = ((length -(dis - movedDis)) / length) *(pathData[i + 1].z - pathData[i].z) + pathData[i].z
                findNewStartPos = true
                table.insert(self.PathData, { x = pointX, y = pointY, z = pointZ })
            end
        end
    end

    self.NewPathDataCount = Utils.GetTableLength(self.PathData) 
end

function ActorWarSituation:setPos()
    self.actor.gameObject.transform.position = CS.UnityEngine.Vector3(self.PathData[self.CurrentPathIndex].x, self.PathData[self.CurrentPathIndex].y, self.PathData[self.CurrentPathIndex].z) 
end

function ActorWarSituation:setMoveDirection()
    if self.CurrentPathIndex < self.NewPathDataCount then
        local x = self.PathData[self.CurrentPathIndex + 1].x - self.PathData[self.CurrentPathIndex].x
        local y = self.PathData[self.CurrentPathIndex + 1].y - self.PathData[self.CurrentPathIndex].y
        local z = self.PathData[self.CurrentPathIndex + 1].z - self.PathData[self.CurrentPathIndex].z
        self.MoveDirection = CS.UnityEngine.Vector3(x, y, z).normalized 
        self.actor.gameObject.transform.forward = self.MoveDirection  
    end
end

function ActorWarSituation:update()
    if self.CurrentPathIndex  == 0 then
        self.CurrentPathIndex  = 1
        self.CurrentPathStartTime = TimerManager.currentTime
        self:CalCurrentPathTimeNeed() 
        self:setPos() 
        self:setMoveDirection()
    else
        if TimerManager.currentTime < self.CurrentPathStartTime + self.CurrentPathTimeNeed then
            if self.MoveDirection ~= nil then 
                self.actor.gameObject.transform:Translate(self.MoveDirection * self.Speed * TimerManager.deltaTime, CS.UnityEngine.Space.World)
            end
        else
            self.CurrentPathIndex = self.CurrentPathIndex + 1
            if self.CurrentPathIndex < self.NewPathDataCount then
                self.CurrentPathStartTime = TimerManager.currentTime
                self:CalCurrentPathTimeNeed()
                self:setMoveDirection()
            end
        end
    end
end

function ActorWarSituation:CalCurrentPathTimeNeed()
    if self.PathData[self.CurrentPathIndex] == nil or self.PathData[self.CurrentPathIndex + 1] == nil then
        return
    end
    self.CurrentPathTimeNeed = math.sqrt(
    math.pow(self.PathData[self.CurrentPathIndex].x - self.PathData[self.CurrentPathIndex + 1].x, 2)
    + math.pow(self.PathData[self.CurrentPathIndex].y - self.PathData[self.CurrentPathIndex + 1].y, 2)
    + math.pow(self.PathData[self.CurrentPathIndex].z - self.PathData[self.CurrentPathIndex + 1].z, 2)) / self.Speed
end 

return ActorWarSituation