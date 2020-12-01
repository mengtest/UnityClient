local _C = UIManager.Controller(UIManager.ControllerName.CreateOrJoinAlliance, UIManager.ViewName.CreateOrJoinAlliance)
local _CchatBrief = require(UIManager.ControllerName.ChatBrief)
table.insert(_C.SubCtrl, _CchatBrief)

local view = nil
-- 联盟数据
local allAllianceData = DataTrunk.PlayerInfo.AllianceData.AllianceList
-- 想要跳转到的页数
local wannaPageNum = 0
-- 当前所在页数
local currentPageNum = 0
-- 当前的搜索关键字
local currentSearchKeyword = nil
-- 每页显示几个联盟信息
local numPerPage = 4

local function BackBtnOnClick()
    _C:close()
end

-- 打开创建联盟界面
local function CreateBtnOnClick()
    UIManager.openController(UIManager.ControllerName.CreateAlliance)
end

local function OnSearch()
    -- 搜索关键字为空，走请求联盟列表协议
    if currentSearchKeyword == nil or currentSearchKeyword == "" then
        NetworkManager.C2SListGuildProto(wannaPageNum)
        -- 不为空，走搜索协议
    else
        NetworkManager.C2SSearchGuildProto(currentSearchKeyword, wannaPageNum)
    end
end

-- 搜索，只有点击了搜索按钮才会处理搜索关键字
local function SearchBtnOnClick()
    wannaPageNum = 0
    currentSearchKeyword = view.SearchLabel.text
    OnSearch()
end

-- 上一页
local function LeftArrowBtnOnClick()
    if currentPageNum <= 0 then
        return
    end

    wannaPageNum = currentPageNum - 1
    OnSearch()
end

-- 下一页
local function RightArrowBtnOnClick()
    wannaPageNum = currentPageNum + 1
    OnSearch()
end

-- 加入指定联盟
local function JoinBtnOnClick(id)
    if id == nil or id == "" then
        return
    end

    NetworkManager.C2SUserRequestJoinProto(id)
end

-- 加入联盟成功
local function OnJoinSuccess()
    if not _C.IsOpen then
        return
    end

    _C:destroy(false)
    UIManager.openController(UIManager.ControllerName.Alliance)
end

-- 创建联盟成功
local function OnCreateSuccess()
    if not _C.IsOpen then
        return
    end

    -- 打开自己的联盟界面
    _C:destroy(false)
    UIManager.openController(UIManager.ControllerName.Alliance)
end

-- 更新数据
local function UpdateData(data)
    if not _C.IsOpen then
        return
    end

    currentPageNum = wannaPageNum
    local dataLength = 0

    if data ~= nil then
        dataLength = #data
    end

    view.MainList:RemoveChildrenToPool()

    -- 设置左按钮
    if currentPageNum == 0 then
        view.LeftArrowBtn.grayed = true
        view.LeftArrowBtn.touchable = false
    else
        view.LeftArrowBtn.grayed = false
        view.LeftArrowBtn.touchable = true
    end

    -- 设置右按钮
    if dataLength < numPerPage then
        view.RightArrowBtn.grayed = true
        view.RightArrowBtn.touchable = false
    else
        view.RightArrowBtn.grayed = false
        view.RightArrowBtn.touchable = true
    end

    -- 如果没数据，则不显示
    if allAllianceData == nil or data == nil then
        return
    end

    -- 遍历获取到的联盟Id
    for i = 1, dataLength do
        if data[i] ~= nil then
            local allianceData = allAllianceData[data[i]]
            if allianceData ~= nil then
                local allianceItem = view.MainList:AddItemFromPool()
                if allianceItem ~= nil then
                    -- 联盟等级配置
                    local levelConfig = GuildLevelConfig:getConfigByLevel(allianceData.Level)

                    if levelConfig ~= nil then
                        -- 联盟名字
                        allianceItem:GetChild("Text_Name").text = allianceData.Name
                        -- 联盟等级
                        allianceItem:GetChild("Text_Level").text = allianceData.Level
                        -- 成员数量
                        allianceItem:GetChild("Text_MemberCount").text = string.format("%s/%s", allianceData.MemberCount, levelConfig.MemberCount)
                        -- 盟主名字
                        allianceItem:GetChild("Text_LeaderName").text = allianceData.Leader.Hero.Name
                        -- 宣言
                        allianceItem:GetChild("Text_Content").text = allianceData.Text
                        -- 旗号
                        allianceItem:GetChild("Label_Flag").title = allianceData.FlagName
                        -- 联盟标签
                        local labelList = allianceItem:GetChild("List_Labels")
                        labelList:RemoveChildrenToPool()

                        for k,v in ipairs(allianceData.Labels) do
                            local labelItem = labelList:AddItemFromPool(labelList.defaultItem)
                            labelItem.title = v
                            labelItem.touchable = false
                        end

                        -- 加入按钮
                        allianceItem:GetChild("Button_Join").onClick:Set(
                        function()
                            JoinBtnOnClick(allianceData.Id)
                        end )
                    end
                end
            end
        end
    end
end

-- 更新外史院
local function UpdateLevel()
    -- 外史院信息
    local buildingData = DataTrunk.PlayerInfo.InternalAffairsData.BuildingsInfo[BuildingType.Recruitment]

    if buildingData == nil then
        return
    end

    view.LevelLabel.text = string.format(Localization.AllianceLevel, buildingData.Level)
end

-- 初始化数据
local function InitData()
    wannaPageNum = 0
    currentPageNum = 0
    currentSearchKeyword = ""
    view.SearchLabel.text = ""
end

function _C:onCreat()
    view = _C.View

    view.BackBtn.onClick:Set(BackBtnOnClick)
    view.CreateBtn.onClick:Set(CreateBtnOnClick)
    view.SearchBtn.onClick:Set(SearchBtnOnClick)
    view.LeftArrowBtn.onClick:Set(LeftArrowBtnOnClick)
    view.RightArrowBtn.onClick:Set(RightArrowBtnOnClick)

    Event.addListener(Event.ON_CREATE_GUILD, OnCreateSuccess)
    Event.addListener(Event.ON_JOINED_GUILD, OnJoinSuccess)
    Event.addListener(Event.ON_UPDATE_GUILD_LIST, UpdateData)
end

function _C:onOpen()
    allAllianceData = DataTrunk.PlayerInfo.AllianceData.AllianceList
    InitData()
    UpdateLevel()
    -- 请求一次数据
    SearchBtnOnClick()
end

function _C:onClose()
    InitData()
end

function _C:onInteractive(isOk)
    if isOk then
        _CchatBrief:setParent(view.UI)
    end
end

function _C:onDestroy()
    Event.removeListener(Event.ON_CREATE_GUILD, OnCreateSuccess)
    Event.removeListener(Event.ON_JOINED_GUILD, OnJoinSuccess)
    Event.removeListener(Event.ON_UPDATE_GUILD_LIST, UpdateData)
end