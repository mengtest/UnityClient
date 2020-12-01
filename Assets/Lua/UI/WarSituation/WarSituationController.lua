local _C = UIManager.Controller(UIManager.ControllerName.WarSituation, UIManager.ViewName.WarSituation)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil

-- 玩家自己的军情信息
local mySituationData = { }
-- 盟友被掠夺的军情
local allyBeRobbedSituationData = { }
-- 联盟军情
local allySituationData = { }

local mySituationDataLength = 0
local allyBeRobbedSituationDataLength = 0
local allySituationDataLength = 0

local marchTimerList = { }

local function BackBtnOnClick()
    _C:close()
end

-- 隐藏计时器
local function HideTimer(obj)
    if obj == nil then
        return
    end

    -- 隐藏时间信息
    obj:GetChild("n8").visible = false
    obj:GetChild("daojishi").visible = false
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
        end,
        -- 结束
        function()
            -- 隐藏时间信息
            SetTimerVisible(timerIcon, timerText, false)
         end,
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

-- 有序化玩家的军情
local function SituationHandler()
    mySituationData = { }
    allyBeRobbedSituationData = { }
    allySituationData = { }

    mySituationDataLength = 0
    allyBeRobbedSituationDataLength = 0
    allySituationDataLength = 0

    for k, v in pairs(DataTrunk.PlayerInfo.MilitaryInfoData.MyMilitaryInfoList) do
        if v ~= nil and v.Self ~= nil and v.Target ~= nil then
            -- 我作为发起方或者目标方军情
            if v.Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id or v.Self.Id == DataTrunk.PlayerInfo.MonarchsData.Id then

                table.insert(mySituationData, v)
                mySituationDataLength = mySituationDataLength + 1
                -- 盟友被掠夺军情
            elseif Utils.IsTheSameGuild(v.Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) and v.Action == MilitaryActionType.Invasion and v.MoveType == MilitaryMoveType.Arrived then
                table.insert(allyBeRobbedSituationData, v)
                allyBeRobbedSituationDataLength = allyBeRobbedSituationDataLength + 1
            end
            -- 联盟军情
            if Utils.IsTheSameGuild(v.Self.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) or Utils.IsTheSameGuild(v.Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId) then
                table.insert(allySituationData, v)
                allySituationDataLength = allySituationDataLength + 1
            end
        end
    end
end

local function InsertContent(data, obj)
    if data == nil or data.Self == nil or data.Target == nil then
        return
    end

    -- 盟友或者我被掠夺中
    if data.Action == MilitaryActionType.Invasion and data.MoveType == MilitaryMoveType.Arrived and 
    (data.Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id or Utils.IsTheSameGuild(data.Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId)) then
        -- 切换到驱逐Controller
        obj:GetController("c1").selectedIndex = 0
        obj:GetChild("btn_quzu").onClick:Set(
        function()
            UIManager.openController(UIManager.ControllerName.WarSituationDetails, data.CombineId)
        end )
    else
        -- 切换到详情Controller
        obj:GetController("c1").selectedIndex = 1
        obj:GetChild("btn_xiangqing").onClick:Set(
        function()
            UIManager.openController(UIManager.ControllerName.WarSituationDetails, data.CombineId)
        end )
    end

    -- 盟友或者我被出征中
    if data.Action == MilitaryActionType.Invasion and (data.Target.Id == DataTrunk.PlayerInfo.MonarchsData.Id or Utils.IsTheSameGuild(data.Target.GuildId, DataTrunk.PlayerInfo.MonarchsData.GuildId)) then
        -- 切换到红色底色Controller
        obj:GetController("yanse").selectedIndex = 1
    else
        -- 切换到蓝色底色Controller
        obj:GetController("yanse").selectedIndex = 0
    end

    -- 发起者名称
    if data.Self.GuildFlagName == nil or data.Self.GuildFlagName == "" then
        obj:GetChild("txt_wanjia1").text = data.Self.Name
    else
        obj:GetChild("txt_wanjia1").text = string.format("[%s]%s", data.Self.GuildFlagName, data.Self.Name)
    end

    -- 目标名称
    if data.Target.GuildFlagName == nil or data.Target.GuildFlagName == "" then
        obj:GetChild("txt_wanjia2").text = data.Target.Name
    else
        obj:GetChild("txt_wanjia2").text = string.format("[%s]%s", data.Target.GuildFlagName, data.Target.Name)
    end

    local timerIcon = obj:GetChild("img_shijian")
    local timerText = obj:GetChild("txt_daojishi")
    -- 开始绘制UI时先将Timer隐藏, 直到收到更新时间的回调时再进行显示,不会出现默认的情况
	SetTimerVisible(timerIcon, timerText, false) 
    -- 移动类型，0-forward(往目标移动)
    if data.MoveType == MilitaryMoveType.Forward then
        -- 行军中
        obj:GetChild("txt_zhuangtai").text = Localization.OnTheMarch
        -- 显示时间信息
        ShowTimer(data.CombineId, timerIcon, timerText, data.MoveArrivedTime, TimerManager.currentTime, false)

        -- 移动类型，1-arrived(到达)
    elseif data.MoveType == MilitaryMoveType.Arrived then
        if data.Action == MilitaryActionType.Invasion then
            -- 掠夺中
            obj:GetChild("txt_zhuangtai").text = Localization.Plundering
            -- 显示时间信息，正序计时
            ShowTimer(data.CombineId, timerIcon, timerText, TimerManager.currentTime, data.MoveArrivedTime, true)

        elseif data.Action == MilitaryActionType.Assist then
            -- 驻扎中
            obj:GetChild("txt_zhuangtai").text = Localization.Stationed
            -- 不显示时间信息
            timerIcon.visible = false
            timerText.visible = false
        end
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
                local item = buzhenList:AddItemFromPool()
                item.icon = UIConfig.Race[v.RaceType]
                item.title = ""
            end
        end
    end

    obj:GetChild("txt_shuzi").text = fightAmount
end

-- 紧急军情绘制
local function ListRendererEmergency(index, obj)
    -- 我的军情栏
    if index == 0 then
        obj:GetChild("txt_wodejunqing").text = Localization.MySituation
        obj:GetChild("txt_shuzi").text = mySituationDataLength
        -- 盟友被攻击的军情栏
    elseif index == mySituationDataLength + 1 then
        obj:GetChild("txt_wodejunqing").text = Localization.AllyBeRobbedSituation
        obj:GetChild("txt_shuzi").text = allyBeRobbedSituationDataLength
        -- 我的军情栏内容
    elseif index > 0 and index <= mySituationDataLength then
        local data = mySituationData[index]
        InsertContent(data, obj)
        -- 盟友被掠夺的军情
    else
        local data = allyBeRobbedSituationData[index - 1 - mySituationDataLength]
        InsertContent(data, obj)
    end
end

local function ListProviderEmergency(index)
    if index == 0 or index == mySituationDataLength + 1 then
        return UIConfig.WarSituation.TitleItem
    else
        return UIConfig.WarSituation.InfoItem
    end
end

-- 联盟军情绘制
local function ListRendererAlly(index, obj)
    -- 我的军情栏
    if index == 0 then
        obj:GetChild("txt_wodejunqing").text = Localization.AllySituation
        obj:GetChild("txt_shuzi").text = allySituationDataLength
    else
        -- 盟友的军情
        local data = allySituationData[index]
        InsertContent(data, obj)
    end
end

-- 联盟军情列表提供者
local function ListProviderAlly(index)
    if index == 0 then
        return UIConfig.WarSituation.TitleItem
    else
        return UIConfig.WarSituation.InfoItem
    end
end

-- 更新紧急军情
local function UpdatEmergencySituation()
    SituationHandler()

    view.List.itemRenderer = ListRendererEmergency
    view.List.itemProvider = ListProviderEmergency

    -- title+我的军情数量+title+盟友的军情数量
    view.List.numItems = 1 + mySituationDataLength + 1 + allyBeRobbedSituationDataLength
end

-- 更新联盟军情
local function UpdateAllySituation()
    SituationHandler()

    view.List.itemRenderer = ListRendererAlly
    view.List.itemProvider = ListProviderAlly

    -- title+联盟的军情数量
    view.List.numItems = 1 + allySituationDataLength
end

local function StateOnChanged()
    if view.State_C.selectedIndex == 0 then
        UpdatEmergencySituation()
    else
        UpdateAllySituation()
    end
end

-- 获取所有军情
local function onGetAllMilitary()
    if not _C.IsOpen then
        return
    end

    StateOnChanged()
end

-- 军情更新
local function onMilitaryUpdate()
    if not _C.IsOpen then
        return
    end

    StateOnChanged()
end

-- 军情移除
local function onMilitaryRemoved(data)
    if not _C.IsOpen then
        return
    end

    if data == nil then
        return
    end

    -- 销毁计时器
    if marchTimerList ~= nil then
        if marchTimerList[data] ~= nil then
            TimerManager.disposeTimer(marchTimerList[data])

            marchTimerList[data] = nil
        end
    end

    StateOnChanged()
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

        marchTimerList = {}
    end
end

function _C:onOpen()
    -- 无联盟，不可点触联盟军情tab
    if DataTrunk.PlayerInfo.MonarchsData.GuildId == nil or DataTrunk.PlayerInfo.MonarchsData.GuildId <= 0 then
        view.LianMengTab.grayed = true
        view.LianMengTab.touchable = false
    else
        view.LianMengTab.grayed = false
        view.LianMengTab.touchable = true
    end

    -- 发送打开军情系统请求，获取我的军情消息
    NetworkManager.C2SSwitchActionProto(true)

    UpdatEmergencySituation()
end

function _C:onClose()

    -- 发送关闭军情系统请求，服务器不会再发送我的军情过来
    NetworkManager.C2SSwitchActionProto(false)
    -- 清理数据
    onClearData()
end

function _C:onCreat()
    view = _C.View
    view.BackBtn.onClick:Set(BackBtnOnClick)
    view.State_C.onChanged:Set(StateOnChanged)

    Event.addListener(Event.ON_ALL_MY_MILITARY_UPDATED, onGetAllMilitary)
    Event.addListener(Event.ON_MY_MILITARY_UPDATED, onMilitaryUpdate)
    Event.addListener(Event.ON_MY_MILITARY_REMOVED, onMilitaryRemoved)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)      
    end
end

function _C:onDestroy()
    view.BackBtn.onClick:Clear()
    view.State_C.onChanged:Clear()
    Event.removeListener(Event.ON_ALL_MY_MILITARY_UPDATED, onGetAllMilitary)
    Event.removeListener(Event.ON_MY_MILITARY_UPDATED, onMilitaryUpdate)
    Event.removeListener(Event.ON_MY_MILITARY_REMOVED, onMilitaryRemoved)
    view.List.itemRenderer = nil
    view.List.itemProvider = nil
end