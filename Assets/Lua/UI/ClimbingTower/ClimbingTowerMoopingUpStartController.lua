local _C = UIManager.Controller(UIManager.ControllerName.ClimbingTowerMoopingUpStart, UIManager.ViewName.ClimbingTowerMoopingUpStart)
_C.IsPopupBox = true

local view = nil
-- 楼层奖励
local floorAwardList = nil
-- 千重楼实例化信息
local towerInsInfo = DataTrunk.PlayerInfo.TowerData
-- 楼层共层数
local towerTotalFloor = MiscCommonConfig.Config.TowerTotalFloor
-- 君主实例化数据
local monarchInsInfo = DataTrunk.PlayerInfo.MonarchsData.LevelConfig
-- 参与扫荡武将
local moopingupCaptainList = nil
-- 结算动画
local animTimer = nil
-- 动画楼层Id
local animFloorId = 1

-- 跳过动画
local function btnSKip()
    -- 可交互
    view.TiaoGuo.touchable = true
    -- 关闭界面
    _C:close()
    -- 进入结算面板
    UIManager.openController(UIManager.ControllerName.ClimbingTowerMoopingUpOver, moopingupCaptainList)
end
-- 更新每层所得显示
local function updateMoopingupAwardInfo()
    floorAwardList = { }
    view.MoopingupAwardList.numItems = 0

    -- 获得道具
    award = function(t1, t2)
        if nil ~= t2 then
            for k, v in pairs(t2) do
                table.insert(t1, v)
            end
        end
    end
    for k, v in pairs(towerInsInfo.LatestMoopingUp) do
        local prize = { }

        award(prize, v.Goods)
        award(prize, v.Equips)
        award(prize, v.Currencys)

        table.insert(floorAwardList, prize)
    end
    animFloorId = 0
    view.MoopingupAwardList.numItems = 0

    animTimer:reset()
    animTimer:start()
    view.TiaoGuo.touchable = false
end

-- 更新扫荡描述
local function updateMoopingupBaseInfo()
    -- 扫荡次数（加数据）
    view.MoopingUpCount.text = 10
    -- 重置时间
    view.ResetTime.text = string.format(Localization.TimeReset, MiscCommonConfig.Config.DailyResetTime)
    -- 历史最高层
    view.MoopingUpFloorMax.text = towerInsInfo.HistoryMaxFloor
end
-- 楼层奖励渲染
local function onFloorAwardRender(index, obj)
    obj:GetChild("TextField_Floor").text = string.format(Localization.TowerCurFloor_2, index + 1)
    local itemList = obj:GetChild("List_Gain").asList
    local floorInsInfo = floorAwardList[index + 1]

    -- 楼层奖励
    itemList:RemoveChildrenToPool()
    for k, v in pairs(floorInsInfo) do
        local item = itemList:AddItemFromPool()

        -- 刷新数据
        item:GetController("State_C").selectedIndex = 1
        item:GetController("Count_C").selectedIndex = 1
        item:GetController("CornerMark_C").selectedIndex = 0

        item:GetChild("title").text = v.Amount
        item:GetChild("icon").url = v.Config.Icon

        -- 品质
        if v.ClassifyType == ItemClassifyType.Equip then
            item:GetChild("quality").url = UIConfig.Item.EquipQuality[v.Config.Quality.Level]
        else
            item:GetChild("quality").url = UIConfig.Item.DefaultQuality[v.Config.Quality]
        end

        itemList:AddChild(item)
    end
end
-- 计时开始
local function timerStart()
    animFloorId = animFloorId + 1

    view.MoopingupAwardList.numItems = animFloorId
    -- 滚动
    view.MoopingupAwardList:ScrollToView(animFloorId - 1, true)
end
-- 计时结束
local function timerComplete()
    if animFloorId == #floorAwardList then
        -- 进入结算
        btnSKip()
        return
    end

    animTimer:reset()
    animTimer:start()
end
function _C:onCreat()
    view = _C.View

    view.BtnSkip.onClick:Add(btnSKip)
    view.MoopingupAwardList.itemRenderer = onFloorAwardRender
    -- 计时
    animTimer = TimerManager.newTimer(0.5, false, false, timerStart, nil, timerComplete)
end
function _C:onOpen(data)
    moopingupCaptainList = data
    updateMoopingupBaseInfo()
    updateMoopingupAwardInfo()
end
function _C:onClose()
    animTimer:pause()
end
function _C:onDestroy()
    view.BtnSkip.onClick:Clear()
    view.MoopingupAwardList.itemRenderer = nil
end
