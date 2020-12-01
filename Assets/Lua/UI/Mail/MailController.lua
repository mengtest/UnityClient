local _C = UIManager.Controller(UIManager.ControllerName.Mail, UIManager.ViewName.Mail)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 邮件每批返回多少个
local mailBatchCount = MiscCommonConfig.Config.MailBatchCount
-- 邮件数据
local mailData = DataTrunk.PlayerInfo.MailData

-- 请求邮件请求邮件请求邮件
local function C2SReqMail(read, keep, report, has_prize, collected, min_id)
    NetworkManager.C2SListMailProto(read, keep, report, has_prize, collected, min_id, mailBatchCount)
end

-- 请求邮件
local function RequestMail()
    -- 邮件数量(可能会有坑)
    local length = 0
    local data = mailData.MailList[view.Tab_C.selectedIndex]

    if view.UnreadToggle.selected and not view.AccessoryToggle.selected then
        length = Utils.GetTableLength(data.Unread)
        print("请求" .. view.Tab_C.selectedIndex .. "页签未读邮件")
        if view.Tab_C.selectedIndex == 0 then
            C2SReqMail(1, 0, 0, 0, 0, data.Unread[length].Id)
        elseif view.Tab_C.selectedIndex == 1 then
            C2SReqMail(1, 0, 2, 0, 0, data.Unread[length].Id)
        elseif view.Tab_C.selectedIndex == 2 then
            C2SReqMail(1, 0, 1, 0, 0, data.Unread[length].Id)
        else
            C2SReqMail(1, 2, 0, 0, 0, data.Unread[length].Id)
        end
    elseif not view.UnreadToggle.selected and view.AccessoryToggle.selected then
        length = Utils.GetTableLength(data.HasPrize)
        print("请求" .. view.Tab_C.selectedIndex .. "页签含附件邮件")
        if view.Tab_C.selectedIndex == 0 then
            C2SReqMail(0, 0, 0, 2, 0, data.HasPrize[length].Id)
        elseif view.Tab_C.selectedIndex == 1 then
            C2SReqMail(0, 0, 2, 2, 0, data.HasPrize[length].Id)
        elseif view.Tab_C.selectedIndex == 2 then
            C2SReqMail(0, 0, 1, 2, 0, data.HasPrize[length].Id)
        else
            C2SReqMail(0, 2, 0, 2, 0, data.HasPrize[length].Id)
        end
    elseif view.UnreadToggle.selected and view.AccessoryToggle.selected then
        length = Utils.GetTableLength(data.UnreadAndHasPrize)
        print("请求" .. view.Tab_C.selectedIndex .. "页签未读且含附件邮件")
        if view.Tab_C.selectedIndex == 0 then
            C2SReqMail(1, 0, 0, 2, 0, data.UnreadAndHasPrize[length].Id)
        elseif view.Tab_C.selectedIndex == 1 then
            C2SReqMail(1, 0, 2, 2, 0, data.UnreadAndHasPrize[length].Id)
        elseif view.Tab_C.selectedIndex == 2 then
            C2SReqMail(1, 0, 1, 2, 0, data.UnreadAndHasPrize[length].Id)
        else
            C2SReqMail(1, 2, 0, 2, 0, data.UnreadAndHasPrize[length].Id)
        end
    else
        length = Utils.GetTableLength(data.All)
        print("请求" .. view.Tab_C.selectedIndex .. "页签全部邮件")
        if view.Tab_C.selectedIndex == 0 then
            C2SReqMail(0, 0, 0, 0, 0, data.All[length].Id)
        elseif view.Tab_C.selectedIndex == 1 then
            C2SReqMail(0, 0, 2, 0, 0, data.All[length].Id)
        elseif view.Tab_C.selectedIndex == 2 then
            C2SReqMail(0, 0, 1, 0, 0, data.All[length].Id)
        else
            C2SReqMail(0, 2, 0, 0, 0, data.All[length].Id)
        end
    end
end

local function MailItemRenderer(index, obj)
    local data = mailData.MailList[view.Tab_C.selectedIndex]

    if view.UnreadToggle.selected and not view.AccessoryToggle.selected then
        data = data.Unread[index + 1]
    elseif not view.UnreadToggle.selected and view.AccessoryToggle.selected then
        data = data.HasPrize[index + 1]
    elseif view.UnreadToggle.selected and view.AccessoryToggle.selected then
        data = data.UnreadAndHasPrize[index + 1]
    else
        data = data.All[index + 1]
    end

    if data == nil then
        return
    end

    -- 收藏按钮
    local collectBtn = obj:GetChild("Button_Collect")
    local collect_C = obj:GetChild("Component_Star"):GetController("State_C")
    -- 清空点击事件
    local infoBtn = obj:GetChild("Button_Details")
    infoBtn.onClick:Clear()

    -- 系统邮件
    if not data.HasReport then
        -- 是否有奖励
        local hasPrize_C = obj:GetController("Type_C")

        if data.HasPrize then
            hasPrize_C.selectedIndex = 0

            -- 附件列表
            local list = obj:GetChild("List_Rewards")
            list:RemoveChildrenToPool()

            -- 通货
            for k, v in pairs(data.Prize.Currencys) do
                local item = list:AddItemFromPool(UIConfig.Mail.PrizeItem)
                item.icon = v.Config.Icon
                item:GetController("State_C").selectedIndex = 1
                item:GetChild("title").text = v.Amount
                item:GetController("Count_C").selectedIndex = 1
            end

            -- 物品
            for k, v in pairs(data.Prize.Goods) do
                local item = list:AddItemFromPool(UIConfig.Mail.PrizeItem)
                item.icon = v.Config.Icon
                item:GetController("State_C").selectedIndex = 1
                local count_c = item:GetController("Count_C")

                if v.Amount > 1 then
                    count_c.selectedIndex = 1
                    item:GetChild("title").text = v.Amount
                else
                    count_c.selectedIndex = 0
                end
            end

            -- 装备
            for k, v in pairs(data.Prize.Equips) do
                local item = list:AddItemFromPool(UIConfig.Mail.PrizeItem)
                item.icon = v.Config.Icon
                item:GetController("State_C").selectedIndex = 1
                local count_c = item:GetController("Count_C")

                if v.Amount > 1 then
                    count_c.selectedIndex = 1
                    item:GetChild("title").text = v.Amount
                else
                    count_c.selectedIndex = 0
                end
            end
        else
            hasPrize_C.selectedIndex = 1
        end

        infoBtn.onClick:Add( function()
            print("进入系统邮件")
            UIManager.openController(UIManager.ControllerName.SystemMail, data)
        end )
    else
        -- 战报邮件

        infoBtn.onClick:Add( function()
            UIManager.openController(UIManager.ControllerName.BattlelogMail, data)
        end )
    end
    -- 通用部分
    -- Icon
    obj:GetChild("Loader_Icon").url = UIConfig.Mail[data.Icon]
    -- 标题
    obj:GetChild("Text_Title").text = data.Title .. ":" .. data.Id
    -- 内容
    obj:GetChild("Text_Content").text = data.Text
    -- 时间
    obj:GetChild("Text_Time").text = Utils.secondFuzzyConversion(TimerManager.currentTime - data.SendTime)

    -- 0 收藏状态
    if data.Keep then
        collect_C.selectedIndex = 0
        collectBtn.onClick:Set( function()
            print("取消收藏!")
            NetworkManager.C2SKeepMailProto(data.Id, false)
        end )
    else
        collect_C.selectedIndex = 1
        collectBtn.onClick:Set( function()
            print("收藏!")
            NetworkManager.C2SKeepMailProto(data.Id, true)
        end )
    end

    -- 是否已读
    local read_C = obj:GetController("State_C")

    if data.Read then
        read_C.selectedIndex = 1
    else
        read_C.selectedIndex = 0
        infoBtn.onClick:Add( function()
            NetworkManager.C2SReadMailProto(data.Id)
        end )
    end

    -- 如果当前页签邮件数量不等于空且划到最下面时请求邮件
    view.MainList.scrollPane.onScrollEnd:Set(RequestMail)
end

local function MailListProvider(index)
    -- 0-系统，1-攻城胜利，2-攻城失败，3-守城胜利，4-守城失败
    local data = mailData.MailList[view.Tab_C.selectedIndex]

    if view.UnreadToggle.selected and not view.AccessoryToggle.selected then
        data = data.Unread[index + 1]
    elseif not view.UnreadToggle.selected and view.AccessoryToggle.selected then
        data = data.HasPrize[index + 1]
    elseif view.UnreadToggle.selected and view.AccessoryToggle.selected then
        data = data.UnreadAndHasPrize[index + 1]
    else
        data = data.All[index + 1]
    end

    if data == nil then
        return
    end

    if data.HasReport then
        return UIConfig.Mail.BattlelogItem
    else
        return UIConfig.Mail.SystemItem
    end
end

-- 更新邮件列表
local function UpdataMailList()
    -- 邮件数量
    local length = 0

    if view.UnreadToggle.selected and not view.AccessoryToggle.selected then
        length = Utils.GetTableLength(mailData.MailList[view.Tab_C.selectedIndex].Unread)
        print("未读邮件个数:" .. length)
    elseif not view.UnreadToggle.selected and view.AccessoryToggle.selected then
        length = Utils.GetTableLength(mailData.MailList[view.Tab_C.selectedIndex].HasPrize)
        print("有附件邮件个数:" .. length)
    elseif view.UnreadToggle.selected and view.AccessoryToggle.selected then
        length = Utils.GetTableLength(mailData.MailList[view.Tab_C.selectedIndex].UnreadAndHasPrize)
        print("未读且有附件邮件个数:" .. length)
    else
        length = Utils.GetTableLength(mailData.MailList[view.Tab_C.selectedIndex].All)

        if length == 0 or length == nil then
            view.State_C.selectedIndex = 0
            return
        else
            view.State_C.selectedIndex = 1
            print("tab" .. view.Tab_C.selectedIndex .. "的邮件个数为:" .. length)
        end
    end

    view.MainList.itemRenderer = MailItemRenderer
    view.MainList.itemProvider = MailListProvider
    view.MainList.numItems = length
end

-- 切换页签时还原筛选器,请求相应邮件,清空本地筛选器内容
local function TagPanelOnChanged()
    view.UnreadToggle.selected = false
    view.AccessoryToggle.selected = false
    -- 初始化到顶部
    view.MainList.scrollPane:ScrollTop()

    -- 默认展示全部邮件
    local currData = mailData.MailList[view.Tab_C.selectedIndex].All
    -- 邮件个数
    local length = Utils.GetTableLength(currData)
    -- 最后一封的邮件Id
    local mailId = ""

    if length ~= 0 and length ~= nil then
        mailId = currData[length].Id
    end

    -- 0 全部 1 战报 2 系统 3 收藏
    if view.Tab_C.selectedIndex == 0 then
        print("请求全部", mailId)
        C2SReqMail(0, 0, 0, 0, 0, mailId)
    elseif view.Tab_C.selectedIndex == 1 then
        print("请求战报", mailId)
        C2SReqMail(0, 0, 2, 0, 0, mailId)
    elseif view.Tab_C.selectedIndex == 2 then
        print("请求系统", mailId)
        C2SReqMail(0, 0, 1, 0, 0, mailId)
    else
        print("请求收藏", mailId)
        C2SReqMail(0, 2, 0, 0, 0, mailId)
    end
end

function _C:onCreat()
    view = self.View;

    view.BackBtn.onClick:Set( function() _C:close() end)
    view.Tab_C.onChanged:Set(TagPanelOnChanged)
    view.UnreadToggle.onClick:Set(UpdataMailList)
    view.AccessoryToggle.onClick:Set(UpdataMailList)

    Event.addListener(Event.MAIL_REQUEST_MAIL_LIST_SUCCESS, UpdataMailList)
    Event.addListener(Event.MAIL_COLLECT_OR_NOT_SUCCESS, UpdataMailList)
    Event.addListener(Event.MAIL_READ_SUCCESS, UpdataMailList)
    Event.addListener(Event.MAIL_DELETE_SUCCESS, UpdataMailList)
end

function _C:onOpen()
    -- 第一次打开时请求全部页签的邮件
    -- 0-全部 1-战报 2-系统 3-收藏
    local length = Utils.GetTableLength(mailData.MailList[0].All)

    if length == 0 or length == nil then
        C2SReqMail(0, 0, 0, 0, 0, "")
    else
        UpdataMailList()
    end
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    view.MainList.scrollPane.onScrollEnd:Clear()
    view.MainList.itemRenderer = nil
    view.MainList.itemProvider = nil
    view.Tab_C.onChanged:Clear()

    Event.removeListener(Event.MAIL_REQUEST_MAIL_LIST_SUCCESS, UpdataMailList)
    Event.removeListener(Event.MAIL_COLLECT_OR_NOT_SUCCESS, UpdataMailList)
    Event.removeListener(Event.MAIL_READ_SUCCESS, UpdataMailList)
    Event.removeListener(Event.MAIL_DELETE_SUCCESS, UpdataMailList)
end