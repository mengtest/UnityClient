local _C = UIManager.Controller(UIManager.ControllerName.AllianceVoteWindow, UIManager.ViewName.AllianceVoteWindow)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil
local impeachData = nil
-- 玩家数据
local monarchData = nil
-- 投票计时器
local timer = nil
-- 自己选了谁
local myTargetId = ""

local function CloseBtnOnClick()
    _C:destroy()
end

local function TimerUpdate(t, p)
    view.TimeText.text = Utils.secondConversion(math.ceil(p))
end

-- 投票列表
local function CandidateListRenderer(index, obj)
    -- 成员id
    local id = impeachData.Candidates[index + 1]
    -- 得票数
    local points = impeachData.Points[index + 1]
    -- 玩家数据
    local memberData = allianceData:GetMemberDataById(id)

    if memberData == nil then
        return
    end

    -- 名字
    obj:GetChild("Text_Name").text = memberData.Hero.Name
    -- 进度条
    local voteBar = obj:GetChild("ProgressBar_Vote")
    -- 当前得票数
    voteBar.value = points
    -- 最大值(联盟人数)
    voteBar.max = allianceData.MyAlliance.MemberCount
    -- 0:可投票 1:已支持
    local state_C = obj:GetController("State_C")

    -- 判断自己有没有投他
    if myTargetId == id then
        state_C.selectedIndex = 1
    else
        state_C.selectedIndex = 0
    end
end

-- 详情按钮点击事件
local function VoteDetailsBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceCheckVote)
end

local function UpdateData()
    if not _C.IsOpen then
        return
    end

    -- 从选民中找有没有自己
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
    -- 私信暂无
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