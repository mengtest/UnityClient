local _C = UIManager.Controller(UIManager.ControllerName.AllianceChangePostWindow, UIManager.ViewName.AllianceChangePostWindow)
_C.IsPopupBox = true

local view = nil
-- 联盟成员数据
local memberListData = nil
-- 操作者的数据
local operatorData = nil
-- 被操作的玩家数据
local memberData = nil
-- 拷贝一份职位列表数据(因人而异)
local postListData = nil

-- 点击取消按钮
local function CloseBtnOnClick()
    _C:destroy()
end

-- 点击确认按钮
local function ConfirmBtnOnClick()
    local index = view.PostList.selectedIndex

    if index == -1 then
        UIManager.showTip( { content = Localization.PleaseSelectAPost, result = false })
    else
        -- 1:副盟主 2:长老 3:成员
        NetworkManager.C2SUpdateMemberClassLevelProto(memberData.Hero.Id, postListData[view.PostList.selectedIndex + 1].Level)
        CloseBtnOnClick()
    end
end

-- 判断该职位的人数有没有到达上限(true 已满,false 未满)
-- level:等级
local function IsFull(level)
    -- 当前职位最大数量:配置
    local max = GuildClassLevelConfig.Config[level].Count
    -- 当前职位成员数量
    local currAmount = 0

    if max == 0 then
        return false
    else
        for k, v in pairs(memberListData) do
            if v.ClassLevel == level then
                currAmount = currAmount + 1
            end
        end

        return currAmount > max
    end
end

function _C:onCreat()
    view = _C.View

    view.BG.onClick:Set(CloseBtnOnClick)
    view.ConfirmBtn.onClick:Set(ConfirmBtnOnClick)
    view.CloseBtn.onClick:Set(CloseBtnOnClick)
end

-- data[1]:GuildMemberClass()   操作者的数据
-- data[2]:GuildMemberClass()   被操作的玩家数据
function _C:onOpen(data)
    memberListData = DataTrunk.PlayerInfo.AllianceData.MemberList
    operatorData = data[1]
    memberData = data[2]
    -- 名字
    view.NameText.text = memberData.Hero.Name
    view.PostList:RemoveChildrenToPool()
    postListData = { }

    -- 如果最低级的不是1就会有问题
    for i = operatorData.ClassLevel - 1, 1, -1 do
        while true do
            -- 跳过玩家当前的职位
            if i == memberData.ClassLevel then
                break
            end

            table.insert(postListData, GuildClassLevelConfig.Config[i])
            local item = view.PostList:AddItemFromPool(view.PostList.defaultItem)
            -- 0:成员 1:长老 2:副盟主
            local type_C = item:GetController("Type_C")
            type_C.selectedIndex = i - 1
            -- 0:未满 1:已满
            local state_C = item:GetController("State_C")

            if IsFull(i) then
                state_C.selectedIndex = 1
                item.touchable = false
            else
                state_C.selectedIndex = 0
                item.touchable = true
            end

            break
        end
    end
end