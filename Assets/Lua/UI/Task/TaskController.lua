local _C = UIManager.Controller(UIManager.ControllerName.Task, UIManager.ViewName.Task)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
local taskData = nil

-- 整理后有意义的分支任务数据，去掉了为空的数据
local meaningfulBranchTaskData = { }
-- 记录领取任务奖励的任务Id
local collectPrizeTaskId = -1
-- 记录领取任务奖励的任务是否为主线任务
local collectPrizeTaskIsMain = false
-- 记录是不是在进行建筑的升级,由于建筑必须点击主城内的模型,如果在野外必须先回到主城再打开要升级的建筑
local isUpgradeBuilding = false
local upgradeBuildingTaskConfig = nil

local function BackBtnOnClick()
    _C:close()
end

-- 跳转
local function GotoTaskDestination(taskConfig)
    if taskConfig == nil then
        return
    end

    -- 城池等级，到主城界面
    if taskConfig.Target.Type == TaskTargetType.TASK_TARGET_BASE_LEVEL then
        _C:close()
        -- 君主等级，去君主界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_HERO_LEVEL then
        UIManager.openController(UIManager.ControllerName.Lords, DataTrunk.PlayerInfo.MonarchsData)
        -- 科技等级，去指定科技的升级界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_TECH_LEVEL then
        local tech = TechnologyConfig:getConfigById(taskConfig.Target.SubType)
        UIManager.openController(UIManager.ControllerName.UpgradeTechnology, { type = tech.Type, sequence = tech.Sequence })
        -- 建筑升级，去指定建筑的升级界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_BUILDING_LEVEL then
        -- 此处应该缓存下所要的配置,如果是在城外的话 先回到主程内再打开升级
        isUpgradeBuilding = true
        upgradeBuildingTaskConfig = taskConfig
        Event.dispatch(Event.ENTER_MAIN_CITY)
        -- 武将数量，去酒馆
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_CAPTAIN_COUNT then
        UIManager.openController(UIManager.ControllerName.Tavern)
        -- 武将等级、千重楼通关N层，去千重楼
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_CAPTAIN_LEVEL_COUNT or
        taskConfig.Target.Type == TaskTargetType.TASK_TARGET_TOWER_FLOOR then
        UIManager.openController(UIManager.ControllerName.ClimbingTowerMain)
        -- 武将品质、强化，去武将界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_CAPTAIN_QUALITY_COUNT or
        taskConfig.Target.Type == TaskTargetType.TASK_TARGET_CAPTAIN_REFINED_TIMES then
        UIManager.openController(UIManager.ControllerName.General)
        -- 武将装备，去装备界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_CAPTAIN_EQUIPMENT then
        UIManager.openController(UIManager.ControllerName.CaptainEquipMain)
        -- 武将修炼，修炼位，去修炼界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_TRAINING_USE_COUNT or
        taskConfig.Target.Type == TASK_TARGET_TRAINING_LEVEL_COUNT then
        UIManager.openController(UIManager.ControllerName.PracticeHall)
        -- 训练、治疗士兵、去军营界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_RECRUIT_SOLDIER_COUNT or
        taskConfig.Target.Type == TaskTargetType.TASK_TARGET_HEAL_SOLDIER_COUNT then
        UIManager.openController(UIManager.ControllerName.Barrack)
        --士兵进阶, 去进阶界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_SOLDIER_LEVEL then
        UIManager.openController(UIManager.ControllerName.SoldierUpgrade)
        -- 野外种地、收获，去野外场景
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_RESOURCE_POINT_COUNT or
        taskConfig.Target.Type == TaskTargetType.TASK_TARGET_COLLECT_RESOURCE then
        _C:close()
        Event.dispatch(Event.ENTER_OUTSIDE)
        -- 联盟功能，去联盟界面
    elseif taskConfig.Target.Type == TaskTargetType.TASK_TARGET_JOIN_GUILD then
        -- 未加入联盟，打开选择联盟界面；否则打开我的联盟界面
        if DataTrunk.PlayerInfo.MonarchsData.GuildId == 0 then
            UIManager.openController(UIManager.ControllerName.CreateOrJoinAlliance)
        else
            UIManager.openController(UIManager.ControllerName.Alliance)
        end
    end
end

-- 领取任务奖励
local function OnCollectPrize(taskId, isMainTask)
    if taskId > 0 then
        collectPrizeTaskId = taskId
        collectPrizeTaskIsMain = isMainTask
        NetworkManager.C2SCollectTaskPrize(taskId)
    end
end

-- 更新主任务
local function UpdateMainTask()
    local mainTaskConfig = TaskConfig:getMainTaskConfigById(taskData.MainTaskId)

    if mainTaskConfig == nil then
        return
    end
    -- 任务完成，显示领取按钮
    if taskData.MainTaskCompleted == true then
        view.MainTask:GetController("wancheng").selectedIndex = 0
        view.MainTask:GetTransition("wancheng_yun"):Play()
        view.MainTask:GetTransition("huode"):Play()
        view.MainTask:GetChild("btn_lingqu").onClick:Set(
        function()
            OnCollectPrize(taskData.MainTaskId, true)
        end )
        -- 任务未完成，显示前往按钮
    else
        view.MainTask:GetController("wancheng").selectedIndex = 1
        view.MainTask:GetTransition("wancheng_yun"):Stop()
        view.MainTask:GetTransition("huode"):Stop()
        view.MainTask:GetChild("btn_qianwang").onClick:Set(
        function()
            GotoTaskDestination(mainTaskConfig)
        end )
    end

    -- 显示任务名字，任务内容
    view.MainTask:GetChild("txt_leixing").text = Localization.TaskPrefixMain
    view.MainTask:GetChild("txt_biaoti").text = mainTaskConfig.Name
    view.MainTask:GetChild("txt_neirong").text = mainTaskConfig.Text

    -- 显示进度
    view.MainTask:GetChild("progressBar_renwu").value = taskData.MainTaskProgress
    view.MainTask:GetChild("progressBar_renwu").max = mainTaskConfig.Target.TotalProgress

    -- 显示奖励
    local prizeList = view.MainTask:GetChild("list_jiangli")
    prizeList:RemoveChildrenToPool()

    if mainTaskConfig ~= nil then
        -- 通货
        for k, v in pairs(mainTaskConfig.Prize.Currencys) do
            local prizeItem = prizeList:AddItemFromPool(UIConfig.BtnIcon2Xiao3)
            prizeItem.icon = v.Config.Icon
            prizeItem.title = v.Amount
            prizeItem:GetController("Count_C").selectedIndex = 1
            prizeItem:GetController("State_C").selectedIndex = 1
            -- 添加监听
            prizeItem.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)
        end

        -- 物品
        for k, v in pairs(mainTaskConfig.Prize.Goods) do
            local prizeItem = prizeList:AddItemFromPool(UIConfig.BtnIcon2Xiao3)
            prizeItem.icon = v.Config.Icon
            prizeItem:GetController("State_C").selectedIndex = 1
            if v.Amount > 1 then
                prizeItem:GetController("Count_C").selectedIndex = 1
                prizeItem.title = v.Amount
            else
                prizeItem:GetController("Count_C").selectedIndex = 0
            end

            -- 添加监听
            prizeItem.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)
        end

        -- 装备
        for k, v in pairs(mainTaskConfig.Prize.Equips) do
            local prizeItem = prizeList:AddItemFromPool(UIConfig.BtnIcon2Xiao3)
            prizeItem.icon = v.Config.Icon
            prizeItem:GetController("State_C").selectedIndex = 1
            if v.Amount > 1 then
                prizeItem:GetController("Count_C").selectedIndex = 1
                prizeItem.title = v.Amount
            else
                prizeItem:GetController("Count_C").selectedIndex = 0
            end

            -- 添加监听
            prizeItem.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)
        end
    end
end

local function TaskListRenderer(index, obj)
    -- 获取任务配置
    local data = meaningfulBranchTaskData[index + 1]

    if data ~= nil then
        local branchTaskConfig = TaskConfig:getBranchTaskConfigById(data.Id)

        -- 任务完成，显示领取按钮
        if data.Complete == true then
            obj:GetController("wancheng").selectedIndex = 0
            obj:GetTransition("wancheng_yun"):Play()
            obj:GetTransition("huode"):Play()
            obj:GetChild("btn_lingqu").onClick:Set(
            function()
                OnCollectPrize(data.Id, false)
            end )
            -- 任务未完成，显示前往按钮
        else
            obj:GetController("wancheng").selectedIndex = 1
            obj:GetTransition("wancheng_yun"):Stop()
            obj:GetTransition("huode"):Stop()
            obj:GetChild("btn_qianwang").onClick:Set(
            function()
                GotoTaskDestination(branchTaskConfig)
            end )
        end

        -- 显示任务名字，任务内容
        obj:GetChild("txt_leixing").text = Localization.TaskPrefixBranch
        obj:GetChild("txt_biaoti").text = branchTaskConfig.Name
        obj:GetChild("txt_neirong").text = branchTaskConfig.text

        -- 显示进度
        obj:GetChild("progressBar_renwu").value = data.Progress
        obj:GetChild("progressBar_renwu").max = branchTaskConfig.Target.TotalProgress

        -- 显示奖励
        local prizeList = obj:GetChild("list_jiangli")
        prizeList:RemoveChildrenToPool()

        if branchTaskConfig ~= nil then
            -- 通货
            for k, v in pairs(branchTaskConfig.Prize.Currencys) do
                local prizeItem = prizeList:AddItemFromPool(UIConfig.BtnIcon2Xiao3)
                prizeItem.icon = v.Config.Icon
                prizeItem.title = v.Amount
                prizeItem:GetController("Count_C").selectedIndex = 1
                prizeItem:GetController("State_C").selectedIndex = 1
                -- 添加监听
                prizeItem.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)
            end

            -- 物品
            for k, v in pairs(branchTaskConfig.Prize.Goods) do
                local prizeItem = prizeList:AddItemFromPool(UIConfig.BtnIcon2Xiao3)
                prizeItem.icon = v.Config.Icon
                prizeItem:GetController("State_C").selectedIndex = 1
                if v.Amount > 1 then
                    prizeItem:GetController("Count_C").selectedIndex = 1
                    prizeItem.title = v.Amount
                else
                    prizeItem:GetController("Count_C").selectedIndex = 0
                end

                -- 添加监听
                prizeItem.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)
            end

            -- 装备
            for k, v in pairs(branchTaskConfig.Prize.Equips) do
                local prizeItem = prizeList:AddItemFromPool(UIConfig.BtnIcon2Xiao3)
                prizeItem.icon = v.Config.Icon
                prizeItem:GetController("State_C").selectedIndex = 1
                if v.Amount > 1 then
                    prizeItem:GetController("Count_C").selectedIndex = 1
                    prizeItem.title = v.Amount
                else
                    prizeItem:GetController("Count_C").selectedIndex = 0
                end

                -- 添加监听
                prizeItem.onClick:Set( function() UIManager.openController(UIManager.ControllerName.ItemTips, v) end)
            end
        end
    end
end

-- 更新分支任务
local function UpdateBranchTask()
    local maxLength = 0
    meaningfulBranchTaskData = { }


    -- 整理不为空的分支任务
    for k, v in pairs(taskData.BranchTaskIdList) do
        if v ~= nil then
            -- print("现在活着的分支任务有", v)
            local taskInfo = { }
            taskInfo.Id = v
            taskInfo.Progress = taskData.BranchTaskProgressList[v]
            taskInfo.Complete = taskData.BranchTaskCompletedList[v]

            table.insert(meaningfulBranchTaskData, taskInfo)
            maxLength = maxLength + 1
        end
    end

    view.BranchTaskList.itemRenderer = TaskListRenderer
    view.BranchTaskList.numItems = maxLength
end
-- 显示获得任务奖励界面
local function ShowGetPrizePanel(taskId)
    -- 如果界面没有打开
    if not _C.IsOpen then
        return
    end

    if taskId ~= collectPrizeTaskId then
        return
    end

    local taskConfig = nil
    if collectPrizeTaskIsMain == true then
        taskConfig = TaskConfig:getMainTaskConfigById(taskId)
    else
        taskConfig = TaskConfig:getBranchTaskConfigById(taskId)
    end

    UIManager.openController(UIManager.ControllerName.TaskPrize, taskConfig)
    -- 如果没有新的支线任务则不能更新支线任务列表,会导致上次的任务残留 故在领奖之后更新一下支线任务
    UpdateBranchTask()
end

local function UpdateTask()

    -- 如果界面没有打开
    if not _C.IsOpen then
        return
    end

    UpdateMainTask()
    UpdateBranchTask()
end

function _C:onOpen()
    taskData = DataTrunk.PlayerInfo.TaskData
    UpdateTask()
end

function _C:onCreat()
    view = _C.View

    view.BackBtn.onClick:Set(BackBtnOnClick)

    Event.addListener(Event.UDPATE_TASK, UpdateTask)
    Event.addListener(Event.COLLECT_TASK_PRIZE_SUCCESS, ShowGetPrizePanel)
    Event.addListener(Event.NEW_TASK, UpdateTask)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onUpdate()
    if isUpgradeBuilding then
        isUpgradeBuilding = false
        if upgradeBuildingTaskConfig.Target ~= nil then
            -- 建筑类型
            local buildingType = upgradeBuildingTaskConfig.Target.SubType
            -- 值是否有效
            if buildingType > BuildingType.None and buildingType <= BuildingType.CityBuildingCount then
                local name = ""
                if buildingType == BuildingType.FeudalOfficial then
                    name = "FeudalOfficial"
                elseif buildingType == BuildingType.Warehouse then
                    name = "Warehouse"
                elseif buildingType == BuildingType.Tavern then
                    name = "Tavern"
                elseif buildingType == BuildingType.Barrack then
                    name = "Barrack"
                elseif buildingType == BuildingType.Academy then
                    name = "Academy"
                elseif buildingType == BuildingType.Rampart then
                    name = "Rampart"
                elseif buildingType == BuildingType.Recruitment then
                    name = "Recruitment"
                elseif buildingType == BuildingType.Recruitment then
                    name = "Recruitment"
                elseif buildingType == BuildingType.Smithy then
                    name = "Smithy"
                elseif buildingType == BuildingType.Campsite then
                    name = "Campsite"
                end
                CS.LPCFramework.CameraController.SetTargetCamera(name)
                UIManager.openController(UIManager.ControllerName.Upgrade, DataTrunk.PlayerInfo.InternalAffairsData.BuildingsInfo[buildingType])
            else
                print("[warning] 任务跳转建筑升级，错误的参数值SubType")
            end
        end

        upgradeBuildingTaskConfig = nil
    end
end

function _C:onDestroy()
    view.BackBtn.onClick:Clear()
    Event.removeListener(Event.UDPATE_TASK, UpdateTask)
    Event.removeListener(Event.COLLECT_TASK_PRIZE_SUCCESS, ShowGetPrizePanel)
    Event.removeListener(Event.NEW_TASK, UpdateTask)
end