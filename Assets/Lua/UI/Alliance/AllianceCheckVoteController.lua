local _C = UIManager.Controller(UIManager.ControllerName.AllianceCheckVote, UIManager.ViewName.AllianceCheckVote)
_C.IsPopupBox = true

local view = nil
-- ��������
local allianceData = nil
-- ���˵�������
local impeachData = nil

local function CloseBtnOnClick()
    _C:destroy()
end

-- ͶƱ�б�
local function MainListRenderer(index, obj)
    -- id
    local id = impeachData.VoteHeros[index + 1]
    -- HeroBasicSnapshotClass()
    local data = allianceData:GetMemberDataById(id)

    if data == nil then
        return
    end

    -- ͷ��&�ȼ�
    local head = obj:GetChild("Label_Head")
    head.icon = UIConfig.MonarchsIcon[data.Head].SmallIcon
    head.title = data.Level
    -- ����
    obj:GetChild("Text_Name").text = data.Name
    -- ְλ
    obj:GetChild("Text_Post").text = GuildClassLevelConfig.Config[allianceData:GetMemberPostById(id)].Name
    -- Ŀ��id
    local targetId = impeachData.VoteTarget[index + 1]
    -- Ŀ������
    local targetData = allianceData:GetMemberDataById(targetId)

    if targetData == nil then
        return
    end

    -- Ŀ��ְλ
    local targetPost = obj:GetChild("Text_VoteForPost")
    -- ְλid
    local targetPostId = allianceData:GetMemberPostById(targetId)

    -- ���������
    if targetPostId == allianceData.MyAlliance.Leader.ClassLevel then
        -- ԭ����
        targetPost.text = Localization.AlliancePrimary .. GuildClassLevelConfig.Config[targetPostId].Name
    else
        targetPost.text = GuildClassLevelConfig.Config[targetPostId].Name
    end

    -- Ŀ������
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