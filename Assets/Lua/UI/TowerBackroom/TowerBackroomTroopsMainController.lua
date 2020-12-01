local _C = UIManager.Controller(UIManager.ControllerName.TowerBackroomTroopsMain, UIManager.ViewName.TowerBackroomTroopsMain)
local _CSub = require(UIManager.ControllerName.TowerBackroomTroopsBase)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)
table.insert(_C.SubCtrl, _CSub)

local view = nil
-- 君主实例化信息
local monarchsData = DataTrunk.PlayerInfo.MonarchsData
-- 密室实例化信息
local backroomInsInfo = DataTrunk.PlayerInfo.TowerBackroom
-- 奖励列表
local awardItemsList = nil

-- 返回
local function btnBack()
    if not _C.IsOpen then
        return
    end

    _C:close()
end
-- 一键喊话
local function btnShout()
    UIManager.showTip( { content = "一键喊话尚未开发", result = false })
end
-- 离开队伍
local function btnLeaveTroops()
    NetworkManager.C2SLeaveTeamProto()
end
-- 邀请好友
local function btnInviteFriends()
    UIManager.openController(UIManager.ControllerName.TowerBackroomTroopsInvite)
end
-- 开始挑战
local function btnStart()
    if #backroomInsInfo.TroopsDetailInfo.Members < backroomInsInfo.TroopsDetailInfo.FloorConfig.MinAttackerCount then
        UIManager.showTip( { content = Localization.BackroomChallengeTroopNumLack, result = false })
        return
    end
    if backroomInsInfo.TroopsDetailInfo.LeaderId ~= monarchsData.Id then
        UIManager.showTip( { content = Localization.BackroomChallengeNotLeader, result = false })
        return
    end
    NetworkManager.C2SStartChallenge()
end
-- 获取密室战斗回放成功
local function getBackroomReplayAck(bytes)
    -- 解析
    local battle = shared_pb.AllCombatProto()
    battle:ParseFromString(bytes)

    -- 密室回放
    backroomInsInfo.BackroomReplay:updateInfo(battle.multi)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 关闭界面
    btnBack()
    -- 开始战斗
    LevelManager.loadScene(backroomInsInfo.BackroomReplay.MapRes, backroomInsInfo.BackroomReplay)
end
-- 获取密室战斗回放失败
local function getBackroomReplayError(value)
    -- 关闭菊花
    Event.dispatch(Event.SYNC_CLOSE)
    -- 网络异常
    UIManager.showTip( { content = Localization.ConnectError .. value, result = false })
end    
-- 请求战斗回放数据
local function httpRequstBattle()
    if not _C.IsOpen then
        return
    end

    -- 打开菊花
    UIManager.openController(UIManager.ControllerName.Sync)
    -- 请求回放
    CS.LPCFramework.HttpHelper.CreateGetHttpResponse(backroomInsInfo.BackroomReplay.Result.OtherResultInfo.Link, getBackroomReplayAck, getBackroomReplayError)
end
-- 刷新数据
local function updateRoomBaseInfo()
    view.RoomName.text = string.format(Localization.BackroomFloor, backroomInsInfo.TroopsDetailInfo.FloorId)
    view.TroopsMinNum.text = string.format(Localization.BackroomChallengeMinTroopsNum, backroomInsInfo.TroopsDetailInfo.FloorConfig.MinAttackerCount)
end
-- item渲染
local function onItemRender(index, obj)
    obj.name = tostring(index)
    local itemInfo = awardItemsList[index + 1]

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
-- 获取胜利奖励 
local function getVictoryAwardInfo()
    awardItemsList = { }
    -- 楼层配置
    local floorConfig = backroomInsInfo.TroopsDetailInfo.FloorConfig
    -- 获得道具
    award = function(t, cornerType)
        if nil ~= t then
            for k, v in pairs(t) do
                v.CornerType = cornerType
                table.insert(awardItemsList, v)
            end
        end
    end
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
    view.ItemAwardList.numItems = #awardItemsList

    -- 超级大奖
    local showSuperPrize = function(prizeInfo)
        view.SuperPrize.Root.visible = true
        view.SuperPrize.Num.text = prizeInfo.Amount
        view.SuperPrize.Icon.url = prizeInfo.Config.Icon
        view.SuperPrize.Quality.url = UIConfig.Item.DefaultQuality[prizeInfo.Config.Quality]
    end
    view.SuperPrize.Root.visible = false
    if nil ~= floorConfig.SuperPrize then
        if #floorConfig.SuperPrize.Equips > 0 then
            showSuperPrize(floorConfig.SuperPrize.Equips[1])
        elseif #floorConfig.SuperPrize.Goods > 0 then
            showSuperPrize(floorConfig.SuperPrize.Goods[1])
        elseif #floorConfig.SuperPrize.Currencys > 0 then
            showSuperPrize(floorConfig.SuperPrize.Currencys[1])
        end
    end

    -- 联盟贡献值
    view.GuildContribution.Num.text = floorConfig.ContributionForGuild.Amount
    view.GuildContribution.Icon.url = floorConfig.ContributionForGuild.Config.Icon
    view.GuildContribution.Quality.url = UIConfig.Item.DefaultQuality[floorConfig.ContributionForGuild.Config.Quality]
end
function _C:onCreat()
    view = _C.View
    _CSub.view = view

    view.BtnBack.onClick:Add(btnBack)
    view.BtnStart.onClick:Add(btnStart)
    view.BtnLeave.onClick:Add(btnLeaveTroops)
    view.BtnInvite.onClick:Add(btnInviteFriends)
    view.BtnShout.onClick:Add(btnShout)
    view.ItemAwardList.itemRenderer = onItemRender

    Event.addListener(Event.TOWER_BACKROOM_LEAVE_TROOPS_SUCCEED, btnBack)
    Event.addListener(Event.TOWER_BACKROOM_BATTLE_REPLAY_ACK, httpRequstBattle)
end

function _C:onOpen(data)
    updateRoomBaseInfo()
    getVictoryAwardInfo()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnStart.onClick:Clear()
    view.BtnLeave.onClick:Clear()
    view.BtnInvite.onClick:Clear()
    view.BtnShout.onClick:Clear()
    view.ItemAwardList.itemRenderer = nil

    Event.removeListener(Event.TOWER_BACKROOM_LEAVE_TROOPS_SUCCEED, btnBack)
    Event.removeListener(Event.TOWER_BACKROOM_BATTLE_REPLAY_ACK, httpRequstBattle)
end
