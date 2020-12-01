local _C = UIManager.Controller(UIManager.ControllerName.BuildersSpeedup, UIManager.ViewName.BuildersSpeedup)
_C.IsPopupBox = true
local view = nil
-- CD倒计时
local cdTimer = nil
-- 建筑队加速道具Id
local buildingSpeedupGoods = { 10001, 10002, 10003, 10004 }
-- 科技队加速道具Id
local techSpeedupGoods = { 10005, 10006, 10007, 10008 }
-- 当前类型(0 建筑 1 科技)
local currType = nil
-- 索引(从0开始,int)
local currIndex = nil
-- 道具数据(Default)
local itemsData = nil
-- 内政数据
local internalData = nil
-- 建筑队休息数据
local buildersTimeoutInfo = nil
-- 科技队休息数据
local technicianTimeOutInfo = nil
-- 当前倒计时秒数
local currCD = 0
-- 使用的道具超过当前CD多少分钟(转换成秒便于计算)会出现提示(配置)
local hintSecond = 30 * 60
-- 当前元宝数量
local currYuanBaoAmont = 0

-- 刷新建筑队数据
local function RefreshUI()
    for i = 1, 4 do
        -- 道具数据
        local propData = nil

        if currType == 0 then
            propData = itemsData[buildingSpeedupGoods[i]]
            view.PropsList[i].title = math.floor(ItemsConfig:getConfigById(buildingSpeedupGoods[i]).Effect.Cdr / 60) .. Localization.Minute
        elseif currType == 1 then
            propData = itemsData[technicianTimeOutInfo[i]]
            view.PropsList[i].title = math.floor(ItemsConfig:getConfigById(techSpeedupGoods[i]).Effect.Cdr / 60) .. Localization.Minute
        end

        -- 没有该道具
        if propData == nil then
            view.PropsList[i].touchable = false
            view.PropsList[i].grayed = true
            view.PropsList[i].title = "0"
        else
            view.PropsList[i].touchable = true
            view.PropsList[i].grayed = false
            -- 数量
            local amount = propData.Amount
            view.PropsList[i].title = amount

            if amount > 0 then
                view.PropsList[i].onClick:Set( function()
                    if ItemsConfig:getConfigById(buildingSpeedupGoods[i]).Effect.Cdr - currCD > hintSecond then
                        -- 二次确认框
                        UIManager.openController(UIManager.ControllerName.Popup, {
                            UIManager.PopupStyle.ContentYesNo,
                            content = Localization.UseSpeedupPropHint,
                            btnFunc = { nil, function() NetworkManager.NewC2sUseCdrGoodsMsg(buildingSpeedupGoods[i], 1, currType, currIndex - 1) end }
                        } )
                    else
                        -- 目前只能1个1个用
                        -- <param name="id" type="number">道具id</param>
                        -- <param name="count" type="number">道具个数</param>
                        -- <param name="cdrType" type="number">减cd类型，0-建筑 1-科技</param>
                        -- <param name="index" type="number">索引</param>
                        NetworkManager.NewC2sUseCdrGoodsMsg(buildingSpeedupGoods[i], 1, currType, currIndex - 1)
                    end
                end )
            end
        end
    end
end

-- 秒建筑队CD
-- config.MiscConfigProto.miao_building_worker_duration 时间间隔 X
-- config.MiscConfigProto.miao_building_worker_cost 秒cd消耗 Y
-- 当前时间：CTime
-- 建筑队cd结束时间，EndTime
-- 秒CD总消耗 = ((Max(EndTime - Ctime, 0) + X - 1) / X) * Y
-- 参数配置
local config = MiscCommonConfig.Config

local function CdTimerUpdate(t, p)
    view.Time.text = Utils.secondConversion(math.ceil(p))
    view.CdBar.value = p
    currCD = p

    -- 进度条状态(0未满 1已满)
    if view.CdBar.value >= view.CdBar.max then
        view.State_C.selectedIndex = 1
    else
        view.State_C.selectedIndex = 0
    end

    local X = nil
    local Y = nil

    -- (0 建筑 1 科技)
    if currType == 0 then
        X = config.MiaoBuildingWorkerDuration
        Y = config.MiaoBuildingWorkerCost.YuanBao
    elseif currType == 1 then
        X = config.MiaoTechWorkerDuration
        Y = config.MiaoTechWorkerCost.YuanBao
    end

    if X <= 0 then
        view.YuanBaoBtn.visible = false
        return
    else
        view.YuanBaoBtn.visible = true
    end
    local yuanBaoAmount = math.floor(((p + X - 1) / X) * Y)
    view.YuanBaoBtn.title = yuanBaoAmount
    currYuanBaoAmont = yuanBaoAmount
end

local function CdTimerComplete()
    -- CD结束关闭界面
    _C:close()
end

-- data.typeId // 0 建筑队,1 科技队
-- data.index // 索引 服务器-1使用,客户端直接用
function _C:onOpen(data)
    itemsData = DataTrunk.PlayerInfo.ItemsData.Default
    internalData = DataTrunk.PlayerInfo.InternalAffairsData
    buildersTimeoutInfo = internalData.BuildersTimeoutInfo
    technicianTimeOutInfo = internalData.TechnicianTimeOutInfo

    if data.typeId == nil or data.index == nil then
        return
    end

    -- 播放动效
    view.Effect_T:Play()
    currType = data.typeId
    currIndex = data.index
    local cd = 0

    if data.typeId == 0 then
        cd = buildersTimeoutInfo[currIndex] - TimerManager.currentTime
        -- 建筑队疲劳时间上限
        view.CdBar.max = internalData.BuildingWorkerFatigueDuration
        view.YuanBaoBtn.onClick:Set(
        function()
            UIManager.openController(UIManager.ControllerName.Popup, {
                UIManager.PopupStyle.ContentYesNo,
                content = string.format(Localization.UseYuanBaoHint,currYuanBaoAmont),
                btnFunc = { nil, function() NetworkManager.C2SMiaoBuildingWorderCdMsg(currIndex - 1) end }
            } )
        end )
    elseif data.typeId == 1 then
        cd = technicianTimeOutInfo[currIndex] - TimerManager.currentTime
        -- 科技队疲劳时间上限
        view.CdBar.max = internalData.TechWorkerFatigueDuration
        view.YuanBaoBtn.onClick:Set(
        function()
            UIManager.openController(UIManager.ControllerName.Popup, {
                UIManager.PopupStyle.ContentYesNo,
                content = string.format(Localization.UseYuanBaoHint,currYuanBaoAmont),
                btnFunc = { nil, function() NetworkManager.C2SMiaoTechWorderCdMsg(currIndex - 1) end }
            } )
        end )
    end

    -- 开始倒计时
    if cdTimer == nil then
        cdTimer = TimerManager.newTimer(cd, false, true, nil, CdTimerUpdate, CdTimerComplete)
    end

    cdTimer:addCd(cd - cdTimer.MaxCd)
    cdTimer:reset()
    RefreshUI()
    cdTimer:start()
end

function BackBtnOnClick()
    _C:close()
end

-- 使用科技加速道具成功
local function UseSpeedupPropsSuccess()
    if not _C.IsOpen then
        return
    end

    -- 刷新时间
    if currType == 0 then
        cdTimer:addCd((buildersTimeoutInfo[currIndex] - TimerManager.currentTime) - cdTimer.CurCd)
    elseif currType == 1 then
        cdTimer:addCd((technicianTimeOutInfo[currIndex] - TimerManager.currentTime) - cdTimer.CurCd)
    end

    if cdTimer.CurCd <= 0 then
        _C:close()
    end
end

-- 更新道具数量
local function UpdateItemInfo()
    if not _C.IsOpen then
        return
    end

    if currType == 0 then
        RefreshUI()
    elseif currType == 1 then
        RefreshTechBuilders()
    end
end

function _C:onCreat()
    view = _C.View

    view.BackBtn.onClick:Set(BackBtnOnClick)

    Event.addListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, UseSpeedupPropsSuccess)
    Event.addListener(Event.ITEM_DEFAULT_UPDATE, UpdateItemInfo)
    -- 秒CD成功直接关界面
    Event.addListener(Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS, BackBtnOnClick)
    Event.addListener(Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS, BackBtnOnClick)
end

function _C:onDestroy()
    TimerManager.disposeTimer(cdTimer)
    cdTimer = nil
    Event.removeListener(Event.ITEM_USE_SPEEDUP_PROPS_SUCCESS, UseSpeedupPropsSuccess)
    Event.removeListener(Event.ITEM_DEFAULT_UPDATE, UpdateItemInfo)
    Event.removeListener(Event.BUILDERS_MIAO_BUILDING_WORKER_CD_SUCCESS, BackBtnOnClick)
    Event.removeListener(Event.BUILDERS_MIAO_TECH_WORKER_CD_SUCCESS, BackBtnOnClick)
end