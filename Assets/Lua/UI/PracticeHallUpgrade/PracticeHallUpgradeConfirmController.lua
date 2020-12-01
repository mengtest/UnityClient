local _C = UIManager.Controller(UIManager.ControllerName.PracticeHallUpgradeConfirm, UIManager.ViewName.PracticeHallUpgradeConfirm)
local view = nil
_C.IsPopupBox = true
-- 玩家修炼位数据
local trainingData = DataTrunk.PlayerInfo.MilitaryAffairsData.Training
-- 修炼位满级等级
local maxLevel = 5

-- 返回按钮
local function BackBtnOnClick()
    if not _C.IsOpen then
        return
    end

    _C:close()
end

-- 刷新UI
local function RefreshUI(index)
    local data = trainingData[index + 1]

    view.UpgradeList:RemoveChildrenToPool()
    -- 配置
    local config = TrainingLevelConfig.Config

    -- 当前等级到等级上限(比如当前3级,上限4级,那只生成一个升阶按钮)
    for i = data.LevelLimit, data.Level + 1, -1 do
        local obj = view.UpgradeList:AddItemFromPool(view.UpgradeList.defaultItem)
        -- 修炼效率(Desc)
        obj:GetChild("Text_Efficiency").text = config[i].Desc
        -- 修炼位图片
        obj:GetChild("Label_Stage"):GetController("Level_C").selectedIndex = i - 1
        -- 花费
        obj:GetChild("Text_Cost").text = config[i].Cost.YuanBao - config[data.Level].Cost.YuanBao
        -- 按钮时间
        obj:GetChild("Button_Upgrade").onClick:Set( function()
            print("升阶序号:", index, "等级:", i)
            NetworkManager.C2SUpgradeTrainingProto(index, i)
        end )
    end
end

-- Index //修炼台序号 从0开始的
function _C:onOpen(index)
    RefreshUI(index)
end

function _C:onCreat()
    view = _C.View
    view.BackBtn.onClick:Set(BackBtnOnClick)

    Event.addListener(Event.PRACTICEHALL_UPGRADE_SUCCESS, BackBtnOnClick)
end

function _C:onDestroy()
    Event.removeListener(Event.PRACTICEHALL_UPGRADE_SUCCESS, BackBtnOnClick)
end