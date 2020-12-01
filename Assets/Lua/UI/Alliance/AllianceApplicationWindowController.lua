local _C = UIManager.Controller(UIManager.ControllerName.AllianceApplicationWindow, UIManager.ViewName.AllianceApplicationWindow)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil

-- 点击关闭按钮
local function CloseBtnOnClick()
    _C:destroy(true)
end

local function MainListRenderer(index, obj)
    local data = allianceData.RequestJoinHero[index + 1]
    local headLabel = obj:GetChild("Label_Head")
    -- 头像
    headLabel.icon = UIConfig.MonarchsIcon[data.Head].SmallIcon
    -- 等级
    headLabel.title = data.Level
    -- 名字
    obj:GetChild("Text_Name").text = data.Name
    -- 个人排名
    obj:GetChild("Text_Ranking").text = "敬请期待"
    -- 千重楼层数
    obj:GetChild("Text_ClimbingTower").text = data.TowerMaxFloor
    -- 百战千军军衔
    obj:GetChild("Text_MilitaryRank").text = "敬请期待"
    -- 当前联盟
    local allianceName = ""

    if data.GuildName == "" then
        allianceName = Localization.None
    else
        allianceName = data.GuildName
    end

    obj:GetChild("Text_CurrAlliance").text = allianceName
    -- 批准
    obj:GetChild("Button_Approve").onClick:Set( function()
        NetworkManager.C2SGuildReplyJoinRequestProto(data.Id, true)
    end )
    -- 拒绝
    obj:GetChild("Button_Refuse").onClick:Set( function()
        NetworkManager.C2SGuildReplyJoinRequestProto(data.Id, false)
    end )
end

-- 刷新UI
local function RefreshUI()
    if not _C.IsOpen then
        return
    end

    view.MainList.itemRenderer = MainListRenderer
    view.MainList.numItems = Utils.GetTableLength(allianceData.RequestJoinHero)
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set(CloseBtnOnClick)
    view.CloseBtn.onClick:Set(CloseBtnOnClick)

    Event.addListener(Event.ALLIANCE_REPLY_SUCCESS, RefreshUI)
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData.MyAlliance
    RefreshUI()
end

function _C:onDestroy()
    view.MainList.itemRenderer = nil

    Event.removeListener(Event.ALLIANCE_REPLY_SUCCESS, RefreshUI)
end