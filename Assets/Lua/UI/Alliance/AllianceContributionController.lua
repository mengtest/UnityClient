local _C = UIManager.SubController(UIManager.ControllerName.AllianceContributionController, nil)
_C.view = nil

local view = nil
-- 联盟数据
local allianceData = DataTrunk.PlayerInfo.AllianceData
-- 君主数据
local monarchsData = DataTrunk.PlayerInfo.MonarchsData
-- 联盟成员(深拷贝)
local memberData = { }
-- 当前中间捐献的配置序号
local currCenterData = -1
-- 显示顺序(木材,石料,粮食,铜币,元宝)
local titleSequence = { Localization.Wood, Localization.Stone, Localization.Food, Localization.Gold, Localization.YuanBao }

-- 捐献记录列表
local function ContributionListRenderer(index, obj)
    local data = allianceData.MyAlliance.DonateRecords[index + 1]

    -- 捐献时间
    obj:GetChild("Text_Time").text = Utils.getIntradayTimeStamp(data.DonateTime)
    -- 根据sequence和times获取配置(其实只是要配置里的消耗)
    local config = GuildDonateConfig.Config[string.format("%s_%s", data.Sequence, data.Times)]
    -- 捐献描述(名字+捐献了+消耗+种类)
    local content = data.Name .. Localization.Donate

    -- 类型(hardcode)
    if data.Sequence == 1 then
        content = string.format("%s%s%s", content, config.Cost.Food, Localization.Food)
    elseif data.Sequence == 2 then
        content = string.format("%s%s%s", content, config.Cost.Wood, Localization.Wood)
    elseif data.Sequence == 3 then
        content = string.format("%s%s%s", content, config.Cost.Stone, Localization.Stone)
    elseif data.Sequence == 4 then
        content = string.format("%s%s%s", content, config.Cost.Gold, Localization.Gold)
    elseif data.Sequence == 5 then
        content = string.format("%s%s%s", content, config.Cost.YuanBao, Localization.YuanBao)
    end

    obj:GetChild("Text_Info").text = content
end

-- 更新按钮数据
-- sequence:UI顺序,dataId:数据Id
local function UpdateBtnData(sequence, dataId)
    local btn = "Label_" .. sequence
    -- 保存数据
    view[btn].data = dataId
    -- 设置资源名称
    view[btn].title = titleSequence[dataId]
end

-- 更新正中间的数据
-- dataId:数据Id
local function UpdateCenterData(dataId)
    -- 保存id
    currCenterData = dataId
    -- 名称
    view.TitleText.text = titleSequence[dataId]
    -- 获取配置(GuildDonateClass())
    local config = GuildDonateConfig.Config[string.format("%s_%s", dataId, monarchsData.GuildDonateTimes[dataId] + 1)]

    -- 判断是否已达上限(=空就不能捐了)
    if config ~= nil then
        -- 消耗就有点蛋疼了,自己处理一下
        local cost = nil

        -- 1:food 2:wood 3:stone 4:gold 5:yuanbao
        if dataId == 1 then
            cost = config.Cost.Food
        elseif dataId == 2 then
            cost = config.Cost.Wood
        elseif dataId == 3 then
            cost = config.Cost.Stone
        elseif dataId == 4 then
            cost = config.Cost.Gold
        elseif dataId == 5 then
            cost = config.Cost.YuanBao
        end

        -- 捐献数量
        view.DonationText.text = string.format(Localization.AllianceDonateAmount, cost)
        -- 描述
        view.DescText.text = string.format("%s\n%s", string.format(Localization.AddConstructionValue, config.GuildBuildingAmount), string.format(Localization.AddContributionValue, config.ContributionAmount))
        -- 捐献按钮
        view.DonateBtn.onClick:Set( function()
            NetworkManager.C2SDonateProto(config.Sequence)
        end )
        view.DonateBtn.grayed = false
        view.DonateBtn.touchable = not view.DonateBtn.grayed
    else
        -- 捐献数量(置空)
        view.DonationText.text = ""
        -- 描述(今日已达捐献上限)
        view.DescText.text = Localization.AllianceDonateToLimit
        view.DonateBtn.grayed = true
        view.DonateBtn.touchable = not view.DonateBtn.grayed
    end
end

-- 初始化捐献按钮数据
local function InitDonateBtns()
    -- 默认是(1.木材,2.石料,3.粮食,4.铜币,5.元宝)
    UpdateBtnData(1, 1)
    UpdateBtnData(2, 2)
    UpdateCenterData(3)
    UpdateBtnData(4, 4)
    UpdateBtnData(5, 5)
end

-- 更新捐献资源页
local function UpdatePage0Data()
    local data = allianceData.MyAlliance

    if data == nil then
        return
    end

    -- 联盟建设值
    view.ConstructionValue.text = data.BuildingAmount
    -- 今日个人贡献
    view.ContributionValue.text = allianceData.MyData.ContributionAmount
    -- 更新当前捐献按钮信息
    UpdateCenterData(currCenterData)
    -- 联盟捐献记录
    view.ContributionList.itemRenderer = ContributionListRenderer
    view.ContributionList.numItems = #allianceData.MyAlliance.DonateRecords
end

-- 捐献排行榜列表
local function RankingListRenderer(index, obj)
    local index = index + 1
    local data = memberData[index]

    -- 排名
    -- 0:第一名 1:第二名 2:第三名 :3其他
    local order_C = obj:GetController("Order_C")

    if index < 4 then
        order_C.selectedIndex = index - 1
    else
        order_C.selectedIndex = 3
        obj:GetChild("Text_Order").text = index
    end

    -- 名字
    obj:GetChild("Text_Name").text = data.Hero.Name
    -- 捐献资源(总捐献值)
    obj:GetChild("Text_DonateRes").text = data.DonationTotalAmount
    -- 总捐献元宝数
    obj:GetChild("Text_DonateYuanBao").text = data.DonationTotalYuanBao
    -- 今日贡献值
    obj:GetChild("Text_DonateByToday").text = data.ContributionAmount
    -- 7日贡献值
    obj:GetChild("Text_DonateBySevenDays").text = data.ContributionAmount7
    -- 总贡献值
    obj:GetChild("Text_TotalDonation").text = data.ContributionTotalAmount
end

-- 更新捐献记录页
local function UpdatePage2Data()
    -- 深拷贝
    for k, v in pairs(allianceData.MemberList) do
        memberData[k] = v
    end

    view.DonateRankingList.itemRenderer = RankingListRenderer
    view.DonateRankingList.numItems = allianceData.MyAlliance.MemberCount
end

function _C.RefreshUI()
    if not _C.IsOpen then
        return
    end

    UpdatePage0Data()
    UpdatePage2Data()
end

-- 捐献资源排序开关
local function ResourceToggleOnClick()
    if view.ResourceToggle.selected then
        table.sort(memberData, function(a, b) return a.DonationTotalAmount < b.DonationTotalAmount end)
    else
        table.sort(memberData, function(a, b) return a.DonationTotalAmount > b.DonationTotalAmount end)
    end

    view.DonateRankingList:RefreshVirtualList()
end

-- 捐献元宝排序开关
local function YuanBaoToggleOnClick()
    if view.YuanBaoToggle.selected then
        table.sort(memberData, function(a, b) return a.DonationTotalYuanBao < b.DonationTotalYuanBao end)
    else
        table.sort(memberData, function(a, b) return a.DonationTotalYuanBao > b.DonationTotalYuanBao end)
    end

    view.DonateRankingList:RefreshVirtualList()
end

-- 今日贡献排序开关
local function HodiernalContributionToggleOnClick()
    if view.HodiernalContributionToggle.selected then
        table.sort(memberData, function(a, b) return a.ContributionAmount < b.ContributionAmount end)
    else
        table.sort(memberData, function(a, b) return a.ContributionAmount > b.ContributionAmount end)
    end

    view.DonateRankingList:RefreshVirtualList()
end

-- 七日贡献排序开关
local function SevenDaysContributionToggleOnClick()
    if view.SevenDaysContributionToggle.selected then
        table.sort(memberData, function(a, b) return a.ContributionAmount7 < b.ContributionAmount7 end)
    else
        table.sort(memberData, function(a, b) return a.ContributionAmount7 > b.ContributionAmount7 end)
    end

    view.DonateRankingList:RefreshVirtualList()
end

-- 总贡献排序开关
local function TotalContributionToggleOnClick()
    if view.TotalContributionToggle.selected then
        table.sort(memberData, function(a, b) return a.ContributionTotalAmount < b.ContributionTotalAmount end)
    else
        table.sort(memberData, function(a, b) return a.ContributionTotalAmount > b.ContributionTotalAmount end)
    end

    view.DonateRankingList:RefreshVirtualList()
end

-- 资源按钮1点击事件
local function ResButton1OnClick()
    local tempId = view.Label_1.data
    UpdateBtnData(1, currCenterData)
    UpdateCenterData(tempId)
end

-- 资源按钮2点击事件
local function ResButton2OnClick()
    local tempId = view.Label_2.data
    UpdateBtnData(2, currCenterData)
    UpdateCenterData(tempId)
end

-- 资源按钮4点击事件
local function ResButton4OnClick()
    local tempId = view.Label_4.data
    UpdateBtnData(4, currCenterData)
    UpdateCenterData(tempId)
end

-- 资源按钮5点击事件
local function ResButton5OnClick()
    local tempId = view.Label_5.data
    UpdateBtnData(5, currCenterData)
    UpdateCenterData(tempId)
end

-- 默认排序(七日)
local function DefaultSort()
    -- 捐献页
    if _C.view.Page_C.selectedIndex ~= 1 then
        return
    end

    table.sort(memberData, function(a, b) return a.ContributionAmount7 > b.ContributionAmount7 end)
    view.DonateRankingList:RefreshVirtualList()
end

function _C:onCreat()
    view = _C.view.ContributionPage
    -- 初始化捐献按钮
    InitDonateBtns()
    -- 捐献按钮事件
    view.Label_1.onClick:Set(ResButton1OnClick)
    view.Label_2.onClick:Set(ResButton2OnClick)
    view.Label_4.onClick:Set(ResButton4OnClick)
    view.Label_5.onClick:Set(ResButton5OnClick)
    -- true:↓ false:↑
    view.ResourceToggle.onChanged:Set(ResourceToggleOnClick)
    view.YuanBaoToggle.onChanged:Set(YuanBaoToggleOnClick)
    view.HodiernalContributionToggle.onChanged:Set(HodiernalContributionToggleOnClick)
    view.SevenDaysContributionToggle.onChanged:Set(SevenDaysContributionToggleOnClick)
    view.TotalContributionToggle.onChanged:Set(TotalContributionToggleOnClick)

    -- 页签
    _C.view.Page_C.onChanged:Set(DefaultSort)
    Event.addListener(Event.ALLIANCE_DONATE_SUCCESS, _C.RefreshUI)
end

function _C:onDestroy()
    view.DonateRankingList.itemRenderer = nil
    view.ContributionList.itemRenderer = nil
    _C.view.Page_C.onChanged:Clear()
    Event.removeListener(Event.ALLIANCE_DONATE_SUCCESS, _C.RefreshUI)
end

return _C