local _C = UIManager.Controller(UIManager.ControllerName.AfterBattle3V3Win, UIManager.ViewName.AfterBattle3V3Win)
-- view
local view = nil
-- 回放信息
local replayInfo = nil
-- 自身獎勵
local selfAwardInfo = nil
-- 君主实例化信息
local monarchsData = DataTrunk.PlayerInfo.MonarchsData
-- 密室实例化信息
local backroomInsInfo = DataTrunk.PlayerInfo.TowerBackroom

-- 返回
local function btnBack()
    _C:close()
    if LevelManager.PreLevelType == LevelType.MainCity then
        LevelManager.loadScene(LevelType.MainCity)
    elseif LevelManager.PreLevelType == LevelType.WorldMap then
        -- 加载场景
        LevelManager.loadScene(LevelType.WorldMap)
    end
end
-- 回放
local function btnReplay()
    _C:close()
    UIManager.openController(UIManager.ControllerName.Battle3V3Main)
end

-- item渲染
local function onPlayerItemRender(index, obj)
    local playerInfo = replayInfo.Result.OtherResultInfo.Members[index + 1]

    -- 超级大奖
    if replayInfo.Result.OtherResultInfo.GetSuperPrizeTroopId == playerInfo.Id then
        local showSuperPrize = function(prizeInfo)
            local prize = obj:GetChild("Component_Prize")
            prize:GetController("Count_C").selectedIndex = 1
            prize:GetController("State_C").selectedIndex = 1
            prize:GetController("CornerMark_C").selectedIndex = 0

            prize:GetChild("title").text = prizeInfo.Amount
            prize:GetChild("icon").url = prizeInfo.Config.Icon
            prize:GetChild("quality").url = UIConfig.Item.DefaultQuality[prizeInfo.Config.Quality]
        end
        if #replayInfo.Result.OtherResultInfo.SuperPrize.Equips > 0 then
            showSuperPrize(replayInfo.Result.OtherResultInfo.SuperPrize.Equips[1])
        elseif #replayInfo.Result.OtherResultInfo.SuperPrize.Goods > 0 then
            showSuperPrize(replayInfo.Result.OtherResultInfo.SuperPrize.Goods[1])
        elseif #replayInfo.Result.OtherResultInfo.SuperPrize.Currencys > 0 then
            showSuperPrize(replayInfo.Result.OtherResultInfo.SuperPrize.Currencys[1])
        end

        obj:GetController("State_C").selectedIndex = 0
    else
        obj:GetController("State_C").selectedIndex = 1
    end

    -- 连胜次数
    if playerInfo.ContinueWinTime > 0 then
        obj:GetChild("TextField_WinNumber").text = string.format(Localization.WinNum, playerInfo.ContinueWinTime)
        obj:GetController("Type_C").selectedIndex = 1
    else
        obj:GetController("Type_C").selectedIndex = 0
    end

    -- 基础信息
    if playerInfo.GuildId <= 0 then
        obj:GetChild("TextField_LordName").text = playerInfo.Name
    else
        obj:GetChild("TextField_LordName").text = string.format("[%s]%s", playerInfo.GuildFlagName, playerInfo.Name)
    end

    -- 判断是不是自己
    if playerInfo.Id == monarchsData.Id then
        selfAwardInfo = { }
        -- 获得道具
        award = function(t, cornerType)
            if nil ~= t then
                for k, v in pairs(t) do
                    v.CornerType = cornerType
                    table.insert(selfAwardInfo, v)
                end
            end
        end
        -- 首胜道具
        if playerInfo.IsFirstPass and nil ~= replayInfo.Result.OtherResultInfo.FloorConfig.FirstPassPrize then
            award(replayInfo.Result.OtherResultInfo.FloorConfig.FirstPassPrize.Goods, ItemCornerType.Noraml)
            award(replayInfo.Result.OtherResultInfo.FloorConfig.FirstPassPrize.Equips, ItemCornerType.Noraml)
            award(replayInfo.Result.OtherResultInfo.FloorConfig.FirstPassPrize.Currencys, ItemCornerType.Noraml)
        end
        -- 展示道具
        award(playerInfo.PassPrize.Goods, ItemCornerType.Noraml)
        award(playerInfo.PassPrize.Equips, ItemCornerType.Noraml)
        award(playerInfo.PassPrize.Currencys, ItemCornerType.Noraml)

        view.AwardList.numItems = #selfAwardInfo
    end
end

-- item渲染
local function onAwardItemRender(index, obj)
    obj.name = tostring(index)
    local itemInfo = selfAwardInfo[index + 1]

    -- 刷新
    obj:GetController("Count_C").selectedIndex = 1
    obj:GetController("State_C").selectedIndex = 1

    obj.title = itemInfo.Amount
    obj:GetChild("icon").url = itemInfo.Config.Icon
    obj:GetChild("quality").url = UIConfig.Item.DefaultQuality[itemInfo.Config.Quality]

    -- 角标
    if itemInfo.CornerType == ItemCornerType.Noraml then
        obj:GetController("CornerMark_C").selectedIndex = 0
    elseif itemInfo.CornerType == ItemCornerType.FirstWin then
        obj:GetController("CornerMark_C").selectedIndex = 1
    elseif itemInfo.CornerType == ItemCornerType.Prob then
        obj:GetController("CornerMark_C").selectedIndex = 2
    end
end
-- 更新信息
local function updateWinInfo()
    view.BattleLeftChalletNum.text = backroomInsInfo.ChallengeTimes
    view.BattleLeftHelpNum.text = backroomInsInfo.HelpTimes

    -- 此处注意顺序
    view.AwardList.numItems = 0
    view.PlayerList.numItems = #(replayInfo.Result.OtherResultInfo.Members)
end
function _C:onCreat()
    view = _C.View

    view.PlayerList.itemRenderer = onPlayerItemRender
    view.AwardList.itemRenderer = onAwardItemRender
    view.BtnBack.onClick:Add(btnBack)
    view.BtnReplay.onClick:Add(btnReplay)
end

function _C:onOpen(data)
    replayInfo = data
    updateWinInfo()
end

function _C:onDestroy()
    view.PlayerList.itemRenderer = nil
    view.AwardList.itemRenderer = nil
    view.BtnBack.onClick:Clear()
    view.BtnReplay.onClick:Clear()
end