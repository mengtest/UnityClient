local _C = UIManager.Controller(UIManager.ControllerName.PracticeHallUpgrade, UIManager.ViewName.PracticeHallUpgrade)
local view = nil
-- 玩家修炼位数据
local trainingData = DataTrunk.PlayerInfo.MilitaryAffairsData.Training

-- 返回按钮
local function BackBtnOnClick()
    _C:close()
end

local function UpgradeListRenderer(index, obj)
    data = trainingData[index + 1]

    if data == nil then
        return
    end

    -- 等级
    local lev = data.Level

    if lev < 1 then
        return
    end

    -- 修炼台等级
    obj:GetChild("Label_Stage"):GetController("Level_C").selectedIndex = lev - 1
    -- 配置
    local config = TrainingLevelConfig.Config[lev]
    -- 修炼效率(描述)
    obj:GetChild("Text_Efficiency").text = config.Desc
    -- 经验产出(每小时)
    obj:GetChild("Text_Output").text = string.format(Localization.PerHourExp, config.ExpOutput * config.Coef)
    -- 满级控制器
    local state_C = obj:GetController("State_C")

    -- 判断是否满级
    if data.Level == data.LevelLimit then
        state_C.selectedIndex = 1
    else
        state_C.selectedIndex = 0
        -- 升阶按钮
        obj:GetChild("Button_Upgrade").onClick:Set( function()
            UIManager.openController(UIManager.ControllerName.PracticeHallUpgradeConfirm, index)
        end )
    end
end

-- 刷新UI
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    view.UpgradeList.itemRenderer = UpgradeListRenderer
    view.UpgradeList.numItems = #trainingData
end

function _C:onOpen()
    RefreshUI()
end

function _C:onCreat()
    view = _C.View
    view.BackBtn.onClick:Set(BackBtnOnClick)

    Event.addListener(Event.PRACTICEHALL_UPGRADE_SUCCESS, RefreshUI)
end

function _C:onDestroy()
    view.UpgradeList.itemRenderer = nil

    Event.removeListener(Event.PRACTICEHALL_UPGRADE_SUCCESS, RefreshUI)
end