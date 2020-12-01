local _C = UIManager.Controller(UIManager.ControllerName.AllianceModify, UIManager.ViewName.AllianceModify)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil
-- 我的数据
local myData = nil
-- 当前的声望目标
local currTarget = -1
-- 当前的友盟
local currAlly = ""
-- 当前的敌盟
local currEnemy = ""
-- 当前的宣言
local currManifesto = ""
-- 当前的公告
local currNotice = ""
-- 当前的标签(用于判断是否更新了标签,如果没有更新则不发消息)
local currLabel = { }
-- 当前的君主等级
local currMonarchLevel = -1
-- 当前的个人排名
local currRanking = -1
-- 当前的千重楼层数
local currFloor = -1
-- 当前的百战千军军衔
local currClassLevel = -1
-- 当前是否允许直接加入审批
local currAutoJoin = false
-- 标签最大字符数
local labelMaxByte = GuildConfig.Config.GuildLabelLimitChar
-- 标签的最大个数
local labelMaxCount = GuildConfig.Config.GuildLabelLimitCount
-- 百战千军军衔(模拟配置,从低到高)
local militaryRankList = { "小卒", "步兵", "骑士", "禁卫", "先锋", "将军", "元帅", "诸侯" }
-- 标签增加按钮
local addBtn = nil

-- 关闭界面
local function CancelBtnOnClick()
    if currAutoJoin ~= view.AutoJoinBtn.selected or currMonarchLevel ~= tonumber(view.MonarchLevelInput.text) or currFloor ~= tonumber(view.FloorInput.text) then
        UIManager.openController(UIManager.ControllerName.Popup, {
            UIManager.PopupStyle.ContentYesNo,
            content = Localization.CancelBtnRemind,
            btnFunc =
            {
                function()
                    _C:destroy()
                end,
                function()
                    NetworkManager.C2SUpdateJoinConditionProto(not view.AutoJoinBtn.selected, tonumber(view.MonarchLevelInput.text), 0, tonumber(view.FloorInput.text))
                end
            }
        } )
    else
        _C:destroy()
    end
end

-- 保存当前友盟
local function SaveCurrAlly()
    currAlly = view.AllyInput.text
end

-- 修改友盟
local function ChangeAlly()
    local content = view.AllyInput.text

    if content == currAlly then
        return
    end

    if not Utils.isSensitiveWordWithTips(content) then
        NetworkManager.C2SUpdateFriendGuildProto(content)
    end
end

-- 保存当前敌盟
local function SaveCurrEnemy()
    currEnemy = view.EnemyInput.text
end

-- 修改敌盟
local function ChangeEnemy()
    local content = view.EnemyInput.text

    if content == currEnemy then
        return
    end

    if not Utils.isSensitiveWordWithTips(content) then
        NetworkManager.C2SUpdateEnemyGuildProto(content)
    end
end

-- 保存当前宣言
local function SaveCurrManifesto()
    currManifesto = allianceData.Text
end

-- 修改宣言
local function ChangeManifesto()
    local content = view.ManifestoInput.text

    if content == currManifesto then
        return
    end

    if not Utils.isSensitiveWordWithTips(content) then
        NetworkManager.C2SUpdateTextProto(content)
    end
end

-- 保存当前公告
local function SaveCurrNotice()
    currNotice = allianceData.InternalText
end

-- 修改公告
local function ChangeNotice()
    local content = view.NoticeInput.text

    if content == currNotice then
        return
    end

    if not Utils.isSensitiveWordWithTips(content) then
        NetworkManager.C2SUpdateInternalTextProto(content)
    end
end

-- 更新+按钮是否可以显示
local function UpdateAddBtnState()
    addBtn.visible = view.LabelList.numChildren < labelMaxCount + 1
end

-- 更新标签列表
local function UpdateLabelList()
    for i = 0, view.LabelList.numChildren - 2 do
        local item = view.LabelList:GetChildAt(i)
        -- 设置失焦回调
        item:GetChild("title").onFocusOut:Set(
        function()
            local text = item.title

            if text == "" then
                view.LabelList:RemoveChildToPool(item)
                UpdateAddBtnState()
            else
                if not Utils.isLegalName(text, 1, labelMaxByte) then
                    -- 强制清空
                    item.title = ""
                end
            end
        end )
    end
end

-- 点击修改按钮
local function ChangeBtnOnClick()
    -- 将已有的标签转换为可删除状态
    for i = 0, view.LabelList.numChildren - 2 do
        local item = view.LabelList:GetChildAt(i)
        -- 0:正常 1:增加 2:更改&删除
        item:GetController("Type_C").selectedIndex = 2
        -- 删除按钮
        item:GetChild("Button_Delete").onClick:Set( function()
            view.LabelList:RemoveChildToPool(item)
        end )
        item:GetChild("title").editable = true
        -- 更新List(主要是设置关闭按钮和失焦回调)
        UpdateLabelList()
    end

    -- 判断是否达到标签数量上限
    UpdateAddBtnState()
end

-- 修改联盟标签成功
local function ChangeLabelSuccess()
    if not _C.IsOpen then
        return
    end

    view.Label_C.selectedIndex = 0

    -- 更改每个标签状态为不可编辑
    for i = 0, view.LabelList.numChildren - 2 do
        local item = view.LabelList:GetChildAt(i)
        -- 0:正常 1:增加 2:更改&删除
        item:GetController("Type_C").selectedIndex = 0
        item:GetChild("title").editable = false
    end

    -- 隐藏addbtn
    addBtn.visible = false

    -- 记录当前的标签
    currLabel = { }

    for i = 0, view.LabelList.numChildren - 2 do
        table.insert(currLabel, view.LabelList:GetChildAt(i).title)
    end
end

-- 点击保存按钮
local function SaveBtnOnClick()
    for i = 0, view.LabelList.numChildren - 2 do
        local item = view.LabelList:GetChildAt(i)
        -- 0:正常 1:增加 2:更改&删除
        item:GetController("Type_C").selectedIndex = 0

        if item.title == "" then
            view.LabelList:RemoveChildToPool(item)
        end
    end

    local label = { }

    for i = 0, view.LabelList.numChildren - 2 do
        table.insert(label, view.LabelList:GetChildAt(i).title)
    end

    -- 如果有不一样的就发消息
    for k, v in pairs(label) do
        if v ~= currLabel[k] then
            NetworkManager.C2SUpdateGuildLabelProto(label)
            return
        end
    end

    -- 这里是没有任何修改,模拟更改成功,其实就是切换状态
    ChangeLabelSuccess()
end

-- 确认按钮
local function ConfirmBtnOnClick()
    -- 相当于保存一下标签
    SaveBtnOnClick()

    if currAutoJoin ~= view.AutoJoinBtn.selected or currMonarchLevel ~= tonumber(view.MonarchLevelInput.text) or currFloor ~= tonumber(view.FloorInput.text) then
        -- 1.是否允许加入 2.君主等级 3.百战千军等级(敬请期待) 4.千重楼
        -- bool number number number
        NetworkManager.C2SUpdateJoinConditionProto(not view.AutoJoinBtn.selected, tonumber(view.MonarchLevelInput.text), 0, tonumber(view.FloorInput.text))
    else
        CancelBtnOnClick()
    end
end

-- 点击增加标签按钮
local function AddBtnOnClick()
    -- 插在倒数第二个
    local item = view.LabelList:AddChildAt(view.LabelList:AddItemFromPool(view.LabelList.defaultItem), view.LabelList.numChildren - 2)
    -- 可输入状态
    item:GetController("Type_C").selectedIndex = 0
    -- 清空内容
    item.title = ""
    -- 获取焦点
    item:GetChild("title"):RequestFocus()
    -- 每点一次就更新一次List
    UpdateLabelList()
    -- 更新自己的状态
    UpdateAddBtnState()
end

-- 点击声望目标下拉框
local function TargetComboBoxOnClick()
    view.TargetComboBox.dropdown.sortingOrder = view.UI.sortingOrder + 1
end

-- 声望目标下拉框点击事件
local function TargetComboBoxOnChanged()
    if currTarget == tonumber(view.TargetComboBox.values[view.TargetComboBox.selectedIndex]) then
        return
    end

    -- 保存
    currTarget = tonumber(view.TargetComboBox.values[view.TargetComboBox.selectedIndex])
    NetworkManager.C2SUpdateGuildPrestigeProto(currTarget)
end

-- 点击百战千军军衔下拉框
local function MilitaryRankComboBoxOnClick()
    view.MilitaryRankComboBox.dropdown.sortingOrder = view.UI.sortingOrder + 1
end

-- 更新入盟条件
local function UpdateJoinCondition()
    -- 君主等级
    view.MonarchLevelInput.text = allianceData.RequiredHeroLevel
    currMonarchLevel = allianceData.RequiredHeroLevel
    -- 个人排名
    view.RankingInput.text = "敬请期待"
    view.RankingInput.editable = false
    -- 千重楼层数
    view.FloorInput.text = allianceData.RequiredTowerMaxFloor
    currFloor = allianceData.RequiredTowerMaxFloor
    -- 百战千军军衔(假的)
    view.MilitaryRankComboBox.title = militaryRankList[allianceData.RequiredJunXianLevel + 1]
    view.MilitaryRankComboBox.title = "敬请期待"
    view.MilitaryRankComboBox.touchable = false
    -- 是否允许直接入盟
    view.AutoJoinBtn.selected = not allianceData.RejectAutoJoin
    currAutoJoin = view.AutoJoinBtn.selected
end

function _C:onCreat()
    view = _C.View

    -- 声望目标Id
    local targetIdTable = { }
    -- 声望目标名称
    local targetTitleTable = { }

    for k, v in ipairs(DefaultCountryConfig.Config) do
        table.insert(targetIdTable, v.Id)
        table.insert(targetTitleTable, v.Name)
    end

    -- 初始化声望目标下拉框
    view.TargetComboBox.visibleItemCount = #DefaultCountryConfig.Config
    view.TargetComboBox.values = targetIdTable
    view.TargetComboBox.items = targetTitleTable
    -- 初始化百战千军军衔
    view.MilitaryRankComboBox.visibleItemCount = Utils.GetTableLength(militaryRankList)
    view.MilitaryRankComboBox.items = militaryRankList

    view.TargetComboBox.onClick:Set(TargetComboBoxOnClick)
    view.TargetComboBox.onChanged:Set(TargetComboBoxOnChanged)
    view.MilitaryRankComboBox.onClick:Set(MilitaryRankComboBoxOnClick)
    view.BG.onClick:Set(CancelBtnOnClick)
    view.AllyInput.onFocusIn:Set(SaveCurrAlly)
    view.AllyInput.onFocusOut:Set(ChangeAlly)
    view.EnemyInput.onFocusIn:Set(SaveCurrEnemy)
    view.EnemyInput.onFocusOut:Set(ChangeEnemy)
    view.ManifestoInput.onFocusIn:Set(SaveCurrManifesto)
    view.ManifestoInput.onFocusOut:Set(ChangeManifesto)
    view.NoticeInput.onFocusIn:Set(SaveCurrNotice)
    view.NoticeInput.onFocusOut:Set(ChangeNotice)
    view.ChangeBtn.onClick:Set(ChangeBtnOnClick)
    view.SaveBtn.onClick:Set(SaveBtnOnClick)
    view.ConfirmBtn.onClick:Set(ConfirmBtnOnClick)
    view.CancelBtn.onClick:Set(CancelBtnOnClick)

    -- Event.addListener(Event.ON_UPDATE_GUILD_TARGET, ModifyTargetSuccess)
    Event.addListener(Event.ON_UPDATE_GUILD_Label, ChangeLabelSuccess)
    Event.addListener(Event.ALLIANCE_MODIFY_JOIN_CONDITION_SUCCESS, function() _C:destroy() end)
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData.MyAlliance
    myData = DataTrunk.PlayerInfo.AllianceData.MyData
    -- 我的职位权限配置
    local classLevelConfig = GuildClassLevelConfig.Config[myData.ClassLevel].Permission
    -- 我的职称权限配置
    local classTitleConfig = nil

    -- 联盟数据的系统职称id里寻找是不是有我的id
    for k, v in pairs(allianceData.ClassTitle.SystemClassTitleMemberId) do
        -- 如果找到了
        if v == DataTrunk.PlayerInfo.MonarchsData.Id then
            -- 在根据k值,去拿他的系统职称id
            local classTitleId = allianceData.ClassTitle.SystemClassTitleId[k]
            -- 根据id取配置
            classTitleConfig = GuildClassTitleConfig.Config[classTitleId].Permission
            break
        end
    end

    -- 声望目标
    view.TargetComboBox.title = DefaultCountryConfig.Config[allianceData.PrestigeTarget].Name
    -- 保存
    currTarget = allianceData.PrestigeTarget

    -- 友盟是否可操作
    view.ManifestoLabel.touchable = classLevelConfig.UpgradeFriendGuild or(classTitleConfig ~= nil and classTitleConfig.UpgradeFriendGuild)
    view.ManifestoLabel.grayed = not classLevelConfig.UpgradeFriendGuild or(classTitleConfig ~= nil and classTitleConfig.UpgradeFriendGuild)
    -- 友盟
    view.AllyInput.text = allianceData.FriendGuildText

    -- 敌盟是否可操作
    view.ManifestoLabel.touchable = classLevelConfig.UpgradeEnemyGuild or(classTitleConfig ~= nil and classTitleConfig.UpgradeEnemyGuild)
    view.ManifestoLabel.grayed = not classLevelConfig.UpgradeEnemyGuild or(classTitleConfig ~= nil and classTitleConfig.UpgradeEnemyGuild)
    -- 敌盟
    view.EnemyInput.text = allianceData.EnemyGuildText

    -- 宣言是否可操作
    view.ManifestoLabel.touchable = classLevelConfig.UpdateText or(classTitleConfig ~= nil and classTitleConfig.UpdateText)
    view.ManifestoLabel.grayed = not classLevelConfig.UpdateText or(classTitleConfig ~= nil and classTitleConfig.UpdateText)
    -- 宣言
    view.ManifestoInput.text = allianceData.Text
    -- 记录当前的宣言
    currManifesto = allianceData.Text

    -- 公告是否可操作
    view.NoticeLabel.touchable = classLevelConfig.UpdateInternalText or(classTitleConfig ~= nil and classTitleConfig.UpdateInternalText)
    view.NoticeLabel.grayed = not classLevelConfig.UpdateInternalText or(classTitleConfig ~= nil and classTitleConfig.UpdateInternalText)
    -- 公告
    view.NoticeInput.text = allianceData.InternalText
    -- 记录当前的公告
    currNotice = allianceData.InternalText

    -- 标签是否可操作
    if classLevelConfig.UpdateLabel or(classTitleConfig ~= nil and classTitleConfig.UpdateLabel) then
        view.Label_C.selectedIndex = 0
    else
        view.Label_C.selectedIndex = 2
    end

    -- 标签数据
    view.LabelList:RemoveChildrenToPool()

    if allianceData.Labels ~= nil then
        for k, v in pairs(allianceData.Labels) do
            local item = view.LabelList:AddItemFromPool(view.LabelList.defaultItem)
            item.title = v
            item:GetChild("title").editable = false
        end
    end

    -- 再加一个+号按钮
    addBtn = view.LabelList:AddItemFromPool(view.LabelList.defaultItem)
    -- 0:正常 1:增加 2:删除
    addBtn:GetController("Type_C").selectedIndex = 1
    -- 清空内容
    addBtn.title = ""
    -- 隐藏
    addBtn.visible = false
    -- 按钮事件
    addBtn.onClick:Set(AddBtnOnClick)

    -- 记录当前的标签
    currLabel = { }

    for i = 0, view.LabelList.numChildren - 2 do
        table.insert(currLabel, view.LabelList:GetChildAt(i).title)
    end

    -- 入盟条件是否可操作
    view.ConditionPanel.touchable = classLevelConfig.UpdateJoinCondition or(classTitleConfig ~= nil and classTitleConfig.UpdateJoinCondition)
    view.ConditionPanel.grayed = not classLevelConfig.UpdateJoinCondition or(classTitleConfig ~= nil and classTitleConfig.UpdateJoinCondition)

    -- 入盟条件
    UpdateJoinCondition()
end

function _C:onDestroy()
    view.TargetComboBox:Dispose()
    view.MilitaryRankComboBox:Dispose()

    -- Event.removeListener(Event.ON_UPDATE_GUILD_TARGET, ModifyTargetSuccess)
    Event.removeListener(Event.ON_UPDATE_GUILD_Label, ChangeLabelSuccess)
    Event.removeListener(Event.ALLIANCE_MODIFY_JOIN_CONDITION_SUCCESS, function() _C:destroy() end)
end