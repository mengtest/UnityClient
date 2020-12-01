local _C = UIManager.SubController(UIManager.ControllerName.AllianceManageController, nil)
_C.view = nil

local view = nil
-- 联盟数据
local allianceData = nil
-- 我的君主数据
local monarchsData = nil
-- 名城数量(测试用)
local cityNum = 0

local function MemberListRenderer(index, obj)
    -- data:GuildMemberClass()
    local data = allianceData.MemberList[index + 1]

    if data == nil then
        return
    end

    -- 头像
    local headItem = obj:GetChild("Label_Head")
    headItem.icon = UIConfig.MonarchsIcon[data.Hero.Head].SmallIcon
    -- 等级
    headItem.title = data.Hero.Level
    -- 名字
    obj:GetChild("Text_Name").text = data.Hero.Name
    -- 点击查看玩家详情面板(要判断是否为NPC,暂无)
    obj:GetChild("Button_HeroInfo").onClick:Set( function()
        NetworkManager.C2SViewOtherHero(data.Hero.Id)
    end )
    -- 职位
    obj:GetChild("Text_Post").text = GuildClassLevelConfig.Config[data.ClassLevel].Name
    -- 是否是NPC
    -- 0:没标签/无 1:有标签 2:NPC
    local type_C = obj:GetController("Type_C")

    if tonumber(data.Hero.Id) < 0 then
        type_C.selectedIndex = 2
        return
        -- 系统职称 + 自定义职称数量
    elseif Utils.GetTableLength(allianceData:GetSystemTitle(data.Hero.Id)) + Utils.GetTableLength(allianceData:GetCustomTitle(data.Hero.Id)) <= 1 then
        type_C.selectedIndex = 0
    else
        type_C.selectedIndex = 1
    end

    -- 职称
    local titleLabel = obj:GetChild("Label_Title")
    -- 默认显示
    titleLabel.visible = true
    -- 关闭交互
    titleLabel.touchable = false
    -- 0:系统职称 1:自定义职称 2:增加
    local titleType_C = titleLabel:GetController("Type_C")
    -- 系统职称
    local systemTitle = allianceData:GetSystemTitle(data.Hero.Id)
    -- 自定义职称
    local customTitle = allianceData:GetCustomTitle(data.Hero.Id)
    -- 职称列表
    local titleList = obj:GetChild("List_Label")

    -- 如果有系统职称
    if Utils.GetTableLength(systemTitle) > 0 then
        titleType_C.selectedIndex = 0
        titleLabel.title = GuildClassTitleConfig.Config[systemTitle[1]].Name
        -- 开始填剩下的职称
        titleList:RemoveChildrenToPool()

        -- 一个人还可能有多个系统职称,真是有意思
        for i = 2, #systemTitle do
            local item = titleList:AddItemFromPool(titleList.defaultItem)
            -- 0:系统职称 1:自定义职称 2:增加
            item:GetController("Type_C").selectedIndex = 0
            -- 关闭交互
            item.touchable = false
            -- 系统职称名
            item.title = GuildClassTitleConfig.Config[systemTitle[i]].Name
        end

        -- 自定义职称
        for k, v in pairs(customTitle) do
            local item = titleList:AddItemFromPool(titleList.defaultItem)
            -- 0:系统职称 1:自定义职称 2:增加
            item:GetController("Type_C").selectedIndex = 1
            -- 关闭交互
            item.touchable = false
            item.title = v
        end
    else
        if Utils.GetTableLength(customTitle) > 0 then
            titleType_C.selectedIndex = 1
            titleLabel.title = customTitle[1]
            -- 开始填剩下的职称
            titleList:RemoveChildrenToPool()

            -- 从第二个开始
            for i = 2, Utils.GetTableLength(customTitle) do
                local item = titleList:AddItemFromPool(titleList.defaultItem)
                -- 0:系统职称 1:自定义职称 2:增加
                item:GetController("Type_C").selectedIndex = 1
                -- 关闭交互
                item.touchable = false
                item.title = customTitle[i]
            end
        else
            titleType_C.selectedIndex = 2
            titleLabel.visible = false
        end
    end

    -- 总贡献
    obj:GetChild("Text_TotalContribution").text = data.ContributionTotalAmount
    -- 本周贡献
    obj:GetChild("Text_ThisWeekContribution").text = data.ContributionAmount7
    -- 登陆时间
    local onlineState = obj:GetChild("Text_State")

    if data.Hero.LastOfflineTime <= 0 then
        onlineState.text = Localization.AllianceMemberOnline
    else
        onlineState.text = string.format(Localization.AllianceMemberOffline, Utils.secondFuzzyConversion(TimerManager.currentTime - data.Hero.LastOfflineTime))
    end

    -- 千重楼
    obj:GetChild("Text_Floor").text = data.Hero.TowerMaxFloor
    -- 百战千军军衔
    obj:GetChild("Text_ClassLevel").text = "敬请期待"
    -- 工资
    obj:GetChild("Text_Salary").text = "敬请期待"
end

-- 更新玩家列表
local function UpdateMemberList()
    if not _C.IsOpen then
        return
    end

    if allianceData.MyAlliance == nil then
        return
    end

    -- 清空选择
    view.MemberList:SelectNone()

    -- 判断自己是不是盟主/副盟主 0:盟主初始化 2:副盟主初始化 4:其他人初始化
    if allianceData.MyAlliance.Leader == allianceData.MyData then
        view.Post_C.selectedIndex = 0
    elseif allianceData.MyAlliance.Leader.ClassLevel - 1 == allianceData.MyData.ClassLevel then
        view.Post_C.selectedIndex = 2
    else
        view.Post_C.selectedIndex = 4
    end

    view.MemberList.itemRenderer = MemberListRenderer
    view.MemberList.numItems = allianceData.MyAlliance.MemberCount
end

-- 成员item点击回调
local function MemberItemOnClick()
    -- 当前选择Item的索引
    local selectedIndex = view.MemberList.selectedIndex
    -- 当前选择成员的数据
    local selectedData = allianceData.MemberList[selectedIndex + 1]

    if selectedData == nil then
        return
    end

    -- 判断自己是不是盟主/副盟主 0:盟主初始化 1:盟主可操作 2:副盟主初始化 3:副盟主可操作 4:其他人初始化
    if allianceData.MyAlliance.Leader == allianceData.MyData then
        if selectedIndex == 0 then
            view.Post_C.selectedIndex = 0
        else
            view.Post_C.selectedIndex = 1
        end
    elseif allianceData.MyAlliance.Leader.ClassLevel - 1 == allianceData.MyData.ClassLevel then
        if selectedData.ClassLevel >= allianceData.MyAlliance.MyData.ClassLevel then
            view.Post_C.selectedIndex = 2
        else
            view.Post_C.selectedIndex = 3
        end
    else
        view.Post_C.selectedIndex = 4
    end

    view.MemberList:RefreshVirtualList()
end

-- 点击入盟申请按钮
local function ApplicationBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceApplicationWindow)
end

-- 点击修改职位按钮
local function ChangePostBtnOnClick()
    local index = view.MemberList.selectedIndex

    if index == -1 then
        UIManager.showTip( { content = Localization.PleaseSelectAMember, result = false })
    else
        local data = { }
        -- 操作者的数据
        table.insert(data, allianceData.MyData)
        -- 成员数据
        table.insert(data, allianceData.MemberList[index + 1])
        UIManager.openController(UIManager.ControllerName.AllianceChangePostWindow, data)
    end
end

-- 点击修改职称按钮
local function ChangeTitleBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceChangeTitleWindow)
end

-- 点击踢出联盟按钮
local function KickoutBtnOnClick()
    local memberData = allianceData.MemberList[view.MemberList.selectedIndex + 1]

    UIManager.openController(UIManager.ControllerName.Popup, {
        UIManager.PopupStyle.ContentYesNo,
        content = string.format(Localization.KickoutConfirm,memberData.Hero.Name),
        btnFunc =
        {
            nil,
            function()
                NetworkManager.C2SKickOtherProto(memberData.Hero.Id)
            end
        }
    } )
end

-- 点击修改工资按钮
local function ChangeSalaryBtnOnClick()
    local index = view.MemberList.selectedIndex

    if index == -1 then
        UIManager.showTip( { content = Localization.PleaseSelectAMember, result = false })
    else
        UIManager.showTip( { content = "敬请期待", result = false })
        -- UIManager.openController(UIManager.ControllerName.AllianceChangeSalaryWindow, allianceData.MemberList[index + 1])
    end
end

-- 点击禅让盟主按钮
local function DemiseBtnOnClick()
    local memberData = allianceData.MemberList[view.MemberList.selectedIndex + 1]

    UIManager.openController(UIManager.ControllerName.Popup, {
        UIManager.PopupStyle.ContentYesNo,
        content = string.format(Localization.DemiseConfirm,memberData.Hero.Name),
        btnFunc =
        {
            nil,
            function()
                NetworkManager.C2SUpdateMemberClassLevelProto(memberData.Hero.Id, allianceData.MyAlliance.Leader.ClassLevel)
            end
        }
    } )
end

-- 点击退出联盟按钮
local function QuitBtnOnClick()
    UIManager.openController(UIManager.ControllerName.Popup, {
        UIManager.PopupStyle.ContentYesNo,
        content = Localization.PullOutOfTheAllianceConfirm,
        btnFunc = { nil, function() NetworkManager.C2SLeaveGuildProto() end }
    } )
end

-- 点击解散联盟按钮
local function DissolveBtnOnClick()
    UIManager.openController(UIManager.ControllerName.Popup, {
        UIManager.PopupStyle.ContentYesNo,
        content = Localization.DissolveAllianceConfirm,
        btnFunc =
        {
            nil,
            function()
                -- 判断联盟人数(还要判断名城的数量)
                if allianceData.MyAlliance.MemberCount > 1 then
                    UIManager.showTip( { content = Localization.PleaseDemiseFirst, result = false })
                elseif cityNum > 0 then
                    UIManager.showTip( { content = Localization.PleaseRecruitFirst, result = false })
                else
                    -- 退出联盟
                    NetworkManager.C2SLeaveGuildProto()
                end
            end
        }
    } )
end

-- 更新大事记
local function UpdateNoteList()
    -- 清空
    view.NoteList:RemoveChildrenToPool()
    -- 数据
    data = allianceData.MyAlliance.BigEvents

    if #data == 0 then
        return
    end

    -- 实例化UI
    for i = 1, #data do
        local item = view.NoteList:AddItemFromPool(view.NoteList.defaultItem)
        -- 时间
        item:GetChild("Text_Time").text = Utils.getIntradayTimeStamp(data[i].time)
        -- 内容
        local content = ""

        -- 大事件类型
        if data[i].Satue ~= nil then
            -- 雕像(盟主名,地区名)
            content = string.format(Localization.AllianceBigEventsStatue, data[i].Satue.LeaderName, data[i].Satue.RegionName)
        elseif data[i].LevelUp ~= nil then
            -- 升级(新的等级)
            content = string.format(Localization.AllianceBigEventsLevelUp, data[i].LevelUp.Level)
        elseif data[i].Impeach ~= nil then
            -- 弹劾(旧盟主,新盟主)
            content = string.format(Localization.AllianceBigEventsImpeach, data[i].Impeach.OldLeaderNameh, data[i].Impeach.NewLeaderName)
        else
            -- 禅让(旧盟主,新盟主)
            content = string.format(Localization.AllianceBigEventsDemise, data[i].Demise.OldLeaderNameh, data[i].Demise.NewLeaderName)
        end

        item:GetChild("Text_Content").text = content
    end
end

function _C.RefreshUI()
    UpdateMemberList()
    UpdateNoteList()
end

-- 查看其它玩家信息
local function ViewOtherPlayerSuccess(data)
    if data == nil or not _C.IsOpen then
        return
    end

    UIManager.openController(UIManager.ControllerName.Lords, data)
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData
    monarchsData = DataTrunk.PlayerInfo.MonarchsData
end

function _C:onCreat()
    view = _C.view.ManagePage
    view.MemberList.onClickItem:Set(MemberItemOnClick)
    view.ApplicationBtn.onClick:Set(ApplicationBtnOnClick)
    view.ChangePostBtn.onClick:Set(ChangePostBtnOnClick)
    view.ChangeTitleBtn.onClick:Set(ChangeTitleBtnOnClick)
    view.KickoutBtn.onClick:Set(KickoutBtnOnClick)
    view.ChangeSalaryBtn.onClick:Set(ChangeSalaryBtnOnClick)
    view.ChangePostBtn.onClick:Set(ChangePostBtnOnClick)
    view.DemiseBtn.onClick:Set(DemiseBtnOnClick)
    view.DissolveBtn.onClick:Set(DissolveBtnOnClick)
    view.QuitBtn.onClick:Set(QuitBtnOnClick)

    Event.addListener(Event.ON_VIEW_OTHER_HERO, ViewOtherPlayerSuccess)
    Event.addListener(Event.ON_CHANGE_MEMBER_POST_SUCCESS, UpdateMemberList)
    Event.addListener(Event.ALLIANCE_ON_UPDATE_MEMBER_TITLE_SUCCESS, UpdateMemberList)
end

function _C:onDestroy()
    view.MemberList.itemRenderer = nil

    Event.removeListener(Event.ON_VIEW_OTHER_HERO, ViewOtherPlayerSuccess)
    Event.removeListener(Event.ON_CHANGE_MEMBER_POST_SUCCESS, UpdateMemberList)
    Event.removeListener(Event.ALLIANCE_ON_UPDATE_MEMBER_TITLE_SUCCESS, UpdateMemberList)
end

return _C