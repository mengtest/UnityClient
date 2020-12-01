local _C = UIManager.Controller(UIManager.ControllerName.WarSituationDetails, UIManager.ViewName.WarSituationDetails)
local view = nil

-- 跳转到此界面的军情Id
local situationId = nil
-- 军情信息
local situationData = { }
-- 附属军情信息
local additionalSituationData = { }

-- 军情的数量
local situationDataLength = 0
-- 额外军情的数量
local additionalSituationDataLength = 0
-- 出征数据
local combatInfo = nil

-- 行军计时器列表
local marchTimerList = { }

local OnExpel = nil 


local function BackBtnOnClick()
    _C:close()
end

local function SetTimerVisible(icon, text, visible)
    if visible then
        if not icon.visible then
            icon.visible = true
        end
        if not text.visible then
            text.visible = true
        end
    else
        if icon.visible then
            icon.visible = false
        end
        if text.visible then
            text.visible = false
        end
    end
end

-- 显示计时器
local function ShowTimer(id, timerIcon, timerText, startTime, endTime, isAscend)
    if id == nil or timerIcon == nil or timerText == nil or startTime == nil or endTime == nil then
        return
    end

    -- 倒计时，还有多久; 正计时，已经进行了多久
    local remainSeconds = startTime - endTime
    remainSeconds = math.floor(remainSeconds + 0.5)
    local maxCount = remainSeconds
    if isAscend == true then
        maxCount = 999999
    end

    -- 如果已经存在且正负序不同，删除它
    if marchTimerList[id] ~= nil and marchTimerList[id].IsAscend ~= isAscend then
        TimerManager.disposeTimer(marchTimerList[id])
        marchTimerList[id] = nil
    end

    if marchTimerList[id] == nil then
        marchTimerList[id] = TimerManager.newTimer(maxCount, false, true,
        nil,
        -- 更新
        function(t, f)
            -- 显示时间信息
            SetTimerVisible(timerIcon, timerText, true and f >= 0)
            timerText.text = Utils.secondConversion(math.floor(f))
        end
        ,
        -- 结束
        function()
            -- 隐藏时间信息
            SetTimerVisible(timerIcon, timerText, false)
        end
        ,
        self,
        isAscend)
        -- 频繁的更新虚拟列表，导致之前的render item被清空，需要设置最新的item给timer的回调函数
    else
        marchTimerList[id].onUpdate = function(t, f)
            SetTimerVisible(timerIcon, timerText, true and f >= 0)
            timerText.text = Utils.secondConversion(math.floor(f))
        end

        marchTimerList[id].onComplete = function()
            -- 隐藏时间信息
            SetTimerVisible(timerIcon, timerText, false)
        end
    end

    -- 如果时间计时器的max与新计算的remainSeconds不相等，重置为现在时间, 此处考虑到点击召回后remainSeconds
    -- 小于行军的remainSeconds
    if marchTimerList[id].MaxCd ~= maxCount then
        marchTimerList[id]:resetMax(maxCount)
    end

    if marchTimerList[id].IsStart == false then
        marchTimerList[id]:start(remainSeconds)
    end
end 

local function InsertContent(data, obj)
    if data == nil then
        return
    end

    -- 切换到详情Controller
    obj:GetController("c1").selectedIndex = 1
    obj:GetChild("btn_xiangqing").onClick:Set(
    function()
        UIManager.openController(UIManager.ControllerName.WarSituationDetails, data)
    end )

    if data.Self.GuildFlagName == nil or data.Self.GuildFlagName == "" then
        obj:GetChild("txt_wanjia1").text = data.Self.Name
    else
        obj:GetChild("txt_wanjia1").text = string.format("[%s]%s", data.Self.GuildFlagName, data.Self.Name)
    end

    if data.Target.GuildFlagName == nil or data.Target.GuildFlagName == "" then
        obj:GetChild("txt_wanjia2").text = data.Target.Name
    else
        obj:GetChild("txt_wanjia2").text = string.format("[%s]%s", data.Target.GuildFlagName, data.Target.Name)
    end

    local timerIcon = obj:GetChild("img_shijian")
    local timerText = obj:GetChild("txt_daojishi")

    -- 移动类型，0-forward(往目标移动)
    if data.MoveType == MilitaryMoveType.Forward then
        -- 行军中
        obj:GetChild("txt_zhuangtai").text = Localization.OnTheMarch
        -- 显示时间信息
        ShowTimer(data.CombineId, timerIcon, timerText, data.MoveArrivedTime, TimerManager.currentTime, false)
        -- 移动类型，2-back(回家)
    elseif data.MoveType == MilitaryMoveType.Back then
        -- 返回中
        obj:GetChild("txt_zhuangtai").text = Localization.InTheBack
        -- 显示时间信息
        ShowTimer(data.CombineId, timerIcon, timerText, data.MoveArrivedTime, TimerManager.currentTime, false)
    end

    -- 布阵列表
    local buzhenList = obj:GetChild("list_zhiye")
    buzhenList:RemoveChildrenToPool()

    -- 部队
    local fightAmount = 0
    for k, v in pairs(data.CaptainInfoList) do
        if v ~= nil then
            fightAmount = fightAmount + v.FightAmount

            if v.RaceType ~= nil then
                local item = buzhenList:AddItemFromPool(UIConfig.RaceItem)
                item.icon = UIConfig.Race[v.RaceType]
                item.title = ""
            end
        end
    end

    obj:GetChild("txt_shuzi").text = fightAmount
end

-- 正在支援的盟友军情绘制
local function ListRenderer(index, obj)
    -- 我的军情栏
    if index == 0 then
        obj:GetChild("txt_wodejunqing").text = Localization.AllyAssistSituation
        obj:GetChild("txt_shuzi").text = additionalSituationDataLength
    else
        -- 盟友的军情
        local data = additionalSituationData[index]
        InsertContent(data, obj)
    end
end

-- 联盟军情列表提供者
local function ListProvider(index)
    if index == 0 then
        return UIConfig.WarSituation.TitleItem
    else
        return UIConfig.WarSituation.InfoItem
    end
end

-- 召回军队
local function OnCancelInvasion(id)
    NetworkManager.C2SCancelInvasionProto(id)
end

local function UpdateMainSituation()
    local robbedGold = 0
    local robbedStone = 0
    local robbedFood = 0
    local robbedWood = 0
    local lowestFight = 0
    local lowestFightEnemyInfo = nil

    -- 更新发起者信息（1人）
    if situationDataLength == 1 then
        local info = situationData[1]
        local oneGuyPanel = view.SubListMain:GetChild("com_difangliebiao")
        if oneGuyPanel ~= nil then

            -- 名字
            if info.Self.GuildFlagName == nil or info.Self.GuildFlagName == "" then
                oneGuyPanel:GetChild("faqiming").text = info.Self.Name
            else
                oneGuyPanel:GetChild("faqiming").text = string.format("[%s]%s", info.Self.GuildFlagName, info.Self.Name)
            end

            -- 布阵列表
            local buzhenList = oneGuyPanel:GetChild("faqijundui")
            buzhenList:RemoveChildrenToPool()

            -- 抢到的资源
            robbedGold = info.Gold
            robbedStone = info.Stone
            robbedFood = info.Food
            robbedWood = info.Wood

            -- print("~@#!@#!@#@#", robbedGold, robbedStone, robbedFood, robbedWood)

            -- 部队
            local currLoad = info.Gold + info.Food + info.Wood + info.Stone
            local totalLoad = 0
            local fightAmount = 0
            for k, v in pairs(info.CaptainInfoList) do
                if v ~= nil then
                    -- 战斗力
                    fightAmount = fightAmount + v.FightAmount
                    -- 每个军队的最大负载
                    totalLoad = totalLoad + v.Soldier * v.LoadPerSoldier

                    -- 武将item设置
                    if v.RaceType ~= nil then
                        local item = buzhenList:AddItemFromPool(UIConfig.WarSituation.CaptainItem)
                        item:GetChild("txt_wujiangmignzi").text = string.format(Localization.CaptainInfo, v.Name, v.Level, v.Soldier, v.TotalSoldier)
                        item:GetChild("com_zhiye").icon = UIConfig.Race[v.RaceType]
                        item:GetChild("com_zhiye").title = ""
                    end
                end
            end

            -- 颜色，我自己或者盟友为发起方显示蓝色，否则红色
            if info.Self.Id == DataTrunk.PlayerInfo.MonarchsData.Id or Utils.IsTheSameGuild(info.Self.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) then
                oneGuyPanel:GetController("yanse").selectedIndex = 1
            else
                oneGuyPanel:GetController("yanse").selectedIndex = 0
            end

            -- 是否显示军队负载，援助时不显示
            if info.Action == MilitaryActionType.Assist then
                oneGuyPanel:GetController("qiangziyuan").selectedIndex = 1
            else

                oneGuyPanel:GetController("qiangziyuan").selectedIndex = 0
                oneGuyPanel:GetChild("shu_fuzai").text = string.format("%s/%s", currLoad, totalLoad)
            end

            -- 战斗力
            oneGuyPanel:GetChild("shu_zhandouli").text = fightAmount
        end

        -- 更新发起者信息（多人）
    elseif situationDataLength > 1 then
        local manyGuyPanel = view.SubListMain:GetChild("list_difang")
        manyGuyPanel:RemoveChildrenToPool()

        local buzhenList = nil
        local raceItem = nil
        local currLoad = 0
        local totalLoad = 0
        local fightAmount = 0
        local timerIcon = nil
        local timerText = nil

        for i = 1, situationDataLength do
            local info = situationData[i]
            if info ~= nil then

                local item = manyGuyPanel:AddItemFromPool(UIConfig.WarSituation.AttackerItem)
                -- 发起者名字
                if info.Self.GuildFlagName == nil or info.Self.GuildFlagName == "" then
                    item:GetChild("wanjia1").text = info.Self.Name
                else
                    item:GetChild("wanjia1").text = string.format("[%s]%s", info.Self.GuildFlagName, info.Self.Name, false)
                end

                timerIcon = item:GetChild("n65")
                timerText = item:GetChild("daojishi")

                -- 移动类型(到达)
                if info.MoveType == MilitaryMoveType.Arrived then
                    -- 掠夺
                    if info.Action == MilitaryActionType.Invasion then
                        item:GetChild("zhuangtai").text = Localization.Plundering
                        -- 显示时间信息
                        ShowTimer(info.CombineId, timerIcon, timerText, TimerManager.currentTime, info.MoveArrivedTime, true)
                    end
                end

                -- 布阵列表
                buzhenList = item:GetChild("buzhenliebiao")
                buzhenList:RemoveChildrenToPool()

                -- 抢到的资源
                robbedGold = robbedGold + info.Gold
                robbedStone = robbedStone + info.Stone
                robbedFood = robbedFood + info.Food
                robbedWood = robbedWood + info.Wood

                -- 部队
                currLoad = info.Gold + info.Food + info.Wood + info.Stone
                totalLoad = 0
                fightAmount = 0
                for k, v in pairs(info.CaptainInfoList) do
                    if v ~= nil then
                        -- 战斗力
                        fightAmount = fightAmount + v.FightAmount
                        -- 每个军队的最大负载
                        totalLoad = totalLoad + v.Soldier * v.LoadPerSoldier

                        -- 武将item设置
                        if v.RaceType ~= nil then
                            raceItem = buzhenList:AddItemFromPool(UIConfig.RaceItem)
                            raceItem.icon = UIConfig.Race[v.RaceType]
                            raceItem.title = ""
                        end
                    end
                end

                -- 颜色，我自己或者盟友为发起方显示蓝色，否则红色
                if info.Self.Id == DataTrunk.PlayerInfo.MonarchsData.Id or Utils.IsTheSameGuild(info.Self.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) then
                    item:GetController("yanse").selectedIndex = 1
                else
                    item:GetController("yanse").selectedIndex = 0
                end

                -- 军队负载
                item:GetChild("shu_fuzai").text = string.format("%s/%s", currLoad, totalLoad)

                -- 战斗力
                item:GetChild("shu_zhandouli").text = fightAmount

                -- 我为发起者时显示召回按钮
                if info.Self.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
                    item:GetController("annuikongzhi").selectedIndex = 0
                    item:GetChild("btn_zhaohui").onClick:Set(
                    function()
                        OnCancelInvasion(info.CombineId)
                    end
                    )
                    -- 我为被攻击者时显示驱逐按钮
                elseif info.Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
                    item:GetController("annuikongzhi").selectedIndex = 1
                    item:GetChild("btn_quzu").onClick:Set(
                    function()
                        OnExpel(info, true)
                    end
                    )
                else
                    item:GetController("annuikongzhi").selectedIndex = 2
                end

                -- 在掠夺盟友，计算战斗力最低的敌人
                if Utils.IsTheSameGuild(info.Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) then
                    if lowestFight == 0 then
                        lowestFight = fightAmount
                        lowestFightEnemyInfo = info
                    else
                        if lowestFight > fightAmount then
                            lowestFight = fightAmount
                            lowestFightEnemyInfo = info
                        end
                    end
                end
            end
        end
    end
    -- 如果是多人在掠夺盟友，显示通用驱逐按钮，设置点击回调，驱逐战斗力最低的敌人
    if lowestFightEnemyInfo ~= nil then
        view.Button_C.selectedIndex = 1
        -- 驱逐回调
        view.SubListMain:GetChild("btn_quzu").onClick:Set(
        function()
            OnExpel(lowestFightEnemyInfo, false)
        end
        )
    end

    local data = situationData[1]

    -- 更新目标信息
    -- 名字
    if data.Target.GuildFlagName == nil or data.Target.GuildFlagName == "" then
        view.SubListMain:GetChild("txt_mubiaoming").text = data.Target.Name
    else
        view.SubListMain:GetChild("txt_mubiaoming").text = string.format("[%s]%s", data.Target.GuildFlagName, data.Target.Name)
    end

    -- 抢到的资源
    view.SubListMain:GetChild("txt_liangshi").text = robbedFood
    view.SubListMain:GetChild("txt_mutou").text = robbedWood
    view.SubListMain:GetChild("txt_tongbi").text = robbedGold
    view.SubListMain:GetChild("txt_shitou").text = robbedStone
    -- 单人状态下，根据军情类型显示时间
    if situationDataLength == 1 then
        local stateLabel = view.SubListMain:GetChild("txt_lueduo")
        local timerLabel = view.SubListMain:GetChild("txt_daojishi")
        local timerIcon = view.SubListMain:GetChild("txt_shijian")

        -- 移动类型，0-forward(往目标移动)
        if data.MoveType == MilitaryMoveType.Forward then
            -- 行军中
            stateLabel.text = Localization.OnTheMarch
            -- 显示时间信息
            ShowTimer(data.CombineId, timerIcon, timerLabel, data.MoveArrivedTime, TimerManager.currentTime, false)

            -- 移动类型，1-arrived(到达)
        elseif data.MoveType == MilitaryMoveType.Arrived then
            if data.Action == 0 then
                -- 掠夺中
                stateLabel.text = Localization.Plundering
                -- 显示时间信息
                ShowTimer(data.CombineId, timerIcon, timerLabel, TimerManager.currentTime, data.MoveArrivedTime, true)

            elseif data.Action == 1 then
                -- 驻扎中
                stateLabel.text = Localization.Stationed
                -- 不显示时间信息
                timerIcon.visible = false
                timerLabel.visible = false
            end
            -- 移动类型，2-back(回家)
        elseif data.MoveType == MilitaryMoveType.Back then
            -- 返回中
            stateLabel.text = Localization.InTheBack
            -- 显示时间信息
            ShowTimer(data.CombineId, timerIcon, timerLabel, data.MoveArrivedTime, TimerManager.currentTime, false)
        end
    end
end

-- 更新军情
local function UpdatSituation()
    -- 主要军情
    UpdateMainSituation()

    -- 额外军情
    if additionalSituationDataLength > 0 then
        view.SubListAddi.visible = true

        view.SubListAddi.itemRenderer = ListRenderer
        view.SubListAddi.itemProvider = ListProvider

        -- title+额外军情数量
        view.SubListAddi.numItems = 1 + additionalSituationDataLength
    else
        view.SubListAddi.visible = false
    end
end

-- 驱逐军队
-- 默认驱逐战斗力最低的对手
-- 当我自己被掠夺时，可以指定驱逐对象
function OnExpel(info, isAttackMe)
    if info == nil then
        return
    end

    combatInfo:clear()
    -- 请求出征
    combatInfo.ToCombat = function(captainId, count, selected, troopId)
        if isAttackMe then
            NetworkManager.C2SExpelProto(info.CombineId, DataTrunk.PlayInfo.RegionData:getSelectRegion(), troopId)
        else
            NetworkManager.C2SInvasionProto(false, info.Target.Id, DataTrunk.PlayInfo.RegionData:getSelectRegion(), troopId)
        end
        return true
    end
    -- 驱逐自己
    combatInfo.Monarch = { }
    if situationData[1].Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id then
        -- 战斗类型
        combatInfo.Type = BattleDeploymentType.PVP_Expel_ForSelf
        -- 对方君主信息（军情的发起者）
        combatInfo.Monarch.Name = info.Self.Name
        combatInfo.Monarch.Head = UIConfig.MonarchsIcon[info.Self.Head]
        combatInfo.Monarch.Guild = info.Self.GuildName
        combatInfo.Monarch.Level = info.Self.Level
        combatInfo.Monarch.MainCityLevel = info.Self.BaseLevel
        combatInfo.Monarch.FightAmount = 0
        combatInfo.Monarch.TowerFloor = 0
        combatInfo.Monarch.Rank = Localization.None
        -- 帮助盟友驱逐
    else
        -- 战斗类型
        combatInfo.Type = BattleDeploymentType.PVP_Expel_ForFriend
        -- 对方君主信息（军情的发起者）
        combatInfo.Monarch.Name = info.Target.Name
        combatInfo.Monarch.Head = UIConfig.MonarchsIcon[info.Target.Head]
        combatInfo.Monarch.Guild = info.Target.GuildName
        combatInfo.Monarch.Level = info.Target.Level
        combatInfo.Monarch.MainCityLevel = info.Target.BaseLevel
        combatInfo.Monarch.FightAmount = 0
        combatInfo.Monarch.TowerFloor = 0
        combatInfo.Monarch.Rank = Localization.None
    end
    -- 武将(共五个槽位)
    combatInfo.Troops = { }
    for k, v in pairs(info.CaptainInfoList) do
        if v ~= nil then
            combatInfo.Troops[k] = MonsterCaptainClass()
            combatInfo.Troops[k].Name = v.Name
            combatInfo.Troops[k].Head = v.Head
            combatInfo.Troops[k].Race = v.RaceType
            combatInfo.Troops[k].Quality = v.Quality
            combatInfo.Troops[k].Solider = v.Solider
            combatInfo.Troops[k].MaxSolider = v.TotalSoldier
            combatInfo.Troops[k].Level = v.Level
        end
    end

    -- 打开布阵
    UIManager.openController(UIManager.ControllerName.PreBattle, combatInfo)
end

-- 召回军队
local function OnCancelInvasion(id)
    NetworkManager.C2SCancelInvasionProto(id)
end

-- 援助
local function OnAssist(info)
    if info.Target.Id == nil or info.Target.Id == "" then
        return
    end
    combatInfo:clear()

    -- 战斗类型
    combatInfo.Type = BattleDeploymentType.PVP_Assist
    -- 请求出征
    combatInfo.ToCombat = function(captainId, count, selected, troopId)
        NetworkManager.C2SInvasionProto(false, info.Target.Id, DataTrunk.PlayInfo.RegionData:getSelectRegion(), troopId)
        _C:close()
        return true
    end
    -- 盟友君主信息
    combatInfo.Monarch = { }
    combatInfo.Monarch.Name = info.Target.Name
    combatInfo.Monarch.Head = UIConfig.MonarchsIcon[info.Target.Head]
    combatInfo.Monarch.Guild = info.Target.GuildName
    combatInfo.Monarch.Level = info.Target.Level
    combatInfo.Monarch.MainCityLevel = info.Target.BaseLevel
    combatInfo.Monarch.FightAmount = 0
    combatInfo.Monarch.TowerFloor = 0
    combatInfo.Monarch.Rank = ""

    -- 打开布阵
    UIManager.openController(UIManager.ControllerName.PreBattle, combatInfo)
end

-- 设置控制器状态
local function SetState()

    -- 默认显示目标城池
    view.Target_C.selectedIndex = 0

    -- 军情条数
    if situationDataLength == 1 then
        view.Count_C.selectedIndex = 0
    else
        view.Count_C.selectedIndex = 1
    end

    -- 目标方是否为我自己或者盟友
    if situationData[1].Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id or Utils.IsTheSameGuild(situationData[1].Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) then
        view.Color_C.selectedIndex = 0
    else
        view.Color_C.selectedIndex = 1
    end

    -- 是否为援助，非援助类型的要显示抢资源
    if situationData[1].Action == MilitaryActionType.Assist then
        view.Action_C.selectedIndex = 1
    else
        view.Action_C.selectedIndex = 0
    end

    -- 单条军情
    if situationDataLength == 1 then
        -- 自己发起的且不在返回状态，显示通用召回按钮；
        if situationData[1].Self.Id == DataTrunk.PlayerInfo.MonarchsData.Id and situationData[1].MoveType ~= MilitaryMoveType.Back then
            view.Button_C.selectedIndex = 0
            -- 召回回调
            view.SubListMain:GetChild("btn_xiangqing").onClick:Set(
            function()
                OnCancelInvasion(situationData[1].CombineId)
            end
            )

            -- 掠夺我或者盟友的显示驱逐按钮
        elseif (situationData[1].Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id or
            Utils.IsTheSameGuild(situationData[1].Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId)) and
            situationData[1].Action == MilitaryActionType.Invasion and
            situationData[1].MoveType == MilitaryMoveType.Arrived then

            view.Button_C.selectedIndex = 1
            -- 驱逐回调
            view.SubListMain:GetChild("btn_quzu").onClick:Set(
            function()
                OnExpel(situationData[1], situationData[1].Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id)
            end
            )
            -- 正在出征我盟友的显示援助按钮
        elseif situationData[1].Target.Id ~= DataTrunk.PlayerInfo.MonarchsData.Id and
            Utils.IsTheSameGuild(situationData[1].Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) and
            situationData[1].Action == MilitaryActionType.Invasion and
            situationData[1].MoveType == MilitaryMoveType.Forward then
            view.Button_C.selectedIndex = 2
            -- 驱逐回调
            view.SubListMain:GetChild("btn_yuanzhu").onClick:Set(
            function()
                OnAssist(situationData[1])
            end
            )
            -- 其他情况不显示
        else
            view.Button_C.selectedIndex = 3
        end
        -- 多条军情大多数情况不用通用按钮，有专用召回按钮，自行判断
    elseif situationDataLength > 1 then
        view.Button_C.selectedIndex = 3
    end
end

-- 处理军情
-- int data, 军情Id
local function SituationHandler()
    situationData = { }
    additionalSituationData = { }

    situationDataLength = 0
    additionalSituationDataLength = 0

    -- 获取军情
    local info = DataTrunk.PlayerInfo.MilitaryInfoData.MyMilitaryInfoList[situationId]
    if info == nil then
        _C:close()
        return
    end

    -- 如果是掠夺军情，需要提取出所有对这个城池掠夺的对象，对这个城池支援的对象
    if info.Action == MilitaryActionType.Invasion and info.MoveType == MilitaryMoveType.Arrived then
        for k, v in pairs(DataTrunk.PlayerInfo.MilitaryInfoData.MyMilitaryInfoList) do
            if v ~= nil and v.Self ~= nil and v.Target ~= nil then
                -- 同样在掠夺此城池的家伙
                if v.Target.Id == info.Target.Id and v.Action == MilitaryActionType.Invasion and v.MoveType == MilitaryMoveType.Arrived then
                    table.insert(situationData, v)
                    situationDataLength = situationDataLength + 1
                    -- 支援此城池的家伙
                elseif v.Target.Id == info.Target.Id and v.Action == MilitaryActionType.Assist then
                    table.insert(additionalSituationData, v)
                    additionalSituationDataLength = additionalSituationDataLength + 1
                end
            end
        end

        -- 其他军情，只需要展示这一条的详情即可
    else
        table.insert(situationData, info)
        situationDataLength = 1
    end

    -- 设置控制器状态
    SetState()
    -- 更新军情
    UpdatSituation()
end

----------------------------------------------------------------------------------

-- 获取所有军情
local function onGetAllMilitary()
    if not _C.IsOpen then
        return
    end

    SituationHandler()
end

-- 军情更新
local function onMilitaryUpdate(id)
    if not _C.IsOpen then
        return
    end

    SituationHandler()
end

-- 军情移除
-- id, num，军情Id
local function onMilitaryRemoved(id)
    if not _C.IsOpen then
        return
    end

    if data == nil then
        return
    end

    -- 销毁计时器
    if marchTimerList ~= nil then
        if marchTimerList[id] ~= nil then
            TimerManager.disposeTimer(marchTimerList[id])

            marchTimerList[id] = nil
        end
    end

    SituationHandler()
end

-- 清理数据
local function onClearData()
    -- 删除Timer
    if marchTimerList ~= nil then
        for k, v in pairs(marchTimerList) do
            if v ~= nil then
                TimerManager.disposeTimer(v)

                v = nil
            end
        end

        marchTimerList = { }
    end
end

-- 打开界面
function _C:onOpen(data)
    situationId = data
    combatInfo = BattleDeploymentInfo()
    SituationHandler()
end

function _C:onClose()
    -- 清理数据
    onClearData()
end

function _C:onCreat()
    view = _C.View
    view.BackBtn.onClick:Set(BackBtnOnClick)

    -- Event.addListener(Event.ON_ALL_MY_MILITARY_UPDATED, onGetAllMilitary)
    Event.addListener(Event.ON_MY_MILITARY_UPDATED, onMilitaryUpdate)
    Event.addListener(Event.ON_MY_MILITARY_REMOVED, onMilitaryRemoved)
end

function _C:onDestroy()
    -- Event.removeListener(Event.ON_ALL_MY_MILITARY_UPDATED, onGetAllMilitary)
    Event.removeListener(Event.ON_MY_MILITARY_UPDATED, onMilitaryUpdate)
    Event.removeListener(Event.ON_MY_MILITARY_REMOVED, onMilitaryRemoved)
end