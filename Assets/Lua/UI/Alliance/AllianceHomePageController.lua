local _C = UIManager.SubController(UIManager.ControllerName.AllianceHomePage, nil)
_C.view = nil

local view = nil
-- 联盟数据
local allianceData = nil
-- 升级计时器
local upgradeTimer = nil
-- 计时结束
local UpgradeTimerComplete = nil

local function UpgradeTimerUpdate(t, p)
    view.UpgradeTime.text = Utils.secondConversion(math.ceil(p))
end

-- 动态列表点击item事件
local function DynamicListOnClickItem(context)
    -- 玩家id
    local id = context.data.data
    UIManager.showTip( { content = "假装跳转到id为" .. id .. "的主城", result = true })
end

-- 动态显示区列表
local function DynamicListItemRenderer(index, obj)
    -- 数据(GuildDynamicClass())
    local data = allianceData.MyAlliance.Dynamics[index + 1]

    if data == nil then
        return
    end

    -- 时间
    obj:GetChild("Text_Time").text = Utils.getIntradayTimeStamp(data.Time)
    -- 0:左(主动) 1:右(被动)
    local type_C = obj:GetController("Type_C")
    -- 内容
    local content = ""

    if data.Attack.AttackerId ~= "" then
        -- 攻击，里面的进攻方是本盟的
        type_C.selectedIndex = 0
        content = string.format(Localization.AllianceBigDynamicsAttack, data.Attack.AttackerName, data.Attack.BeenAttackerName)
        -- 头像
        obj.icon = data.AttackerHead
        obj.data = data.Attack.AttackerId
    elseif data.BeenAttack.AttackerId ~= "" then
        -- 被攻击，里面的被进攻方是本盟的
        type_C.selectedIndex = 1
        content = string.format(Localization.AllianceBigDynamicsBeenAttack, data.BeenAttack.BeenAttackerName, data.BeenAttack.AttackerName)
        -- 头像
        obj.icon = data.BeenAttackerHead
        obj.data = data.BeenAttack.BeenAttackerId
    elseif data.Join.AttackerId ~= "" then
        -- 加入了
        type_C.selectedIndex = 0
        content = string.format(Localization.AllianceBigDynamicsJoin, data.Join.Name)
        obj.data = data.Join.Id

        -- 头像
        if data.Head ~= nil then
            obj.icon = data.Head.SmallIcon
        end
    end

    obj.title = content
end

-- 更新动态显示区
local function UpdateDynamicList()
    view.WarSituationList.itemRenderer = DynamicListItemRenderer
    view.WarSituationList.numItems = #allianceData.MyAlliance.Dynamics
end

-- 升级按钮点击事件
local function UpgradeBtnOnClick()
    NetworkManager.C2SUpgradeLevelProto()
end

-- 加速按钮点击事件
local function SpeedupBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceUpgradeSpeedup)
end

-- 禅让中按钮点击事件
local function DemiseBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceDemiseDetailsWindow)
end

-- 弹劾按钮点击事件
local function ImpeachBtnOnClick()
    NetworkManager.C2SImpeachLeaderProto()
end

-- 投票/查看按钮点击事件
local function VoteBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceVoteWindow)
end

-- 更新主页数据
local function UpdateData()
    if not _C.IsOpen then
        return
    end

    -- GuildClass()
    local data = allianceData.MyAlliance

    if data == nil then
        return
    end

    -- 联盟等级配置
    local levelConfig = GuildLevelConfig:getConfigByLevel(data.Level)

    if levelConfig == nil then
        return
    end

    -- 更新联盟信息
    -- 国家&旗号
    -- 国家,服务器暂无数据
    view.Country_C.selectedIndex = 1
    -- 旗号
    view.Flag.title = data.FlagName
    -- 联盟名字
    view.AllianceName.text = data.Name
    -- 盟主名字
    view.LeaderName.text = data.Leader.Hero.Name

    -- 0:弹劾 1:投票 2:查看 3:禅让 4:无
    -- 盟主达到48小时不在线后，任一其他玩家都可以发起弹劾 GuildConfig.Config.ImpeachLeaderOfflineDuration
    if TimerManager.currentTime - data.Leader.LastOfflineTime > GuildConfig.Config.ImpeachLeaderOfflineDuration then
        -- 当前有没有弹劾,0代表没有弹劾
        if data.ImpeachLeader.ImpeachEndTime == 0 then
            -- 显示弹劾按钮
            view.Leader_C.selectedIndex = 0
            -- 弹劾按钮
            view.ImpeachBtn.onClick:Set(ImpeachBtnOnClick)
        else
            -- 看自己有没有投票(string:成员id)
            for k, v in data.ImpeachLeader.VoteHeros do
                if v == allianceData.MyData.Hero.Id then
                    -- 查看
                    view.Leader_C.selectedIndex = 2
                    break
                else
                    -- 投票
                    view.Leader_C.selectedIndex = 1
                end
            end

            view.VoteBtn.onClick:Set(VoteBtnOnClick)
        end
    elseif data.ChangeLeaderTime > 0 then
        -- 禅让
        view.Leader_C.selectedIndex = 3
        -- 点击禅让中按钮
        view.DemiseBtn.onClick:Set(DemiseBtnOnClick)
    else
        -- 无
        view.Leader_C.selectedIndex = 4
    end

    ---- 测试
    -- view.Leader_C.selectedIndex = 1
    -- view.VoteBtn.onClick:Set(VoteBtnOnClick)

    -- 联盟等级
    view.AllianceLevel.text = data.Level
    -- 成员数量
    view.MemberCount.text = string.format("%s/%s", data.MemberCount, levelConfig.MemberCount)
    -- 排名(v0.3)
    view.Ranking.text = "敬请期待"
    -- 建设值
    view.ConstructionValue.text = data.BuildingAmount
    -- 银两(v0.3)
    view.Silver.text = "敬请期待"
    -- 0 已放置 1 未放置 2 没雕像
    -- 雕像,服务器暂无数据
    if allianceData.MyAlliance.Leader == allianceData.MyData then
        view.Statue_C.selectedIndex = 1
        if allianceData.StatueLocation == 0 then
            view.Statue.text = Localization.AllianceStatueNotSet
            view.PlaceBtn.text = Localization.AllianceStatueSet
        else
            view.Statue.text = DataTrunk.PlayerInfo.RegionData:getRegionNameById(allianceData.StatueLocation)
            view.PlaceBtn.text = Localization.AllianceStatueReturn
        end
    else
        if allianceData.StatueLocation == 0 then
            view.Statue_C.selectedIndex = 2
            view.Statue.text = Localization.AllianceStatueNotSet
        else
            view.Statue_C.selectedIndex = 0
            view.Statue.text = DataTrunk.PlayerInfo.RegionData:getRegionNameById(allianceData.StatueLocation)
        end
    end

    -- 联盟标签
    if Utils.GetTableLength(data.Labels) == 0 then
        view.Tag_C.selectedIndex = 1
    else
        view.Tag_C.selectedIndex = 0
        view.TagList:RemoveChildrenToPool()

        for k, v in pairs(data.Labels) do
            local item = view.TagList:AddItemFromPool(view.TagList.defaultItem)
            -- 不可编辑
            item:GetChild("title").editable = false
            item.title = v
        end
    end

    -- 诏书,服务器暂无数据
    view.Edict_C.selectedIndex = 1
    -- 更新动态显示区
    UpdateDynamicList()

    -- 编辑按钮以下有一个为true,即显示
    -- 是否可修改声望目标,服务器暂无
    -- 是否可修改友盟敌盟,服务器暂无
    -- 是否可修改联盟宣言
    -- 是否可修改联盟公告
    -- 是否可修改联盟标签
    -- 是否可修改入盟权限

    -- 我的职位权限配置
    local classLevelConfig = GuildClassLevelConfig.Config[allianceData.MyData.ClassLevel].Permission
    -- 我的职称权限配置
    local classTitleConfig = nil

    -- 联盟数据的系统职称id里寻找是不是有我的id
    for k, v in pairs(data.ClassTitle.SystemClassTitleMemberId) do
        -- 如果找到了
        if v == DataTrunk.PlayerInfo.MonarchsData.Id then
            -- 在根据k值,去拿他的系统职称id
            local classTitleId = data.ClassTitle.SystemClassTitleId[k]
            -- 根据id取配置
            classTitleConfig = GuildClassTitleConfig.Config[classTitleId].Permission
            break
        end
    end

    -- 编辑按钮是否显示
    if classLevelConfig.UpdateText or classLevelConfig.UpdateInternalText or classLevelConfig.UpdateLabel or classLevelConfig.UpdateJoinCondition then
        view.EditBtn.visible = true
    else
        if classTitleConfig == nil then
            view.EditBtn.visible = false
        elseif classTitleConfig.UpdateText or classTitleConfig.UpdateInternalText or classTitleConfig.UpdateLabel or classTitleConfig.UpdateJoinCondition then
            view.EditBtn.visible = true
        else
            view.EditBtn.visible = false
        end
    end

    -- 进度条直接放在外部处理,反正有控制器控制,也不需要写2遍
    view.LevelProgressBar.value = data.BuildingAmount
    view.LevelProgressBar.max = GuildLevelConfig.Config[data.Level].UpgradeBuilding

    -- cd
    local cd = data.UpgradeEndTime - TimerManager.currentTime

    -- 联盟等级状态
    -- 0 进度条 1 升级按钮 2 可加速 3 不可加速
    -- 升级结束时间（0表示当前没有在升级），unix时间戳，秒
    if cd <= 0 then
        -- 经验值未满,显示进度条
        if data.BuildingAmount < GuildLevelConfig.Config[data.Level].UpgradeBuilding then
            view.Level_C.selectedIndex = 0
        else
            -- 判断玩家是否有升级的权限
            if classLevelConfig.UpgradeLevel or(classTitleConfig ~= nil and classTitleConfig.UpgradeLevel) then
                view.Level_C.selectedIndex = 1
                -- 升级按钮点击事件
                view.UpgradeBtn.onClick:Set(UpgradeBtnOnClick)
            else
                view.Level_C.selectedIndex = 0
            end
        end

        -- 如果有,暂停计时器
        if upgradeTimer ~= nil then
            upgradeTimer:pause()
        end
    else
        -- 开始倒计时
        if upgradeTimer == nil then
            upgradeTimer = TimerManager.newTimer(cd, false, true, nil, UpgradeTimerUpdate, UpgradeTimerComplete)
        end

        upgradeTimer:addCd(cd - upgradeTimer.MaxCd)
        upgradeTimer:reset()
        upgradeTimer:start()

        -- 判断玩家是否有加速的权限
        if classLevelConfig.UpgradeLevelCdr or(classTitleConfig ~= nil and classTitleConfig.UpgradeLevelCdr) then
            view.Level_C.selectedIndex = 2
            -- 加速按钮点击事件
            view.SpeedupBtn.onClick:Set(SpeedupBtnOnClick)
        else
            view.Level_C.selectedIndex = 3
        end
    end

    -- 联盟目标 0: 有 1:没有
    if data.GuildTargetId == 0 then
        view.Target_C.selectedIndex = 1
    else
        view.Target_C.selectedIndex = 0
        view.TargetDesc.text = GuildTargetConfig.Config[data.GuildTargetId].Desc
    end

    -- 公告列表
    view.DetailsList:RemoveChildrenToPool()

    -- 声望目标
    if data.PrestigeTarget ~= 0 then
        local item = view.DetailsList:AddItemFromPool(view.DetailsList.defaultItem)
        item.title = Localization.PrestigeTarget
        item:GetChild("Text_Content").text = DefaultCountryConfig.Config[data.PrestigeTarget].Name
    end

    -- 友盟
    if data.FriendGuildText ~= "" then
        local item = view.DetailsList:AddItemFromPool(view.DetailsList.defaultItem)
        item.title = Localization.AllyAlliance
        item:GetChild("Text_Content").text = data.FriendGuildText
    end

    -- 敌盟
    if data.EnemyGuildText ~= "" then
        local item = view.DetailsList:AddItemFromPool(view.DetailsList.defaultItem)
        item.title = Localization.EnemyAlliance
        item:GetChild("Text_Content").text = data.EnemyGuildText
    end

    -- 宣言
    if data.Text ~= "" then
        local item = view.DetailsList:AddItemFromPool(view.DetailsList.defaultItem)
        item.title = Localization.Manifesto
        item:GetChild("Text_Content").text = data.Text
    end

    -- 公告
    if data.InternalText ~= "" then
        local item = view.DetailsList:AddItemFromPool(view.DetailsList.defaultItem)
        item.title = Localization.Notice
        item:GetChild("Text_Content").text = data.InternalText
    end
end

-- 计时器结束回调
UpgradeTimerComplete = function()
    UpdateData()
end

-- 点击联盟名字(盟主改名字)
local function AllianceNameOnClick()
    -- 判断是不是盟主
    if allianceData.MyAlliance.Leader == allianceData.MyData then
        UIManager.openController(UIManager.ControllerName.AllianceChangeNameWindow)
    end
end

-- 点击旗号(盟主改旗号)
local function AllianceFlagOnClick()
    -- 判断是不是盟主
    if allianceData.MyAlliance.Leader == allianceData.MyData then
        UIManager.openController(UIManager.ControllerName.AllianceChangeFlagWindow)
    end
end

-- 点击放置按钮
local function PlaceBtnOnClick()
    if allianceData.StatueLocation == 0 then
        UIManager.openController(UIManager.ControllerName.StatueArea)
    else
        NetworkManager.C2STakeBackGuildStatue()
    end
end

-- 点击军情按钮
local function WarSituationBtnOnClick()
    UIManager.openController(UIManager.ControllerName.WarSituation)
end

-- 点击编辑按钮
local function EditBtnOnClick()
    UIManager.openController(UIManager.ControllerName.AllianceModify)
end

function _C.RefreshUI()
    UpdateData()
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData
end

function _C:onCreat()
    view = _C.view.HomePage

    view.AllianceNameBtn.onClick:Set(AllianceNameOnClick)
    view.Flag.onClick:Set(AllianceFlagOnClick)
    view.SpeedupBtn.onClick:Set(SpeedupBtnOnClick)
    view.PlaceBtn.onClick:Set(PlaceBtnOnClick)
    view.WarSituationBtn.onClick:Set(WarSituationBtnOnClick)
    view.EditBtn.onClick:Set(EditBtnOnClick)
    view.WarSituationList.onClickItem:Add(DynamicListOnClickItem)

    Event.addListener(Event.ON_UPDATE_GUILD_TARGET, UpdateData)
    Event.addListener(Event.ALLIANCE_ON_UPDATE_ALLY, UpdateData)
    Event.addListener(Event.ALLIANCE_ON_UPDATE_ENEMY, UpdateData)
    Event.addListener(Event.ON_UPDATE_GUILD_TEXT, UpdateData)
    Event.addListener(Event.ON_UPDATE_GUILD_NOTICE, UpdateData)
    Event.addListener(Event.ON_UPDATE_GUILD_Label, UpdateData)
    Event.addListener(Event.ON_OTHER_LEAVE_GUILD, UpdateData)
    Event.addListener(Event.ON_KICK_OTHER, UpdateData)
    Event.addListener(Event.ON_NEW_MEMBER_JOIN, UpdateData)
    Event.addListener(Event.OTHER_CHANGE_NAME_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_UPGRADE_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_UPGRADE_SPEEDUP_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_DONATE_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_IMPEACH_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_VOTE_SUCCESS, UpdateData)
    Event.addListener(Event.ALLIANCE_STATUE_UPDATE, UpdateData)
end

function _C:onDestroy()
    TimerManager.disposeTimer(upgradeTimer)
    upgradeTimer = nil
    view.WarSituationList.itemRenderer = nil

    Event.removeListener(Event.ON_UPDATE_GUILD_TARGET, UpdateData)
    Event.removeListener(Event.ALLIANCE_ON_UPDATE_ALLY, UpdateData)
    Event.removeListener(Event.ALLIANCE_ON_UPDATE_ENEMY, UpdateData)
    Event.removeListener(Event.ON_UPDATE_GUILD_TEXT, UpdateData)
    Event.removeListener(Event.ON_UPDATE_GUILD_NOTICE, UpdateData)
    Event.removeListener(Event.ON_UPDATE_GUILD_Label, UpdateData)
    Event.removeListener(Event.ON_OTHER_LEAVE_GUILD, UpdateData)
    Event.removeListener(Event.ON_KICK_OTHER, UpdateData)
    Event.removeListener(Event.ON_NEW_MEMBER_JOIN, UpdateData)
    Event.removeListener(Event.OTHER_CHANGE_NAME_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_UPGRADE_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_UPGRADE_SPEEDUP_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_ON_UPDATE_NAME_OR_FLAG_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_DONATE_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_IMPEACH_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_VOTE_SUCCESS, UpdateData)
    Event.removeListener(Event.ALLIANCE_STATUE_UPDATE, UpdateData)
end

return _C