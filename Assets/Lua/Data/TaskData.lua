-- ConfigData.MainTask 主线任务数据
-- ConfigData.BranchTask 支线任务数据
-- TaskData 英雄任务数据
-- ConfigData.TaskBox 任务宝箱数据
-- 从以上数据中可以获取到完整的任务列表


-- 任务实例化信息
local TaskData = { }
-- 主线任务id，0表示所有主线都清掉了
TaskData.MainTaskId = 0
-- 主线任务进度
TaskData.MainTaskProgress = 0
-- 主线任务是否已完成
TaskData.MainTaskCompleted = false
-- 支线任务id
TaskData.BranchTaskIdList = {}
-- 支线任务进度
TaskData.BranchTaskProgressList = {}
-- 支线任务是否已完成
TaskData.BranchTaskCompletedList = {}
-- 已领取的宝箱id
TaskData.CollectTaskBoxId = 0

function TaskData:updateInfo(data)
    if data == nil then
        return
    end

    self:clear()
    
    if data.main_task_id ~= nil then
        self.MainTaskId = data.main_task_id
    end

    if data.main_task_progress ~= nil then
        self.MainTaskProgress = data.main_task_progress
    end

    -- 获取主线任务配置，判断是否已经完成
    local mainConfig = TaskConfig:getMainTaskConfigById(self.MainTaskId)
    if mainConfig ~= nil then
        if self.MainTaskProgress >= mainConfig.Target.TotalProgress then
            self.MainTaskCompleted = true
        else
            self.MainTaskCompleted = false
        end
    end

    -- 更新分支任务id，进度，是否完成
    if data.branch_task_id ~= nil then
        for i = 1, #data.branch_task_id do
            local taskId = data.branch_task_id[i]
            if taskId ~= nil then
                local taskProgress = 0
                local taskCompleted = false
                -- 任务进度
                taskProgress = data.branch_task_progress[i]

                if taskProgress == nil then
                    taskProgress = 0
                end
                -- 获取支线任务配置，判断是否已经完成
                local branchConfig = TaskConfig:getBranchTaskConfigById(taskId)
                if branchConfig ~= nil then
                    if taskProgress >= branchConfig.Target.TotalProgress then
                        taskCompleted = true
                    else
                        taskCompleted = false
                    end
                end
                
                self.BranchTaskIdList[taskId] = taskId
                self.BranchTaskProgressList[taskId] = taskProgress
                self.BranchTaskCompletedList[taskId] = taskCompleted
            end
        end
    end

    if data.collect_task_box_id ~= nil then
        self.CollectTaskBoxId = data.collect_task_box_id
    end
end

function TaskData:clear()
    self.MainTaskId = 0
    self.MainTaskProgress = 0
    self.MainTaskCompleted = false
    self.BranchTaskIdList = {}
    self.BranchTaskProgressList = {}
    self.BranchTaskCompletedList = {}
    self.CollectTaskBoxId = 0
end

--****************************************************************
-- 注册服务器消息监听
--****************************************************************

-- 更新任务进度
-- module 15, msgId = 1
-- id: int // 任务id
-- progress: int // 任务进度
-- complete: bool // true表示任务完成，可以领取奖励了
local function S2CUpdateTaskProgressProto(data)
    if data ~= nil then
        if data.id == TaskData.MainTaskId then
            TaskData.MainTaskProgress = data.progress
            TaskData.MainTaskCompleted = data.complete
            -- 发送事件
            Event.dispatch(Event.UDPATE_TASK, data.id)

        elseif nil ~= TaskData.BranchTaskIdList[data.id] then
            TaskData.BranchTaskProgressList[data.id] = data.progress
            TaskData.BranchTaskCompletedList[data.id] = data.complete
            -- 发送事件
            Event.dispatch(Event.UDPATE_TASK, data.id)
        end
    end
end
task_decoder.RegisterAction(task_decoder.S2C_UPDATE_TASK_PROGRESS, S2CUpdateTaskProgressProto)

--****************************************************************
-- 领取任务奖励
-- module 15, msgId = 3
-- id: int // 任务id
local function S2CCollectTaskPrizeProto(data)
    if data ~= nil then
        --print("领取任务奖励成功~~~~~~~", data.id)
        -- 如果是支线任务，需要清理
        if nil ~= TaskData.BranchTaskIdList[data.id] then
            TaskData.BranchTaskIdList[data.id] = nil
            TaskData.BranchTaskProgressList[data.id] = nil
            TaskData.BranchTaskCompletedList[data.id] = nil
        end

        -- 发送事件
        Event.dispatch(Event.COLLECT_TASK_PRIZE_SUCCESS, data.id)
    end
end
task_decoder.RegisterAction(task_decoder.S2C_COLLECT_TASK_PRIZE, S2CCollectTaskPrizeProto)

-- 领取任务奖励失败
-- moduleId = 15, msgId = 4
local function S2CFailCollectTaskPrizeProto(code)
    UIManager.showNetworkErrorTip(task_decoder.ModuleID,task_decoder.S2C_FAIL_COLLECT_TASK_PRIZE,code)
end
task_decoder.RegisterAction(task_decoder.S2C_FAIL_COLLECT_TASK_PRIZE, S2CFailCollectTaskPrizeProto)

--****************************************************************
-- 接受新任务，任务接受的时候可能就已经有进度或者完成了
-- module 15, msgId = 5
-- id: int // 任务id
-- progress: int // 任务进度
-- complete: bool // true表示任务完成，可以领取奖励了
-- main: bool // true表示主线任务
local function S2CNewTaskProto(data)
    if data ~= nil then
    --print("来新任务啦", data)
        if data.main == true then
            TaskData.MainTaskId = data.id
            TaskData.MainTaskProgress = data.progress
            TaskData.MainTaskCompleted = data.complete
        else
        --print("是分支任务哦")
            TaskData.BranchTaskIdList[data.id] = data.id
            TaskData.BranchTaskProgressList[data.id] = data.progress
            TaskData.BranchTaskCompletedList[data.id] = data.complete
        end
        -- 发送事件
        Event.dispatch(Event.NEW_TASK, data.id)
    end
end
task_decoder.RegisterAction(task_decoder.S2C_NEW_TASK, S2CNewTaskProto)

--****************************************************************
-- 领取累积宝箱奖励
-- module 15, msgId = 7
-- id: int // 任务宝箱id
local function S2CCollectTaskBoxPrizeProto(data)
    if data ~= nil then
        -- 发送事件
        Event.dispatch(Event.COLLECT_TASK_BOX_PRIZE_SUCCESS, data.id)
    end
end
task_decoder.RegisterAction(task_decoder.S2C_COLLECT_TASK_BOX_PRIZE, S2CCollectTaskBoxPrizeProto)

-- 领取累积宝箱奖励失败
-- moduleId = 15, msgId = 8
local function S2CFailCollectTaskBoxPrizeProto(code)
    UIManager.showNetworkErrorTip(task_decoder.ModuleID,task_decoder.S2C_FAIL_COLLECT_TASK_BOX_PRIZE,code)
end
task_decoder.RegisterAction(task_decoder.S2C_FAIL_COLLECT_TASK_BOX_PRIZE, S2CFailCollectTaskBoxPrizeProto)

return TaskData