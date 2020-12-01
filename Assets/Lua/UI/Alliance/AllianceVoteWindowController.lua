local _C = UIManager.Controller(UIManager.ControllerName.AllianceVoteWindow, UIManager.ViewName.AllianceVoteWindow)
_C.IsPopupBox = true

local view = nil
-- ��������
local allianceData = nil
local impeachData = nil
-- �������
local monarchData = nil
-- ͶƱ��ʱ��
local timer = nil
-- �Լ�ѡ��˭
local myTargetId = ""

local function CloseBtnOnClick()
    _C:destroy()
end

local function TimerUpdate(t, p)
    view.TimeText.text = Utils.secondConversion(math.ceil(p))
end

-- ͶƱ�б�
local function CandidateListRenderer(index, obj)
    -- ��Աid
    local id = impeachData.Candidates[index + 1]
    -- ��Ʊ��
    local points = impeachData.Points[index + 1]
    -- �������
    local memberData = allianceData:GetMemberDataById(id)

    if memberData == nil then
        return
    end

    -- ����
    obj:GetChild("Text_Name").text = memberData.Hero.Name
    -- ������
    local voteBar = obj:GetChild("ProgressBar_Vote")
    -- ��ǰ��Ʊ��
    voteBar.value = points
    -- ���ֵ(��������)
    voteBar.max = allianceData.MyAlliance.MemberCount
    -- 0:��ͶƱ 1:��֧��
    local state_C = obj:GetController("State_C")

    -- �ж��Լ���û��Ͷ��
    if myTargetId == id then
        state_C.selectedIndex = 1
    else
        state_C.selectedIndex = 0
    end
end

-- ���鰴ť����¼�
local function VoteDetailsBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceCheckVote)
end

local function UpdateData()
    if not _C.IsOpen then
        return
    end

    -- ��ѡ��������û���Լ�
    for k, v in ipairs(impeachData.VoteHeros) do
        if v == monarchData.Id then
            myTargetId = impeachData.VoteTarget[k]
            break
        end
    end

    view.CandidateList.itemRenderer = CandidateListRenderer
    view.CandidateList.numItems = #impeachData.Candidates
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData
    impeachData = allianceData.MyAlliance.ImpeachLeader
    monarchData = DataTrunk.PlayerInfo.MonarchsData
    -- cd
    local cd = impeachData.ImpeachEndTime - TimerManager.currentTime
    timer = TimerManager.newTimer(cd, false, true, nil, TimerUpdate, CloseBtnOnClick)
    timer:addCd(cd - timer.MaxCd)
    timer:reset()
    timer:start()
end

function _C:onCreat()
    view = _C.View
    view.BG.onClick:Set(CloseBtnOnClick)
    view.CloseBtn.onClick:Set(CloseBtnOnClick)
    -- ˽������
    view.VoteDetailsBtn.visible = false
    view.VoteDetailsBtn.onClick:Set(VoteDetailsBtnOnClick)
    Event.addListener(Event.ALLIANCE_VOTE_SUCCESS, UpdateData)
end

function _C:onDestroy()
    view.CandidateList.itemRenderer = nil
    TimerManager.disposeTimer(timer)
    timer = nil
    Event.removeListener(Event.ALLIANCE_VOTE_SUCCESS, UpdateData)
end