local _C = UIManager.Controller(UIManager.ControllerName.BattlelogMail, UIManager.ViewName.BattlelogMail)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

_C.IsPopupBox = true
local view = nil
-- 君主id
local mainPlayerId = DataTrunk.PlayerInfo.MonarchsData.Id
-- 当前邮件Id
local currMailId = ""

-- 更新收藏状态
local function UpdateCollectState(isKeep)
    if isKeep then
        view.CollectBtn.icon = UIConfig.Mail.CollectIcon
        view.CollectBtn.title = Localization.Collect
    else
        view.CollectBtn.icon = UIConfig.Mail.NotCollectIcon
        view.CollectBtn.title = Localization.NotCollect
    end

    view.CollectBtn.onClick:Set( function()
        NetworkManager.C2SKeepMailProto(currMailId, not isKeep)
    end )
end

-- 删除成功
local function DeleteSuccessCallBack()
    _C:close()
end

-- 简单处理一下
local function NumConvert(num)
    if type(num) ~= "number" then
        return
    end

    if num < 10 then
        return "0" .. num
    else
        return num
    end
end

function _C:onOpen(data)
    view.Title.text = data.Title
    view.Content.text = data.SubTitle
    local timeTable = os.date("*t", data.SendTime)
    -- 日期
    view.Date.text = timeTable.year .. "." .. NumConvert(timeTable.month) .. "." .. NumConvert(timeTable.day)
    -- 时间
    view.Time.text = NumConvert(timeTable.hour) .. ":" .. NumConvert(timeTable.min) .. ":" .. NumConvert(timeTable.sec)
    -- 战报数据
    local battlelog = data.Report
    -- 左边的标题
    view.Our.Title.text = battlelog.AttackerDesc
    -- 右边的标题
    view.Enemy.Title.text = battlelog.DefenserDesc
    view.Our.List:RemoveChildrenToPool()
    view.Enemy.List:RemoveChildrenToPool()

    if battlelog.Gold > 0 then
        -- 左边
        local item = view.Our.List:AddItemFromPool(view.Our.List.defaultItem)
        -- 0 红 1 蓝
        local color_C_L = item:GetController("State_C")
        item.icon = UIConfig.CurrencyType.Gold
        item.title = battlelog.Gold

        -- 左边赢了
        if battlelog.AttackerWin then
            color_C_L.selectedIndex = 1
        else
            color_C_L.selectedIndex = 0
        end
    end

    if battlelog.Food > 0 then
        -- 左边
        local item = view.Our.List:AddItemFromPool(view.Our.List.defaultItem)
        -- 0 红 1 蓝
        local color_C_L = item:GetController("State_C")
        item.icon = UIConfig.CurrencyType.Food
        item.title = battlelog.Food

        -- 左边赢了
        if battlelog.AttackerWin then
            color_C_L.selectedIndex = 1
        else
            color_C_L.selectedIndex = 0
        end
    end

    if battlelog.Wood > 0 then
        -- 左边
        local item = view.Our.List:AddItemFromPool(view.Our.List.defaultItem)
        -- 0 红 1 蓝
        local color_C_L = item:GetController("State_C")
        item.icon = UIConfig.CurrencyType.Wood
        item.title = battlelog.Wood

        -- 左边赢了
        if battlelog.AttackerWin then
            color_C_L.selectedIndex = 1
        else
            color_C_L.selectedIndex = 0
        end
    end

    if battlelog.Stone > 0 then
        -- 左边
        local item = view.Our.List:AddItemFromPool(view.Our.List.defaultItem)
        -- 0 红 1 蓝
        local color_C_L = item:GetController("State_C")
        item.icon = UIConfig.CurrencyType.Stone
        item.title = battlelog.Stone

        -- 左边赢了
        if battlelog.AttackerWin then
            color_C_L.selectedIndex = 1
        else
            color_C_L.selectedIndex = 0
        end
    end

    for i = 0, view.Our.List.numItems - 1 do
        local item = view.Enemy.List:AddItemFromPool(view.Enemy.List.defaultItem)
        local copyItem = view.Our.List:GetChildAt(i)
        item.icon = copyItem.icon
        item.title = copyItem.title
        item:GetController("State_C").selectedIndex = math.abs(copyItem:GetController("State_C").selectedIndex - 1)
    end


    leftData = battlelog.Attacker
    rightData = battlelog.Defenser

    -- 头像
    if leftData.Head ~= "" then
        view.Our.Icon.url = UIConfig.MonarchsIcon[leftData.Head].SmallIcon
    end
    -- 名字
    view.Our.Name.text = leftData.Name
    -- 坐标
    view.Our.Coordinate.title = string.format(Localization.LordsCoord, leftData.BaseX, leftData.BaseY)
    view.Our.Coordinate.onClick:Set( function() print("怕是要飞过去了,坐标:" .. leftData.BaseX .. ',' .. leftData.BaseY) end)
    view.Our.SoilderBar.value = leftData.AliveSoldier
    view.Our.SoilderBar.max = leftData.TotalSoldier

    if rightData.Head ~= "" then
        view.Enemy.Icon.url = UIConfig.MonarchsIcon[rightData.Head].SmallIcon
    end
    view.Enemy.Name.text = rightData.Name
    view.Enemy.Coordinate.text = string.format(Localization.LordsCoord, rightData.BaseX, rightData.BaseY)
    view.Enemy.Coordinate.onClick:Set( function() print("怕是要飞过去了,坐标:" .. rightData.BaseX .. ',' .. rightData.BaseY) end)
    view.Enemy.SoilderBar.value = rightData.AliveSoldier
    view.Enemy.SoilderBar.max = rightData.TotalSoldier

    -- 删除按钮
    view.DeleteBtn.onClick:Set( function()
        NetworkManager.C2SDeleteMailProto(data.Id)
    end )
    -- 收藏按钮
    currMailId = data.Id
    UpdateCollectState(data.Keep)
    -- 回放按钮
    view.ReplayBtn.onClick:Set( function()
        print("回放url", battlelog.ReplayUrl)
    end )
end

function _C:onCreat()
    view = _C.View
    view.CloseBtn.onClick:Set( function() _C:close() end)
    Event.addListener(Event.MAIL_COLLECT_OR_NOT_SUCCESS, UpdateCollectState)
    Event.addListener(Event.MAIL_DELETE_SUCCESS, DeleteSuccessCallBack)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    Event.removeListener(Event.MAIL_COLLECT_OR_NOT_SUCCESS, UpdateCollectState)
    Event.removeListener(Event.MAIL_DELETE_SUCCESS, DeleteSuccessCallBack)
end