local _C = UIManager.Controller(UIManager.ControllerName.TowerBackroomTroopsInvite, UIManager.ViewName.TowerBackroomTroopsInvite)
_C.IsPopupBox = true

local view = nil
-- 君主实例化信息
local monarchsData = DataTrunk.PlayerInfo.MonarchsData
-- 联盟实例化信息
local allianceData = DataTrunk.PlayerInfo.AllianceData
-- 密室实例化信息
local backroomInsInfo = DataTrunk.PlayerInfo.TowerBackroom
-- 当前处理列表
local handleListInfo = nil

-- 邀请列表
local inviteMembersList =
{
    Guild = nil,
    Friends = nil
}

-- 返回
local function btnBack()
    _C:close()
end
-- 联盟
local function btnGuild()
    if view.GroupStat.selectedIndex == 1 then
        return
    end

    -- 联盟
    handleListInfo = inviteMembersList.Guild
    view.FriendList.numItems = #handleListInfo

    view.GroupStat.selectedIndex = 1
end
-- 好友
local function btnFriend()
    if view.GroupStat.selectedIndex == 2 then
        return
    end

    -- 好友
    handleListInfo = inviteMembersList.Friends
    view.FriendList.numItems = #handleListInfo

    view.GroupStat.selectedIndex = 2
end
-- 更新邀请结果
local function updateInveteRusult(inviteResult)
    -- 更新状态
    for k, v in pairs(inviteMembersList.Guild) do
        if v.Info.Id == inviteResult.Id then
            v.Result = inviteResult.Result
            break
        end
    end
    for k, v in pairs(inviteMembersList.Friends) do
        if v.Info.Id == inviteResult.Id then
            v.Result = inviteResult.Result
            break
        end
    end

    -- 置状态
    local item = view.FriendList:GetChild(inviteResult.Id)
    if nil ~= item then
        item:GetController("State_C").selectedIndex = inviteResult.Result
    end
end
-- item渲染
local function onItemRender(index, obj)
    local itemInfo = handleListInfo[index + 1]

    obj.name = tostring(itemInfo.Info.Id)

    obj:GetChild("TextField_FlagName").text = string.format("【%s】", itemInfo.Info.GuildFlagName)
    obj:GetChild("TextField_Name").text = itemInfo.Info.Name
    obj:GetController("State_C").selectedIndex = itemInfo.Result

    obj:GetChild("btn_invite").onClick:Set( function() NetworkManager.C2SInviteProto(itemInfo.Info.Id) end)
end
-- 获取邀请列表
local function getInviteMembersList()
    inviteMembersList.Guild = { }
    inviteMembersList.Friends = { }

    -- 联盟
    if nil ~= allianceData.OnlineMemberData then
        for k, v in pairs(allianceData.OnlineMemberData) do
            -- 过滤自己
            if v.Hero.Id ~= monarchsData.Id then
                local memble = { }
                memble.Info = v.Hero
                memble.Result = backroomInsInfo.InviteResultType.Invite
                table.insert(inviteMembersList.Guild, memble)
            end
        end
    end

    view.GroupStat.selectedIndex = 2
    view.BtnGuild.onClick:Call()
end

function _C:onCreat()
    view = _C.View

    view.BtnBack.onClick:Add(btnBack)
    view.BtnFriend.onClick:Add(btnFriend)
    view.BtnGuild.onClick:Add(btnGuild)

    view.FriendList.itemRenderer = onItemRender

    Event.addListener(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, updateInveteRusult)
end

function _C:onOpen(data)
    getInviteMembersList()
end

function _C:onDestroy()
    view.BtnBack.onClick:Clear()
    view.BtnFriend.onClick:Clear()
    view.BtnGuild.onClick:Clear()

    view.FriendList.itemRenderer = nil

    Event.removeListener(Event.TOWER_BACKROOM_INVITE_ACK_RESULT, updateInveteRusult)
end
