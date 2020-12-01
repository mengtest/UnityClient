local _C = UIManager.Controller(UIManager.ControllerName.SystemMail, UIManager.ViewName.SystemMail)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

_C.IsPopupBox = true
local view = nil

-- 更新收藏状态
local function UpdateCollectState(isKeep)
    if isKeep then
        view.CollectBtn.icon = UIConfig.Mail.CollectIcon
        view.CollectBtn.title = Localization.Collect
        view.CollectBtn.onClick:Set( function()
            NetworkManager.C2SKeepMailProto(data.Id, false)
        end )
    else
        view.CollectBtn.icon = UIConfig.Mail.NotCollectIcon
        view.CollectBtn.title = Localization.NotCollect
        view.CollectBtn.onClick:Set( function()
            NetworkManager.C2SKeepMailProto(data.Id, true)
        end )
    end
end

-- 删除成功
local function DeleteSuccessCallBack()
    _C:close()
end

-- 领取成功
local function GetPrizeSuccess()
    view.State_C.selectedIndex = 0
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
    -- 标题
    view.Title.text = data.Title
    local timeTable = os.date("*t", data.SendTime)
    -- 日期
    view.Date.text = timeTable.year .. "." .. NumConvert(timeTable.month) .. "." .. NumConvert(timeTable.day)
    -- 时间
    view.Time.text = NumConvert(timeTable.hour) .. ":" .. NumConvert(timeTable.min) .. ":" .. NumConvert(timeTable.sec)
    -- 内容
    view.Content.text = data.Text
    -- 附件列表
    view.AwardList:RemoveChildrenToPool()

    if not data.HasPrize then
        view.State_C.selectedIndex = 2
    else
        if data.Collected then
            view.State_C.selectedIndex = 0
        else
            view.State_C.selectedIndex = 1
            -- 通货
            for k, v in pairs(data.Prize.Currencys) do
                local item = view.AwardList:AddItemFromPool(UIConfig.Mail.PrizeItem)
                item.icon = v.Config.Icon
                item:GetChild("title").text = v.Amount
                item:GetController("State_C").selectedIndex = 1
                item:GetController("Count_C").selectedIndex = 1
            end

            -- 物品
            for k, v in pairs(data.Prize.Goods) do
                local item = view.AwardList:AddItemFromPool(UIConfig.Mail.PrizeItem)
                item.icon = v.Config.Icon
                item:GetController("State_C").selectedIndex = 1
                local count_C = item:GetController("Count_C")

                if v.Amount > 1 then
                    count_C.selectedIndex = 1
                    item:GetChild("title").text = v.Amount
                else
                    count_C.selectedIndex = 0
                end
            end

            -- 装备
            for k, v in pairs(data.Prize.Equips) do
                local item = view.AwardList:AddItemFromPool(UIConfig.Mail.PrizeItem)
                item.icon = v.Config.Icon
                item:GetController("State_C").selectedIndex = 1
                local count_C = item:GetController("Count_C")

                if v.Amount > 1 then
                    count_C.selectedIndex = 1
                    item:GetChild("title").text = v.Amount
                else
                    count_C.selectedIndex = 0
                end
            end

            -- 领取按钮
            view.GetBtn.onClick:Set( function()
                NetworkManager.C2SCollectMailPrizeProto(data.Id)
            end )
        end
    end

    -- 删除按钮
    view.DeleteBtn.onClick:Set( function()
        NetworkManager.C2SDeleteMailProto(data.Id)
    end )
    -- 收藏按钮
    UpdateCollectState(data.Keep)
end

function _C:onCreat()
    view = _C.View
    view.CloseBtn.onClick:Set( function() _C:close() end)

    Event.addListener(Event.MAIL_COLLECT_OR_NOT_SUCCESS, UpdateCollectState)
    Event.addListener(Event.MAIL_DELETE_SUCCESS, DeleteSuccessCallBack)
    Event.addListener(Event.MAIL_GET_PRIZE_SUCCESS, GetPrizeSuccess)
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    Event.removeListener(Event.MAIL_COLLECT_OR_NOT_SUCCESS, UpdateCollectState)
    Event.removeListener(Event.MAIL_DELETE_SUCCESS, DeleteSuccessCallBack)
    Event.removeListener(Event.MAIL_GET_PRIZE_SUCCESS, GetPrizeSuccess)
end