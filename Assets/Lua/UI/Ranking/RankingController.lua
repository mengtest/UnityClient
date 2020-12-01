local UIController = UIManager.Controller(UIManager.ControllerName.Ranking, UIManager.ViewName.Ranking)
UIController.rankingData = nil
UIController.rankingStartIndex = nil
UIController.rankingEndIndex = nil
UIController.currentRankingData = nil
UIController.itemsCountInView = nil
UIController.rankingState = 0 -- 0 self; 1 pull up; 2 pull down; 3 top; 4 search
UIController.searchingString = ""
UIController.currentHundredsWarLevel = 0
UIController.currentGList = nil


function UIController:onCreat()
    UIController.View.BackTopCtr.selectedIndex = 1
    UIController.View.TabCtr.onChanged:Set(self.OnTabCtrStateChanged)

    UIController.View.ButtonReturn.onClick:Set(self.OnReturnClick)
    UIController.View.ButtonSerachOrCancel.onClick:Set(self.OnSearchClick)
    UIController.View.ButtonSelfOrTop.onClick:Set(self.OnTopClick)

    UIController.View.AllianceRanking.itemRenderer = self.AllianceRankingRenderer
    UIController.View.AllianceRanking.scrollPane.onPullUpRelease:Add(self.OnPullUpRelease)
    UIController.View.AllianceRanking.scrollPane.onPullDownRelease:Add(self.OnPullDownRelease)
    UIController.View.AllianceRanking.scrollPane.onScrollEnd:Add(self.OnScrollEnd)

    UIController.View.SecretTowerRanking.itemRenderer = self.SecretTowerRankingRenderer
    UIController.View.SecretTowerRanking.scrollPane.onPullUpRelease:Add(self.OnPullUpRelease)
    UIController.View.SecretTowerRanking.scrollPane.onPullDownRelease:Add(self.OnPullDownRelease)
    UIController.View.SecretTowerRanking.scrollPane.onScrollEnd:Add(self.OnScrollEnd)

    UIController.View.HundredsWarRanking.itemRenderer = self.HundredsWarRakingRenderer
    UIController.View.HundredsWarRanking.scrollPane.onPullUpRelease:Add(self.OnPullUpRelease)
    UIController.View.HundredsWarRanking.scrollPane.onPullDownRelease:Add(self.OnPullDownRelease)
    UIController.View.HundredsWarLevel.onClickItem:Set(self.HundredsWarLevelClick)
    UIController.View.HundredsWarLevel.scrollPane.onScrollEnd:Add(self.OnScrollEnd)

    UIController.View.CountryRanking.itemRenderer = self.CountryRankingRenderer
    UIController.View.CountryRanking.scrollPane.onPullUpRelease:Add(self.OnPullUpRelease)
    UIController.View.CountryRanking.scrollPane.onPullDownRelease:Add(self.OnPullDownRelease)
    UIController.View.CountryRanking.scrollPane.onScrollEnd:Add(self.OnScrollEnd)

    Event.addListener(Event.GET_RANKING, self.OnGetRanking)
end

-- 切换切页
function UIController.OnTabCtrStateChanged()
    UIController.rankingState = 0
    UIController.rankingStartIndex = 1
    UIController.rankingEndIndex = 1
    UIController.View.BackTopCtr.selectedIndex = 0
    UIController.View.SearchCtr.selectedIndex = 0
    UIController.currentHundredsWarLevel = 0
    -- alliance
    if UIController.View.TabCtr.selectedIndex == 0 then
        UIController.currentGList = UIController.View.AllianceRanking
        UIController.rankingData.CurrentRankingType = UIController.rankingData.RankingType.Alliance
        UIController:RequestRanking(true)
    -- secret tower
    elseif UIController.View.TabCtr.selectedIndex == 1 then
        UIController.currentGList = UIController.View.SecretTowerRanking
        UIController.rankingData.CurrentRankingType = UIController.rankingData.RankingType.SecretTower
        UIController:RequestRanking(true)
    -- hundreds war
    elseif UIController.View.TabCtr.selectedIndex == 2 then
        UIController.currentGList = UIController.View.HundredsWarRanking
        UIController.currentHundredsWarLevel = UIController.GetHundredsWarLevel()
        UIController.rankingData.CurrentRankingType = UIController.rankingData.RankingType.HundredsWar
        UIController:RequestRanking(true)
    -- country
    elseif UIController.View.TabCtr.selectedIndex == 3 then
        UIController.currentGList = UIController.View.CountryRanking
        UIController.rankingData.CurrentRankingType = UIController.rankingData.RankingType.Country
        UIController:RequestRanking(true)
    end
end

-- 关闭UI
function UIController.OnReturnClick()
    UIController:close()
end

-- 点击查询输入的家伙的排名
function UIController.OnSearchClick()
    UIController.rankingState = 4
    if UIController.View.SearchCtr.selectedIndex == 0 then
        UIController.searchingString = UIController.View.SearchInput.text
        if UIController.searchingString == "" then
            UIManager.showTip( { result = false, content = Localization.RankingSearchEmptyTip } )
            return
        end
        UIController.View.SearchCtr.selectedIndex = 1
        UIController:RequestRanking(false)
    elseif UIController.View.SearchCtr.selectedIndex == 1 then
        UIController.rankingState = 3
        UIController.View.SearchCtr.selectedIndex = 0
        UIController.searchingString = ""
        UIController.View.SearchInput.text = ""
        UIController:RequestRanking(false)
    end
end

-- 点击了回到榜首或者查看自己按钮
function UIController.OnTopClick()
    UIController.View.SearchCtr.selectedIndex = 0
    UIController.searchingString = ""
    UIController.View.SearchInput.text = ""
    --  查自己
    if UIController.View.BackTopCtr.selectedIndex == 0 then
        UIController.rankingState = 0
        UIController.View.BackTopCtr.selectedIndex = 1
        UIController:RequestRanking(true)
    --  查榜首
    else
        UIController.rankingStartIndex = 1
        UIController.rankingState = 3
        UIController.View.BackTopCtr.selectedIndex = 0        
        UIController:RequestRanking(false)
    end
end

-- 联盟排行榜
function UIController.AllianceRankingRenderer(index, obj)
    UIController.itemsCountInView = math.floor( UIController.View.AllianceRanking.viewHeight / obj.viewHeight )

    if UIController.rankingStartIndex + index == 1 then-- first
        obj:GetController("State_C").selectedIndex = 0
    elseif UIController.rankingStartIndex + index == 2 then-- second
        obj:GetController("State_C").selectedIndex = 1
    elseif UIController.rankingStartIndex + index == 3 then-- second
        obj:GetController("State_C").selectedIndex = 2
    else
        obj:GetController("State_C").selectedIndex = 3
        obj:GetChild("Text_Number").text = UIController.rankingStartIndex + index
    end

    obj:GetChild("Text_LeagueName").text = UIController.currentRankingData[index + 1].leader.guild_name
    obj:GetChild("Text_LeaderName").text = UIController.currentRankingData[index + 1].leader.name
    obj:GetChild("Text_LeagueLevel").text = UIController.currentRankingData[index + 1].level
    obj:GetChild("Text_Progress").text = UIController.currentRankingData[index + 1].building_amount
    
    obj:GetController("Type_C").selectedIndex = 0
    if UIController.searchingString == UIController.currentRankingData[index + 1].leader.guild_name then
        obj:GetController("Type_C").selectedIndex = 2
    end

    if UIController.currentRankingData[index + 1].leader.guild_id == DataTrunk.PlayerInfo.MonarchsData.GuildId then
        obj:GetController("Type_C").selectedIndex = 1
    end
end

-- 重楼排行榜
function UIController.SecretTowerRankingRenderer(index, obj)
    UIController.itemsCountInView = math.floor( UIController.View.SecretTowerRanking.viewHeight / obj.viewHeight )

    if UIController.rankingStartIndex + index == 1 then-- first
        obj:GetController("State_C").selectedIndex = 0
    elseif UIController.rankingStartIndex + index == 2 then-- second
        obj:GetController("State_C").selectedIndex = 1
    elseif UIController.rankingStartIndex + index == 3 then-- second
        obj:GetController("State_C").selectedIndex = 2
    else
        obj:GetController("State_C").selectedIndex = 3
        obj:GetChild("Text_Number").text = UIController.rankingStartIndex + index
    end

    obj:GetChild("Loader_LordPicture").icon = UIController.currentRankingData[index + 1].hero.head
    obj:GetChild("Text_LordName").text = UIController.currentRankingData[index + 1].hero.name
    obj:GetChild("Text_LeagueName").text = UIController.currentRankingData[index + 1].hero.guild_name
    obj:GetChild("Text_Record").text = UIController.currentRankingData[index + 1].floor
    obj:GetChild("Text_Time").text = Utils.getTimeStamp(UIController.currentRankingData[index + 1].time)

    obj:GetController("Type_C").selectedIndex = 0
    if UIController.searchingString == UIController.currentRankingData[index + 1].hero.name then
        obj:GetController("Type_C").selectedIndex = 2
    end

    if UIController.currentRankingData[index + 1].hero.id == DataTrunk.PlayerInfo.MonarchsData.Id then
        obj:GetController("Type_C").selectedIndex = 1
    end
end

-- 百战排行榜
function UIController.HundredsWarRakingRenderer(index, obj)
    UIController.itemsCountInView = math.floor( UIController.View.HundredsWarRanking.viewHeight / obj.viewHeight )

    if UIController.rankingStartIndex + index == 1 then-- first
        obj:GetController("State_C").selectedIndex = 0
    elseif UIController.rankingStartIndex + index == 2 then-- second
        obj:GetController("State_C").selectedIndex = 1
    elseif UIController.rankingStartIndex + index == 3 then-- second
        obj:GetController("State_C").selectedIndex = 2
    else
        obj:GetController("State_C").selectedIndex = 3
        obj:GetChild("Text_Number").text = UIController.rankingStartIndex + index
    end

    obj:GetChild("Loader_LordPicture").icon = UIController.currentRankingData[index + 1].hero.head
    obj:GetChild("Text_LordName").text = UIController.currentRankingData[index + 1].hero.name
    obj:GetChild("Text_Points").text = UIController.currentRankingData[index + 1].point
    obj:GetChild("Text_Miltary").text = UIController.currentRankingData[index + 1].level

    obj:GetController("Type_C").selectedIndex = 0
    if UIController.searchingString == UIController.currentRankingData[index + 1].hero.name then
        obj:GetController("Type_C").selectedIndex = 2
    end

    if UIController.currentRankingData[index + 1].hero.id == DataTrunk.PlayerInfo.MonarchsData.Id then
        obj:GetController("Type_C").selectedIndex = 1
    end
end

-- 百战排行切换头衔显示对应的榜单
function UIController.HundredsWarLevelClick()
    UIController.currentHundredsWarLevel = UIController.GetHundredsWarLevel()
    UIController:RequestRanking(false)
end

function UIController.GetHundredsWarLevel()
    return -UIController.View.HundredsWarLevelCtr.selectedIndex + 8
end

-- 国家排行榜
function UIController.CountryRankingRenderer(index, obj)
    UIController.itemsCountInView = math.floor( UIController.View.CountryRanking.viewHeight / obj.viewHeight )

    if UIController.rankingStartIndex + index == 1 then-- first
        obj:GetController("State_C").selectedIndex = 0
    elseif UIController.rankingStartIndex + index == 2 then-- second
        obj:GetController("State_C").selectedIndex = 1
    elseif UIController.rankingStartIndex + index == 3 then-- second
        obj:GetController("State_C").selectedIndex = 2
    else
        obj:GetController("State_C").selectedIndex = 3
        obj:GetChild("Text_Number").text = UIController.rankingStartIndex + index
    end

    obj:GetChild("Text_CountryName").text = UIController.currentRankingData[index + 1].name
    obj:GetChild("Text_CityAmount").text = UIController.currentRankingData[index + 1].city_count
    obj:GetChild("Text_Money").text = UIController.currentRankingData[index + 1].city_output
    obj:GetChild("Loader_LordPicture").icon = UIController.currentRankingData[index + 1].leader.head
    obj:GetChild("Text_LordName").text = UIController.currentRankingData[index + 1].leader.name
    obj:GetChild("Text_LeagueName").text = UIController.currentRankingData[index + 1].leader.guild_name

    obj:GetController("Type_C").selectedIndex = 0
    if UIController.searchingString == UIController.currentRankingData[index + 1].hero.name then
        obj:GetController("Type_C").selectedIndex = 2
    end

    if UIController.currentRankingData[index + 1].leader.guild_id == DataTrunk.PlayerInfo.MonarchsData.GuildId then
        obj:GetController("Type_C").selectedIndex = 1
    end
end

-- 手指上滑排行榜滑到底时
function UIController.OnPullUpRelease()
    local footer = UIController.currentGList.scrollPane.footer
    if footer ~= nil then
        footer:GetController("State_C").selectedIndex = 1
    end
    UIController.rankingState = 1
    UIController.rankingStartIndex = UIController.rankingStartIndex + #UIController.currentRankingData - UIController.itemsCountInView
    UIController:RequestRanking(false)
end

-- 手指下滑排行榜滑到顶时
function UIController.OnPullDownRelease()
    local header = UIController.currentGList.scrollPane.header
    if header ~= nil then
        header:GetController("State_C").selectedIndex = 1
    end
    UIController.rankingState = 2
    UIController.rankingEndIndex = UIController.rankingStartIndex
    UIController.rankingStartIndex = UIController.rankingEndIndex + UIController.itemsCountInView - 1 - UIController.rankingData.RankingDataCount
    if UIController.rankingStartIndex < 1 then
        UIController.rankingStartIndex = 1
    end
    UIController:RequestRanking(false)
end

function UIController.OnScrollEnd()
    local header = UIController.currentGList.scrollPane.header
    if header ~= nil then
        header:GetController("State_C").selectedIndex = 2
    end
    local footer = UIController.currentGList.scrollPane.footer
    if footer ~= nil then
        footer:GetController("State_C").selectedIndex = 0
    end
end

-- 请求排行榜数据
function UIController:RequestRanking(isSelf)
    NetworkManager.C2SRequestRankProto(self.rankingData.CurrentRankingType, self.searchingString, isSelf, self.rankingStartIndex, self.currentHundredsWarLevel)
end

function UIController:onOpen(rankingType)
    self.rankingData = DataTrunk.PlayerInfo.RankingData
    self.rankingData.CurrentRankingType = rankingType
    if rankingType == self.rankingData.RankingType.Country then
        self.TabCtr.selectedIndex = 3
    elseif rankingType == self.rankingData.RankingType.Alliance then
        -- 联盟是默认切页 没有触发Controller.onChanged 所以调一下
        UIController.OnTabCtrStateChanged()
    elseif rankingType == self.rankingData.RankingType.SecretTower then
        self.TabCtr.selectedIndex = 1
    elseif rankingType == self.rankingData.RankingType.HundredsWar then
        self.TabCtr.selectedIndex = 2
    end

    UIController.View.HundredRefreshTime.text = string.format(Localization.RankingRefresh, MiscCommonLocalConfig.DailyResetHour, MiscCommonLocalConfig.DailyResetMinute)
end

-- 获得排行榜数据并处理
function UIController.OnGetRanking(startIndnex, data)
    UIController.currentRankingData = data
    local selfIndex = nil
    local searchIndex = nil
    if UIController.rankingData.CurrentRankingType == UIController.rankingData.RankingType.Country then
        for i, v in ipairs(data) do
            if v.leader.id == DataTrunk.PlayerInfo.AllianceData.MyAlliance.Leader.Hero.Id then
                selfIndex = i
            end
            if v.leader.guild_name == UIController.searchingString then
                searchIndex = i
            end
        end
    elseif UIController.rankingData.CurrentRankingType == UIController.rankingData.RankingType.Alliance then
        for i, v in ipairs(data) do
            if DataTrunk.PlayerInfo.MonarchsData.GuildId == v.leader.guild_id then
                selfIndex = i
            end
            if v.leader.guild_name == UIController.searchingString then
                searchIndex = i
            end
        end
    elseif UIController.rankingData.CurrentRankingType == UIController.rankingData.RankingType.SecretTower then
        for i, v in ipairs(data) do
            if v.hero.id == DataTrunk.PlayerInfo.MonarchsData.Id then
                selfIndex = i
            end
            if v.hero.name == UIController.searchingString then
                searchIndex = i
            end
        end
    elseif UIController.rankingData.CurrentRankingType == UIController.rankingData.RankingType.HundredsWar then
        for i, v in ipairs(data) do
            if v.hero.id == DataTrunk.PlayerInfo.MonarchsData.Id then
                selfIndex = i
            end
            if v.hero.name == UIController.searchingString then
                searchIndex = i
            end
        end
    end

    local lastRankingStartIndex = UIController.rankingStartIndex
    UIController.rankingStartIndex = startIndnex
    UIController.currentGList.numItems = #data

    -- 获取自己排行
    if UIController.rankingState == 0 then
        UIController.View.BackTopCtr.selectedIndex = 1
        if selfIndex == nil then
            UIController.currentGList:ScrollToView(lastRankingStartIndex - startIndnex, false);
            UIManager.showTip( { result = false, content = Localization.RankingNotContainYou } )
        else
            UIController.currentGList:ScrollToView(selfIndex - 1, true);
        end
    -- 上滑刷新
    elseif UIController.rankingState == 1 then
        UIController.currentGList:ScrollToView(lastRankingStartIndex - startIndnex, false);
    -- 下滑刷新
    elseif UIController.rankingState == 2 then
        UIController.currentGList:ScrollToView(UIController.rankingEndIndex - startIndnex, false);
    -- 榜首
    elseif UIController.rankingState == 3 then
        UIController.currentGList:ScrollToView(startIndnex - 1, false);
    -- 查询他人
    elseif UIController.rankingState == 4 then
        searchIndex = searchIndex or startIndnex
        UIController.currentGList:ScrollToView(searchIndex - 1, true);
    end
end

function UIController:onDestroy()
    UIController.View.TabCtr.onChanged:Clear()

    UIController.View.ButtonReturn.onClick:Clear()
    UIController.View.ButtonSerachOrCancel.onClick:Clear()
    UIController.View.ButtonSelfOrTop.onClick:Clear()

    UIController.View.AllianceRanking.itemRenderer = nil
    UIController.View.AllianceRanking.scrollPane.onPullUpRelease:Clear()
    UIController.View.AllianceRanking.scrollPane.onPullDownRelease:Clear()
    UIController.View.AllianceRanking.scrollPane.onScrollEnd:Clear()

    UIController.View.SecretTowerRanking.itemRenderer = nil
    UIController.View.SecretTowerRanking.scrollPane.onPullUpRelease:Clear()
    UIController.View.SecretTowerRanking.scrollPane.onPullDownRelease:Clear()
    UIController.View.SecretTowerRanking.scrollPane.onScrollEnd:Clear()

    UIController.View.HundredsWarRanking.itemRenderer = nil
    UIController.View.HundredsWarRanking.scrollPane.onPullUpRelease:Clear()
    UIController.View.HundredsWarRanking.scrollPane.onPullDownRelease:Clear()
    UIController.View.HundredsWarRanking.scrollPane.onScrollEnd:Clear()
    UIController.View.HundredsWarLevel.onClickItem:Clear()

    UIController.View.CountryRanking.itemRenderer = nil
    UIController.View.CountryRanking.scrollPane.onPullUpRelease:Clear()
    UIController.View.CountryRanking.scrollPane.onPullDownRelease:Clear()
    UIController.View.CountryRanking.scrollPane.onScrollEnd:Clear()

    Event.removeListener(Event.GET_RANKING, self.OnGetRanking)
end

return UIController