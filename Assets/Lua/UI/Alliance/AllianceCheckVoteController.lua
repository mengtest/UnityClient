local _C = UIManager.Controller(UIManager.ControllerName.AllianceCheckVote, UIManager.ViewName.AllianceCheckVote)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil
-- 联盟弹劾数据
local impeachData = nil

local function CloseBtnOnClick()
    _C:destroy()
end

-- 投票列表
local function MainListRenderer(index, obj)
    -- id
    local id = impeachData.VoteHeros[index + 1]
    -- HeroBasicSnapshotClass()
    local data = allianceData:GetMemberDataById(id)

    if data == nil then
        return
    end

    -- 头像&等级
    local head = obj:GetChild("Label_Head")
    head.icon = UIConfig.MonarchsIcon[data.Head].SmallIcon
    head.title = data.Level
    -- 名字
    obj:GetChild("Text_Name").text = data.Name
    -- 职位
    obj:GetChild("Text_Post").text = GuildClassLevelConfig.Config[allianceData:GetMemberPostById(id)].Name
    -- 目标id
    local targetId = impeachData.VoteTarget[index + 1]
    -- 目标数据
    local targetData = allianceData:GetMemberDataById(targetId)

    if targetData == nil then
        return
    end

    -- 目标职位
    local targetPost = obj:GetChild("Text_VoteForPost")
    -- 职位id
    local targetPostId = allianceData:GetMemberPostById(targetId)

    -- 如果是盟主
    if targetPostId == allianceData.MyAlliance.Leader.ClassLevel then
        -- 原盟主
        targetPost.text = Localization.AlliancePrimary .. GuildClassLevelConfig.Config[targetPostId].Name
    else
        targetPost.text = GuildClassLevelConfig.Config[targetPostId].Name
    end

    -- 目标名字
    obj:GetChild("Text_VoteForName").text = targetData.Name
end

local function UpdateData()
    if not _C.IsOpen then
        return
    end

    view.MainList.itemRenderer = MainListRenderer
    view.MainList.numItems = #impeachData.VoteHeros
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData
    impeachData = allianceData.MyAlliance.ImpeachLeader
    UpdateData()
end

function _C:onCreat()
    view = _C.View
    view.BG.onClick:Set(CloseBtnOnClick)
    Event.addListener(Event.ALLIANCE_VOTE_SUCCESS, UpdateData)
end

function _C:onDestroy()
    view.MainList.itemRenderer = nil
    Event.removeListener(Event.ALLIANCE_VOTE_SUCCESS, UpdateData)
end