local _C = UIManager.Controller(UIManager.ControllerName.AllianceChangeTitleWindow, UIManager.ViewName.AllianceChangeTitleWindow)
_C.IsPopupBox = true

local view = nil
-- 联盟数据
local allianceData = nil
-- 成员列表数据(动态)
local memberDisplayData = { }
-- 系统职称id(根据配置)(int[])
local systemClassTitleId = { }

for k, v in pairs(GuildClassTitleConfig.Config) do
    table.insert(systemClassTitleId, v.Id)
end

-- 系统职称拥有者(string[])
local systemClassTitleMemberId = { }
-- 自定义职称名字
local customClassTitleName = { }
-- 自定义职称拥有者Id
local customClassTitleMemberId = { }
-- 当前的系统职称拥有者(string[])
local currSystemClassTitleMemberId = { }
-- 当前的自定义职称名字
local currCustomClassTitleName = { }
-- 当前的自定义职称拥有者Id
local currCustomClassTitleMemberId = { }
-- 自定义职称最大字符数(配置,GuildConfigClass)
local customTitleMaxLength = nil

-- 点击取消按钮
local function CloseBtnOnClick()
    _C:destroy()
end

-- 点击确认按钮
local function ConfirmBtnOnClick()
    local data = shared_pb.GuildClassTitleProto()

    -- 系统职称id
    for k, v in pairs(systemClassTitleId) do
        data.system_class_title_id:append(v)
    end

    -- 系统职称拥有者
    for k, v in pairs(systemClassTitleMemberId) do
        data.system_class_title_member_id:append(v)
    end

    -- 自定义职称名字
    for k, v in pairs(customClassTitleName) do
        data.custom_class_title_name:append(v)
    end

    -- 自定义职称拥有者Id
    for k, v in pairs(customClassTitleMemberId) do
        local memberId = data.custom_class_title_member_id:add()

        for i, j in pairs(v.V) do
            memberId.v:append(j)
        end
    end

    -- 序列化为字符串
    local data = data:SerializeToString()
    -- 发包
    NetworkManager.C2SUpdateClassTitleProto(data)
end

-- 更新成员展示列表
-- id:成员Id:table 自定义职称(可传入空值)
local function UpdateMemberDisplayList(id)
    memberDisplayData = { }

    if type(id) ~= "table" then
        for k, v in pairs(allianceData.MemberList) do
            if v.Hero.Id ~= id then
                table.insert(memberDisplayData, v)
            end
        end
    else
        -- 传进来是一个table类型的要排除所有Id
        -- 先保存/拷贝所有成员数据
        for k, v in pairs(allianceData.MemberList) do
            table.insert(memberDisplayData, v)
        end

        -- 剔除
        for k, v in pairs(id) do
            for i, j in pairs(memberDisplayData) do
                if v == j.Hero.Id then
                    table.remove(memberDisplayData, i)
                end
            end
        end
    end

    view.MemberList.numItems = #memberDisplayData
    view.MemberList:RefreshVirtualList()
end

--------------------------------------------------------------------------------
-- 系统职称成员列表
--------------------------------------------------------------------------------
-- 更新系统职称成员列表
-- id:成员id
local function UpdateSystemMemberList(id)
    view.SystemMemberList:RemoveChildrenToPool()
    -- 更新数据
    systemClassTitleMemberId[view.SystemTitleList.selectedIndex + 1] = id

    if id == nil then
        return
    end

    local item = view.SystemMemberList:AddItemFromPool(view.SystemMemberList.defaultItem)
    -- 保存id
    item.data = id

    -- 根据Id取名字
    for k, v in pairs(allianceData.MemberList) do
        if v.Hero.Id == id then
            item.title = v.Hero.Name
        end
    end
end

-- 系统职称成员列表item点击回调
local function SystemMemberListOnClickItem(context)
    -- 成员数据
    -- id:成员id
    local id = context.data.data
    -- 这里比较特殊因为系统职称只能有一个才能这么玩
    -- 从系统职称玩家列表中移除
    UpdateSystemMemberList(nil)
    -- 更新成员列表
    UpdateMemberDisplayList(nil)
end
--------------------------------------------------------------------------------
-- 系统职称列表
--------------------------------------------------------------------------------
-- 系统职称item点击回调
local function SystemTitleListOnClickItem(context)
    -- 数据
    -- data:GuildClassTitleDataClass()
    local data = context.data.data
    -- 清空自定义职称选择
    view.CustomTitleList:SelectNone()
    -- 清空自定义职称成员列表
    view.CustomMemberList:RemoveChildrenToPool()
    -- 成员id
    local id = systemClassTitleMemberId[view.SystemTitleList.selectedIndex + 1]
    -- 更新系统成员列表
    UpdateSystemMemberList(id)
    -- 更新成员展示列表数据
    UpdateMemberDisplayList(id)
end

-- 初始化系统职称列表
local function InitSystemTitleList()
    view.SystemTitleList:RemoveChildrenToPool()
    local data = GuildClassTitleConfig.Config

    if data == nil then
        return
    end

    for i = 1, #data do
        local item = view.SystemTitleList:AddItemFromPool(view.SystemTitleList.defaultItem)
        -- 系统职称
        item:GetController("Type_C").selectedIndex = 0
        -- 关闭输入
        item:GetChild("title").editable = false
        item.title = data[i].Name
        -- 保存数据(GuildClassTitleDataClass())
        item.data = data[i]
    end
    -- 默认选第一个
    view.SystemTitleList:GetChildAt(0).selected = true
    -- item点击回调
    view.SystemTitleList.onClickItem:Add(SystemTitleListOnClickItem)
end

--------------------------------------------------------------------------------
-- 自定义职称成员列表
--------------------------------------------------------------------------------
-- 更新自定义职称成员列表
-- data : 成员id[]
local function UpdateCustomMemberList(data)
    -- 清空
    view.CustomMemberList:RemoveChildrenToPool()

    if data == nil then
        return
    end

    for k, v in pairs(data) do
        local item = view.CustomMemberList:AddItemFromPool(view.CustomMemberList.defaultItem)
        -- 保存id
        item.data = v

        -- 根据Id取名字
        for i, j in pairs(allianceData.MemberList) do
            if j.Hero.Id == v then
                item.title = j.Hero.Name
            end
        end
    end
end

-- 自定义职称成员列表item点击回调
local function CustomMemberListOnClickItem(context)
    -- 成员数据
    -- id:成员id
    local id = context.data.data
    -- 玩家id表
    local data = customClassTitleMemberId[view.CustomTitleList.selectedIndex + 1].V

    if data == nil then
        return
    end

    for k, v in pairs(data) do
        if v == id then
            -- 删除数据
            table.remove(data, k)
            -- 移除UI
            view.CustomMemberList:RemoveChildToPoolAt(k - 1)
        end
    end

    -- 更新自定义职称成员列表
    UpdateCustomMemberList(data)
    -- 更新成员列表
    UpdateMemberDisplayList(data)
end
--------------------------------------------------------------------------------
-- 自定义职称列表
--------------------------------------------------------------------------------
-- 当前自定义职称item的内容
local currText = ""
-- 检查是否重名
-- content:自定义标签名
local function IsAlreadyExist(content)
    for k, v in pairs(customClassTitleName) do
        if content == v then
            return true
        end
    end

    return false
end

-- 更新自定义职称列表
local function UpdateCustomTitleList()
    for i = 0, view.CustomTitleList.numChildren - 2 do
        local item = view.CustomTitleList:GetChildAt(i)
        -- 删除按钮
        item:GetChild("Button_Close").onClick:Set( function()
            UIManager.openController(UIManager.ControllerName.Popup, {
                UIManager.PopupStyle.ContentYesNo,
                content = Localization.DeleteTitleConfirm,
                btnFunc =
                {
                    nil,
                    function()
                        -- 删除数据
                        table.remove(customClassTitleName, i + 1)
                        -- 删除UI
                        view.CustomTitleList:RemoveChildToPool(item)
                    end
                }
            } )
        end )
        -- 设置失焦回调
        item:GetChild("title").onFocusOut:Set(
        function()
            local text = item.title

            if text == "" then
                -- 有编辑过给他还原
                if Utils.GetTableLength(customClassTitleMemberId[i + 1].V) > 0 then
                    item.title = currText
                else
                    view.CustomTitleList:RemoveChildToPool(item)
                end
            else
                -- 判断合法性
                if not Utils.isLegalName(text, 1, customTitleMaxLength) then
                    -- 强制清空
                    item.title = ""
                    -- elseif IsAlreadyExist(text) then
                    --     -- 提示重复
                    --     UIManager.showTip( { content = Localization.AllianceCustomTitleIsAlreadyExist, result = false })
                    --     -- 强制清空
                    --     item.title = ""
                else
                    -- 更新数据(不一定是增,有可能是改)
                    customClassTitleName[i + 1] = text
                    -- 更新展示成员列表
                    UpdateMemberDisplayList(customClassTitleMemberId[i + 1].V)
                end
            end
        end )
    end
end

-- 点击增加标签按钮
local function AddBtnOnClick()
    -- 插在倒数第二个
    local item = view.CustomTitleList:AddChildAt(view.CustomTitleList:AddItemFromPool(view.CustomTitleList.defaultItem), view.CustomTitleList.numChildren - 2)
    -- 自定义
    item:GetController("Type_C").selectedIndex = 1
    -- 删除
    item:GetController("Delete_C").selectedIndex = 1
    -- 清空内容
    item.title = ""
    -- 每点一次就更新一次List
    UpdateCustomTitleList()
end

-- 自定义职称列表item点击回调
local function CustomTitleListOnClickItem(context)
    -- 保存内容
    currText = context.data.title
    -- 清空系统职称选择
    view.SystemTitleList:SelectNone()
    -- 清空系统职称成员列表
    view.SystemMemberList:RemoveChildrenToPool()

    if context.data.name == "addBtn" then
        AddBtnOnClick()
        -- 倒数第二个(新建的item)
        local item = view.CustomTitleList:GetChildAt(view.CustomTitleList.numItems - 2)
        -- 模拟点击
        item.onClick:Call()
        -- 获取焦点
        item:GetChild("title"):RequestFocus()
        -- item:RequestFocus()
    end

    -- 玩家id表
    local data = customClassTitleMemberId[view.CustomTitleList.selectedIndex + 1].V
    -- 更新自定义成员列表
    UpdateCustomMemberList(data)
    -- 更新成员列表
    UpdateMemberDisplayList(data)
end

-- 自定义职称增加按钮
local addBtn = nil
-- 初始化自定义职称列表
local function InitCustomTitleList()
    view.CustomTitleList:RemoveChildrenToPool()
    local data = allianceData.MyAlliance.ClassTitle.CustomClassTitleName

    if data == nil then
        return
    end

    for k, v in pairs(data) do
        local item = view.CustomTitleList:AddItemFromPool()
        item.title = v
        -- 0:正常 1:删除
        item:GetController("Delete_C").selectedIndex = 1
    end

    addBtn = view.CustomTitleList:AddItemFromPool(view.CustomTitleList.defaultItem)
    -- 0:系统职称 1:自定义职称 2:增加
    addBtn:GetController("Type_C").selectedIndex = 2
    addBtn.name = "addBtn"
    -- item点击回调
    view.CustomTitleList.onClickItem:Add(CustomTitleListOnClickItem)
    -- 更新
    UpdateCustomTitleList()
end
--------------------------------------------------------------------------------
-- 成员列表
--------------------------------------------------------------------------------
local function MemberListRenderer(index, obj)
    -- 成员数据
    -- data(GuildMemberClass())
    local data = memberDisplayData[index + 1]

    if data == nil then
        return
    end

    -- 名字
    obj.title = data.Hero.Name
    -- 保存数据
    obj.data = data
end

-- 从成员列表中删除
-- id:成员Id
local function RemoveFromMemberDisplayList(id)
    for k, v in pairs(memberDisplayData) do
        if v.Hero.Id == id then
            table.remove(memberDisplayData, k)
        end
    end

    view.MemberList.numItems = #memberDisplayData
    view.MemberList:RefreshVirtualList()
end

-- 成员列表item点击回调
local function MemberListOnClickItem(context)
    -- 成员数据
    -- data(GuildMemberClass())
    local data = context.data.data
    -- 系统列表选择索引
    local systemIndex = view.SystemTitleList.selectedIndex
    -- 自定义列表选择索引
    local customIndex = view.CustomTitleList.selectedIndex

    if systemIndex ~= -1 then

        -- 判断列表内是否有数据(根据数据判断)
        if systemClassTitleMemberId[systemIndex + 1] ~= nil then
            -- 提示人数已达上限
            UIManager.showTip( { content = Localization.TheNumberHasReachedAnUpperLimit, result = false })
        else
            -- 从成员列表移除
            RemoveFromMemberDisplayList(data.Hero.Id)
            -- 增加到系统职称成员列表内
            UpdateSystemMemberList(data.Hero.Id)
        end
    elseif customIndex ~= -1 then
        -- 从成员列表移除
        RemoveFromMemberDisplayList(data.Hero.Id)
        -- 成员id表
        local memberIdTable = customClassTitleMemberId[view.CustomTitleList.selectedIndex + 1].V

        -- 更新自定义职称数据
        if memberIdTable == nil then
            memberIdTable = { }
        end

        table.insert(memberIdTable, data.Hero.Id)
        -- 更新自定义职称成员列表
        UpdateCustomMemberList(memberIdTable)
    else
        UIManager.showTip( { content = Localization.PleaseSelectATitle, result = false })
    end
end

-- 初始化成员列表
local function InitMemberList()
    -- 成员列表
    view.MemberList.itemRenderer = MemberListRenderer
    view.MemberList.numItems = #memberDisplayData
    view.MemberList.onClickItem:Add(MemberListOnClickItem)
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set(CloseBtnOnClick)
    view.ConfirmBtn.onClick:Set(ConfirmBtnOnClick)
    view.CloseBtn.onClick:Set(CloseBtnOnClick)
    view.SystemMemberList.onClickItem:Add(SystemMemberListOnClickItem)
    view.CustomMemberList.onClickItem:Add(CustomMemberListOnClickItem)

    Event.addListener(Event.ALLIANCE_ON_UPDATE_MEMBER_TITLE_SUCCESS, CloseBtnOnClick)
end

function _C:onOpen()
    allianceData = DataTrunk.PlayerInfo.AllianceData
    customTitleMaxLength = GuildConfig.Config.GuildClassTitleMaxCharCount
    InitSystemTitleList()
    InitCustomTitleList()
    -- 职称数据
    local titleData = allianceData.MyAlliance.ClassTitle
    -- 系统职称拥有者id
    systemClassTitleMemberId = titleData.SystemClassTitleMemberId
    -- 保存
    currSystemClassTitleMemberId = systemClassTitleMemberId
    -- 自定义职称名字
    customClassTitleName = titleData.CustomClassTitleName
    -- 保存
    currCustomClassTitleName = customClassTitleName
    -- 自定义职称拥有者id
    customClassTitleMemberId = titleData.CustomClassTitleMemberId
    -- 保存
    currCustomClassTitleMemberId = customClassTitleMemberId
    -- 第一个系统职称的成员id
    local id = systemClassTitleMemberId[1]
    -- 默认显示第一个系统职称的成员列表
    UpdateSystemMemberList(id)
    -- 清空自定义成员列表
    view.CustomMemberList:RemoveChildrenToPool()
    -- 初始化成员列表
    InitMemberList()
    -- 初始化成员显示列表(剔除ID为默认职称的成员)
    UpdateMemberDisplayList(id)
end

function _C:onDestroy()
    view.MemberList.itemRenderer = nil

    Event.removeListener(Event.ALLIANCE_ON_UPDATE_MEMBER_TITLE_SUCCESS, CloseBtnOnClick)
end