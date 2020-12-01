local _C = UIManager.Controller(UIManager.ControllerName.PracticeHallPractice, nil)
_C.view = nil

local view = nil
-- 玩家修炼位数据
local trainingData = DataTrunk.PlayerInfo.MilitaryAffairsData.Training
-- 武将数据
local generalData = DataTrunk.PlayerInfo.MilitaryAffairsData.Captains
-- 空闲武将数据
local leisureGeneralId = { }
-- 槽位计时器(从1开始)
local timerByIndex = { }

-- 一键修炼
local function PracticeBtnOnClick()
    NetworkManager.S2CAutoSetTrainingCaptain()
end

-- 一键领取
local function GetBtnOnClick()
    NetworkManager.C2SCollectAllTrainingExp()
end

-- 升级修炼台
local function UpgradeBtnOnClick()
    UIManager.openController(UIManager.ControllerName.PracticeHallUpgrade)
end

local function StageListRenderer(index, obj)
    -- 不为空用实例化数据,为空就走配置
    local data = trainingData[index + 1]
    -- 0 没有武将 1 有武将 2 未开启
    local state_C = obj:GetController("State_C")
    -- 修炼台
    local xlt_C = obj:GetChild("Label_Stage"):GetController("Level_C")

    if data ~= nil then
        if data.Captain == nil or data.Captain == 0 then
            -- 没有武将
            state_C.selectedIndex = 0
            -- 双拖动bug,临时提示文本
            obj:GetChild("Text_State").text = "空闲中"
        else
            -- 有武将
            state_C.selectedIndex = 1
            -- 英雄数据
            local heroInfo = generalData[data.Captain]
            -- 职业
            obj:GetChild("Loader_GeneralType").url = UIConfig.Race[heroInfo.Race]
            -- 名字
            obj:GetChild("Text_Name").text = heroInfo.Name
            -- 等级
            obj:GetChild("Text_Level").text = heroInfo.Level
            -- 武将按钮
            local heroBtn = obj:GetChild("Button_General")
            -- 头像(中)
            heroBtn:GetChild("Component_General"):GetChild("Loader_Icon").url = heroInfo.MiddleHead
            -- 经验产出速度(+xx/秒)
            local outputSpeed = data.Output / 3600
            -- 当前计时器
            local timer = timerByIndex[index + 1]
            -- 经验条
            local bar = heroBtn:GetChild("Image_Exp")
            bar.fillAmount =(data.Exp + outputSpeed) / data.Capcity

            local function TimerComplete(t, p)
                if (data.Exp + outputSpeed) <= data.Capcity then
                    bar.fillAmount =(data.Exp + outputSpeed) / data.Capcity
                end
            end

            if timer == nil then
                timer = TimerManager.newTimer(1, true, true, nil, nil, TimerComplete)
            end

            timer:start()

            -- 可转生提示v0.2(隐藏处理)
            heroBtn:GetChild("Label_Tips").visible = false
        end

        if data.Level < 1 then
            return
        end

        -- 修炼台
        xlt_C.selectedIndex = data.Level - 1
    else
        -- 未开启
        state_C.selectedIndex = 2
        -- 等级
        local tempLevel = MilitaryCommonConfig.Config.TrainingInitLevel[index + 1]
        -- 修炼台
        xlt_C.selectedIndex = tempLevel - 1
        -- 等级限制
        obj:GetChild("Text_RequiredLevel").text = string.format(Localization.PracticeHallStageRequireHeroLevel, MilitaryCommonConfig.Config.TrainingHeroLevel[index + 1])
    end
end

local function GeneralListRenderer(index, obj)
    local data = generalData[leisureGeneralId[index + 1]]
    -- 名字
    obj:GetChild("title").text = data.Name
    -- 武将btn
    -- local generalBtn = obj:GetChild("Component_General")
    -- 等级
    obj:GetChild("txt_gji").text = data.Level
    -- 兵种
    -- generalBtn:GetChild("Label_GeneralType").icon = UIConfig.Race[data.Race]
    -- 品质
    obj:GetController("pinzhi").selectedIndex = data.Quality - 1
    -- 头像(小)
    obj:GetChild("loader_wujiang").url = data.Head
end

-- 刷新UI
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    -- 修炼台列表
    view.StageList.itemRenderer = StageListRenderer
    -- 数量
    view.StageList.numItems = #MilitaryCommonConfig.Config.TrainingHeroLevel

    -- 在修炼的武将Id
    local generalInPracticeId = { }

    for k, v in pairs(trainingData) do
        if v.Captain ~= 0 then
            generalInPracticeId[v.Captain] = v.Captain
        end
    end

    -- 空闲武将ID
    leisureGeneralId = { }

    for k, v in pairs(generalData) do
        if generalInPracticeId[k] == nil then
            table.insert(leisureGeneralId, k)
        end
    end

    -- 武将列表
    view.GeneralList.itemRenderer = GeneralListRenderer
    view.GeneralList.numItems = #leisureGeneralId
end

function _C:onOpen()
    RefreshUI()
end

function _C:onCreat()
    view = _C.view

    view.PracticeBtn.onClick:Set(PracticeBtnOnClick)
    view.UpgradeBtn.onClick:Set(UpgradeBtnOnClick)
    view.GetBtn.onClick:Set(GetBtnOnClick)

    Event.addListener(Event.PRACTICEHALL_UPGRADE_SUCCESS, RefreshUI)
    Event.addListener(Event.GENERAL_UPDATE, RefreshUI)
    Event.addListener(Event.PRACTICEHALL_AUTO_SET_TRAINING_CAPTAIN_SUCCESS, RefreshUI)
    Event.addListener(Event.PRACTICEHALL_COLLECT_ALL_TRAINING_EXP_SUCCESS, RefreshUI)
end

function _C:onDestroy()
    for k, v in pairs(timerByIndex) do
        TimerManager.disposeTimer(v)
        v = nil
    end

    view.StageList.itemRenderer = nil
    view.GeneralList.itemRenderer = nil

    Event.removeListener(Event.PRACTICEHALL_UPGRADE_SUCCESS, RefreshUI)
    Event.removeListener(Event.GENERAL_UPDATE, RefreshUI)
    Event.removeListener(Event.PRACTICEHALL_AUTO_SET_TRAINING_CAPTAIN_SUCCESS, RefreshUI)
    Event.removeListener(Event.PRACTICEHALL_COLLECT_ALL_TRAINING_EXP_SUCCESS, RefreshUI)
end

return _C