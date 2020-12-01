-- 邮件信息
local MailData = { }
MailData.MailList =
{
    -- 全部邮件列表
    [0] =
    {
        All = { },
        Unread = { },
        HasPrize = { },
        UnreadAndHasPrize = { },
    },
    -- 战报邮件列表
    [1] =
    {
        All = { },
        Unread = { },
        HasPrize = { },
        UnreadAndHasPrize = { },
    },
    -- 系统邮件列表
    [2] =
    {
        All = { },
        Unread = { },
        HasPrize = { },
        UnreadAndHasPrize = { },
    },
    -- 收藏邮件列表
    [3] =
    {
        All = { },
        Unread = { },
        HasPrize = { },
        UnreadAndHasPrize = { },
    },
}

-- 检测该Id邮件是否存在在该页签内
-- id: 邮件id
-- mailTabs: 哪一个页签
local function isExist(id, mailTabs)
    for k, v in pairs(mailTabs) do
        if v.Id == id then
            print("这封邮件已经有了", id)
            return true
        end
    end

    return false
end

-- 收到邮件(插在首尾)
function MailData:receiveMail(tab, mailData)
    if not isExist(mailData.id, self.MailList[tab].All) then
        local mail = MailClass()
        mail:updateInfo(mailData)
        table.insert(self.MailList[tab].All, 1, mail)

        -- 未读邮件
        if not mail.Read then
            table.insert(self.MailList[tab].Unread, 1, mail)
            -- 未读且含附件邮件
            if mail.HasPrize then
                table.insert(self.MailList[tab].UnreadAndHasPrize, 1, mail)
            end
        end

        -- 含附件邮件
        if mail.HasPrize then
            table.insert(self.MailList[tab].HasPrize, 1, mail)
        end

        print(tab .. "邮件个数:", #self.MailList[tab].All)
    end
end

-- 刷新邮件
function MailData:updateMail(tab, mailData)
    if not isExist(mailData.id, self.MailList[tab].All) then
        local mail = MailClass()
        mail:updateInfo(mailData)
        table.insert(self.MailList[tab].All, mail)

        -- 未读邮件
        if not mail.Read then
            table.insert(self.MailList[tab].Unread, mail)
            -- 未读且含附件邮件
            if mail.HasPrize then
                table.insert(self.MailList[tab].UnreadAndHasPrize, mail)
            end
        end

        -- 含附件邮件
        if mail.HasPrize then
            table.insert(self.MailList[tab].HasPrize, mail)
        end

        print(tab .. "邮件个数:", #self.MailList[tab].All, mail.Id, mail.Read, mail.HasPrize)
    end
end

-- 删除一封邮件
-- id:邮件id
function MailData:deleteMail(id)
    for k, v in pairs(self.MailList) do
        for i, j in pairs(v) do
            for key, mailData in pairs(j) do
                if mailData.Id == id then
                    table.remove(j, key)
                end
            end
        end
    end
end

-- 清理该页签内所有数据
function MailData:clear(tabId)
    if tabId == nil or tabId < 0 or tabId > 3 then
        return
    end

    self.MailList[tabId] = {
        All = { },
        Unread = { },
        HasPrize = { },
        UnreadAndHasPrize = { },
    }
end

-- *********************************************************************
-- 协议处理
-- *********************************************************************

-- 请求邮件成功
-- moduleId = 8, msgId = 2
-- config.MiscConfig.MailBatchCount 一次推送多少个邮件（当打开邮件界面时，邮件数少于这个值，则请求邮件数）
-- 返回的邮件列表id是从高到低，客户端一直往上拖，逐批加载
-- 当返回的邮件列表小于config.MiscConfig.MailBatchCount，说明已经没有新邮件了
-- 收到的全部邮件分类可以填充到其他分类中，但是其他分类获取的邮件不要放到全部分类中
-- read: int // 0-全部 1-未读 2-已读
-- keep: int // 0-全部 1-未收藏 2-已收藏
-- report: int // 战报 0-全部 1-无 2-有
-- has_prize: int // 奖励 0-全部 1-无 2-有
-- collected: int // 0-全部 1-未领取 2-已领取
-- mail: bytes[] // shared_proto.MailProto
local function S2CListMailProto(data)
    print("请求邮件成功!", data.read, data.keep, data.report, data.has_prize, data.collected)

    if data.report == 0 then
        -- 全部
        print("更新全部邮件", #data.mail)
        for k, v in ipairs(data.mail) do
            local mail = shared_pb.MailProto()
            mail:ParseFromString(v)
            MailData:updateMail(0, mail)
        end
    elseif data.report == 2 then
        -- 战报
        print("更新战报邮件", #data.mail)
        for k, v in ipairs(data.mail) do
            local mail = shared_pb.MailProto()
            mail:ParseFromString(v)
            MailData:updateMail(1, mail)
        end
    elseif data.report == 1 then
        -- 系统
        print("更新系统邮件", #data.mail)
        for k, v in ipairs(data.mail) do
            local mail = shared_pb.MailProto()
            mail:ParseFromString(v)
            MailData:updateMail(2, mail)
        end
    end

    -- 收藏邮件单独处理,因为data.report有3种情况
    if data.keep == 2 then
        -- 收藏
        print("更新收藏邮件", #data.mail)
        for k, v in ipairs(data.mail) do
            local mail = shared_pb.MailProto()
            mail:ParseFromString(v)
            MailData:updateMail(3, mail)
        end
    end

    Event.dispatch(Event.MAIL_REQUEST_MAIL_LIST_SUCCESS)
end
mail_decoder.RegisterAction(mail_decoder.S2C_LIST_MAIL, S2CListMailProto)

-- 请求邮件失败
-- moduleId = 8, msgId = 3
local function S2CFailListMailProto(code)
    UIManager.showTip( { content = Localization["Error8_3_" .. tostring(code)], result = false })
end
mail_decoder.RegisterAction(mail_decoder.S2C_FAIL_LIST_MAIL, S2CFailListMailProto)
-- *********************************************************************
-- 收到一个新邮件
-- 每收到一个新邮件，都排在邮件的开头
-- moduleId = 8, msgId = 4
-- mail: bytes // shared_proto.MailProto
local function S2CReceiveMailProto(data)
    if type(data.mail) ~= "string" then
        return
    end

    print("收到一封邮件")

    local mail = shared_pb.MailProto()
    mail:ParseFromString(data.mail)

    print(mail)

    -- 全部邮件
    MailData:receiveMail(0, mail)

    if mail.has_report then
        -- 战报邮件
        print("收到战报邮件!!! ", mail.id)
        MailData:receiveMail(1, mail)
    else
        -- 系统邮件
        print("收到系统邮件!!! ", mail.id)
        MailData:receiveMail(2, mail)
    end

    Event.dispatch(Event.MAIL_RECEIVE_A_MAIL)
end
mail_decoder.RegisterAction(mail_decoder.S2C_RECEIVE_MAIL, S2CReceiveMailProto)

-- *********************************************************************
-- 删除邮件成功
-- moduleId = 8, msgId = 9
-- id: string // 删除邮件id
local function S2CDeleteMailProto(data)
    MailData:deleteMail(data.id)

    Event.dispatch(Event.MAIL_DELETE_SUCCESS)
end
mail_decoder.RegisterAction(mail_decoder.S2C_DELETE_MAIL, S2CDeleteMailProto)

-- 删除邮件失败
-- moduleId = 8, msgId = 10
local function S2CFailDeleteMailProto(code)
    UIManager.showTip( { content = Localization["Error8_10_" .. tostring(code)], result = false })
end
mail_decoder.RegisterAction(mail_decoder.S2C_FAIL_DELETE_MAIL, S2CFailDeleteMailProto)
-- *********************************************************************
-- 收藏/取消收藏邮件成功
-- moduleId = 8, msgId = 12
-- id 邮件id
-- keep true表示收藏，false表示取消收藏
local function S2CKeepMailProto(data)
    print("收藏/取消收藏邮件成功!")

    -- 更新该id邮件的收藏状态
    for k, v in pairs(MailData.MailList) do
        for i, j in pairs(v) do
            for key, mailData in pairs(j) do
                if mailData.Id == data.id then
                    mailData.Keep = data.keep
                    -- 如果是收藏的话,尝试塞到收藏邮件中
                    if data.keep then
                        if not isExist(data.id, MailData.MailList[3].All) then
                            table.insert(MailData.MailList[3].All, mailData)
                        end
                        -- 未读邮件
                        if not mailData.Read and not isExist(data.id, MailData.MailList[3].Unread) then
                            table.insert(MailData.MailList[3].Unread, mailData)
                            -- 未读且含附件邮件
                            if mailData.HasPrize and not isExist(data.id, MailData.MailList[3].UnreadAndHasPrize) then
                                table.insert(MailData.MailList[3].UnreadAndHasPrize, mailData)
                            end
                        end

                        -- 含附件邮件
                        if mailData.HasPrize and not isExist(data.id, MailData.MailList[3].HasPrize) then
                            table.insert(MailData.MailList[3].HasPrize, mailData)
                        end
                    end
                end
            end
        end
    end

    -- 从收藏邮件中删除
    if not data.keep then
        for k, v in pairs(MailData.MailList[3]) do
            for i, j in pairs(v) do
                if j.Id == data.id then
                    table.remove(v, i)
                end
            end
        end
    end

    Event.dispatch(Event.MAIL_COLLECT_OR_NOT_SUCCESS, data.keep)
end
mail_decoder.RegisterAction(mail_decoder.S2C_KEEP_MAIL, S2CKeepMailProto)

-- 收藏邮件失败
-- moduleId = 8, msgId = 13
local function S2CFailKeepMailProto(code)
    UIManager.showTip( { content = Localization["Error8_13_" .. tostring(code)], result = false })
end
mail_decoder.RegisterAction(mail_decoder.S2C_FAIL_KEEP_MAIL, S2CFailKeepMailProto)
-- *********************************************************************
-- 领取邮件奖励成功
-- moduleId = 8, msgId = 15
-- id: string // 邮件id，客户端将奖励部分删除
local function S2CCollectMailPrizeProto(data)
    for k, v in pairs(MailData.MailList) do
        for i, j in pairs(v) do
            for key, mailData in pairs(j) do
                if mailData.Id == data.id then
                    -- mailData.Prize = nil
                    mailData.Collected = true
                end
            end
        end
    end

    -- 从含附件和未读且含附件中删除
    for k, v in pairs(MailData.MailList) do
        for i, j in pairs(v.HasPrize) do
            if j.Id == data.id then
                table.remove(v.Unread, i)
            end
        end

        for i, j in pairs(v.UnreadAndHasPrize) do
            if j.Id == data.id then
                table.remove(v.UnreadAndHasPrize, i)
            end
        end
    end

    Event.dispatch(Event.MAIL_GET_PRIZE_SUCCESS)
end
mail_decoder.RegisterAction(mail_decoder.S2C_COLLECT_MAIL_PRIZE, S2CCollectMailPrizeProto)

-- 领取邮件奖励失败
-- moduleId = 8, msgId = 16
local function S2CFailCollectMailPrizeProto(data)
    UIManager.showTip( { content = Localization["Error8_16_" .. tostring(code)], result = false })
end
mail_decoder.RegisterAction(mail_decoder.S2C_FAIL_COLLECT_MAIL_PRIZE, S2CFailCollectMailPrizeProto)
-- *********************************************************************
-- 读取邮件成功
-- moduleId = 8, msgId = 21
-- id: string // 邮件id
local function S2CReadMailProto(data)
    for k, v in pairs(MailData.MailList) do
        for i, j in pairs(v) do
            for key, mailData in pairs(j) do
                if mailData.Id == data.id then
                    mailData.Read = true
                end
            end
        end
    end

    -- 从未读邮件和未读且含附件中删除
    for k, v in pairs(MailData.MailList) do
        for i, j in pairs(v.Unread) do
            if j.Id == data.id then
                table.remove(v.Unread, i)
            end
        end

        for i, j in pairs(v.UnreadAndHasPrize) do
            if j.Id == data.id then
                table.remove(v.UnreadAndHasPrize, i)
            end
        end
    end

    Event.dispatch(Event.MAIL_READ_SUCCESS)
end
mail_decoder.RegisterAction(mail_decoder.S2C_READ_MAIL, S2CReadMailProto)

-- 读取邮件失败
-- moduleId = 8, msgId = 22
local function S2CFailReadMailProto(data)
    UIManager.showTip( { content = Localization["Error8_22_" .. tostring(code)], result = false })
end
mail_decoder.RegisterAction(mail_decoder.S2C_FAIL_READ_MAIL, S2CFailReadMailProto)
-- *********************************************************************
return MailData