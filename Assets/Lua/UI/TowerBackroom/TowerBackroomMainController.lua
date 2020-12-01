local _C = UIManager.Controller(UIManager.ControllerName.TowerBackroomMain, UIManager.ViewName.TowerBackroomMain)
local _CSub = require(UIManager.ControllerName.TowerBackroomBase)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)
table.insert(_C.SubCtrl, _CSub)

local view = nil
-- 当前楼层Id
local curFloorId = 0
-- 开放的最大楼层,此处包含密室邀请
local maxOpenFloor = 0
-- 密室实例化信息
local backroomInsInfo = DataTrunk.PlayerInfo.TowerBackroom
-- 创建队伍数据
local battleDeploymentInfo = BattleDeploymentInfo()

-- 返回
local function btnBack()
    _C:close()
end

-- 打开部队详情面板
local function openTroopsDetailPanel()
    UIManager.openController(UIManager.ControllerName.TowerBackroomTroopsMain)
end
--  刷新楼层列表
local function refreshTroopsCountList()
    if not _C.IsOpen then
        return
    end

    view.FloorCountList:RefreshVirtualList()
end

-- 刷新主面板数据
local function updateRoomBaseInfo()
    if not _C.IsOpen then
        return
    end

    view.HelpNum.text = string.format(Localization.BackroomHelpNum, backroomInsInfo.HelpTimes)
    view.RoomNum.text = string.format(Localization.BackroomChallengeNum, backroomInsInfo.ChallengeTimes)

    if backroomInsInfo.ChallengeTimes >= BackroomCommonConfig.Config.MaxChallengeTimes then
        view.RoomNumStat.selectedIndex = 1
    else
        view.RoomNumStat.selectedIndex = 0
    end

    if BackroomCommonConfig.Config.MaxChallengeTimes > 0 then
        view.TroopCreatStat.selectedIndex = 0
    else
        view.TroopCreatStat.selectedIndex = 1
    end
end
-- 创建队伍
local function btnCreatTroops()
    -- 已在队伍判断
    if backroomInsInfo.TroopsDetailInfo.TeamId > 0 then
        UIManager.showTip( { content = Localization.BackroomInTroops, result = false })
        return
    end
    -- 已无挑战次数
    if backroomInsInfo.ChallengeTimes <= 0 then
        UIManager.showTip( { content = Localization.BackroomChallengeNumEmpty, result = false })
        return
    end

    -- 楼层配置
    local floorConfig = BackroomConfig:getConfigById(curFloorId)

    -- 清除数据
    battleDeploymentInfo:clear()
    -- 战斗类型
    battleDeploymentInfo.Type = BattleDeploymentType.PVE_TowerBackroom
    -- 战力显示方式
    battleDeploymentInfo.FightAmountShowType = 1
    -- 请求创建
    battleDeploymentInfo.ToCombat = function(captainId, count, isGuild)
        print("创建联盟队伍", isGuild)

        -- 同步
        NetworkManager.C2SCreateTeamProto(curFloorId, captainId, isGuild)
        return true
    end
    -- 获得道具
    award = function(t, cornerType)
        if nil ~= t then
            for k, v in pairs(t) do
                v.CornerType = cornerType
                table.insert(battleDeploymentInfo.Awards, v)
            end
        end
    end
    battleDeploymentInfo.Awards = { }
    -- 首胜道具
    if nil ~= floorConfig.FirstPassPrize then
        award(floorConfig.FirstPassPrize.Goods, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Equips, ItemCornerType.FirstWin)
        award(floorConfig.FirstPassPrize.Currencys, ItemCornerType.FirstWin)
    end
    -- 展示道具
    if nil ~= floorConfig.ShowPrize then
        award(floorConfig.ShowPrize.Goods, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Equips, ItemCornerType.Prob)
        award(floorConfig.ShowPrize.Currencys, ItemCornerType.Prob)
    end
    -- 超级大奖
    if nil ~= floorConfig.SuperPrize then
        award(floorConfig.SuperPrize.Goods, ItemCornerType.Noraml)
        award(floorConfig.SuperPrize.Equips, ItemCornerType.Noraml)
        award(floorConfig.SuperPrize.Currencys, ItemCornerType.Noraml)
    end
    -- 密室信息
    battleDeploymentInfo.Backroom = { }
    battleDeploymentInfo.Backroom.IsCreatTroop = true
    battleDeploymentInfo.Backroom.FloorId = curFloorId
    battleDeploymentInfo.Backroom.MinPlayerNum = floorConfig.MinAttackerCount
    battleDeploymentInfo.Backroom.MaxPlayerNum = floorConfig.MaxAttackerCount
    battleDeploymentInfo.Backroom.TroopsNum = #floorConfig.MonsterMasters
    battleDeploymentInfo.Backroom.MaxContinueNum = floorConfig.MaxContinueWinTimes

    -- 打开布阵
    UIManager.openController(UIManager.ControllerName.PreBattle, battleDeploymentInfo)
end
-- item点击
local function onItemClick(item)
    curFloorId = tonumber(item.data.name)
    -- 密室邀请楼层
    local isInviteFloor = curFloorId >= maxOpenFloor
    view.BtnCreatTroop.visible = not isInviteFloor

    _CSub:updateFloorTroopsInfo(curFloorId, isInviteFloor)
end
-- item渲染
local function onItemRender(index, obj)
    local floorId = maxOpenFloor - index
    obj.name = tostring(floorId)

    -- 最高楼层为密室邀请
    if floorId >= maxOpenFloor then
        obj:GetChild("title").text = string.format(Localization.TowerFloorInvite)
        obj:GetChild("Label_shuzi").title = backroomInsInfo.InviteTroopsInfo.TroopsCount
    else
        -- 当前楼层
        obj:GetChild("title").text = string.format(Localization.TowerCurFloor_2, floorId)

        -- 楼层队伍数量
        if nil ~= backroomInsInfo.FloorTroopsInfo[floorId] then
            obj:GetChild("Label_shuzi").title = backroomInsInfo.FloorTroopsInfo[floorId].TroopsCount
        else
            obj:GetChild("Label_shuzi").title = 0
        end
    end
end
-- 更新密室楼层个数信息
local function getTroopCountInfo()
    maxOpenFloor = backroomInsInfo.OpenMaxFloor + 1
    curFloorId = maxOpenFloor
    view.FloorCountList.numItems = 0
    view.FloorCountList.numItems = maxOpenFloor
end
function _C:onCreat()
    view = _C.View
    _CSub.view = view

    view.BtnBack.onClick:Add(btnBack)
    view.BtnCreatTroop.onClick:Add(btnCreatTroops)
    view.FloorCountList.itemRenderer = onItemRender
    view.FloorCountList.onClickItem:Add(onItemClick)

    Event.addListener(Event.TOWER_BACKROOM_TROOPS_REFRESH, refreshTroopsCountList)
    Event.addListener(Event.TOWER_BACKROOM_JOIN_TROOPS_SUCCEED, openTroopsDetailPanel)
    Event.addListener(Event.TOWER_BACKROOM_BASE_INFO_REFRESH, updateRoomBaseInfo)
end

function _C:onOpen(data)
    getTroopCountInfo()
    updateRoomBaseInfo()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onShow()
    -- 检测是否允许创建队伍
    if backroomInsInfo.TroopsDetailInfo.TeamId <= 0 and backroomInsInfo.ChallengeTimes > 0 then
        view.BtnCreatTroop.grayed = false
    else
        view.BtnCreatTroop.grayed = true
    end
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnCreatTroop.onClick:Clear()
    view.FloorCountList.itemRenderer = nil
    view.FloorCountList.onClickItem:Clear()

    Event.removeListener(Event.TOWER_BACKROOM_TROOPS_REFRESH, refreshTroopsCountList)
    Event.removeListener(Event.TOWER_BACKROOM_JOIN_TROOPS_SUCCEED, openTroopsDetailPanel)
    Event.removeListener(Event.TOWER_BACKROOM_BASE_INFO_REFRESH, updateRoomBaseInfo)
end

function _C:onUpdate()
    view.RecoverTime.text = string.format(Localization.BackroomChallengeRecoverTime, Utils.secondConversion(math.ceil(backroomInsInfo.ChallengeRecoverTimer.CurCd)))
end

